The remaining `reliable-pause-resume` worktree belongs to another job, not mine. My work is complete and pushed.

---

## Completion report

**Job:** `issue-inbox-watcher-reactji-acknowledge` — give the issue-inbox watcher reactji parity with the comment-watcher (kriskowal/garden #13).

**Done. Pushed to `origin/main2` as `85f1d2e4b`** (isolated worktree off `origin/main2`, explicit-pathspec commit, rebase-CAS push — landed on attempt 1).

### What changed (4 files)
1. **`scripts/jobs/handlers/comment-reactji-gh.sh`** — added an `issue` surface → `repos/<repo>/issues/<number>/reactions`. The id for this surface is the **issue NUMBER**, not a comment id. The existing `issue-comment` / `pr-review-comment` / `pr-review-body` surfaces are unchanged.
2. **`scripts/jobs/issue-inbox-watcher.sh`** — fires 👀 for every trusted maintainer interaction it dispatches, **before** posting the job / sending the message (mirrors the comment-watcher's ordering):
   - new ISSUE → react `issue` surface, id = number;
   - new ISSUE-COMMENT → react `issue-comment` surface, id = comment id.
   - Wired via a new `GARDEN_ISSUE_REACTJI` handler default and a `react_ack` helper; a reactji failure logs a `WARN` and **still dispatches** (never blocks).
3. **`scripts/jobs/test/issue-inbox-watcher-test.sh`** — a comprehensive test (the #10 re-engagement regression) already existed on `main2`. I integrated rather than overwrote: added cases **G–J** (issue-surface ack id=number before post; issue-comment-surface ack id=comment-id before msg; the `issue` surface hits `/issues/<n>/reactions` with the comment surface unchanged; reactji failure doesn't block). **Critically**, I also hardened the existing `run_watcher` to always stub the reactji handler — without that, my new `react_ack` would have made the existing tests call the real `gh` API against live `kriskowal/garden` issues.
4. **`skills/reactji-acknowledgment/SKILL.md`** — field note recording the parity fix and reinforcing the 2026-05-20 pattern: every job-posting surveillance surface must order reactji-before-post.

### Verification
- `bash -n` clean on all three changed scripts.
- `issue-inbox-watcher-test.sh`: **25/25 pass** (6 pre-existing + my 19 new assertions).
- `comment-watcher-test.sh`: **95/95 pass** — no regression from the shared reactji helper change.

### Notes / follow-ups
- I based the work on `origin/main2`, which is **ahead of the deployed root checkout** (the root lacks the 11-column TSV `closed_at`/re-engagement logic). The reactji change layers cleanly on top of that newer base.
- One initial test assertion (J's cursor-advance) was incorrect given the logging POST stub doesn't land a job on the board (so the watcher's `verify_posted ... fresh` correctly holds the cursor); I corrected the test to assert the meaningful property (post attempted + WARN logged) instead.
- No deploy performed — `main2` is the dev branch; the deployed root advances only via the deliberate `deploy-garden.sh`.
