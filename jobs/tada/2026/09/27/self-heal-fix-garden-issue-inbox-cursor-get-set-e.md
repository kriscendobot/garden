Done. Completion report:

## Completion report — `self-heal-fix-garden-issue-inbox-cursor-get-set-e`

**Finding on arrival:** the code fix this job describes was **already landed** in commit `df83fca2355` (2026-09-19, "fix(jobs): fail open on nonzero cursor-get.sh rc in issue-inbox/comment/mention watchers"), 8 days before this job was posted. `issue-inbox-watcher.sh`'s cursor read (now at line 507) is already the guarded `if cursor_out="$(...)"; then rc=0; else rc=$?; fi` form, WARN-and-exit-0 on any nonzero rc — generalized exactly like `triager.sh` (`b320648e47`). So **no code change was needed**; re-applying it would have been a no-op.

**What was genuinely missing** — the test deliverable. `df83fca2355` shipped with no test, and the existing `issue-inbox-tick-bounds-test.sh` cases D/E only cover the **rc=75 quiet-skip** path (a wedged cursor-IO lock). The **loud rc≠75 fail-open** path (the WARN-logging branch) had no coverage.

**What I did:**
- Added a new case `CURSOR-GET — a LOUD (non-75) cursor-get failure fails OPEN, never fatal` to `scripts/jobs/test/issue-inbox-watcher-test.sh`. It points the watcher at a **nonexistent journal remote** so `cursor-get.sh`'s clone fails `repository … does not exist` (classified upstream-gone → re-raised rc=1, not latched as 75), and asserts: the tick exits 0 (not a `set -e` crash), the `cursor read failed … (rc=…)` WARN fires, the failure is not mis-latched as rc=75, and nothing is dispatched behind the unreadable cursor.
- **Verified it's a real regression guard:** temporarily reverting the watcher to the pre-fix bare command substitution makes the new case fail with the exact silent exit-1 crash the fix describes ("loaded N maintainer(s)" then die); restored, all pass.
- Full suite: **58 passed, 0 failed**, both before and after rebasing onto the latest `main2`.

**Changed / pushed:** one file, `scripts/jobs/test/issue-inbox-watcher-test.sh` (+36). Committed as `440431aa922` and pushed to `origin/main2`.

**Follow-ups:** none required. One incidental note: this worktree's git config (`rebase.autostash`/`rebase.autosquash` + `GIT_EDITOR=true`) wedged `git rebase` into a duplicated-todo loop; I recovered cleanly via `reset --hard origin/main2` + `cherry-pick`. Not a code issue, just an environment quirk worth being aware of for future rebase-CAS pushes here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-issue-inbox-cursor-get-set-e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 92 tokens (4041612 cached reads)
- Output: 30280 tokens
- Cost: $3.896626 (2 engagement(s) unpriced)
- Wall-clock: 628s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
