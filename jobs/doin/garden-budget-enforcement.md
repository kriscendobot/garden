---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design a mechanism that makes every job draw against a live, enforced token/spend
budget — not just a retrospective cost analysis. Maintainer request, 2026-08-15,
liaison conversation.

## The gap

The prior 5-part budget study (`jobs/tada/garden-budget-ratecard.md`,
`garden-budget-triple.md`, `garden-budget-omega.md`, and the other two) built a
correct-priced cost ledger and an omega task-rank proposal, but it is entirely
*retrospective and partial*: `cost-by-pr.sh` measures only **28.8% coverage** of
merged-PR cost (`garden-budget-triple.md`). No job today is required to check
against, decrement, or be gated by any budget while it runs — the ledger observes
after the fact, on whatever fraction of jobs happen to leave a `usage/<base>.jsonl`
record. The `garden-budget-omega` design also flagged that no dispatch behavior
changed as a result of any of the five reports.

Separately, `roles/liaison/AGENT.md` and the job-board skill already support a
per-job `handler-timeout:` header for wall-clock, and `post-orchestration.sh`
supports `--budget-tokens N` for a whole orchestration (used successfully for the
`ironhorse-test262-implementation-completion-resume-6` campaign) — but that is an
opt-in, per-orchestration mechanism a producer must remember to add, not a
standing property of every job.

## What this design should cover

- What "the token budget" is: per-account weekly Anthropic quota (2 Max 20x
  accounts, $400/mo flat, see `garden-budget-ratecard.md` for the pricing
  derivation), separately from any OpenAI/local spend, and how a design should
  represent multiple independent budget pools (per-provider, per-host-account) so
  leveling monk/cleric/hermit counts between hosts (as already done manually today,
  see `hosts/<host>` worker counts) and gating dispatch can both read the same
  live figure.
- How a job — ordinary board work, not just an orchestration that opts in — comes
  to carry a budget draw: at minimum, extend the existing `--budget-tokens`
  pattern from orchestration-only to every dispatch path (foreman promotion,
  triager-posted jobs, watcher-posted jobs, schedule dispatch), or propose
  something better if the orchestration mechanism does not generalize cleanly.
  Explain why raising coverage from 28.8% to closer to 100% is achievable (or isn't)
  given `cost-by-pr.sh`'s own findings about why so much cost goes unattributed.
  Cite the `garden-budget-omega` design directly for related-but-not-identical work
  it already scoped: the deterministic rank-ordered promoter it proposes governs
  plan→todo *ordering*, not budget consumption or admission, so this design should
  say explicitly whether/how the two compose (e.g., does a budget-aware admission
  gate sit alongside the omega-ranked promoter, ahead of it, or replace part of it).
- What happens at the boundary: does a job that would exceed the remaining weekly
  budget get deferred (parked, like the existing `plan/` + `gate: deferred`
  mechanism), refused outright, or admitted with a loud warning? Consider the
  precedent set today (2026-08-15): a manual observation that garden1 burned 20%
  of its weekly Anthropic quota in the first ~13 hours since the Friday 9pm
  Pacific reset while garden2 burned 5% with zero monk/gardener workers running,
  prompting a manual, one-time worker-count leveling
  (`scripts/jobs/set-workers.sh gardener 2` / the `sysop set-workers` op) rather
  than anything automatic. This design's mechanism should make that kind of
  rebalancing a property of the system, not a thing the liaison has to notice and
  do by hand.
- A concrete example worth grounding the design against: the
  `endojs-endo-but-for-bots-pr992-gauntlet` run this same window burned 6 full
  panel/fix rounds (12 gardener dispatches) and still halted at
  `max_iterations=6` without converging (`jobs/tada/endojs-endo-but-for-bots-pr992-gauntlet.md`).
  A budget-aware system should be able to say, after the fact or ideally before
  round 6, whether that spend was worth continuing.

## Deliverable

A `designs/<name>.md` following the existing budget-study lineage's format
(Status, Decision, grounded in cited evidence, explicit about what remains
provisional), landed on `main2` with a `designs/README.md` index row, per
`skills/design-to-pr-pipeline/SKILL.md` conventions if applicable, or the plain
direct-to-main2 landing the five prior budget jobs used if this is judged
garden-meta rather than project work. Flag any open question that needs the
maintainer's judgment explicitly rather than guessing (the `garden-budget-omega`
job's own pattern of posting a grounding question to the maintainer inbox when a
term or scheme could not be confirmed is the right model to follow here too).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T17:00:51Z
