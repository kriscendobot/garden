# The CNF backlog triple — the garden's open queue as an ordinal measure

| Created | 2026-08-04 |
| Author  | builder (job `garden-backlog-triple`) |
| Status  | Landed (read-only, report-only; nothing reads it yet) |

Ports jcorbin's **ordinal backlog measure** from `unum` to the garden. The open
queue is reported as a Cantor-Normal-Form triple

    (r2, r1, r0)  =  omega^2*r2 + omega*r1 + r0

and two runs are compared with **lexicographic (ordinal) `o<`, never by total
count**. The reason, in jcorbin's words:

> Finishing one rank-1 PLANNING task typically REPLACES it with several rank-0
> children, which raises the total count while strictly decreasing the triple
> (one fewer omega-term, finitely more finite terms). A count-based measure
> would read healthy planning work as regress.

Implementation: [`scripts/jobs/cnf-backlog-triple.py`](../scripts/jobs/cnf-backlog-triple.py)
(deterministic, no-LLM, read-only); tests
[`scripts/jobs/test/cnf-backlog-triple-test.sh`](../scripts/jobs/test/cnf-backlog-triple-test.sh).

**Scope discipline.** This is step 1 of 4 (a read-only metric). It changes NO
dispatch, promotion, or claiming behaviour, and nothing reads it yet. Steps 2–4
(review-rounds correlation, correcting
[`omega-task-rank-and-foreman-retirement.md`](omega-task-rank-and-foreman-retirement.md),
an admission gate) are out of scope and not started here. Read alongside that
omega design (the consumer this measure is built for) and
[`issue-cost-and-triple-evaluation.md`](issue-cost-and-triple-evaluation.md).

## Two invariants, preserved from unum

1. **Rank is DERIVED, never declared.** The script reads **no** `rank:`/`omega:`
   field and never adds one (unum closed its TADA/1172 unstarted rather than add
   such a field). A declared rank is self-reported and gameable; a board-derived
   one is recomputable by any outside observer. The `--check` suite pins that a
   `rank: 2` on a builder job is ignored — the job stays R0.
2. **The measure is board-derived.** Recomputed from the job files on every run.
   No persisted counter a later run increments (which a merge resolving a
   frontmatter conflict the other way could silently rewind — the hazard the
   garden already hit from `reputation/` breadcrumbs).

## The rank rules — a better signal than unum's

unum regexes prose for `groom|uplift` slugs and a first-person "filed as a
trampoline seed" self-declaration, and its own comment records the false
positive an over-broad `\btrampoline\b.*\b(seed|capstone)\b` under `re.S`
caused. The garden does not need any of that: jobs carry **`role:`**, assigned
by the **producer** (it already selects the model tier and the `AGENT.md` a
worker loads), not self-reported by the job. Deriving rank from role is still
derivation — of a cleaner, already-audited signal.

Rules apply **in order, first match wins**:

| # | rank | rule | signal |
|---|---|---|---|
| 1 | floor | **realized floor** | the job has already spawned children (from `jobs/orch/*.md` `children:` or `orchestrated_by:` provenance); its rank is at least `1 + max(child rank)`, capped at 2. A **fact**, not an estimate, so it wins first. |
| 2 | R2 | output is tasks whose output is tasks | `role: orchestrator`; or an orchestration-shaped basename (`orch`/`groom`/`uplift`, whole-word) as a backstop |
| 3 | R1 | output is a decision/plan/report, not the work | `role:` in {designer, assayer, researcher, scholar, librarian, prosecutor, triager, watchman}; or a `DESIGN`/`PROPOSE`/`SPEC` title; or a title ending in `?` |
| 4 | R0 | changes code or external state | everything else (builder, fixer, weaver, conductor, cleaner, shepherd, botanist, boatman, gardener, …) |

### Divergences from unum, deliberate

- **Role, not prose.** unum's R1 fires partly on a prose regex over the
  done-criteria ("primary artifact is a report/plan/decision"). We drop it: it
  is the gameable prose-scraping the producer-assigned `role:` replaces.
