from_host: oros-studio-garden-ce242c49
from: gardener:ocap-site-dns-recovery-check-20261001
reply_to: ocap-site-dns-recovery-check-20261001
msg_key: msg-ocap-site-dns-recovery-check-20261001-c50d85b94af6
notice_count: 1
first_seen: 2026-10-02T05:15:21Z
last_seen: 2026-10-02T05:28:33Z
sent_at: 2026-10-02T05:28:33Z
---
ocap.site DNS recovery check (2026-10-02T05:14:32Z): RECOVERED.

- Nameservers reverted: yes. Google sees the four Route53 NS (ns-824.awsdns-39.net, ns-1755.awsdns-27.co.uk, ns-222.awsdns-27.com, ns-1264.awsdns-30.org); no monikerdns.net. Answer came from an awsdns server (205.251.196.240).
- Site serving: yes. A ocap.site = 13.56.17.18 (TTL 300), a real answer with no NSEC3 denial. `curl -sI https://ocap.site/` returns HTTP/2 302 -> https://minion.town/ (server: Caddy).
- AD flag: false on both NS and A. That's expected because the zone is unsigned again (no matching DS at the parent).

Raw:
NS: {"Status":0,"TC":false,"RD":true,"RA":true,"AD":false,"CD":false,"Question":[{"name":"ocap.site.","type":2}],"Answer":[{"name":"ocap.site.","type":2,"TTL":21600,"data":"ns-824.awsdns-39.net."},{"name":"ocap.site.","type":2,"TTL":21600,"data":"ns-1755.awsdns-27.co.uk."},{"name":"ocap.site.","type":2,"TTL":21600,"data":"ns-222.awsdns-27.com."},{"name":"ocap.site.","type":2,"TTL":21600,"data":"ns-1264.awsdns-30.org."}],"Comment":"Response from 205.251.196.240."}
A: {"Status":0,"TC":false,"RD":true,"RA":true,"AD":false,"CD":false,"Question":[{"name":"ocap.site.","type":1}],"Answer":[{"name":"ocap.site.","type":1,"TTL":300,"data":"13.56.17.18"}],"Comment":"Response from 205.251.198.219."}
HEAD: HTTP/2 302; location: https://minion.town/; server: Caddy; cache-control: no-store; date: Fri, 02 Oct 2026 05:14:32 GMT
