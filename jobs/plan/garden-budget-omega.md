---
gate: orchestrated
orchestrated_by: garden-budget-attribution
priority: normal
role: designer
posted_by: producer
posted_at: 2026-08-02T21:05:45Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Budget 5/5 — task rank (omega), and retiring the foreman

Fifth child of orchestration `garden-budget-attribution`. Runs after
`garden-budget-triple`. **Design and proposal only — implement nothing that
changes dispatch without the maintainer's word.**

## What the maintainer asked for

> "look at what Josh Corbin's Unum is doing to classify tasks by their omega
> notation, that is, the task's rank in a tree of plans, such that a job that
> cannot be completed without a plan inside its time window must create a plan
> and promote itself in that tree. The garden should focus on completing the
> lowest rank tasks, including those that require a human review to make
> progress. The foreman would ideally be retired, as the foreman generates work
> that consumes from the budget without direction."

## Start by resolving an ambiguity — do not guess

A liaison searched the library and found **two different things called Unum**:

- `library/concepts/habitat-unum.md` + `library/sections/habitat-chronicles--unum-pattern--*`
  — the Habitat Chronicles Unum (presences, vats, channels, messaging patterns).
  This is a distributed-object pattern and is almost certainly **not** what was
  meant.
- `library/sections/unum--*` (15 sections, including `token-cost-ledger`,
  `cost-attribution-and-aggregation`, `vigil-charge-initiative-budget`,
  `per-persona-model-tiers`) — cited by `designs/token-cost-ledger.md`. This is
  the likelier referent.

**No omega notation exists anywhere in the garden.** The only `omega` matches are
econometrics (Diebold-Mariano, HAR-RV volatility) and unrelated. So the ranking
scheme is not in the library and must not be invented here.

`jcorbin` is on `journal/maintainers/allowlist`. Read the `unum--*` sections
first; if they do not define the omega ranking, **ask** — post a question to the
maintainer inbox (`scripts/jobs/message-user.sh`) rather than fabricating a
scheme. A plausible-but-wrong ranking that reorders the garden's priorities is
worse than an honest gap.

## The foreman

Concrete and measured: it promotes `gate: deferred` plan jobs to a **5-active
target**, ticking every **5 minutes**, from a backlog of ~94 deferred jobs. It is
leader-only and **is** drain-gated (`fleet_draining && exit 0`, `foreman.sh:95`).
That is exactly "generates work that consumes budget without direction" — it sets
priority by queue order, which is the decision an omega rank should own.

Propose the retirement path: what replaces it (rank-ordered selection), what
happens to the 94 deferred jobs, whether `gate: deferred` survives as a concept,
and how work still reaches idle workers without a pump. Note that stopping the
unit needs a sysop `unit` op with maintainer attestation (`authorized_by:` on
`maintainers/allowlist`) — an agent may not originate that.

## Definition of done

A design document under `designs/` covering the ranking scheme (grounded in a
real source, or explicitly flagged as awaiting jcorbin), how rank interacts with
human-review-blocked work, and a staged foreman retirement. Plus a `tada/` report
naming every question that remains open. Change no dispatch behavior.
