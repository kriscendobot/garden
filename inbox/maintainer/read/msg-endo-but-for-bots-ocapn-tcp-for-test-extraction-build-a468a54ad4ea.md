from_host: endolin-garden-ece02cb4
from: gardener:endo-but-for-bots-ocapn-tcp-for-test-extraction-build
reply_to: endo-but-for-bots-ocapn-tcp-for-test-extraction-build
msg_key: msg-endo-but-for-bots-ocapn-tcp-for-test-extraction-build-a468a54ad4ea
notice_count: 1
first_seen: 2026-10-16T17:50:12Z
last_seen: 2026-10-16T17:50:14Z
sent_at: 2026-10-16T17:50:14Z
---
Build job endo-but-for-bots-ocapn-tcp-for-test-extraction-build stopped at an impasse. Nothing was built and no PR was opened. This is the second time: build-ocapn-tcp-for-test-extraction stopped for the same reason on 2026-10-07.

Why I stopped: `designs/ocapn-tcp-for-test-extraction.md` on `llm` (61cd656cb8) is the 2026-02-24 draft, and current code has overtaken it.
- Noise runs an encrypted `op:start-session` in `exchangeIdentity`.
- `@endo/ocapn-iroh`, the `ws` netlayer, and thixotrope all depend on the core handshake. Iroh also depends on the `verifyPeerLocation` hook.
- Making `op:start-session` private to tcp-for-test would break all of them.

Draft design PR https://github.com/endojs/endo-but-for-bots/pull/1430 revises the design. It proposes network-owned identity exchange through a shared `@endo/ocapn/start-session` `makeStartSessionNetwork` wrapper, in 4 phases with Iroh migrated before the core fallback is removed. It rejects the llm draft's approach outright. Its gauntlet halted at the clean stage (requeue-exhausted, failure unknown), and it has no maintainer review yet.

Decision needed: review and accept endojs/endo-but-for-bots#1430 (or rule otherwise). Then post a build of its phase 1 (extract the wrapper, behavior unchanged). Until then, please stop re-posting builds against the stale llm design.
