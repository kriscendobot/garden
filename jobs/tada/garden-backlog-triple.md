Everything verified and landed. Here is my completion report.

---

## Completion report — `garden-backlog-triple` (step 1 of 4)

Landed jcorbin's **ordinal backlog measure** into the garden as a **read-only, report-only** metric on `main2` (commit `002b1adeb4`, no PR per garden convention). Nothing reads it; dispatch, promotion, and claiming are untouched. Steps 2–4 were not started.

### What I built
- **`scripts/jobs/cnf-backlog-triple.py`** — deterministic, no-LLM. Reports the open queue as the CNF triple `(r2,r1,r0) = ω²·r2 + ω·r1 + r0`, with a per-rank breakdown giving **the reason each job got its rank**, and compares two journal2 revisions under lexicographic **`o<`, never by count** (`--rev`, `--compare`, `--slice active|total|plan`, `--json`, `--check`).
- **`scripts/jobs/test/cnf-backlog-triple-test.sh`** + **`test/fixtures/cnf/{A,B,C}/`** — 12 assertions, all green.
- **`designs/cnf-backlog-triple.md`** — the rule table, both invariants, gate handling, and the live-board audit.

### Invariants preserved
1. **Rank is derived, never declared** — reads no `rank:`/`omega:` field; a test pins that a `rank: 2` on a builder job is ignored (stays R0). Rank comes from **producer-assigned `role:`** (already load-bearing for tier/AGENT.md) plus a realized floor — still derivation.
2. **Board-derived** — recomputed from job files every run; no persisted counter.

### Rank rules (in order, first match wins)
1. **Realized floor** — a job that already spawned children (via `jobs/orch/*.md children:` or `orchestrated_by:`) is at least `1+max(child rank)`, capped 2. A fact, so it wins first.
2. **R2** — `role: orchestrator` (or an orch/groom/uplift-shaped slug).
3. **R1** — `role:` ∈ {designer, assayer, researcher, scholar, librarian, prosecutor, triager, watchman}; or a `DESIGN`/`PROPOSE`/`SPEC` title; or a `?`-title.
4. **R0** — everything else.

### The headline test
The regression suite pins the case that **justifies the ordinal**: finishing one R1 planning job and replacing it with three R0 children moves `(1,1,2)→(1,0,5)` — count **+2 (reads worse)** yet strictly **down under `o<` (reads better)**. If that disagreement ever stops holding, the test goes red. Also exercised: the realized floor, role→rank, the git `--rev/--compare` path (on a private temp repo — never the shared journal), and declared-rank rejection.

### Live board audit (2026-08-04)
**Total backlog (1, 99, 92), n=192**; active is (0,0,0) (board drained for the budget work). Sole R2 = `drive-mystic-rollout-20260723` (orchestrator) — matches the prototype.

### Where I diverge from the prototype (1, 108, 83)
R2 agrees; 9 jobs the prototype called R1 I call R0. I dropped unum's **gameable prose "report-artifact" regex** in favor of the producer's `role:` signal; those 9 are most plausibly the **press/status jobs** its regex swept into R1. Per the job's guidance I did not fit my rules to its numbers.

### Jobs the rules classify badly (surfaced, not fixed)
The **recurring no-`role:` standing drivers** (`*-press-*`, `arc-status-daily-*`, `pi-release-watch-*`, `*-shepherd`) land at R0 though their output is a report/nudge — a **producer gap** (they stamp no role), fixable by the producer stamping `role: watchman/triager`, not by changing this metric. Also flagged: **61 of 192 plan jobs are `poisoned:`** parked failures — counted but surfaced, since they inflate both the ω- and finite-terms with stuck work.

### Follow-ups (out of scope here)
Steps 2 (review-rounds correlation), 3 (correcting `designs/omega-task-rank-and-foreman-retirement.md`), 4 (admission gate) remain. The producer-gap finding above is the natural feed into step 3.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-backlog-triple.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 49 tokens (2210872 cached reads)
- Output: 38974 tokens
- Cost: $3.1277480000000004
- Wall-clock: 575s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
