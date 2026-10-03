from_host: endolin-garden-ece02cb4
from: gardener:ebfb-pr1380-panel-summary-20261003
reply_to: ebfb-pr1380-panel-summary-20261003
msg_key: msg-ebfb-pr1380-panel-summary-20261003-49222e0473f1
notice_count: 1
first_seen: 2026-10-03T05:32:19Z
last_seen: 2026-10-03T05:32:20Z
sent_at: 2026-10-03T05:32:20Z
---
Decision summary for endojs/endo-but-for-bots#1380 (round-6 budget reached; CI green at f988d95d):

- Must-fix before merge — scope/acceptance: the PR itself declares `non-deliverable-probe` and deferred acceptance because supervisor attach and the replay driver are absent. The design's phase gate therefore correctly requires it to stay draft; satisfying this needs a scope/acceptance redesign or those follow-ons, not another local patch.
- Must-fix before merge — final-head review: all round-6 code findings appear addressed in f7d1b115..ac967137, but the only completed panel reviewed 2fb39bc2, while the current f988d95d includes those fixes plus the CI rerun. It has no exact-head panel coverage.
- Must-fix (small mechanical fix, but not sufficient) — PR body is currently 306 words, still over the 300-word gate. Trim at least six words before any new review.

- Follow-up-worthy, not a merge blocker for the worker-side probe: SQLite read APIs still admit stateful PRAGMAs; broader CAS corruption/position-boundary and property-style crypto/replay tests; host-refusal helper consolidation/error-message consistency; hasher-restaging/fsync cost and history restack cleanup. These were deferred or comment-only and do not outweigh the explicit probe boundary.
- Taste/noise: the remaining established `env` abbreviation and commit grouping are not reasons to block a scoped implementation.

Bottom line: needs redesign for a mergeable deliverable. Do not merge/undraft as-is merely because CI is green; either retain endojs/endo-but-for-bots#1380 as its declared draft probe, or replace/extend it with the supervisor-attach + replay-driver acceptance path, then obtain a panel on that final head. The round-6 code objections themselves are closed by the reported fixes, subject to that fresh-head review.
