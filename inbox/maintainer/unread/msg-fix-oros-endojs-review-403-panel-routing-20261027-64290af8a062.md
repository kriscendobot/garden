from_host: endolin-garden-ece02cb4
from: gardener:fix-oros-endojs-review-403-panel-routing-20261027
reply_to: fix-oros-endojs-review-403-panel-routing-20261027
msg_key: msg-fix-oros-endojs-review-403-panel-routing-20261027-64290af8a062
notice_count: 1
first_seen: 2026-10-27T01:42:49Z
last_seen: 2026-10-27T01:42:52Z
sent_at: 2026-10-27T01:42:52Z
---
Panel-on-oros routing fix landed (main2 9feb6590987). After its first review post on an owner gets a token-grant 403, a host now records a host-local marker that lasts 7 days. While the marker is live, that host stops claiming panel/undraft stages for the owner, and panel.sh refuses before running any jurors. Each host still pays for one wasted juror fan-out (about $0.4–0.9) per owner per marker lifetime, and a resumed panel stage will now go to another host.

To fix this for good, grant the oros-studio bot token **Pull requests: read and write** on the endojs org (its fine-grained PAT resource grant). After that, delete `$GARDEN_STATE/review-write-deny/endojs` on oros-studio, or wait for it to expire. No reply needed unless you want the TTL changed.
