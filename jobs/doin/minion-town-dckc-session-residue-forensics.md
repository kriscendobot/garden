---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
requires: aws
handler-timeout: 5400

Read-only production forensics on minion.town. Deliverable is a report. Do NOT
change production, do NOT delete anything you find, and do NOT deploy.

## Why this job exists

The completed job `minion-town-containment-gateway-endo-sock` contained a
confirmed unauthenticated remote-host-powers exposure and preserved evidence,
but its report did not answer what the exposure LEFT BEHIND. Its own evidence
raises the question sharply. From its Step 0:

> `journalctl -u endo-gateway.service` shows the attacker/reporter driving the
> CapTP powers endpoint of vhost `fe0a8e602d18` from 21:27:58 to 21:39:40Z ...
> the returned method list proves the resolved object is the full EndoHost ...
> Probes included `evaluate`, `remove`, `writeText`, a `lookup "plane"`.

`remove` and `writeText` are **mutations**, executed against the daemon TOP HOST
by an unauthenticated public endpoint. So state was very likely written and/or
deleted. De-registering the two vhosts does not undo anything created or
destroyed THROUGH them. The peer forensics job closed with the same gap open:
"assess any exposure during the pre-containment window".

Context you can rely on (established, do not re-derive): the cause was the
gateway resolving a publisher-supplied powers string via
`E(daemonHost).lookup(...)` in the top-host scope; `@agent` resolved host-shaped;
dckc's two vhosts (`f1d754fc…` published 21:35:05Z, `fe0a8e60…` published
21:04:12Z) were the only host-shaped records of seven; containment landed
~22:37-22:45Z. Preserved evidence lives in
`/var/lib/endo-gateway/store/vhosts-revoked-20260812/` and in the gateway journal.
dckc is the REPORTER, not an attacker; he disclosed this himself. Treat the
session as almost certainly benign exploration and the goal as bounding residue,
not building a case.

## Questions, in priority order

1. **What did he actually run, verbatim?** Recover the expressions and arguments
   to `evaluate`, `writeText`, `remove`, and the `lookup "plane"` from the
   gateway journal and any other retained record. Quote them; do not
   characterize them. If the journal retains only method names and not
   arguments, say exactly that.

2. **What persists now?** This is the one that matters. Compare the daemon's
   current state against what it should be:
   - files written or modified in the daemon's store outside normal operation
   - pet names bound or removed (`remove` and `writeText` both suggest this)
   - formulas minted, workers spawned that outlived the session
   - capabilities delegated, stored, or mailed anywhere
   - anything named `plane` or related to that lookup
   Report each finding with what it is, when it appeared, and whether it is
   reachable now. **Report; do not remove.** Removal is the maintainer's call
   and may destroy evidence.

3. **Did anything leave the box?** Network egress initiated by the daemon during
   21:04Z to containment.

4. **Did anyone else find the URLs?** Any CapTP session against either vhost
   across their lifetimes from a source address other than dckc's. Report source
   addresses and timings.

## Evidence discipline

An unauthenticated party held `evaluate` as the daemon user for ~35 minutes, so
the daemon-side logs are within reach of anyone who exploited it. For dckc that
is not a live concern. For question 4 it is: state the limitation explicitly
rather than presenting log absence as proof of absence. If any independent or
append-only record exists (CloudWatch, VPC flow logs, Caddy access logs on a
different trust boundary), prefer it and say which you used.

Where a question cannot be answered because the record does not exist, say so
explicitly. "No such record is retained" is a real finding that bounds what can
ever be known; silence is not.

## Report

Message the maintainer as soon as you know whether anything persisted, before
finishing the rest. If you find live residue that a third party could still
reach, say so immediately and state what would close it, but do not act on it
yourself.

Keep specifics off public trackers.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-12T23:02:34Z
