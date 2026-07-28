# Backend-verified worker provisioning + auth auto-tune for gnomes

Maintainer directive (2026-07-27). A garden node ("gnome") must not run a worker
**kind** it cannot actually back:

1. **Provisioning is evidence-gated.** A fresh gnome may enable a kind's count > 0
   only once a probe shows this host has both the **credentials** and the
   **software** for that kind's backend.
2. **The running fleet self-tunes to auth.** Each scaler tick re-probes every
   declared kind and computes an **effective** per-kind count that falls toward `0`
   while the backend is unauthenticated/unavailable and ramps back to the
   owner-declared target once a real auth success is confirmed — without rewriting
   the journal record on every flap.

Worker-kind → backend map (already the `common.sh` registry, `worker_kind_field`):

| kind | provider | backend | handler |
| --- | --- | --- | --- |
| `gardener` | `anthropic` | Claude (`claude -p`) | `handlers/gardener-claude.sh` |
| `cleric` | `openai` | OpenAI via `codex` | `handlers/cleric-codex.sh` |
| `hermit` | `local` | on-box Ollama `/v1` via `codex` | `handlers/cleric-codex.sh` |
| `mystic` | `moonshot` | Moonshot Kimi via `kimi` | `handlers/mystic-kimi.sh` |
| `fireworker` | `fireworks` | Fireworks via `codex` | `handlers/cleric-codex.sh` |

Live shapes this must serve: **ps23** has only Claude (no `codex`, no `ollama`) →
gardeners only; **garden/garden2** have every backend (hermits disabled pending a
separate failure investigation, unrelated to this design).

Design only. Base: garden `main2`, direct (no PR).

## 0. Relation to the pre-claim health gate (already landed)

`worker_health_gate` (`common.sh`, wired into `gardener.sh`'s poll loop; the ps23
work-sink regression 2026-07-27/28) is the **software half at the claim boundary**:
a worker that cannot resolve its agent binary (`worker_health_probe` → `command -v
claude|codex|kimi`) **self-disqualifies before claiming**, latches one journal
error per healthy→unhealthy edge, and un-parks itself when the binary reappears.
It is fast (one `command -v` + a dir test), per-worker, and per-claim.

This design is **layered on top of it, not a replacement**, and adds the two
dimensions the health gate deliberately does not carry:

1. **Credentials, not just software.** `worker_health_gate` proves the CLI exists;
   it does not prove the host is *authenticated* to the backend. `codex` on PATH
   with no `codex login`, or `claude` with no credential, passes the health gate
   but cannot do work. The backend **probe** here adds the auth check.
2. **Effective count / provisioning, at the scaler layer.** The health gate acts
   on one worker at claim time; it cannot keep a host from *declaring* a kind it
   can't back, nor ramp a whole pool down to 0 and back. That is the scaler-layer
   effective-count and the `set-workers` declare-gate below.

Division of labor: the **health gate** stays the cheap per-claim software backstop
(unchanged); the **backend probe + effective count** is the per-tick credential and
capacity layer. Both reuse the same registry (`worker_kind_field`), so a new kind
is covered by both from one place. The probe's software checks (`command -v …`)
intentionally mirror the health gate's rather than depend on it, because the probe
runs in the scaler and in `set-workers`, not only in the worker poll loop.

---

## 1. The per-backend probe (cheap, deterministic, no LLM)

One entry point, `worker_backend_probe <kind>`, added to `common.sh`. It returns
`0` when this host has **both** credentials and software for the kind's backend,
`1` otherwise, and prints a one-line actionable diagnostic to stderr on failure.
It spends **no tokens** and issues no model call — every check is a filesystem/env
read, a `login status` subprocess, or a bounded `curl` to a local/`/models`
endpoint. Each probe is wrapped in `timeout` (reuse the `unit_ctl_bounded` bound,
default 8s) so a hung backend can never stall the reconcile loop.

