# Design: mirror operator-directed host state into the maintainer inbox

A lightly-attended host (`oros-studio`) must be operable remotely. Today a fact
that a *local operator* can see at the host — most sharply, **why this host is
drained** — is invisible to a remote maintainer, so the two cannot race to fix an
issue: the maintainer waits on the operator, or asks a question the host already
knows the answer to. This design mirrors the small set of operator-facing host
facts into journal state and, coalesced, into the maintainer inbox, so either
party can act and a fix by *either* stands the other down.

Maintainer directive: kriskowal, 2026-09-17 — "oros-studio is only lightly
attended and I expect that we will need to operate it remotely. Let's adjust so
messages to the operator also get sent to the maintainer inbox, so the local
operator and garden maintainers can race to address issues."

## The motivating incident

On 2026-09-17 `oros-studio-garden-ce242c49` sat drained for ~13.5 hours (from
06:16:38Z) and fell 11 commits behind while the other two hosts stayed current.
Its `fleet/health` record read `roll_status: operator-drained`, but no `drain on`
op had crossed the bus since 2026-09-14 (lifted 09-15). So the liaison could see
**that** the host was drained and not **why**.

The "why" exists. `drain-fleet.sh` writes `set_by`, `set_at`, `source:`, and an
optional free-text `reason` into the draining marker (`scripts/jobs/drain-fleet.sh:73-76`).
But that marker is a **host-local file** (`$GARDEN_DRAINING_MARKER`,
`$GARDEN_STATE/draining`; `common.sh:288`) — unreadable from any other host. And
the two obvious remote reads are both closed:

- The sysop vocabulary has no operation that **reads** host state; every op in the
  closed set mutates (`sysop.sh` `dispatch_op`).
- A host-pinned job (`requires: host=…`) cannot help: a **drained** host claims
  nothing, so the very condition you want to diagnose prevents diagnosis.

Note the sharpening from `845b1895e2`: a drain whose `source:` is absent or
unrecognized **fails safe toward `operator`** (`drain_source`, `common.sh:625-633`),
which is correct for the operator-drain guarantee but means a pre-fix or unsourced
marker reads as an operator drain **indefinitely**, and the rolling-deploy conductor
skips that host forever (`rolling-deploy.sh:243,371`). A host stuck this way no
longer self-heals; remote visibility is what would catch it.

## What already reaches the maintainer, and what does not

The garden already mirrors a large class of host-local **faults** to the inbox.
Every daemon that detects a fault it cannot itself repair calls `alert_maintainer`
(or its edge-latched sibling `alert_maintainer_edge`), which routes through
`watchdog-notice.sh` and keeps **one coalesced entry per condition**
(`common.sh:1760-1968`): the journal-worktree keeper's unpreservable/reset
failures, the root-repo guard's unrepairable origin, a fail-closed budget pool
refusing every claim (`claim-job.sh:216`), a scheduler preflight gap, a
rolling-deploy canary failure, a handler-budget overrun, ollama losing its model,
and more. These are already operator-facing and already delivered; this design
does **not** duplicate them.

The gap is a different class: **operator-initiated posture**. A drain is a
deliberate act, not a fault, so no fault-detector fires on it — yet from another
host it is both invisible and, per the fail-safe reading above, potentially stuck.
That asymmetry is the whole of the motivating incident.

### The boundary: what makes a fact operator-facing

A host fact belongs in the mirror when **all three** hold:

1. **Standing, not transient.** It persists across the host's own control-loop
   ticks and will not self-heal. A blip that the next tick clears is host-local
   noise; a drain that has been in place 13 hours is a standing posture.
2. **Remotely actionable.** A remote maintainer can do something about it —
   canonically, lift a drain (`drain off`, over the sysop bus or by standing at the
   host). A fact no remote party can act on is not worth an inbox entry.
3. **Not already surfaced.** No existing `alert_maintainer` path already reports
   it. The fault classes above stay where they are.

A fact stays **host-local** (published to neither the journal nor the inbox) when
it is either (a) transient/self-healing within the host's control loop, or (b)
**machine-derived sensitive metadata** — the reason the capability cache is
deliberately host-local: "journal2 is public and publishing that a named host holds
an AWS credential would be useful targeting metadata" (`common.sh:6404-6408`). The
mirror never publishes a fact the daemon *derives from* a credential or capability
probe; see § Safe to publish.

