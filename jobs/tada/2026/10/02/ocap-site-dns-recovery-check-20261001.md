**ocap.site DNS recovery check: the site has recovered.** I checked at 2026-10-02T05:14:32Z.

- **Nameservers:** the revert worked. Google's resolver returns the four Route53 nameservers: `ns-824.awsdns-39.net`, `ns-1755.awsdns-27.co.uk`, `ns-222.awsdns-27.com` and `ns-1264.awsdns-30.org`. No `monikerdns.net` entries remain, and the answer came from an awsdns server (205.251.196.240).
- **Site serving traffic:** yes. The `A` query returns `13.56.17.18` (TTL 300), a real answer with no NSEC3 denial. `curl -sI https://ocap.site/` returns `HTTP/2 302` to `https://minion.town/` (server: Caddy), which is the site's normal behavior.
- **AD flag:** `false` on both the NS and A queries. That is expected, because the zone is unsigned again and no DS record at the parent matches Route53's key.
- **Maintainer message:** sent to the maintainer inbox with the summary and the raw query outputs (`msg-ocap-site-dns-recovery-check-20261001-c50d85b94af6`). The send took about 14 minutes because the journal was busy: it lost the push race seven times and waited on a busy clone lock before going through.

I made no changes to the garden repo. One possible follow-up for the maintainer: if they still want DNSSEC, they would need to enable signing in Route53 and add a matching DS record at Moniker without letting Moniker switch the nameservers again.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocap-site-dns-recovery-check-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (235445 cached reads)
- Output: 2472 tokens
- Cost: $0.38811300000000004
- Wall-clock: 882s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
