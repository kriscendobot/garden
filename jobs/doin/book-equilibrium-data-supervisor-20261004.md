---
role: orchestrator
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-04T06:13:03Z cleared=none -->

---
role: orchestrator
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Supervise production 2: a review-economics chapter/section, from real garden data (kriscendobot/garden-book)

Maintainer (kriskowal, liaison 2026-10-04), same session as
`book-illumination-supervisor-20261004`:

> We should also separately incorporate data, based on historical garden
> data, including latency, throughput, review durations, tokens spent on
> engagements, especially the gauntlet, price of merged code, taking into
> account that the garden, endo-but-for-bots, and endo all endure different
> levels of scrutiny for a merge. We should talk about how we still believe
> that review is important for developer confidence, but also because it
> provides data for self-improvement and increases the likelihood that
> subsequent engagements will converge faster. We should talk about seeking
> an equilibrium between human review costs and agentic production costs,
> where we want to chart the marginal reduction in total cost for the
> corresponding increase in agentic and automation costs, to identify the
> equilibrium price between humans and automation. We should have tentative
> numbers from our own experience, visualized evocatively, produced by Claude
> agents, and stylized by Codex agents.

You own this production end to end, same authority/self-chaining pattern as
`garden-book-supervisor-20261003*` and its sibling
`book-illumination-supervisor-20261004`. One claim cannot span the whole
chain; post a dated successor with updated state before a claim ends with
work remaining.

**This job is child 2 of a serial orchestration**
(`book-illumination-and-data-orch-20261004`) and will not be promoted off
`jobs/plan/` until the illumination production (child 1) reaches a terminal
`tada/` report — by the time you're actually running, that production's
anchored color palette and illuminated-manuscript style should already exist
in the repo; read its brief/manifest and **match that established palette and
aesthetic** for any visuals you produce, rather than inventing a second,
clashing visual language.

## The pipeline — three roles, in order, each a separate posted job

**1. DATA + DRAFT (Claude, automatic).** Post a job, `role: builder`,
`tier: mentor`, `fallback-tier: minion`, `dispatch: automatic`. This is the
real analytical work; give it room (a generous handler-timeout) and point it
at real sources, don't let it invent numbers:

- **Primary data:** `journal/reputation/events/*.md` — each record already
  carries `agentic_dollars`, `human_dollars`, `estimated_dollars`,
  `work_class`, `target` (which distinguishes `main2`/garden vs.
  `endo-but-for-bots` vs. other repo targets — this is the handle for the
  "different levels of scrutiny" comparison the maintainer asked for),
  `duration_secs`, `accepted`. `journal/usage/*.jsonl` has per-job
  `elapsed_s`/`outcome` for throughput/latency. Gauntlet panel/fix-round
  costs specifically are visible per-stage in those same records (gauntlet
  stage jobs are regular reputation/usage entries keyed by their stage
  basename).
- **Read before drafting, don't duplicate:** the existing cost-economics
  design corpus already has real analysis to build on —
  `designs/cybernetics-economic-resilience.md`,
  `designs/token-cost-ledger.md`, `designs/qwen-pr-cost-analysis.md`,
  `designs/subscription-budget-model.md`,
  `designs/recurring-budget-calibration.md`,
  `designs/issue-cost-and-triple-evaluation.md`,
  `designs/budgeted-campaign-dispatch.md`, `designs/live-budget-admission.md`,
  `designs/session-budget-pace.md`. Reconcile with these (notably the prior
  finding that human review dominates machine cost by roughly 50-190x at the
  median, and that a flat subscription ledger overstates true notional cost
  by roughly 8.7x) rather than contradicting them without explanation.
- **Scrutiny-level comparison:** garden-on-itself (`main2`, no PR workflow,
  liaison-reviewed or unreviewed), `endo-but-for-bots` (the fork, full
  gauntlet: panel + fix-loop + human merge decision), and upstream `endo`
  proper (ferried, highest bar) are three genuinely different review
  regimes — present them as such, not as one undifferentiated average.
- **The argument to make** (yours to word well, not just restate): review
  earns its cost twice over — once for developer/maintainer confidence in
  what merges, and again because every review round is itself training
  signal that measurably shortens *future* review loops (cite real
  convergence-round data if you can find it — e.g. gauntlets that needed
  fewer fix rounds on repeat work in the same area). Frame the core idea as
  an **equilibrium**: chart how total cost (human review cost + agentic
  production cost) moves as the review/automation split shifts, and find
  where the marginal cost of one more unit of human review stops being worth
  the marginal reduction in total cost it buys — that crossing point is the
  "equilibrium price" between human and automated effort. Be honest that
  these are **tentative, order-of-magnitude** figures from one fleet's
  history, not a rigorous controlled study — say so plainly in the text,
  don't overstate precision the data doesn't support.
- **Deliverable:** a new chapter or section (your call which fits the book's
  existing five-part structure better — read `build/README.md` and the
  current chapter list first) as markdown text, **plus** a structured data/
  chart spec file (e.g. `art/equilibrium-data-spec.md` or similar): for each
  proposed chart, what it shows, its actual tentative numbers/series pulled
  from the sources above, and what question it answers for the reader. Open
  a draft PR with both.

**2. VISUALIZE (Claude, automatic).** Once the data/spec PR is open, post a
job, `role: web-designer`, `tier: mentor`, `dispatch: automatic`. Brief:
render each chart in the spec as an actual evocative SVG visualization
(inline-safe, same CSP constraints as the illustration work) using the real
numbers from step 1 — don't re-derive or alter the data, visualize what's
given. "Evocative" means: favor a chart that makes the equilibrium argument
visually obvious (e.g., two cost curves crossing) over a generic bar chart,
but the numbers must stay accurate to the source. Push to the same PR or a
stacked follow-up.

**3. STYLIZE (Codex).** Once the visualizations exist, post a job pinned to
Codex: `role: builder`, `provider: openai`, `tier: mentor`,
`fallback-tier: minion`, `dispatch: automatic`. Brief: restyle the charts'
visual treatment (borders, texture, typography, ornamentation) to match the
anchored color palette and illuminated-manuscript-gardening aesthetic
established by the illumination production (`book-illumination-supervisor-20261004`'s
manifest) — **do not change what the charts say**, only how they look, so
they feel like they belong in the same book rather than a separate report
stapled in.

**4. INTEGRATE.** Read Codex's result yourself (or post one more Claude
`web-designer` job if the stylized output needs real layout integration work
rather than a drop-in). Merge into `main`, verify phone-width/dark-mode
readability same as every prior integration step, publish, record the new
edition, and send one maintainer message with the URL and a one-paragraph
summary of the tentative numbers/equilibrium framing you landed.

## Scope and authority

Same as the precedent and sibling supervisor: `kriscendobot/garden-book` only,
no upstream repos, no garden fleet/budget config changes. You may rebase,
restack, re-order, withdraw, or add sub-jobs, and merge into `main` yourself.
Run a gauntlet at your discretion. Ask the maintainer only for a decision you
genuinely cannot make yourself — e.g. if the data genuinely doesn't support a
clean equilibrium story, say so rather than forcing one.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-04T06:13:13Z
