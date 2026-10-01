once: 2026-10-01T20:59:43Z
job_basename_prefix: ocap-site-dns-recovery-check-20261001
---
---
role: gardener
---

# Verify ocap.site DNS recovery after registrar nameserver revert

Context: on 2026-10-01, enabling DNSSEC at ocap.site's registrar (Moniker)
silently switched the domain's nameservers from Route53 to Moniker's own
(`ns{1-4}.monikerdns.net`), which serve an empty zone — the site went down
(NSEC3 denial-of-existence on the apex A record). The maintainer reverted
the nameservers at the registrar back to Route53's four
(`ns-1264.awsdns-30.org`, `ns-1755.awsdns-27.co.uk`, `ns-824.awsdns-39.net`,
`ns-222.awsdns-27.com`) at approximately 2026-10-01T19:49Z. The old NS
record's TTL (3600s) means propagation should complete by roughly
2026-10-01T20:49Z.

## Task

1. Check current delegation:
   `curl -s "https://dns.google/resolve?name=ocap.site&type=NS"` — confirm
   it now shows the four `awsdns` nameservers above, not `monikerdns.net`.
2. Confirm the site actually resolves and serves content:
   `curl -s "https://dns.google/resolve?name=ocap.site&type=A"` should show
   a real answer (not an NSEC3 denial), and `curl -sI https://ocap.site/`
   should return a real HTTP response (the 302 redirect to minion.town, per
   the site's normal behavior), not a connection/DNS failure.
3. Also check whether `AD` (authenticated-data) is `true` or `false` on the
   plain `A` query — note it either way, don't treat it as a failure signal:
   the zone is expected to be *unsigned* again at this point (no DS record
   matches Route53's KSK at the parent), so `AD: false` is the
   correct/expected state, not a problem.
4. Send a message to the maintainer inbox
   (`scripts/jobs/message-user.sh ocap-site-dns-recovery-check-20261001`)
   reporting: whether the nameservers reverted successfully, whether the
   site is actually serving traffic again, and the raw query outputs. If it
   has NOT recovered by the time this runs, say so plainly and do not
   speculate further without re-checking — it may just need more
   propagation time at other resolvers even once Google's cache clears.