The probe **reuses the handlers' existing preflights verbatim** — the same code
that gates a real job gates provisioning, so the two can never drift on what
"authenticated" means. The only new probe is the Claude one (the gardener handler
today checks only that the CLI is on PATH).

`worker_backend_probe` dispatches on the registry `provider` field:

- **`anthropic` (gardener) — NEW, `claude_auth_ok`.** Software: `command -v
  claude`. Credentials: `ANTHROPIC_API_KEY` non-empty **or** a non-empty Claude
  Code OAuth credential at `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json`
  (the file `scripts/aws/turnkey/scrub.sh` deletes and `smoke-test.sh` asserts
  absent; written by the first-launch device-login, `context/first-run/auth.md`
  § 1). When `jq` is present and the credential carries
  `.claudeAiOauth.expiresAt`, treat a token whose expiry is in the past as a
  **soft** signal only — Claude Code refreshes it from the stored refresh token —
  so **presence**, not freshness, is the hard pass/fail. A human logout removes
  the file, which is exactly the loss the tick must catch.

  ```sh
  claude_auth_ok() {                       # -> 0 authed+installed, 1 otherwise
    command -v claude >/dev/null 2>&1 || { echo "claude not on PATH" >&2; return 1; }
    [ -n "${ANTHROPIC_API_KEY:-}" ] && return 0
    local cred="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json"
    [ -s "$cred" ] || { echo "no ANTHROPIC_API_KEY and no Claude login credential" >&2; return 1; }
    return 0
  }
  ```

- **`openai` (cleric).** Reuse `codex_provider_preflight openai cleric
  scaler-probe clerics 0` (`handlers/codex-provider-common.sh`): it does
  `command -v codex` + `codex login status`. **Bypass its per-boot `auth-ok`
  marker for the scaler** (see § note below) so a mid-boot logout is seen.

- **`local` (hermit).** Reuse `codex_local_endpoint_ready "$model"`
  (`codex_local_endpoint_responds` + `codex_local_model_present`) against
  `GARDEN_LOCAL_OLLAMA_URL/models`: endpoint reachable **and** serving ≥1 usable
  model (an empty Ollama store returns 200 but cannot run a job — the existing
  helper already rejects it). `$model` = this host's local fleet default
  (`model_routing_default local`, e.g. `qwen3:0.6b`). The scaler probe is
  **read-only** — it does *not* call `codex_local_self_heal` (that starts
  `garden-ollama.service` per job); the unit's own `Restart=always`
  (`ollama-serve.sh`) plus the per-job self-heal already cover recovery, and the
  scaler must stay cheap.

- **`moonshot` (mystic).** Reuse `kimi_provider_preflight scaler-probe`
  (`handlers/kimi-provider-common.sh`): `command -v kimi` + `MOONSHOT_API_KEY`
  non-empty.

- **`fireworks` (fireworker).** Reuse `fireworks_provider_preflight fireworker
  scaler-probe`: `command -v codex` + `FIREWORKS_API_KEY` + a bearer `curl` to
  `$GARDEN_FIREWORKS_BASE_URL/models`, treating `2xx` as pass and `429/503` as a
  **retryable** (transient) failure — the hysteresis in § 2 already absorbs those.

**Per-boot cache vs per-tick re-check.** `codex_provider_preflight` caches a
successful paid-provider auth in `$GARDEN_STATE/<ns>/auth-ok-<boot_id>` because a
`login status` probe is comparatively expensive and its result is stable *for a
job*. The scaler needs the opposite: a **live** re-check each tick so it can ramp
**down** on a mid-boot logout. Resolve by giving the probe a `GARDEN_PROBE_LIVE=1`
mode that skips reading/writing that marker (the marker stays for the hot job
path). The cost is one `codex login status` (and one small `curl` for
local/fireworks) per declared kind per ~60s tick — negligible.

---

## 2. Effective vs declared count (runtime cap, with hysteresis)

