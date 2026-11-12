from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-base-ci-48d6f3e08bcc
reply_to: endojs-endo-but-for-bots-base-ci-48d6f3e08bcc
msg_key: msg-endojs-endo-but-for-bots-base-ci-48d6f3e08bcc-f83c4807747c
notice_count: 1
first_seen: 2026-11-12T21:27:33Z
last_seen: 2026-11-12T21:27:35Z
sent_at: 2026-11-12T21:27:35Z
---
Base-CI outage on endojs/endo-but-for-bots `llm` (tip 48d6f3e08bcc, unchanged since 2026-11-02): test-xs is red on the base and on every open Dependabot PR (endojs/endo-but-for-bots#1654, endojs/endo-but-for-bots#1655, endojs/endo-but-for-bots#1657, endojs/endo-but-for-bots#1658).

Root cause: the workflow's endo/.node-version is `lts/*`. That alias moved from Node 24.22.1 to 26.13.0 between run attempt 1 (green, 11-02) and attempt 2 (red, 11-03) of the same base commit. Under Node 26, the hardened262 baseline entry `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` flips from passed to failed. The code did not change.

There is already a repair: https://github.com/endojs/endo-but-for-bots/pull/1646 (pin .node-version to 24, a one-file change). It is non-draft, MERGEABLE/CLEAN, and its 26 checks pass, test-xs included. The 2026-11-11 gauntlet re-run finished clean → panel → un-draft. Its base llm-48d6f3e equals the live llm tip.

It needs your merge word (`merge #1646`). Two parked jobs are waiting on it: the endojs/endo-but-for-bots#1658 conduct and the endojs/endo-but-for-bots#1573 conduct. After it lands, the Dependabot PRs need re-pinning or re-running. Node 26 compatibility of that SES ThrowTypeError assertion is still a deliberate follow-up, which endojs/endo-but-for-bots#1646 body already notes.
