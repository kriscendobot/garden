---
role: designer
---
# Route opus work to kimi-k3 for evaluation, with automatic opus retry on failure

Maintainer directive (2026-07-28): *"I would like kimi k3 to start taking work away
from claude opus, for evaluation, with the option of retrying with opus if kimi
fails."*

**Deliverable: a design plus implementation.** If the design is large, land the design
and post the build as a child. Do **not** relax any safety bound before the fallback
that justifies it actually works.

## The blocking tension — resolve this first

**The work opus does is exactly the work kimi is currently barred from.**

- `role_default_model` (`common.sh` ~3709): **only `designer` and `builder`** resolve
  to `resolve_model_tier anthropic opus`. Every other role rides the fleet default.
- `job_eligible_for_kind` (`claim-job.sh:67-73`): for `KIND_PROVIDER = moonshot`, the
  job must pin `model: kimi-k3` **and**

  ```bash
  case "$role" in
    designer|builder) return 1 ;;   # explicit K3 is not a high-stakes route
  esac
  ```

So as configured, kimi-k3 **cannot take any work away from opus** — the intersection is
empty. Satisfying the directive requires lifting that bar for at least some
designer/builder work.

That bar is a deliberate safety boundary, and the maintainer's own framing supplies
the mitigation: **an automatic opus retry is what makes routing high-stakes work to
kimi acceptable.** Design them as one unit. **Sequencing is mandatory: the fallback
must be built and demonstrated BEFORE the bar is relaxed**, never the reverse.

Consider whether the relaxation should be **graduated** rather than binary — e.g.
`builder` before `designer`, or only jobs below some work-class size — and say why.

## The fallback does not exist today, and requeue actively defeats it

A failed job is requeued **with the same basename and the same body** — including its
`model: kimi-k3` pin. A mystic therefore re-claims it, fails again, and the cycle
repeats until poison. **There is no path by which a failed kimi job reaches opus.**

So the core build is: **on failure, re-route rather than merely requeue.** Open
questions the design must answer:

- **What counts as "fails"?** Distinguish at minimum: handler non-zero / crash;
  deadline overrun; provider unavailable or quota-limited; and *completed but bad*
  (the panel rejects it, CI stays red, the fix-loop cannot converge). The last is the
  most important for real evaluation and the hardest to detect — a builder job that
  returns a plausible-but-wrong diff is exactly what an evaluation must catch. The
  gauntlet's panel is the existing quality gate; consider making a panel rejection a
  fallback trigger.
- **How is the re-route expressed?** Rewriting the `model:` pin on requeue is the
  obvious mechanism but mutates the job body; alternatives include a
  `fallback-model:` header consumed by the requeue path, or an attempt counter that
  selects from an ordered provider list. Whatever you pick must survive the reaper's
  basename-preserving requeue and must not confuse `job_eligible_for_kind`.
- **Session continuity.** `handlers/gardener-claude.sh` derives a deterministic session
  id from the basename and `--resume`s the interrupted transcript. A kimi transcript is
  **not** resumable by opus. The fallback must start opus **fresh** rather than
  resuming a foreign session — get this wrong and the retry inherits a corrupted or
  alien context.
- **No infinite ping-pong.** One fallback hop, not a cycle. Record which providers a
  job has already burned.

## Prior art — reuse the shape, note the limits

`GARDEN_FOREMAN_PROVIDER_ORDER` ([foreman-providers.md](../../context/operations/foreman-providers.md),
`foreman.sh:199-205`) already implements ordered provider fallback: comma-separated,
left-to-right, an availability/quota failure advances to the next. **Reuse the shape,
but note three gaps** — it applies only to the **foreman's own planning call**, not to
claimed board jobs; it validates against only `openai`, `local`, `anthropic` (**not
moonshot**); and it falls back on *availability*, not on *task failure*, which is the
case that matters here.

## Evaluation is currently impossible — say so and depend on the fix

The directive's purpose is **evaluation**, and the garden cannot currently evaluate
anything:

- **All 1377 reputation events carry `agentic_dollars: censored`; all 73 arms sit at
  `attempts: 0`.** The bid-auction's Thompson draw has never learned from any completed
  job, on any provider. Open job **`build-token-cost-ledger`** is the head of that chain
  and is a hard prerequisite for cost-based comparison.
- **Arms are keyed `<kind>/<provider>/<model>/<thoughtfulness>/<work_class>@<target>`**,
  so kimi-vs-opus on the same work class *is* expressible once arms populate — this is
  the natural comparison surface. Coordinate with
  **`investigate-opencode-alternate-harness`**, which raises the related question of
  whether harness should become an explicit arm dimension.
- Define the **success metric** up front, and do not let it be cost alone. A cheaper
  model that fails half its builder jobs and falls back to opus is *more* expensive in
  total, not less. Count the fallback's opus run against kimi's record, or the
  evaluation lies.

## Operational scope

- The mystic pool is **1** on this host (`hosts/<GARDEN>`: `mystics: 1`) and moonshot
  auth is verified (`/v1/models` → 200); the 2026-07-25 canary passed with real tool
  use. Recommend the initial share and whether the pool needs to grow — start small,
  bounded, and reversible, per the kimi-k3 precedent
  ([kimi-k3.md](../../context/operations/kimi-k3.md)).
- Say how to **turn it off fast** if kimi degrades throughput: one journal-state change
  or one env knob, not a code edit.

## Definition of done

- A design under `designs/` covering the eligibility relaxation, the failure taxonomy,
  the re-route mechanism, the ping-pong bound, and the evaluation metric.
- A working fallback: a deliberately-failed kimi job demonstrably re-runs on opus,
  fresh-session, once — shown in the report.
- The eligibility bar relaxed **only after** that demonstration, and only as far as the
  design argues for.
- A stated kill switch.
- Pushed to `main2` (direct push, no PR).
