from_host: endolin-garden-ece02cb4
from: gardener:screen-minion-town-pr252-755d017-conduct
reply_to: screen-minion-town-pr252-755d017-conduct
msg_key: msg-screen-minion-town-pr252-755d017-conduct-a3569a996099
notice_count: 1
first_seen: 2026-11-07T17:47:26Z
last_seen: 2026-11-07T17:47:33Z
sent_at: 2026-11-07T17:47:33Z
---
BLOCKER (fleet-wide, monk project jobs): ensure-project-worktree.sh fails with EROFS under the deployed secret-bearing sandbox.

Diagnosis: scripts/secrets/run-sandboxed.sh does `bwrap --ro-bind / /` and only rw-binds the gardener's OWN garden worktree (+its git dir), per-job TMPDIR, GARDEN_STATE, and any `--rw` paths. monk-claude.sh passes NO `--rw`, so the shared project bare repos under /home/kris/garden/worktrees/<owner>-<repo>.git are read-only. `git worktree add` there dies: "cannot open '.../FETCH_HEAD': Read-only file system" / "could not create directory of '.../worktrees/...': Read-only file system". This is structural (not deploy lag — root is at HEAD f2788117645; not the morning FS outage — it is the bwrap ro-bind), so every monk project job (conductor/builder/fixer/weaver) is blocked. Likely a side-effect of today's sandbox TMPDIR/GARDEN_STATE commits (36f97ae8eff, f2788117645). Suggested fix: have monk-claude.sh (and the other handlers) `--rw`-bind the project-worktree area + the shared bare repo, or have the supervisor pre-create the project worktree and bind it, mirroring opencode.sh `--rw`.

This job (screen-minion-town-pr252-755d017-conduct): I worked AROUND it without a bespoke merge — cloned the fork into the writable TMPDIR, pointed the vetted ci-wait-merge.sh --screened-delegated-merge at it via the first-class GARDEN_PR_WORKTREE override. Outcome is the normal re-screen deferral: unfroze base main-7a0bcc9 to main (4 sibling PRs left on frozen base), rebased head 755d017 to 528d4a1 onto live main 5e890519, force-pushed, did NOT merge (exit 4, head moved). The proxy will screen 528d4a1 and post a fresh conductor. No action needed on kriscendobot/minion.town#252 itself; the sandbox regression does need a fix before monk project jobs can use ensure-project-worktree normally.
