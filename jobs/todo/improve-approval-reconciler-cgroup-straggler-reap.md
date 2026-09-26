---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/approval-reconciler.sh
journalctl (2026-09-26T11:59:10) shows `garden-approval-reconciler@kriscendobot-endo.service` starting with three left-over `git` processes still in its control group — the exact leak class `comment-watcher.sh`, `dependabot-watcher.sh`, `triager.sh`, `issue-inbox-watcher.sh`, and `receipt-watcher.sh` each fixed by adding a `reap_cgroup_stragglers` sweep after they hit the same symptom (see dependabot-watcher.sh:188-232's postmortem comment). approval-reconciler.sh:369-401's `cleanup()` only sends `kill -TERM "-$pid"` to the setsid process group, which cannot reach a `gh --paginate`-forked git-credential helper (or an ssh master) that escapes the group into its own session — those survive into the next tick's cgroup. Port the cgroup-wide straggler sweep (bounded re-read loop over `/sys/fs/cgroup<leaf>/cgroup.procs`, SIGKILL any live non-self/non-ancestor pid, capped by a deadline) from dependabot-watcher.sh:242-260 or comment-watcher.sh:1494 into approval-reconciler.sh's cleanup path, called on every exit (clean or signalled), not just the stop-time cgroup backstop. `ci-watcher.sh` and `pages-watcher.sh` share the same un-hardened negated-PGID shape (approval-reconciler.sh:369 says "identical guard shape to ci-watcher.sh") and should get the same sweep once this lands.
