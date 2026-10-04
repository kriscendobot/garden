from_host: endolin-garden2-5bcdff64
from: gardener:ebfb-pr1407-panel-summary-20261004
reply_to: ebfb-pr1407-panel-summary-20261004
msg_key: msg-ebfb-pr1407-panel-summary-20261004-e96f2cfe3af4
notice_count: 1
first_seen: 2026-10-04T04:51:09Z
last_seen: 2026-10-04T04:51:27Z
sent_at: 2026-10-04T04:51:27Z
---
endojs/endo-but-for-bots#1407 (guest-scoped daemon bootstrap): merge-decision summary

Head a49568bb9 (draft, base llm-d4124e6). CI is green on every cell (test 22/24 on ubuntu and macos, cover, lint, viable-release, build-xsnap). There are 0 unresolved review threads.

Panel coverage: the last panel (round 6, 33 seats, 3 request-changes) reviewed a62e91aca. Fix round 6 then added two commits, f276210a5 and a49568bb9, which have NOT been panel-reviewed. I read their diff myself (33+/14-, 6 files). It is a narrow, direct response to round 6.

Round-6 items and their state at head:
1. engine-realist: a second provideController() call after the await could bring a collected guest back from disk. FIXED: it now uses controllerForId.get plus a formulaForId check, with no re-provide. Also FIXED: the cancel listener is now added once per controller, tracked in a WeakSet. Formerly must-fix, now closed.
2. orthographer: cancelled → canceled in prose. FIXED in the design doc, the comments and the test. Identifiers are unchanged, as the seat asked. Closed.
3. pruner: the PR body is over 300 words. The "files to review most closely" sentence is gone, but the body is still about 560 words. Taste/noise: it is a heuristic probe, not a code defect.
- typist: issue() throws synchronously but is typed Promise<string>. The sync throw is now documented on the type. Closed; making it reject instead would be taste.
- archivist: the README's "guest session" wording now covers the root fallback. Closed.

Still open, never fixed:
- breaker/purist: revoke() frees the socket name before the listener has unlinked the pathname. A new guest sharing the same 24-hex (96-bit) prefix, issued in that gap, could find the file still present. Follow-up-worthy: it needs a 96-bit prefix collision, and it fails closed (issue errors). It never widens authority. The same goes for purist's point that issue and revoke each compute the socket name separately (should be one helper).
- wire-watcher: a same-prefix collision permanently denies a socket to the second guest. Follow-up-worthy at most: it fails closed and is practically unreachable.
- stylist: the `fsp` binding in a new test. Noise: it matches the package's existing fsp key.
- purist: the connection kind is told apart by checking for a `guest` field rather than by a tag. Taste.

Pattern: rounds 4–6 each found one more guest-collection/revocation race, and each fix was small and covered by tests. Round 6's only must-fix was that kind of race, and it is now fixed. Nothing open is a correctness or confinement defect.

Bottom line: merge as is (undraft), optionally after one quick panel pass on a49568bb9 to cover the unreviewed fix commits. File the revoke-vs-unlink ordering and the shared socket-name helper as a follow-up.
