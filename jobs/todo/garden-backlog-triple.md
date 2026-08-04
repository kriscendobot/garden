---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Land the CNF backlog triple as a read-only garden metric

Repository: https://github.com/kriscendobot/garden — land on `main2`, no PR
(garden convention). Do **NOT** run git in `$GARDEN_ROOT`; use your per-job
worktree.

**Read-only, report-only. Change no dispatch behaviour, no promotion, no
claiming.** This is step 1 of 4 the maintainer approved; steps 2-4 (review-rounds
correlation, correcting the omega design, an admission gate) are NOT in scope and
must not be started here.

## What this is

Port jcorbin's **ordinal backlog measure** to the garden. The open queue is
reported as a Cantor-Normal-Form triple

    (r2, r1, r0)  =  omega^2*r2 + omega*r1 + r0

compared between runs with **lexicographic (ordinal) `o<`, never by total
count**. The point, in jcorbin's words:

> Finishing one rank-1 PLANNING task typically REPLACES it with several rank-0
> children, which raises the total count while strictly decreasing the triple
> (one fewer omega-term, finitely more finite terms). A count-based measure
> would read healthy planning work as regress.

## Source — read it, the library copy is stale

`jcorbin/unum` on tangled.org:

    git clone https://tangled.org/jcorbin.tngl.sh/unum

The garden's library ingest pinned commit `1834aba` (2026-07-09). HEAD is ~183
commits later and **the entire omega/Epoch mechanism postdates the ingest**
(design TADA/1283 is dated 2026-07-31). So read the clone, not just
`library/sections/unum--*`. A liaison already cloned it to
`/home/kris/garden/tmp/unum` — re-clone fresh rather than trusting that copy.

Read at minimum:

- `skills/health-vector/cnf_triple.py` — the reference implementation, and the
  best-commented artifact in the repo
- `devoker/internal/invoke/admission.go` — the doc comment (lines 1-95) states
  the measure, why ordinal beats count, and the stranding enumeration
- `devoker/internal/invoke/task_rank.go` — the single-file oracle
- `TADA/1283*.md` — the design and its motivation

## Two invariants you must preserve

**1. Rank is DERIVED, never declared.** unum closed TADA/1172 unstarted rather
than add a `rank:` frontmatter field. Read **no** `rank:`/`omega:` field from a
job, and do not add one. A declared rank is self-reported and gameable; a
board-derived one is recomputable by any outside observer. (This is the same
hazard the garden hit from the other side: `reputation/` breadcrumbs written by
the session that measures itself get silently rewound by a merge that resolves a
frontmatter conflict the other way.)

**2. The measure is board-derived.** Recompute from the job files themselves on
every run. Persist no counter that a later run increments.

## The garden's rank rules — a better signal than unum's

unum regexes prose for `groom|uplift` slugs and a first-person "filed as a
trampoline seed" declaration. Its own comment records the false positive this
caused: an early `\btrampoline\b.*\b(seed|capstone)\b` under `re.S` fired on two
tasks that merely *discussed* capstone chains, turning `(1,10,5)` into `(3,9,4)`.
**Read that comment before writing any regex.**

The garden does not need it. Jobs carry `role:`, assigned by the **producer**
(not self-reported by the job) and already load-bearing for model tier and which
AGENT.md is loaded. Deriving rank from role is still derivation.

Proposed mapping — **audit it against the real board and correct it**, do not
adopt it on my say-so:

| rank | meaning | signal |
|---|---|---|
| R2 | output is tasks whose own output is tasks | `role: orchestrator`; `jobs/orch/` entries; orchestration/groom-shaped basenames |
| R1 | output is a decision/plan/report, not the work | `role:` in {designer, assayer, researcher, scholar, librarian, prosecutor, triager, watchman}; DESIGN/PROPOSE/SPEC title; title ending in `?` |
| R0 | changes code or external state | everything else (builder, fixer, weaver, conductor, cleaner, shepherd, botanist, boatman, …) |

Apply rules **in order, first match wins**, and — like unum — carry a
**realized floor**: a job that has already spawned children is at least the rank
its children imply, which is a fact rather than an estimate. The garden's spawn
edges are discoverable from orchestration records (`jobs/orch/*.md` `children:`)
and from `garden-promoted-from-plan` / `orchestrated_by:` provenance.

## Scope of the queue

unum measures `TODO/ + DOIN/ + TOQU/`. The garden's analogue is
`jobs/todo/ + jobs/doin/ + jobs/plan/`, but `plan/` is heterogeneous — decide
and document how gates are treated, and make the queue sliceable so
"active backlog" (todo+doin) and "total backlog" (incl. plan) are both
answerable. They are different questions and conflating them hides the thing the
maintainer most wants to see.

## A liaison prototype, as a CHECK not a specification

A throwaway script gave **(1, 108, 83)** over todo+doin+plan, with:

- 92 of 94 `gate: deferred` jobs at **rank 1** — 85 of them `role: prosecutor`
  review-retrospectives. This is the pool the foreman promotes from, and it is
  almost entirely omega-terms.
- 75 of 83 rank-0 jobs behind `gate: go-ahead` — the work that produces
  reviewable artifacts is the work gated on the maintainer.
- exactly one R2: `drive-mystic-rollout-20260723`.

If your implementation disagrees, **your implementation is probably right** —
the prototype had no realized floor, no gate handling, and a crude regex. Say
where and why you diverge; do not reverse-engineer your rules to reproduce
these numbers.

## Definition of done

- A deterministic, no-LLM, read-only script under `scripts/jobs/` reporting the
  triple, a per-rank breakdown with the **reason each job got its rank**, and
  comparison of two revisions under `o<`.
- Regression tests under `scripts/jobs/test/`, including at least one fixture
  proving `o<` and a total-count delta **disagree** — that case is the entire
  justification for the ordinal, so it must be pinned.
- Documented rank rules with their audit against the live board.
- A `tada/` report giving the garden's current triple, the rule table you
  settled on, where you diverged from the prototype and why, and any job the
  rules classify badly.

Do not wire this into dispatch, the foreman, `claim-job.sh`, or the reputation
reducer. It reports; nothing reads it yet.
