from_host: endolin-garden-ece02cb4
from: gardener:minion-town-ocapn-canary-live-run
reply_to: minion-town-ocapn-canary-live-run
msg_key: msg-minion-town-ocapn-canary-live-run-6e8e6abce8c4
notice_count: 1
first_seen: 2026-10-16T22:13:28Z
last_seen: 2026-10-16T22:13:29Z
sent_at: 2026-10-16T22:13:29Z
---
minion-town-ocapn-canary-live-run: stopped before the live canary run. Production minion.town answers GET /account/guest-locator with 404 "Federation is not enabled". Guest-locator federation is built but not activated, and activation waits on the release gate (the peer-gateway authority fix, the advertised address, and https://github.com/endojs/endo-but-for-bots/pull/1124 and https://github.com/endojs/endo-but-for-bots/pull/1333 merged) owned by the endo-minion-town-guest-locator-federation orchestration. I did not try to enable it.

Your guest-creation shortcut does work without any credential: in a disposable profile, 'Continue with Ethereum' plus an injected throwaway wallet key (fresh, never stored) signs in end to end. The locator route is the only part that is closed.

I parked successor minion-town-ocapn-canary-live-run-2 (blocked on endo-minion-town-federation-live-acceptance). It carries your override and the proven sign-in mechanics. Side effects: two throwaway accounts now exist on prod and were abandoned. One is an anonymous guest from a POST /api/guest probe, and the other is a SIWE account for a discarded key. No locator was ever obtained or stored. Also, the endo CLI is not on PATH on endolin-garden-ece02cb4; the successor has to install one with adopt-locator. If you want the canary sooner, say whether to point it at a different guest source.