### The in-scope set, and the candidates deferred

| Candidate (from the directive) | Disposition |
| --- | --- |
| **Drain set/lifted, with reason + `set_by` + `source`** | **In — increment 1.** The motivating case; operator-initiated, currently silent. |
| **A drain stuck / falling behind** (drained + N commits behind leader-sha) | **In — increment 2.** A *derived* operator fact: `drained AND deployed_sha ≠ leader-sha by N`. This is the 11-behind symptom; it is exactly the residual of the fail-safe-toward-operator rule. |
| Deploy stalled / upgrade-ready accumulating | **Mostly already covered** — the root-repo guard already alerts when `deployed_sha` lags `origin/main2` past `GARDEN_DEPLOY_STALL_DAYS` (default **3 days**; `root-repo-guard.sh`), and `upgrade-monitor.sh` alerts on sensor blindness. The mirror adds only the *drained-and-behind* slice above, at **hours** scale and keyed to the drain — the exact case the 3-day stall watch is too slow and too drain-blind to catch. |
| Unit failures / `first_bad_unit` detail | **Already in `fleet/health`** (`unit_failures`, `first_bad_unit`; `common.sh:1164-1166`) and already fault-alerted by the keepers. No new work. |
| Root-repo-guard repairs | **Already alerts** (`root-repo-guard.sh:252`). No new work. |
| Worker starvation (host-pinned job unclaimed past its dwell) | **Deferred.** This is a *board* fact, not a host posture; it belongs to a board-health monitor, not this per-host mirror. Noted as future. |
| Budget/claim-gate halt (fail-closed pool refuses every claim) | **Already alerts** (`claim-job.sh:216`, `budget-level.sh` freeze). No new work. |

The mirror's charter is narrow on purpose: **operator-initiated posture and its
residuals** — chiefly the drain — because that is the class no existing path
carries.

## Mechanism

### Publish posture as journal state (increment 1a)

`fleet/health/<GARDEN>` already carries `roll_status` and is the record every host
can read. Carry the drain's provenance **alongside it**, exactly as the directive
suggests. Add to the health record (`publish_fleet_health`, `common.sh:1140-1181`):

```text
drain_active:  true|false
drain_source:  operator|rolling-deploy|<unrecognized→shown as-is>|-
drain_set_by:  <GARDEN of whoever set it>
drain_set_at:  <ISO>
drain_age_s:   <seconds since drain_set_at>          # derived, so "13h" is legible remotely
drain_reason:  <free prose, or the literal `-` when withheld>   # see § Safe to publish
```

These come straight from the host-local marker via the existing `drain_source`
reader plus two new one-line `sed` reads of `set_by`/`set_at`/`reason` (the same
shape `drain_source` already uses). `drain_age_s` and an **`drain_unsourced:
true`** flag (set when the marker has no `source:` line — the case that reads as
operator forever) make the stuck-host residual visible without any new state.

`publish_fleet_health` is today called only on the deploy path, so a host that is
merely drained publishes nothing fresh. This design adds a **periodic publish**:
the mirror daemon (below) calls a lightweight `publish_operator_state` each tick
(a thin writer that refreshes only the `drain_*` fields and `at:` on the existing
`fleet/health/<GARDEN>` record, CAS-looped like `publish_fleet_health`, best-effort
so an unreachable journal never fails a tick). No new journal path; `fleet/health`
stays the single per-host record.

### Mirror to the inbox, coalesced (increment 1b)

The daemon reuses the existing coalescing path unchanged — it does **not** invent a
second notice mechanism. For each standing operator-facing condition it computes a
**fingerprint** and calls:

```sh
alert_maintainer_edge "operator-drain-$GARDEN" "$fingerprint" "$body"
```

`alert_maintainer_edge` (`common.sh:2017`) is precisely the primitive for a
standing condition: it delivers via `watchdog-notice.sh` **only** when the stored
fingerprint is absent (the condition begins) or differs (it changes), and stays
silent on every steady tick — so a 13-hour drain produces **one** inbox entry, not
one per tick. This is the same call shape `budget-level.sh:49` already uses for its
freeze notices. The fingerprint is `source|set_by|set_at` (plus, for increment 2,
a bucketed commits-behind), so re-alerting happens exactly when the *reason for the
posture* changes, not on cosmetic churn.

