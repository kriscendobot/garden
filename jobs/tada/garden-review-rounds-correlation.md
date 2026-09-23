The work is complete. Here is my completion report.

---

## Completion report — `garden-review-rounds-correlation` (step 2 of 4)

**Question:** Does rank-1 (planning/design) work reduce the human review rounds of the rank-0 work it spawns? **Answer: cannot tell from journal data** — a *null-instrument* result, not a null effect.

**What I did.** Reused the three landed instruments as instructed (`review-rounds.sh`, `cost-by-pr.sh`, `cnf-backlog-triple.py`'s rank rules — applied to reputation `work_class`, not forked). Built the base→PR join, the spawn forest, and per-base rank classification over the live journal (`journal2` HEAD `49cdb5d1ba`, 1915 priced events) + GitHub, 2026-08-04.

**The finding, with the population funnel:**
- Merged bot PRs on the review-dense repo (endo-but-for-bots): **190**, mean **2.41** human rounds, median **1**, p90 **5** (matches step 1 — instrument stable).
- Merged PRs with a discoverable R1 **ancestor**: **0** — against the ~15 floor the job set as its stop rule.

**Why zero — three structural walls (all high-confidence, exhaustively counted):**
1. `tada/` completion records are *reports*, not job specs: **7 of 4135** carry any frontmatter, **0** carry `role:` — the producer-assigned role and parent edges are overwritten on completion.
2. The explicit spawn forest is 2 orch records + 1 `orchestrated_by` + 8 `blocked_on` (which are *dependency* edges, "wait for PR X," not design→build ancestry) — and it touches **0 merged PRs** with a generative R1+ ancestor.
3. The `cost-by-pr` join (28.9%) reaches only **reactive post-PR directives** (address-review/shepherd/conduct), structurally incapable of being a generative ancestor; the 48 real generative design jobs are named by feature area, not PR, so they cannot join.

**What changed.** Added `designs/planning-vs-review-rounds.md` (confidence-graded per claim, in the style of `issue-cost-and-triple-evaluation.md`; put in `designs/` to sit beside the budget/omega arc it feeds). Committed and pushed to `main2` as `35cca221df`. **No dispatch behaviour changed** (read-only, as scoped). Scratch clone removed.

**The deliverable pivoted** to a prospective experiment (since observation cannot answer it): stamp `planned_arm`/`plan_ancestor` on jobs *and* reputation events so ancestry survives completion; stratify on `(repo, changed-file band, area)` to defeat selection bias; ~3–6 weeks to accumulate n at ~5 merged PRs/day; a decision rule fixed in advance (±0.5 rounds median with CI).

**Open questions named (for downstream steps):**
1. **Step 3** (omega design correction): this analysis gives *no evidence* that planning reduces review rounds — step 3 must not cite a review-round benefit as measured; hold the priority direction as unproven.
2. **Step 4** (admission gate): needs the § 6.1 stamp to ever be evaluable — consider making the stamp a precondition the gate enforces.
3. Could git-history reconstruction of `tada` roles + a design→build text matcher recover a retroactive population? Possible for a handful of feature arcs, but it *is* the selection-bias guess the job warns against — flagged not-recommended.
4. Does the producer always know the planned/unplanned arm at post time? Yes for liaison-posted `design X`→`build #N`; genuinely absent (= the `unplanned` arm, not missing data) for foreman/watcher-minted builds.

Descriptive-only context (explicitly *not* the answer): design/doc PRs are reviewed ≥ code PRs (2.55 vs 2.38 rounds) — off-target, reading it as the answer would reproduce the selection-bias trap; minion.town (the one repo with visible design→feature PR structure) is too small (14 merged, mean 0.86).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-review-rounds-correlation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1793567 cached reads)
- Output: 29580 tokens
- Cost: $2.5560715
- Wall-clock: 582s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
