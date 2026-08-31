---
role: designer
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---
# design: a triage-and-batch system for Ironhorse fuzz findings

The current lane emits **one full job per finding** — its own gauntlet, panel,
fixer loop and PR amendment. That granularity has failed in three distinct ways
at once, and the maintainer has paused the fuzzer
(`garden-ironhorse-fuzz.timer`, stopped 2026-08-31) pending this design.

## The measured evidence

**73 quarantined fuzz repair jobs** sat in `jobs/plan/` on 2026-08-31, across
only **THREE** fuzz targets:

    differential_regexp_surface   26
    differential_regexp           26
    differential_source           20

66 of the 73 carry `doom_signature: policy-refusal`; the other 7 are
`requeue-exhausted`. The journal has ~100 recorded findings in
`ironhorse-fuzz/findings/`.

Three failure modes, all traceable to one-job-per-finding:

1. **Policy blockage at scale.** 55 refusals in nine hours on 2026-08-31. Near
   identical prompts trip the same provider filter deterministically, so the
   reaper (correctly) does not requeue and quarantines each one. A separate job
   `ironhorse-fuzz-repair-template-policy-rewrite` addresses the FRAMING; it does
   not address the fact that we generate one such prompt per finding.
2. **No triage before work.** Some `differential_*` findings are **xs-oracle or
   harness artifacts, not port bugs at all** — known instances include a 1024-byte
   result-buffer truncation and XS's non-shortest `fx_dtoa` for large-integer
   doubles versus Ironhorse/V8 shortest output. Nothing classifies a finding
   before a full repair engagement is spawned for it.
3. **Cost and queue pressure.** 52 of 73 are regexp-family and very likely share
   a small number of root causes, yet each carries a full gauntlet.

## What to design

A **triage-and-batch** system. At minimum:

- **A triage stage before any repair work.** Classify each finding: genuine port
  defect / oracle-or-harness artifact / duplicate of an existing finding. Only
  the first class earns a repair engagement. Say how artifacts get recorded so
  the same input is not re-triaged forever, and how the fuzzer stops re-emitting
  them.
- **Clustering.** Group findings by target and by probable root cause, and make
  the unit of work a CLUSTER, not a finding. Specify the clustering signal
  (target, crash site, minimized-input shape, stack signature — whatever the
  recorded findings actually support; check what `ironhorse-fuzz/findings/`
  contains before assuming).
- **Batch job shape.** One job per cluster amending the ONE standing fuzz PR,
  with a bound on cluster size so a batch cannot become unclaimable.
- **Backpressure.** The fuzzer currently generates without regard to how much
  repair backlog exists. Define what stops it — a cap on outstanding findings, or
  a queue-depth check before emitting.
- **Migration for the existing 73.** They are quarantined, not lost. Say how they
  fold into the new shape. Note that a sibling job
  `ironhorse-fuzz-repromote-quarantined` currently plans to re-promote them
  one-by-one under the old shape; if this design supersedes that, say so
  explicitly so the two do not fight.

## Constraints

- **Preserve the existing data discipline.** `ironhorse-fuzz.sh` never
  interpolates crash bytes into a shell command or an LLM prompt; inputs are
  referenced by durable path and sha256. That is correct and must survive.
- Do not design around the policy filter by obscuring what the work is. This is a
  legitimate correctness lane on the garden's own engine; accurate plain
  description is the goal.
- The fuzzer stays paused until this lands. Note in the design what re-arming
  requires — the timer is host-locally disabled AND excluded in
  `install-units.sh`, so re-arming is a deliberate two-part act.

## Definition of done

A design under `designs/`. If it carries genuinely unresolved maintainer-facing
open questions, follow the CLAUDE.md carve-out and present it as a review PR
rather than landing it bare.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-31T21:59:40Z