**The journal `hosts/<host>` record stays the owner-declared target.** `set-workers`
writes it; the scaler never rewrites it on a probe flap. What changes is the value
the scaler *applies*: today `gardener-scaler.sh` reads `want =
read_desired_count(...)` and calls `install-units.sh scale <kind> <want>`. This
design inserts one step:

```
declared = read_desired_count(hosts/<host>, count_key)      # unchanged, journal-owned
effective = backend_effective_count(kind, declared)          # NEW, probe-gated, local
install-units.sh scale <kind> <effective>                    # apply effective, not declared
```

`backend_effective_count` is pure per-host **runtime** state under
`$GARDEN_STATE/<state_ns>/backend/` — no journal write, so it is invisible to
leader/follower and to the owning-host-only-writes rule (§ 5). It keeps a tiny
record per kind: `{ effective, pass_streak, fail_streak }`.

**Hysteresis (confirm-before-move, both directions):**

- **Ramp up.** After `RAMP_UP_CONFIRM` (default **1**) consecutive probe passes,
  set `effective = declared`. Auth success is unambiguous, so one confirmed pass
  is enough; the fleet ramps promptly the moment a login lands.
- **Ramp down.** Only after `RAMP_DOWN_CONFIRM` (default **2**, ~2 min at the
  1-min tick) consecutive probe **failures** drop `effective = 0`. A single
  transient blip (network, a `429`, a restarting Ollama) must **not** tear the
  pool down: a scale-to-0 SIGTERMs idle extras and blocks new claims, and the
  re-ramp costs unit restarts. Two-tick confirmation costs one extra minute of a
  genuinely-dead backend running unauthenticated (the handler preflight already
  fails those jobs environmentally and requeues them) in exchange for immunity to
  flapping.
- **Hold.** Inside the band (streak below threshold), `effective` is unchanged.

Because scale-down already **defers mid-job workers** (`install-units.sh scale`
gates on the `worker_busy` marker and a later tick stops the idle survivor), an
effective→0 never interrupts an in-flight `claude -p`/`codex` call; it only stops
idle capacity and stops *claiming* new work. That is the desired behavior when the
backend is down.

**Optional gradual ramp.** The default is one-step (`0 → declared` on confirm),
which is simplest and matches "allow up to declared once confirmed." A knob
`GARDEN_BACKEND_RAMP_STEP` (default 0 = disabled) can raise `effective` by at most
N per tick for operators who want a slow warm-up; not needed for correctness.

**Decision — sustained failure caps at runtime only; it does NOT down-declare.**
The declared record is left intact even under a long outage, for three reasons:
(a) it encodes owner intent for when the credential returns — down-declaring would
lose the target and defeat auto-restore; (b) a scaler that rewrote `hosts/<host>`
on every flap would thrash the journal and entangle the runtime scaler with the
owning-host-only-writes coupling; (c) the provisioning gate (§ 3) already prevents
a kind from *ever* being declared on a host that cannot run it, so a sustained
runtime failure is a **credential-came-and-went** event, not a misprovision — the
right response is a runtime cap plus an operator-visible alert (§ 6), letting a
human choose to `set-workers <kind> 0` if the loss is permanent. The scaler never
makes that call for them.

---

## 3. Provisioning gate (fresh-gnome bring-up)

**`set-workers.sh` refuses to declare a non-gardener kind's count > 0 until that
kind's probe passes once on this host.** New guard, after the existing
`kind`/`n`/`host` validation:

```sh
if [ "$kind" != gardener ] && [ "$n" -gt 0 ] && [ "${GARDEN_FORCE_DECLARE:-0}" != 1 ]; then
  worker_backend_probe "$kind" \
    || die "refusing to declare $count_key=$n: this host's $kind backend probe failed
            (missing credentials or software). Provision the backend first, or override
            with GARDEN_FORCE_DECLARE=1 if you are staging ahead of a credential."
fi
```

