---
role: gardener
---
# Validate a fireworks job end to end

Maintainer directive (2026-07-28): validate that fireworks jobs can be executed end
to end. Follow the **kimi-k3 precedent** — a bounded, reversible canary, not a
rollout: [context/operations/kimi-k3.md](../../context/operations/kimi-k3.md) is the
model for the shape of this work, and
[context/operations/fireworks.md](../../context/operations/fireworks.md) is the
lane's own page.

## Measured starting state (2026-07-28T07:30Z, `endolin-garden2-5bcdff64`)

The lane is **wired but inert** — nothing is broken; it has simply never been
declared:

- `FIREWORKS_API_KEY` is **present** in the shell *and* in the `systemd --user`
  manager (via `/run/environment.d/60-garden-api-keys.conf`), so a worker would
  inherit it. Verified by name only — **never print, echo, log, or `set -x` this
  value**, and never save a provider response as a fixture.
- Registry: `fireworker` → handler `handlers/cleric-codex.sh`, provider `fireworks`,
  unit `garden-fireworker@`, count_key `fireworkers`. The unit template **is**
  rendered. Note the handler is **shared with the cleric** (openai) — the provider
  split is inside `handlers/codex-provider-common.sh`, which has a dedicated
  `fireworks_provider_preflight` (~line 107/127) describing Fireworks as "a separately
  credentialed OpenAI-compatible service" probed secret-safely.
- **`hosts/endolin-garden2-5bcdff64` has NO `fireworkers:` line.** The scaler treats
  an absent line as "this host does not declare this kind" and quietly leaves the pool
  alone — hence **0 fireworker units**. Declaring it is the deliberate arming act.
- Eligibility (`claim-job.sh:77`): fireworks is an **explicit-model-only lane** — a
  job is eligible only if `model:` matches `fireworks/<wire-id>` with a non-empty
  wire id. This is deliberate, so no unpinned board job can wander onto a paid
  provider. Preserve that property.

## Procedure

1. **Resolve a valid wire id — do this first; it gates everything.**
   `resolve_model_tier fireworks <m>` accepts `fireworks/<wire-id>` only when
   `_model_classify fireworks` also classifies it, so an arbitrary string will be
   rejected as unpinned and the canary will never be claimed. Determine a **live**
   Serverless/Fast/deployment id and confirm it classifies. The namespace deliberately
   carries the exact wire id rather than a friendly tier, precisely so the catalog is
   not baked into code — expect to have to look it up, and record what you used.
2. **Probe auth status-only**, in the style of kimi-k3 § 2: print the HTTP status and
   nothing else. No `-v`, no header echo, no response body saved. A failure means
   stop at zero fireworkers and diagnose without copying the key anywhere.
3. **Arm exactly one worker**: add `fireworkers: 1` for this host
   (`scripts/jobs/set-workers.sh fireworker 1`, or the kind's setter if one exists),
   and confirm the scaler brings up `garden-fireworker@1`.
4. **Post a small, reversible canary** with frontmatter pinning
   `model: fireworks/<wire-id>`. Make it exercise a real **tool action** — create a
   file in its isolated per-job worktree, read back an exact marker, remove it — and
   require its normal completion marker. Do **not** target a production repository, a
   designer/builder role, a merge, or any external side effect.
5. **Verify end to end**, which is the point of the job:
   - the canary reaches `jobs/tada/<base>.md` with the marker;
   - `git status --porcelain` in its worktree is clean — no repository content
     modified, nothing committed or pushed;
   - its reputation event is scoped to `kind: fireworker`, `provider: fireworks`,
     `model: fireworks/<wire-id>` — **not** openai, anthropic, moonshot, or local.
     This matters more than usual because the handler is shared with the cleric:
     a mis-scoped event would mean fireworks work is being recorded against the
     **openai** arm.
6. **Return the pool to zero** (`fireworkers: 0`) unless the maintainer explicitly
   authorizes a larger trial. Non-gardener kinds *can* legitimately scale to 0 — only
   gardeners have the hard floor of one.

## Expect censored cost — record it, do not treat it as failure

Do not be surprised when the canary's event carries `agentic_dollars: censored`.
Measured across the whole journal today: **all 1377 reputation events are censored,
and all 73 arms sit at `attempts: 0`.** No lane — anthropic, openai, moonshot —
writes a `usage/<base>.jsonl` cost ledger, so `complete-job.sh` fails open for every
provider. This is a known fleet-wide condition with two jobs already open
(`fix-censored-events-frozen-reputation-arm`, `wallclock-cost-proxy-for-censored-arms`);
it is **not** a fireworks defect and must not block this validation.

What to do instead: **record whether the codex handler emits any usage/token data for
the fireworks provider**, since that is a genuine input to those two jobs. If it does,
that is a notable finding — it would be the first lane with real cost evidence.

## Definition of done

- A `fireworks/<wire-id>` canary ran to a `tada` report with its exact marker, on a
  real tool action, with a clean worktree and no external side effects.
- The wire id used is named in the report, along with how it was resolved and
  confirmed to classify.
- The reputation event's arm is confirmed scoped to fireworker/fireworks — explicitly
  checked against the shared-handler mis-scoping risk.
- Whether the handler emits usage/token data for fireworks is stated either way.
- The pool is returned to `fireworkers: 0` unless the maintainer said otherwise, and
  the report says which.
- No secret, provider response body, or fixture containing either appears in any
  journal entry, report, log, or commit.

<!-- garden-reaped: 1 -->
