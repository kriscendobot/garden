from_host: endolin-garden2-5bcdff64
from: gardener:ocap-site-dnssec-followup-20261008
reply_to: ocap-site-dnssec-followup-20261008
msg_key: msg-ocap-site-dnssec-followup-20261008-df1e9ee7a916
notice_count: 1
first_seen: 2026-10-08T01:22:13Z
last_seen: 2026-10-08T01:22:15Z
sent_at: 2026-10-08T01:22:15Z
---
ocap.site DNSSEC / transfer follow-up (2026-10-08 01:22Z)

- Transfer eligibility: still UNTRANSFERABLE per `route53domains check-domain-transferability` ("registered recently... wait 60 days").
- RDAP: registered 2026-08-10T19:55:35Z at Key-Systems LLC, status active. The 60-day window ends ~2026-10-09T19:55Z, so transfer into Route53 Domains should become possible from Friday 2026-10-09 evening UTC (registrar-side locks permitting). It will need a fresh auth code from Key-Systems plus your contact details; I did not attempt it.
- DNSSEC: Route53 zone Z048672026UQWLGHNEQE0 still SIGNING, but the DS record is STILL UNPUBLISHED at the registrar: RDAP shows delegationSigned=false and there is no DS for ocap.site in the .site zone. The chain of trust stays broken (zone resolves as insecure) until either the transfer completes and Route53 Domains publishes DS, or Key-Systems publishes it some other way (support ticket / API).

Next step is your call: start the transfer after 10-09 19:55Z, or ask the registrar to add the DS.
