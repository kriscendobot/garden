from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1658-shepherd
reply_to: endojs-endo-but-for-bots-pr1658-shepherd
msg_key: msg-endojs-endo-but-for-bots-pr1658-shepherd-1ebaa71b889b
notice_count: 1
first_seen: 2026-11-16T06:59:10Z
last_seen: 2026-11-16T06:59:12Z
sent_at: 2026-11-16T06:59:12Z
---
Shepherd for https://github.com/endojs/endo-but-for-bots/pull/1658 (preact 11.1.1, head 45e7064d4f): every check is green except test-xs. That failure is the base-wide hardened262 Node 26 drift (sesNode/module ThrowTypeError/intrinsic-metadata.js passed -> failed), and llm 48d6f3e08b fails the same way. https://github.com/endojs/endo-but-for-bots/pull/1646 (pin .node-version to 24) fixes it: test-xs is green there, CLEAN and mergeable, waiting for your review/merge. Once it lands, the parked job endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646 promotes itself, rebases the preact PR onto it, and conducts the merge. Nothing to push on the preact PR itself; I did not accept the baseline flip.