- **Gardener is exempt from the declare-gate.** It is the baseline kind and carries
  a hard floor of ≥1 (`set-workers` refuses `gardeners: 0`; the scaler floors at
  1). A fresh gnome should declare `gardeners: 1` as its *target* even before the
  human finishes the Claude device-login, so the fleet auto-ramps the instant auth
  lands. The **runtime cap** (§ 2/§ 4), not the declare-gate, keeps effective
  gardeners at 0 until the Claude probe passes — this is precisely how "a gnome
  with no Claude auth sits at 0" is honored without weakening the declared floor.
- **`GARDEN_FORCE_DECLARE=1`** is the expert override for staging a declaration
  ahead of a credential (e.g. scripting a host before its key is seeded). The
  runtime cap still keeps it at effective 0 until the probe passes, so the override
  is safe — it changes only the declared target, never what runs.

**Operator flow (fresh gnome).** `context/first-run/` and
`context/operations/starting.md` gain one paragraph:

1. Finish the three credentials (`context/first-run/auth.md`) — at minimum the
   Claude login, so gardeners can run.
2. Declare gardeners: `set-workers.sh gardener <N>` (always allowed).
3. For each *additional* backend the host has, provision it (install `codex` and
   `codex login`; install `ollama` + pull a model; export `MOONSHOT_API_KEY` /
   `FIREWORKS_API_KEY`), then `set-workers.sh <kind> <N>`. The gate passes only
   after provisioning, so a gnome like **ps23** (Claude only) simply cannot
   declare `clerics`/`hermits`/`mystics` — the command refuses with the missing
   piece named, instead of standing up pools that fail every claim.
4. `set-workers.sh <kind> 0` is always allowed (it withdraws a kind), and clearing
   a declaration entirely leaves the line absent (the scaler no-op, not scale-0).

---

## 4. The "auto-tune until logged in" ramp (lifecycle)

The two mechanisms compose into one story per kind:

```
declared (journal, owner)          effective (runtime, probe-gated)
        │                                    │
   set-workers  ──gate: probe once──▶  starts at 0 on bring-up
        │                                    │
        ▼                                    ▼   each scaler tick:
   hosts/<host>                    probe live ─┬─ pass ×RAMP_UP_CONFIRM   → effective = declared
                                               ├─ fail ×RAMP_DOWN_CONFIRM → effective = 0
                                               └─ otherwise               → hold
                                                     │
                                                     ▼
                                        install-units.sh scale <kind> <effective>
```

- **Cold start.** A freshly-installed pool has no backend record → `effective`
  seeds to 0. Tick 1 probes; the first confirmed pass raises it to declared. So a
  host that installed units before its Claude login completes sits idle-but-ready
  and ramps automatically when the device-login finishes — no manual nudge, and no
  pool spinning uselessly on an unauthenticated backend.
- **Auth loss mid-life.** A human logout / expired-and-unrefreshable credential /
  a dead Ollama makes the probe fail; after `RAMP_DOWN_CONFIRM` ticks `effective`
  drops to 0 and idle capacity is withdrawn (in-flight jobs finish first).
- **Recovery.** The next confirmed pass ramps straight back to declared.

---

## 5. Interaction with leader/follower and the standing invariants

- **The scaler is already per-host** (`gardener-scaler.sh` is *not* leader-gated —
  gardeners run on every host). Effective-count computation is local runtime state
  in `$GARDEN_STATE`; it performs **no journal write**, so it cannot conflict with
  singleton-on-leader services and needs no `is-main-host` gate.
- **Owning-host-only-writes is preserved.** `set-workers` still enforces `[ "$host"
  = "$GARDEN" ]` — the gate and cap add read-only probes, never a cross-host write.
  A host caps only *its own* pools from *its own* probe results; it never touches
  another host's record.
