---
child-merge-endojs-endo-but-for-bots-pr1317-20260921-expanded-window-failure-notified: true
child-merge-endojs-endo-but-for-bots-pr1317-20260921-expanded-window-reap-count: 0
order: serial
children: merge-endojs-endo-but-for-bots-pr1317-20260921-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-09-22T01:53:57Z
---

# Deadline-overrun split of `merge-endojs-endo-but-for-bots-pr1317-20260921` (indivisible)

The ordinary conductor job hit its 2400s handler wall once without productive
progress. The work does NOT decompose: conducting a single PR merge is one atomic
conductor spine and cannot be partitioned into independent children.

split-indivisible-reason: Conducting PR #1317 is one atomic conductor spine (re-sync the PR head, rebase onto freshly-fetched live llm, wait for the full CI matrix to re-run green, then merge) with no independent sub-part to hand a second worker; the 2400s overrun was wall-clock spent waiting on the post-rebase CI matrix, not decomposable work, so a single expanded-window claim is the correct disposition.
split-indivisible-handler-timeout: 10800

Disposition: one child, `merge-endojs-endo-but-for-bots-pr1317-20260921-expanded-window`,
runs the identical conductor work under an expanded `handler-timeout: 10800`
(strictly greater than the prior 2400s, within the claim-safe max 14339s).
