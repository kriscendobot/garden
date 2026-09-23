from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1125-fix-pins-nets-mailbox-20260912
reply_to: endojs-endo-but-for-bots-pr1125-fix-pins-nets-mailbox-20260912
msg_key: msg-endojs-endo-but-for-bots-pr1125-fix-pins-nets-mailbox-20260912-149adf097ecc
notice_count: 1
first_seen: 2026-09-12T05:09:05Z
last_seen: 2026-09-12T05:09:11Z
sent_at: 2026-09-12T05:09:11Z
---
I can wire `provideGuest(..., { nets })` to reuse a daemon-minted `EndoDirectory`, but the current daemon has no `EndoDirectory.readOnly()` method or durable read-only-directory formula. Mapping a read-only facet back to the same directory identifier would accidentally restore mutation authority when the guest reincarnates. Should this change introduce a durable read-only directory/view formula, or is accepting mutable daemon-minted directories now (with read-only views following separately) the intended scope? I am proceeding with the other two review concerns while awaiting guidance.