- **The gardeners ≥ 1 guard is preserved at the declared layer, relaxed at the
  effective layer.** `set-workers` still refuses `gardeners: 0` and the scaler
  still floors the *declared* gardener count at 1 — so intent is never lost. But
  the **effective** gardener count may legitimately be 0 when `claude_auth_ok`
  fails: that is the mechanism by which "a gnome with no Claude auth must be able
  to sit at 0" holds without declaring 0. The scaler's existing
  `gardeners: 0 → refuse/floor-1` logic applies to `declared`; it must **not** be
  applied to `effective` (an effective 0 from a failed probe is intended, not a
  misconfig). This is the one behavioral subtlety to get right in implementation:
  the floor guard reads `declared`, the `scale` call takes `effective`.

---

## 6. Observability

- **Log every auto-tune transition.** On any `effective` change,
  `gardener-scaler.sh` emits a structured line:
  `log "auto-tune $kind: effective N->M (declared D; probe <pass|fail> streak K)"`.
  A hold is a quiet `DEBUG`. This makes the ramp legible in the unit journal.
- **Surface a host that cannot run its declared kinds.** When a kind has been
  capped below its declared target for `BACKEND_DEGRADED_TICKS` (default ~10 ticks
  ≈ 10 min), emit **one** `alert_maintainer` keyed
  `backend-degraded-${GARDEN}-${kind}` (the key dedups so it fires once per
  degraded episode, not every tick):
  `"host $GARDEN declares $count_key=$declared but its $kind backend probe has
  failed ~${mins}m (effective 0). It cannot run its declared ${kind}s — <the
  probe's stderr diagnostic>."` The provider-quota reclassifier in
  `alert_maintainer` already folds a fleet-wide quota outage into one notice, so a
  usage-limit flap won't spam. On recovery, log the ramp-up (no second alert
  needed; the dedup key resets for the next episode).
- **Local status sidecar (optional, cheap).** Write
  `$GARDEN_STATE/<state_ns>/backend/status` as `declared=… effective=… probe=…
  since=…` on each transition so `install-units.sh status` (and any future health
  command) can render a per-host backend matrix without re-probing. Read-only, no
  journal.

---

## 7. Implementation surface (for the follow-up build)

Tight and localized; no new services, no new journal schema.

| File | Change |
| --- | --- |
| `scripts/jobs/common.sh` | add `claude_auth_ok`, `worker_backend_probe <kind>` (dispatch on registry `provider`, reuse existing preflights + the software check that mirrors `worker_health_probe`), `backend_effective_count <kind> <declared>` (hysteresis over `$GARDEN_STATE/<ns>/backend/`). Sits alongside the landed `worker_health_gate`/`worker_health_probe` (§ 0), does not modify them. |
| `scripts/jobs/handlers/codex-provider-common.sh` | honor `GARDEN_PROBE_LIVE=1` to bypass the per-boot `auth-ok` marker in `codex_provider_preflight`. |
| `scripts/jobs/gardener-scaler.sh` | between `read_desired_count` and `install-units.sh scale`, compute `effective`; keep the gardener floor on `declared`; pass `effective` to `scale`; log transitions; alert on sustained degradation. |
| `scripts/jobs/set-workers.sh` | add the probe gate for non-gardener `n>0` (with `GARDEN_FORCE_DECLARE=1` override). |
| `context/operations/starting.md`, `context/first-run/auth.md` | document the provisioning gate operator flow (§ 3). |
| `scripts/jobs/test/` | scaler test: probe-fail → effective 0 after `RAMP_DOWN_CONFIRM`; probe-pass → ramp to declared after `RAMP_UP_CONFIRM`; declared record never rewritten; gardener floor honored on declared while effective may be 0. `set-workers` test: non-gardener declare refused when probe fails, allowed after it passes / under force. |

**Tunables** (all env-overridable, sane defaults): `RAMP_UP_CONFIRM=1`,
`RAMP_DOWN_CONFIRM=2`, `BACKEND_DEGRADED_TICKS=10`, `GARDEN_BACKEND_RAMP_STEP=0`,
probe `timeout` 8s, `GARDEN_PROBE_LIVE=1` for the scaler path, `GARDEN_FORCE_DECLARE`
for the declare override.
