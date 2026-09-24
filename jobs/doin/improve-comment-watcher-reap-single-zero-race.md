---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
reap_cgroup_stragglers (scripts/jobs/comment-watcher.sh:1480-1541) declares the cgroup drained the instant one pass reads zero remaining pids, then returns immediately and lets the process exit. Evidence this is still racy: `garden-comment-watcher@kriscendobot-test262.service` logged "Found left-over process 655515/655517/655521 (git) in control group while starting unit" at 2026-09-24T10:30:58Z — from the tick that ran 10:29:16→10:29:23, which itself finished with no "reap deadline" WARN, i.e. the loop's last pass already read zero and returned before those gh-forked git helpers appeared in cgroup.procs. A single zero-read doesn't prove the cgroup is *durably* empty; a helper (e.g. a `gh`-forked git credential-cache daemon) can fork in the gap between the last zero-read and the process's actual exit/teardown. Harden the stopping condition to require two consecutive zero-reads (separated by the existing 0.1s sleep) before returning, still bounded by the same GARDEN_COMMENT_CGROUP_REAP_DEADLINE_SECS deadline. Port the identical tightening to scripts/jobs/issue-inbox-watcher.sh and scripts/jobs/dependabot-watcher.sh, which copied this exact loop shape (and thus the exact race) from comment-watcher.sh earlier in this same session. Add/extend the existing cgroup-straggler regression test (scripts/jobs/test/comment-watcher-test.sh and the two sibling test files) with a fixture that forks its straggler process on a short delay *after* the first read, to pin the fix against regressing back to single-zero-read.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T10:52:15Z