When the condition ends — the host is no longer draining on a later tick, by
whatever hand — the daemon calls `alert_maintainer_edge_clear
"operator-drain-$GARDEN"` on its happy path, which posts **one** `--recovered`
notice that amends the open entry closed in place (`watchdog-notice.sh --recovered`;
`alert_maintainer_clear`, `common.sh:1979-2001`). Because the notice file lives in
the journal-shared maintainer inbox (`inbox/maintainer/unread/watchdog-operator-drain-<GARDEN>.md`),
there is exactly **one** entry for the condition across the whole fleet, and the
proxy's existing watchdog auto-clear (`proxy.sh`, sender `watchdog:*`) archives it
on its normal grace once handled. The mirror rides entirely on machinery that is
already load-bearing.

### The daemon

A new deterministic, **no-LLM** per-host timer, `garden-operator-state`
(`scripts/jobs/operator-state.sh`, cadence ~5–10 min), installed and enabled on
**every** host (like the sysop and the root-repo guard — it reports each host's own
posture, so it is not leader-gated). Each tick:

1. Read this host's drain marker (existence + `source`/`set_by`/`set_at`/`reason`).
2. `publish_operator_state` → refresh the `drain_*` fields on `fleet/health/<GARDEN>`.
3. If draining: `alert_maintainer_edge` with the fingerprint above. Else:
   `alert_maintainer_edge_clear`.
4. (Increment 2) If draining and `deployed_sha` lags `deploy/leader-sha` by ≥ a
   threshold, fold the commits-behind into the fingerprint and body. This fires in
   *hours* and only for a **drained** host lagging the leader-validated sha, so it
   catches the fail-safe-toward-operator residual that the root-repo guard's 3-day,
   drain-blind `origin/main2` stall watch misses.

It runs no `claude`, claims no jobs, mutates nothing on the host — it only reads
host-local state and writes journal records. It is the read-and-publish dual of the
sysop's write-only vocabulary.

## Race semantics

Both a local operator and a remote maintainer may now act on the same drain. The
design makes that safe by construction:

- **Idempotent remedy.** The remedy is `drain off`, and both spellings are
  idempotent: `drain-fleet.sh off` is a no-op when no marker exists, and the sysop
  `drain` op delegates to it. Whoever acts second is a clean no-op, never a fight.
- **Either party closes it for both.** The notice is keyed on the *condition*
  (`operator-drain-<GARDEN>`) and the daemon publishes from the host's **actual**
  state. Once the marker is gone — by the local operator's hand or a maintainer's
  bus `drain off` — the next tick's `alert_maintainer_edge_clear` closes the single
  shared journal entry, and `fleet/health/<GARDEN>` flips `drain_active: false`.
  Both parties read the same close.
- **How the second responder learns to stand down.** Two independent signals: (a)
  the maintainer's `maintainer-watch` Monitor shows the entry flipped to RECOVERED
  (amended in place, not a new message); (b) before acting at all, a maintainer
  reads `fleet/health/<GARDEN>`, which already shows `drain_active: false` the
  instant the host's next tick publishes it. A maintainer who checks state first
  simply finds nothing to do.
- **Who acted, and when.** A drain lifted **over the bus** is already attributable:
  the sysop writes `sysop-log/<GARDEN>/<msgid>.md` with the self-asserted `from_host`
  and the op. A drain lifted **locally** at the host leaves no actor record today —
  `drain-fleet.sh off` just removes the file. To make the local case attributable,
  this design has `drain-fleet.sh off` drop a short host-local breadcrumb
  (`lifted_by: <GARDEN>`, `lifted_at: <ISO>`) that the next publish tick folds into
  the recovery body ("drain lifted locally at …"). This is a one-line addition; see
  Open questions for whether it is worth the churn versus leaving the local case
  unattributed.

## Safe to publish

`journal2` is public, so publishing a host fact must not hand out targeting
metadata. The mirror is safe by the same logic that keeps the capability cache
host-local — and it is on the **right** side of that line:

