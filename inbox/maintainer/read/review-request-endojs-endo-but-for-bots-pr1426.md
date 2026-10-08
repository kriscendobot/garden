from_host: endolin-garden2-5bcdff64
from: gardener:compose-review-requests-budget-reached-20261007
reply_to: compose-review-requests-budget-reached-20261007
msg_key: review-request-endojs-endo-but-for-bots-pr1426
notice_count: 1
first_seen: 2026-10-07T22:13:04Z
last_seen: 2026-10-07T22:13:14Z
sent_at: 2026-10-07T22:13:14Z
---
Review request: endojs/endo-but-for-bots PR 1426 (gauntlet reached its review budget twice)
https://github.com/endojs/endo-but-for-bots/pull/1426
Arc: unallocated (Familiar release; design `familiar-localhttp-protocol`). Draft.

What it does: Chat now renders the security warnings the Familiar already sent over `familiar:security-warnings`, with a dismissible banner that survives body replacement.
It also fixes a delivery race: the Familiar sent the warnings once, often before the page listened, so it now re-sends on every Chat page load and never to a `localhttp:` weblet in the same window.

CI: head `159ea0ff3c`, 25 passed, 8 skipped, 0 failed. Base `llm-395c485`. +1175/-40, 14 files.

Why it didn't converge: two gauntlets, 12 panel/fix rounds (build-familiar-localhttp-protocol-gauntlet ended 10-05; endojs-endo-but-for-bots-pr1426-gauntlet, re-staged after the coverage audit, ended 10-06). In the second gauntlet the blocking set moved each round: engine-realist in round 2 (the macOS `activate` handler re-sent stale warnings instead of re-checking), scribe in round 3 (a process gap), 7 seats in round 5, 3 in round 6. It was narrowing, but each round still turned up something new, and several asks were about process (summary comments, PR description length) rather than code.

Last panel round (round 6, head `998d699115`): 3 request changes (spec-keeper, archivist, pruner), 8 comment-only, 22 approve. Fix round 6 says it addressed them in `159ea0ff3c`; no panel has checked the result:
- spec-keeper: a real bug. `isChatPageUrl` compared encoded paths, but Node writes `~` as `%7E` and Chromium doesn't, so on a path like `PROGRA~1` the warning was never sent. `pageIdentity` in packages/familiar/src/security-warnings.js now decodes before comparing, with a test for both spellings.
- archivist: the dismissal and `mount()` contract moved from the module comment into the `SecurityWarningBanner` JSDoc (packages/chat/security-warning-banner.js).
- pruner: PR description too long. Fix 6 didn't rewrite it, but the body is now 283 words (the seat's limit was 300).
- migrator (suggestion): `@endo/familiar` bumped from patch to minor, since the PR adds exports.

Still open: spec-keeper's optional type check on `callback` in `preload.mjs`.

Look at first: packages/familiar/src/security-warnings.js (the Chat-page URL match decides whether a warning is ever shown, and round 6 found a real miss there), then the electron-main.js send-on-load and `activate` path that rounds 2 and 5 kept returning to.

No GitHub review was requested and nothing was approved.
