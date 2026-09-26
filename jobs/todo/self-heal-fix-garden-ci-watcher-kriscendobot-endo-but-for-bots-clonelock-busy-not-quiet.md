---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`ensure_clone_or_latch_outage` in `scripts/jobs/common.sh` (~line 4671) re-raises a `clone_lock` busy-timeout diagnostic LOUD (`exit "$rc"`, rc=1) instead of the documented "timeout → quiet exit 75, not FATAL" contract every call site comments (ci-watcher.sh:198, comment-watcher.sh:486, mention-watcher.sh:130, dependabot-watcher.sh:168, pages-watcher.sh:76, issue-inbox-watcher.sh:224, approval-reconciler.sh:216, backfill-dropped-review-comments.sh:82, cursor-get.sh:55, cursor-set.sh:60).

Failure signature (from `.garden-state/self-heal/journal` blob `7d9f0bec5f2784a9b0df4454ad2f85ebdb6e825e`): `garden-ci-watcher@kriscendobot-endo-but-for-bots` FATAL exit 1 with `cannot acquire clone lock /home/kris/garden/.garden-state/ci-watcher/verify.lock after 3 waits of 60s and 0 reclaim attempt(s) (a live holder is still busy; if it is crashed, rm -f ...)` — a live, non-stale holder (0 reclaim attempts, so not TTL-expired) was simply still busy past the 3×60s wait ladder.

Root cause: the diagnostic never reaches the transient branch because `journal_bounded_fetch_is_ambiguous_outage` only matches `journal fetch in .* failed after N attempt|clone of .* failed`, and `_fetch_stderr_is_offline` only matches network/DNS/transport signatures — neither pattern covers `clone_lock`'s own die message (`cannot acquire clone lock .* live holder is still busy`, `common.sh` ~line 4142), a purely local, non-network condition.

Fix: in `ensure_clone_or_latch_outage`, add a dedicated branch (checked before the offline/ambiguous-outage branch) that recognizes the lock-busy diagnostic (e.g. `grep -qE 'cannot acquire clone lock .* live holder is still busy'`) and does a quiet `log` + `exit "${GARDEN_OFFLINE_RC:-75}"` — deliberately WITHOUT calling `start_journal_outage_cooldown` (this is host-local lock contention on one specific clone dir, not evidence of a journal/network outage, so it must not latch the shared cooldown that other cursor reads/writes rely on). This restores the contract every caller already assumes and stops the whole watcher class (not just ci-watcher) from FATAL-restarting under ordinary lock contention.
