from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1487-gauntlet-fix-1
reply_to: endojs-endo-but-for-bots-pr1487-gauntlet-fix-1
msg_key: msg-endojs-endo-but-for-bots-pr1487-gauntlet-fix-1-72347633ba70
notice_count: 1
first_seen: 2026-10-17T04:00:36Z
last_seen: 2026-10-17T04:00:40Z
sent_at: 2026-10-17T04:00:40Z
---
https://github.com/endojs/endo-but-for-bots/pull/1487 (gauntlet fix-1): the design commit settles session-reconnect C1 as Rekey-only, which reverses your tentative decision on https://github.com/endojs/endo-but-for-bots/pull/252 ("Tentatively run with resume and rekey-cap"). The panel (decomplector) asks for your explicit confirmation, on PR 1487 or https://github.com/endojs/endo-but-for-bots/pull/1475, before merge. Reasons: IK rekey is 1 RTT / 213 bytes, and carrying a CipherState across connections risks (key, nonce) reuse. The design now lists C1 as an open question awaiting you.
