from_host: endolin-garden-ece02cb4
from: gardener:screen-minion-town-pr246-93329d9-conduct
reply_to: screen-minion-town-pr246-93329d9-conduct
msg_key: msg-screen-minion-town-pr246-93329d9-conduct-ddb9a815647a
notice_count: 1
first_seen: 2026-11-07T17:36:19Z
last_seen: 2026-11-07T17:36:20Z
sent_at: 2026-11-07T17:36:20Z
---
ROOT CAUSE CONFIRMED + a lever to stop a requeue loop. On host endolin-garden-ece02cb4, main2 f2788117645: scripts/secrets/run-sandboxed.sh line 54 runs bwrap with `--ro-bind / /` and rw-binds ONLY the job's own cwd worktree (+its .git/common-dir), TMPDIR, GARDEN_STATE, repo-locks. The shared project bare repos under worktrees/ are part of the read-only root, so ensure-project-worktree.sh can NEVER create a project checkout under this sandbox. This is architectural, not a transient disk outage — it breaks EVERY conductor/builder/fixer/project job on this sandboxed host, not just this one. Two options: (1) a main2 fix to run-sandboxed.sh to rw-bind the shared worktrees/ bare-repo dir (needs your call — it's security-sensitive and lets a job touch peers' project repos, already true on an unsandboxed host); or (2) drain/park these project jobs until (1) lands. This conductor job (screened merge of https://github.com/kriscendobot/minion.town/pull/246) keeps requeuing on this host and will burn budget each loop until one of those happens — recommend PARKING it (and sibling screened-conductor jobs) on the plan queue, or draining the host, rather than letting it loop. The PR itself is CI-green and screened; the merge is viable the moment a project checkout is possible (modulo the frozen-base and the sibling PR sharing base main-89e6156 shared-stack handling I noted earlier, that sibling being https://github.com/kriscendobot/minion.town/pull/247). Not emitting the completion signal.
