once: 2026-10-08T01:11:28Z
job_basename_prefix: ocap-site-dnssec-followup-20261008
---
---
role: gardener
---

# One-week follow-up: ocap.site DNSSEC / domain transfer

Context for whoever claims this: on 2026-09-30/10-01, DNSSEC signing was
enabled on the `ocap.site` Route53 hosted zone (`Z048672026UQWLGHNEQE0`,
KSK `ocap-site-ksk`, zone status `SIGNING`), but the DS record still needs
publishing at the domain's registrar, and the registrar's self-service UI
had no DS-record field. The maintainer considered transferring the domain
into Route53 Domains instead (so Route53 Domains auto-publishes the DS
record), but `transfer-domain` failed on 2026-10-01 with "the domain has
been registered recently... must wait 60 days after registration."

## Task

1. Re-check transfer eligibility:
   `aws route53domains check-domain-transferability --domain-name ocap.site --region us-east-1`
   (use `$HOME/.local/bin/aws`; the `garden-fleet` credential is already
   propagated to this host's `~/.aws`).
2. Send a message to the maintainer inbox (`scripts/jobs/message-user.sh
   ocap-site-dnssec-followup-20261008`) summarizing: current transfer
   eligibility (now unblocked, or the new wait estimate if still locked),
   and a reminder that the DS record is still unpublished at the registrar
   either way. Do not attempt the transfer yourself — contact details and
   a fresh registrar authorization code are needed from the maintainer
   each time, so just report status and let the liaison/maintainer decide
   next steps.