- The fields that actually answer the motivating question — `drain_active`,
  `drain_source`, `drain_set_by`, `drain_set_at`, `drain_age_s`, `drain_unsourced`
  — are **enums, identifiers, and timestamps the daemon derives itself**. None
  reveals a credential, a capability, or a secret. The capability-cache precedent
  forbids publishing **machine-derived credential presence** ("host X holds an AWS
  key"); it does not forbid publishing "host X is drained, by operator, for 13h."
- The one free-text field is `drain_reason`, written by whoever set the drain. It
  is *already* prose intended for "anyone who finds the file" (the marker's own
  text says so). The delta is audience: host-shell → public journal. The
  recommended stance is **public-by-contract**: document at the `drain-fleet.sh`
  interface that the reason is published to the public journal, so operators write
  it as public prose and never put a secret in it — the same discipline the reason
  field already implicitly asks for. As a safety valve for a host that wants reasons
  kept host-local, a per-host `GARDEN_DRAIN_REASON_PRIVATE=1` withholds the free
  text (publishing `drain_reason: -` and a notice that says "reason withheld; read
  it at the host"), while `source`/`set_by`/`age` still publish — enough to answer
  "is this deliberate, and how old" without the prose. See Open questions.

## Relationship to `designs/sysop-attested-exec.md`

The attested `exec` op (kriskowal, 2026-09-16) would let a maintainer run an
arbitrary command on a remote host and read the marker on demand. It is
**complementary but strictly weaker for this purpose**, and the two compose without
overlap:

- `exec` is a **pull**: it requires a maintainer to already *suspect* a problem,
  hold `authorized_by` attestation (it is destructive-tier), and issue a command.
  It answers "let me go look."
- This mirror is a **push**: the host publishes the fact **unprompted**, so the
  liaison sees "oros-studio drained 13h, operator, 11 behind" in the inbox without
  anyone suspecting anything. It answers "you didn't have to ask."
- They stack cleanly. The mirror surfaces the *what* and *why* for free; `exec`
  remains the escalation for the rare case that needs a live read or a remediation
  the closed vocabulary and `drain off` cannot express. The mirror is read-only and
  needs no attestation (it publishes only non-sensitive derived state); `exec`
  keeps its full attestation gate. Neither changes the other's contract.

## Build slice

- **Increment 1 (the fix for the incident):** extend `fleet/health` with the
  `drain_*` fields; add `publish_operator_state`; add the `garden-operator-state`
  timer/service and install it on every host; wire `alert_maintainer_edge` /
  `_edge_clear` for the drain condition. Document the public-by-contract reason at
  `drain-fleet.sh`.
- **Increment 2:** add the drained-and-behind derivation (commits-behind vs
  `deploy/leader-sha`) to the fingerprint and body.
- **Deferred:** worker-starvation (board-health, not host posture).

No implementation is part of this design change.

## Open questions

1. **Reason-publication policy.** Recommended: publish `drain_reason` by default,
   public-by-contract, with a per-host `GARDEN_DRAIN_REASON_PRIVATE` opt-out. Is
   public-by-default acceptable, or should the free text be **withheld by default**
   (publishing only `source`/`set_by`/`age`, which already answer the motivating
   question) and opt *in*? The safest-by-default choice trades a little diagnostic
   richness for zero chance of an accidental secret on the public journal.
2. **Attributing a locally-lifted drain.** Worth the one-line `drain-fleet.sh off`
   breadcrumb (`lifted_by`/`lifted_at`) so the recovery notice can say who lifted
   it, or is "the condition cleared" enough and the extra write not worth it?
3. **Daemon home.** A dedicated `garden-operator-state` timer is cleanest, but the
   root-repo guard already ticks every host on a similar cadence. Fold the publish
   into an existing per-host timer to avoid a new unit, or keep it separate for a
   clean single-responsibility contract? Recommended: separate, since the guard's
   charter (repo invariants) and this one's (operator posture) should not entangle.
4. **Cadence.** ~5–10 min balances "the maintainer learns within minutes" against
   journal write volume (one CAS write per host per tick, even when nothing
   changed — though `commit_and_push` is a no-op when the record is unchanged). Is
   a slower cadence (e.g. 15 min) acceptable given the incident sat for 13 hours?
5. **Scope creep guard.** The boundary (§ What makes a fact operator-facing)
   deliberately keeps most conditions out. Is "operator-initiated posture and its
   residuals" the right charter, or should the first cut also carry the deferred
   board-health facts (worker starvation) so remote operation is more complete on
   day one?
