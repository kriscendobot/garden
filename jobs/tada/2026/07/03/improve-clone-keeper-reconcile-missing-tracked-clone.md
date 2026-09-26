Inbox is empty. Work complete.

## Completion report

**Job:** Fix `clone-keeper.sh` warning "tracked clone worktrees/endojs-endo.git is missing … skipping" every ~30m tick while freshening nothing.

**Findings**
- **Part (b) was already implemented** by prior commits (`1bfbc1087`..`5c919e8f6`): `keep_clone` already reconciles a genuinely-missing clone via `bounded_clone` (timeboxed with `timeout GARDEN_FETCH_TIMEOUT`, retried, logged as `REPAIRED`/`provisioned`, staged into a sibling temp + atomic `mv -T`, returns 0 on failure so one clone never aborts the rest), plus maintainer escalation for un-recreatable/persistently-unreachable cases. Nothing to redo there.
- **Part (a) was the real defect.** The `GARDEN_TRACKED_CLONES` default named `worktrees/endojs-endo.git|origin|master` — a path that exists on **no** host. The only standing clone present is `worktrees/endojs-endo-but-for-bots.git`, and it's what the whole fleet cuts worktrees from (`ensure-project-worktree.sh`, `import-endo.sh`, the endo-but-for-bots watcher). I confirmed the six-week-stale commit `052b0487` (endojs/endo PR #3252) lives on **this fork clone's `master`** branch — so the keeper's own origin story was always about the fork's passive upstream-mirror, and the tracked dir was simply a wrong/phantom path. Pure upstream `endojs/endo` is *not* needed here: it's out of autonomous scope (`ci-watcher`/`comment-watcher` exclude it), has no standing clone on disk, and scholar re-ingestion reads upstream shas via the gh API, not a local clone.

**Changes** (`scripts/jobs/clone-keeper.sh`, `scripts/jobs/test/clone-keeper-test.sh`)
- Repointed the default to `worktrees/endojs-endo-but-for-bots.git|origin|master|ssh://git@github.com/endojs/endo-but-for-bots.git`. Branch `master` (the passive upstream mirror that goes stale) is kept; `llm` is deliberately not tracked (the fleet pushes to it constantly, so it never goes passively stale). The fourth clone-url is pinned explicitly because the fork basename is exactly the ambiguous case `derive_clone_url` warns about (owner `endojs`/name `endo-but-for-bots` vs owner `endojs-endo`/name `but-for-bots`).
- Rewrote the header/inline comments that referenced the phantom `endojs-endo.git` path so the file is internally consistent and records the true root cause.
- Added a DEFAULT-row regression test asserting the shipped default names the real fork clone, keeps `master`, and pins an explicit clone-url.

**Verification**
- `bash -n` clean; shellcheck shows only pre-existing benign warnings.
- Test suite: **45 passed, 0 failed** (42 prior + 3 new).
- End-to-end against the on-disk clone: `worktrees/endojs-endo-but-for-bots.git` resolves as its own git repo, its `origin master` is reachable over ssh, and local == remote — so under the new default the keeper takes the "already fresh" happy path instead of warning forever.

**Follow-ups:** none required. (Optional, out of scope: if the fleet ever needs the standing clone's `refs/remotes/origin/llm` kept fresh independently of on-demand worktree fetches, a second `…|origin|llm|…` row could be added — but `llm` doesn't exhibit the passive-stale hazard this keeper targets.)
