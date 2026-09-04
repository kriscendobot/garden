All work is complete. The fix is landed on main2, the gauntlet is not doomed, and my inbox is empty.

---

## Completion report

**Job:** Investigate the wedged `ironhorse-test262-fable-supervisor-20260829-gauntlet-panel-2` stage (endojs/endo-but-for-bots #1113, test262 ratchet round 2).

### Diagnosis (evidence-cited)

The wedge is **compound**, with one structural root cause and one active aggravator.

**Root cause — the panel stage recomputes the entire 29-seat panel on every requeue (no resume).** The panel stage is agent-supervised: run `panel.sh` (a 29-seat fan-out that takes 20–45+ min — I found a *live* panel for #1124 that had been running **3h35m**, PID 640477) and then post the aggregate as a `gh pr review`. `panel.sh` has **no short-circuit off its own durable record**: every invocation re-fans all seats. Proof the panel *did* complete but the review never posted:
- `journal/panel-runs/endojs-endo-but-for-bots-1113/f9a07b3dee97.md` recorded **05:10:56Z**, head `ba236d72`, `disposition: must-fix`, 20 must-fix items, full 29-seat verdict.
- Yet the last review on #1113 is still `kriscendobot COMMENTED 2026-09-02` (panel round **1**). Panel-2's verdict was computed and durably recorded but **never posted**, so the stage requeues and the next claim throws the recorded aggregate away and re-runs the whole panel. This is exactly failure mode #1 in the filing — non-convergent, ~45 min of `claude -p` burned per cycle up to the reaper's doom threshold.

**Active aggravator — the review-post step is currently hitting the fleet-wide GitHub rate limit.** The most recent panel-2 attempt's captured tool-result shows `attempt=1 rc=1: GraphQL: API rate limit already exceeded for user ID 279080640` (the bot) in a review-post retry loop, and the host surfaced a live `GitHub API rate limit exceeded (5,000/hr shared across all tools and agents)` reminder during this investigation. This is failure mode #3's real cause — **not OOM, not an oversized body**: with many gauntlets running (#1113, #1124, #1116, #717, …) the shared 5000/hr ceiling is exhausted, and the review-post (and the `2s/0-token` startup deaths, consistent with `gh pr view` dying at claim start under saturation) fails. **Timeout is ruled out** (10800s/3h budget; the 05:10 run finished fine).

### Fix (landed, tested)

Added a **single-round resume short-circuit** to `scripts/jobs/gardening/panel.sh` (commit `db4186085a` on `main2`). In `GARDEN_PANEL_SINGLE_ROUND=1` mode, before the fan-out, it looks for a durable `panel-runs/<slug>/<run-id>.md` record whose **last round head == the current worktree HEAD**; on an exact match with a parseable disposition it reconstructs a review-ready aggregate into the rundir from the record's disposition + must-fix titles, prints the same single-round terminal contract, and exits 0 **without dispatching any seats**. The requeued stage then only has to (re)post the review — the cheap, idempotent, rate-limit-retryable step — making the stage **convergent**. It **fails open** (missing store / stale clone / moved head / bad record → normal panel), so it can never emit a wrong verdict, only skip a recompute. Opt out with `GARDEN_PANEL_RESUME=0`; classic mode untouched.

Evidence it works:
- New `panel-single-round-resume-test.sh` — **11/11 pass** (resume fires on head match without running seats and reconstructs items; `GARDEN_PANEL_RESUME=0` disables; head mismatch does not resume; classic mode never resumes).
- Existing `panel-single-round-test.sh` — **14/14 pass** (no regression); empty-diff/seat-retry/repo-slug suites green.
- Extraction validated against the **real** #1113 record: yields head `ba236d72`, disposition `must-fix`, and the full must-fix items block; the default store path resolves to the producer clone that holds it.

I corrected a process slip mid-way: initial edits accidentally landed in the deployed root (`/home/kris/garden2`); I restored that checkout to pristine `HEAD` bytes (no git run there) and did all committed work in this job's worktree.

### State / follow-ups
- **The #1113 gauntlet is NOT doomed** — record `state: running`, `stage: panel`, `iteration: 2`; panel-2 is in `jobs/doin/` (not parked in `plan/`). I did not touch live job state; the reaper owns requeues.
- **Deploy needed:** the fix is on `main2` but the deployed root runs the old `panel.sh` until the deliberate rolling deploy advances it. Once deployed, the next panel-2 claim resumes off `f9a07b3dee97.md` in seconds and only needs the review-post to land.
- **Recommended fleet-capacity mitigation (out of scope for this code fix):** the shared **5000/hr GitHub rate limit** across a busy multi-gauntlet fleet is a standing bottleneck; a rate-limit-aware backoff/stagger for gh-heavy stages is worth a separate design. My resume fix already cuts the panel stage's gh pressure on requeue (skips the related-design pre-pass gh call and all seat work).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-test262-1113-panel-stage-reap-loop-20260904.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (4639421 cached reads)
- Output: 51612 tokens
- Cost: $4.495704249999999
- Wall-clock: 816s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
