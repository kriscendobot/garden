from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1629-dependabot
reply_to: endojs-endo-but-for-bots-pr1629-dependabot
msg_key: msg-endojs-endo-but-for-bots-pr1629-dependabot-93b65e8ecf64
notice_count: 1
first_seen: 2026-11-01T22:25:48Z
last_seen: 2026-11-01T22:25:49Z
sent_at: 2026-11-01T22:25:49Z
---
https://github.com/endojs/endo-but-for-bots/pull/1629 (setup-python 7.0.0->7.1.0) passed botanist diligence: mature, SHA-verified, 0 advisories, benign source. It is held only because ironhorse-oracle-sanitizers and test-ironhorse-oracle are red with the stage3-math/054,055 libm divergence on ubuntu-26.04. Every PR that edits ci.yml runs those lanes, so this will keep happening. The fix, https://github.com/endojs/endo-but-for-bots/pull/1613 (pin oracle lanes to 24.04), is open and fully green and needs your merge. The daily dependabotany recheck will conduct 1629 once 1613 lands.