- **No `--min-id` id-collision hazard.** unum's task ids collide below 887;
  garden job bases are unique kebab strings, so that whole apparatus is gone.
- **Line-scan, not YAML.** Garden jobs routinely carry two `---` frontmatter
  blocks plus HTML-comment provenance. The reader line-scans the preamble for
  the first occurrence of each key it needs (the producer's `role:` always
  precedes any prose mention), which is robust to both.

## The queue, and how gates are treated

unum measures `TODO/ + DOIN/ + TOQU/`. The garden's analogue:

- **active backlog** = `jobs/todo/ + jobs/doin/` — what the fleet is working now.
- **total backlog** = active + `jobs/plan/` — what the fleet still owes.

These are **different questions**, so both are answerable (`--slice active|total|plan`)
and the default prints both; conflating them hides the thing the maintainer most
wants to see. `jobs/tada/` (completed) and `jobs/orch/` are read only as the
**edge corpus** for the realized floor — a job's spawned children may already
have completed.

**Gates do not change a job's rank.** Rank is about a job's *output shape*;
`gate:` is about its *readiness*. So `plan/` jobs are ranked identically whether
`deferred`, `go-ahead`, `blocked`, or `orchestrated` — but the report breaks the
`plan/` contribution down by gate, because *why* a job is parked is exactly what
the reader needs next to the ordinal. (`gate: orchestrated` jobs are latent —
only the orchestrate watcher promotes them; `gate: blocked` jobs wait on a
`blocked_on:` predecessor. Neither fact changes the shape of the work they name.)

## Audit against the live board (2026-08-04)

Total backlog: **(1, 99, 92)**, n=192 (`active` is empty — the board was
deliberately drained for the budget-attribution work). CNF = `w^2 + w*99 + 92`.

- **R2 = 1:** `drive-mystic-rollout-20260723` (`role: orchestrator`). The sole
  omega²-term, matching the prototype.
- **R1 = 99:** prosecutor 85 (the review-retrospective pool the foreman promotes
  from — almost the entire omega-term), designer 9, researcher 3, assayer 1,
  title-is-a-question 1.
- **R0 = 92:** builders, fixers, cleaners, weavers, gardeners, and 56 no-role
  jobs (presses, shepherds, deploys, one-off builds).

The realized floor fires on **nothing** live: the two orchestration records name
children that are not themselves open jobs, and the sole `orchestrated_by:` edge
(`minion-town-weblet-gateway-increment-4`) makes that job a *child*, not a
parent. The R2 is carried entirely by `role: orchestrator`. The floor is
implemented and fixture-tested regardless, because the next orchestration will
exercise it.

### Where I diverge from the liaison prototype, and why

The prototype reported **(1, 108, 83)**; I report **(1, 99, 92)** — the R2
agrees, and 9 jobs it called R1 I call R0. The prototype had a crude regex and
no role signal; those 9 are most plausibly the **press / status jobs** its
prose-artifact rule swept into R1. Per the job's own guidance ("if your
implementation disagrees, your implementation is probably right"), I did not
reverse-engineer the rules to reproduce its numbers.

### Jobs the rules classify badly (surfaced, not fixed)

The **recurring standing drivers with no `role:`** — the arc-`press-*`,
`arc-status-daily-*`, `pi-release-watch-*`, and `*-shepherd`/`*-conduct` jobs —
land at **R0** ("no role"), yet their output is a *report or a nudge*, not code;
by shape several belong at R1. This is not a rule bug but a **producer gap**: the
watchers that post them stamp no role. The derivation-not-declaration fix is for
the producer to stamp them (`role: watchman`/`role: triager` for the status
drivers), after which the rule reads them correctly with no change here. Also
note **61 of the 192 plan jobs are `poisoned:`** (requeue-exhausted /
deadline-overrun parked failures): they are counted as backlog but flagged,
because a large share of both the omega- and finite-terms is stuck-failed work,
not healthy planning — which the bare triple would otherwise hide.
