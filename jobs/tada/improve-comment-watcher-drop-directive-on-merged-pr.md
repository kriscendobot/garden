The work is complete and pushed. Here is my completion report.

---

## Completion report — `improve-comment-watcher-drop-directive-on-merged-pr`

**What I did**

Added a deterministic pre-mint terminal-PR-state guard to `scripts/jobs/comment-watcher.sh` for non-finalize directive verbs, closing the gap where a stale directive on an already-merged/closed PR would mint a no-op job.

**What changed**

- **`scripts/jobs/comment-watcher.sh`** — Immediately after the existing `finalize`-path mergeable check and before the `base`-computing `case "$VERB"`, inserted a guard: for `VERB` in `rebase|retcon|refresh|gauntlet`, run the already-present `GARDEN_PR_MERGEABLE "$repo" "$pr"` probe; on **rc 2** (already merged/closed) it logs the reason, removes the body tempfile, slides the cursor (`hw="$created"; continue`), and skips the post — the exact shape of the finalize-path rc-2 branch. Only rc 2 drops; rc 0 (ready) and rc 1 (open-but-not-ready) both proceed, since these verbs are themselves the remedy for a not-yet-ready PR. `shepherd` is deliberately excluded (it is the open-but-not-ready remedy, never a stale-directive source — matching the job spec's verb list). The probe is skipped when `pr=0` (no PR target) to avoid a misleading `gh pr view 0` failure on directive comments with no PR reference.

- **`scripts/jobs/test/comment-watcher-test.sh`** — Added a new `SD` test case asserting the merged-PR drop (no job minted, no reactji, drop reason logged, cursor slides). Because the new guard makes the directive-verb paths invoke `GARDEN_PR_MERGEABLE`, I wired a hermetic open-PR stub (`MERGEABLE_OPEN`, exit 0, overridable via `CW_MERGEABLE`) into the four runners that exercise directive verbs (`run_watcher`, `run_directive`, `run_pronly`/`run_autopronly`, `run_mentiononly`). This was necessary: `GI3`/`GI5` previously would now have hit the *real* `gh` and the *real* merged `kriskowal/garden#5`/`#9`, returning rc 2 and wrongly dropping — caught and fixed during testing.

**Verification**

- `bash -n` clean on both files; shellcheck surfaces no new warnings (the one pre-existing `SC2034` on line 141 is unrelated).
- Full suite: **150 passed, 0 failed** (was 147; +3 new SD assertions).

**Follow-ups**

None required. The change reuses existing infrastructure (`GARDEN_PR_MERGEABLE`) and introduces no new dependencies. Worth noting for future readers: the guard relies on `pr-mergeable-gh.sh` returning rc 1 (not 2) on a failed/ambiguous `gh` lookup, which it already does by design ("escalate, never force"), so a transient probe failure proceeds to mint rather than silently dropping a live directive.
