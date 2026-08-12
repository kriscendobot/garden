---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
requires: aws
handler-timeout: 3600

URGENT production containment on minion.town, authorized by the maintainer
(kriskowal) on 2026-08-12 in the liaison session. This job DOES change
production, deliberately and narrowly. Nothing outside the two steps below is
authorized; if you believe more is needed, report and ask.

## Why

The peer jobs `minion-town-host-exposure-forensics` and
`ebfb-guest-unconfined-from-tree` reproduced, from outside AWS with no
credential, a full EndoHost bootstrap on a public weblet endpoint
(`wss://6hlvj7a67t2eqpw74hakvrlqodhtt2xm4q54rgild3lqedcwzxjq.ocap.site/.well-known/endo-captp`),
including `makeUnconfined`, `evaluate`, `provideShell`, and `endow`. Cause:
`weblet_publish` accepts an arbitrary powers string, and the gateway resolves it
with `E(host).lookup(powers)` in the GATEWAY's own scope, where `@agent`
resolves to a formula of type `host`. Anyone holding a published weblet URL can
run arbitrary code as the `endo-daemon` service user.

## Authorized actions, in order

**0. Preserve evidence BEFORE changing anything.** Capture, into the job report:
the current `endo-gateway.service` unit and environment as deployed, the two
offending vhost records in full, and the current gateway access log covering the
period around dckc's access if it is retrievable. Containment destroys evidence
otherwise. Note that an attacker with host powers could have altered logs, so
record them as indicative, not authoritative.

**1. Fail the weblet powers endpoints closed.** Remove/disable
`GATEWAY_ENDO_SOCK` on `endo-gateway.service` and restart the gateway. Do not
stop the daemon; do not touch the `*.ocap.site` route; do not touch
`wss://minion.town/.well-known/ocapn-cbor-np` (investigated and not implicated).
Record the exact original value/config first so the change is reversible, and
put the rollback command in the report.

**2. De-register the two offending vhosts** owned by dckc's `iss+sub` record
(the ones granting powers string `@agent`).

## Verify, and report evidence for each

- Re-run the unauthenticated reproduction against the endpoint above from
  outside AWS. It must now fail closed. Paste what it returns. **This is the
  test that matters; a clean restart is not evidence.**
- Confirm the daemon itself is still running and the non-weblet surfaces are up.
- Report what this BREAKS: which legitimate weblet functionality is now down,
  so the maintainer knows the cost he is carrying until the fix deploys.
- Confirm whether de-registering the two vhosts succeeded and whether their URLs
  now fail.

## Then, still read-only

Enumerate **all remaining vhost records** and report every one whose powers
string resolves host-shaped, with vhost name, owner, and publish date. `@agent`
looks like an ordinary thing for a publisher to write, so dckc's two are
unlikely to be the only ones. This list tells the maintainer the true blast
radius and whether anyone else's weblet was exposed. Report it even though step
1 has already failed them closed.

## Bounds

- Do not suspend or modify dckc's account. He reported this responsibly and his
  identifiers were correct; the defect is the gateway's.
- Do not deploy code. The fix is `minion-town-weblet-powers-host-escape-fix`.
- No exploit specifics on any public tracker.
- Report to the maintainer as soon as step 1 is verified, before the enumeration.
