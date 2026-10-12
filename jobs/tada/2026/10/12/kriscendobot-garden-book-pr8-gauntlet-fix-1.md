Fix round 1 for kriscendobot/garden-book PR #8 is done: the panel's must-fix item is applied and pushed. The CI check passed only because this repo has no CI workflows, so nothing actually ran against the change.

**Panel round 1 (comment review at 2026-10-12T19:43:53Z, on head `2d0cc32`):**
- **Must-fix (archivist):** ch8 § 8.7 still described `roles/accountant/` as unbuilt. It now exists on `main2`, and the PR's own exposure map had flagged this.
- **Should-fix (typist):** two `→` arrows and a `×` sign in `editorial/reader-exposure-map.md`.

**What I changed (commit `8304543`, pushed to `book-reader-exposure-copyedit` with `safe-push-pr-head.sh`; head moved from `2d0cc32` to `8304543`):**
- **ch8 § 8.7:** rewrote the section to describe the accountant as it now works, drawing on the design doc, the role brief and the operator page:
  - It is the only writer of the three budget files on the journal (the week's apportionment, the per-arc slices and the foreman's mandate), all changed in one `set-apportionment.sh` commit.
  - A weekly scheduled job carries last week's slate forward, sends the maintainer a statement and a proposal, and applies only a clear reply.
  - Arcs are the budget unit, and producers stamp work with `--arc`.
  - A slice that runs out holds its work, with no borrowing.
  - An orchestration's `--budget-tokens` cap sits inside its arc's slice.

  I renamed the heading from "What's evolving now: the accountant" to "8.7 The accountant" and updated the table-of-contents link to match. Nothing else in the book linked to the old heading. The opening sentence now says the role "has been carved" instead of "is being carved".
- **`editorial/reader-exposure-map.md`:**
  - "automatic → manual → automatic" is now "automatic, then manual, then automatic".
  - "(×2)" is now "(twice)".
  - I removed the open item about § 8.7 being stale, since it is now fixed.
- **Not changed:**
  - The archivist's "conductor" note: the map is right. The gloss is at ch1 line 204, which is inside § 1.3.
  - Other comment-level items, such as the removed dates and the undefined "arc" in ch8, were not must-fix, so I left them.
- `npm test` passes.

**CI:** with the job's exact command, `ci-wait-merge.sh` would have waited out the full hour, because it never treats a PR with no checks as green unless told the repo has no CI. I re-ran it with `GARDEN_CI_ALLOW_NO_CHECKS=1` and it returned rc 0 ("total=0 failed=0 → CI GREEN"). I ran it again after the reaper requeued this job, with the head still at `8304543`, and got rc 0 again.

**Follow-ups:**
- The gauntlet driver should set `GARDEN_CI_ALLOW_NO_CHECKS=1` for garden-book, or the CI wait will time out on every stage.
- The driver should now post panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 4 tokens (165199 cached reads)
- Output: 1489 tokens
- Cost: $1.0779595999999998 (1 engagement(s) unpriced)
- Wall-clock: 697s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
