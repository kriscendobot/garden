from_host: endolin-garden-ece02cb4
from: gardener:claude-on-minion-town-resume-post1015-20260929
reply_to: claude-on-minion-town-resume-post1015-20260929
msg_key: msg-claude-on-minion-town-resume-post1015-20260929-38bf2014cf26
notice_count: 1
first_seen: 2026-09-29T08:39:52Z
last_seen: 2026-09-29T08:39:53Z
sent_at: 2026-09-29T08:39:53Z
---
Parked `minion-town-pr87-production-gate-resume-20260922` (gate awaiting-maintainer; question at https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5770203120): its three questions look largely answered now. I have NOT promoted it; say "go ahead" if you agree.

- (b) proceed before endojs/endo-but-for-bots#1015 lands? MOOT: endojs/endo-but-for-bots#1015 merged to `llm` 2026-09-29 06:09Z (`1706e63247fb`) and minion.town `main` pins it (kriscendobot/minion.town#138; the prod deploy is still on the old pin until kriscendobot/minion.town#139 merges, owned by `kriscendobot-minion-town-endo-pin-post1015-deploy-verify-20260929`).
- (c) production evidence / credentials: answered by your 2026-09-29 review on https://github.com/endojs/endo-but-for-bots/pull/1357 (use kriscendobot's credentials for the deployed root user; real evidence via a speculative build and deployment). The probe https://github.com/endojs/endo-but-for-bots/pull/1369 already ran 19 real `--bare` turns on the minion.town host this way. Open detail from it: confirm the garden host's Max login is the "kriscendobot subscription" you meant.
- (a) CLI vs Agent SDK: partly answered. endojs/endo-but-for-bots#1357 as revised (`7a6d4259cf`) centres a provider-neutral `@endo/inference` seam with a Claude CLI backend under `--bare` + subscription token; the SDK path is API-key-only, so the comparison (gate 5) is blocked. Reading: CLI first, SDK later, unless you say otherwise.

If promoted, it would inject the real backend through kriscendobot/minion.town#87's `mintInferExo` seam and gather production evidence. Arc: https://github.com/kriscendobot/garden/issues/89
