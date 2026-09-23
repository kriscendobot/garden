---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer (kriskowal, 2026-09-23): the garden now has access to two new
models: typesafe.ai's **Jev** model, and Anthropic's **Opus 5.5**. Two related
questions to resolve as one design.

## 1. Where does Opus 5.5 sit in the fleet's tier vocabulary?

`skills/model-selection/SKILL.md` currently has four tiers (mentat, mentor,
minion, myrmidon; closed inventory in `scripts/jobs/model-tier-inventory.tsv`).
Opus 5.5 is possibly mentor- or mentat-shaped in capability but reportedly
**less expensive** than existing models at those tiers. Evaluate:

- Does Opus 5.5 slot into an EXISTING tier (mentor or mentat), or does its
  cost/capability shape warrant introducing a NEW tier (e.g. between mentor
  and mentat)? Ground this in real evidence, not the "possibly" in the prompt —
  check actual pricing/capability where available, or state plainly that
  evidence is unavailable and record it as an open question.
- If it lands at an existing tier, is it strictly better than the incumbent(s)
  at that tier on a cost basis? Should it become the primary/default model
  routed at that tier, given `claude-opus-5` is currently capped down to the
  minion model for automatic work (the "anthropic automatic-work cost
  ceiling" in the skill doc)? Does a cheaper Opus 5.5 change that ceiling
  calculus?
- Follow "Adding or changing a model" in the skill doc: exact provider/id/tier
  row in `model-tier-inventory.tsv`, same id in `model-routing-defaults.tsv`,
  regression coverage, and an update to
  `designs/provider-model-catalog.md` and the skill doc itself.

## 2. Is typesafe.ai's Jev model a fit for classification-shaped jobs (triage, muster)?

typesafe.ai is a NEW provider, not yet in the fleet (no existing worker kind,
credential plumbing, or inventory rows — this is closer in shape to how
mystic/cleric/fireworker/friar were onboarded; see
`skills/model-selection/SKILL.md` for the existing provider-onboarding
patterns and `designs/provider-model-catalog.md`).

Investigate whether Jev suits the garden's **classification-style** work:

- **Triage** (`roles/triager/AGENT.md`) is an existing job-board role/posture
  a gardener wears — a real candidate for a cheap/fast classification model if
  Jev's latency and accuracy profile fit.
- **Muster** is presently **liaison-session-only vocabulary**
  (`roles/liaison/AGENT.md` § Muster) — an interactive conversation the
  liaison drives with the maintainer, explicitly never a board job or
  watcher-recognized action (CLAUDE.md's orchestrator-vocabulary table is
  explicit that `help` and `muster` are liaison-session-only, never
  watcher-recognized, "because triage is a conversation, not a board entry").
  Using Jev for "muster" as stated would mean changing that architecture.
  Don't assume this is wanted — surface it as an open question: does the
  maintainer want an automated Jev-driven inbox classification PASS that FEEDS
  the interactive muster (e.g. Jev pre-classifies/pre-compacts, the liaison
  still disposes with the maintainer), or something else? Do not silently
  reinterpret "muster" to mean a new autonomous job.

Deliverable: a design at `designs/typesafe-jev-and-opus55-tier.md` covering
both threads (they may be one document since both stem from the same new
model access, or two if they turn out to be cleanly separable — your call).
Since this necessarily carries open questions (typesafe.ai credentials/access
mechanics, real pricing evidence, and the muster-architecture question above
at minimum), land it per the "garden's own repo carve-out" in
`roles/designer/AGENT.md`: open questions -> PR with
`<!-- garden-design-open-questions -->`, not a bare land to main2.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T15:54:43Z
