---
role: gardener
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/minion.town
Issue: https://github.com/kriscendobot/minion.town/issues/38 (kriskowal, 2026-08-11)

# Set up FastMail mail delivery DNS for security@minion.town

Implement the DNS records from issue #38 on the **minion.town** Route53 zone. The
fleet already administers Route53 for this account (it created and delegated the
`ocap.site` zone `Z048672026UQWLGHNEQE0`), so this is fleet-doable — but it is a
change to a **live production zone serving a 5-tenant box**, so verify before and
after and change nothing else.

## Verified precondition (2026-08-11, re-verify before writing)

`minion.town` currently has **no MX records, no TXT records, and no
`fm{1,2,3}._domainkey` CNAMEs**. So there is nothing to merge or displace. If that
is no longer true when you run, STOP and report rather than overwriting — see the
SPF hazard below.

## Records to create

MX (apex `minion.town`):

    10  in1-smtp.messagingengine.com
    20  in2-smtp.messagingengine.com

CNAME (DKIM):

    fm1._domainkey.minion.town  ->  fm1.minion.town.dkim.fmhosted.com
    fm2._domainkey.minion.town  ->  fm2.minion.town.dkim.fmhosted.com
    fm3._domainkey.minion.town  ->  fm3.minion.town.dkim.fmhosted.com

TXT (SPF, apex):

    v=spf1 include:spf.messagingengine.com ?all

## Hazards — read before writing

1. **Exactly ONE SPF TXT record may exist per domain.** Two SPF records is a
   permanent-error condition in RFC 7208 and receivers may reject or ignore both.
   If any `v=spf1` TXT already exists at the apex when you run, do NOT add a
   second — merge the `include:` into the existing record, or stop and report.
2. **Do not disturb existing records.** The apex A/ALIAS, the `*.minion.town`
   wildcard, `github-idp`, `siwe-idp`, and `www` all serve live traffic; the IdP
   subdomains carry the OAuth login path that was down for three days last week.
   Add records only; modify or delete nothing.
3. **The SPF policy is `?all` (NEUTRAL)** — that is FastMail's generic default and
   asserts nothing about unauthorized senders. It is what the issue specifies, so
   use it; but note in your report that `~all` (softfail) is the usual hardening
   step once delivery is confirmed working, and that DMARC is absent entirely.
   Do NOT change either without a maintainer directive.

## Verify after

- `dig MX minion.town` returns both messagingengine hosts at priorities 10/20.
- Each `fm{1,2,3}._domainkey.minion.town` CNAME resolves to its `dkim.fmhosted.com`
  target.
- Exactly ONE `v=spf1` TXT exists at the apex.
- **Regression check the live edge is untouched**: `https://minion.town/` still 302,
  `https://github-idp.minion.town/.well-known/openid-configuration` and the siwe-idp
  equivalent still 200, `https://www.minion.town/` still 302.

## Report

List each record created with its final resolved value, confirm the single-SPF
invariant, confirm the edge regression check, and state explicitly whether
FastMail's side (mailbox/alias for `security@minion.town`) still needs an action the
fleet cannot take — the DNS half does not by itself create the mailbox.
