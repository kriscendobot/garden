---
created: 2026-07-29
updated: 2026-07-29
author: designer, gardener
---

# Host requirements at claim time

## Decision

Jobs may carry an optional leading header:

```yaml
requires: aws
```

The value is a comma-separated set of opaque, lowercase tokens, for example
`requires: aws, gpu`. Tokens are deliberately not a mini-language: a future
capability with parameters gets its own stable token (such as `aws-us-east-1`) or
a later, separately designed structured format. Empty or absent `requires:` means
no host requirement and preserves the existing claim path exactly. Unknown and
malformed tokens fail closed, so a typo cannot land sensitive work on a host that
cannot do it.

## Capability discovery

The worker probes capability locally. For `aws`, its sole probe is
[`scripts/aws/verify.sh`](../scripts/aws/verify.sh), which in turn uses
`aws sts get-caller-identity`; the claim gate does not invent a second definition
of AWS access. Its result is cached only under the host-local `GARDEN_STATE`, keyed
by boot id. That keeps normal claim scans cheap. A freshly claimed job repeats the
same predicate without the cache before any handler runs, because a rotated key or
expired session can lapse between claim and execution.

We reject a journal declaration of `aws` capability. `journal2` is public; even
without the secret itself, a record saying *host X has AWS credentials* is useful
target-selection metadata. A local cache publishes neither positive nor negative
inventory, is self-correcting at boot, and the fresh post-claim probe supplies
defense in depth. The trade-off is that the leader cannot inspect a global capability
table; the watchdog below observes the safe public consequence instead.

## Claim and runtime behavior

Claim eligibility is the conjunction of the existing model/provider predicate and
the host-requirements predicate. A worker without AWS skips `requires: aws`; one
with a successful local probe may race to claim it. The gate does not reserve a job
for a particular host and does not alter the push-CAS claim protocol.

After the CAS claim, `gardener.sh` calls the same predicate fresh. On failure it
completes a concise blocked report without invoking the agent. This deliberately
retains the boatman-style post-claim precondition: the claim gate is an optimization,
not a guarantee. Boatman credential checks remain role-specific (human GitHub
identity and upstream push permission); AWS jobs receive the general shared check.

## Unclaimable work

`garden-requirements-watch` runs on the leader every five minutes. It tracks each
requirements-bearing `todo` job in private host state and, after a 15-minute dwell
by default, sends one maintainer notice naming the job and its `requires:` value if
no live worker has claimed it. The alert explicitly also admits the adjacent
operational cause — no eligible workers may be live — rather than falsely claiming
it has secret knowledge of every host. In either case the formerly silent failure is
visible and actionable. The watcher stores no capability inventory in the journal;
it only observes the public queue state and emits a throttled notice.

## Capability is not authorization

`requires:` answers “can this host currently perform the operation?” It cannot
authorize an action. `identity_switch_authorized: true` remains a maintainer-originated
authorization for the ferry's human-identity boundary. A ferry can be authorized yet
blocked on a host lacking the required capability or credentials; conversely an AWS-
capable host receives no authority merely because it passed `requires: aws`. Both
axes must pass, and role-specific authorization checks remain in force.

## Verification

`scripts/jobs/test/host-requirements-gating-test.sh` demonstrates: a host whose
canonical AWS verifier fails skips an AWS-required job while still claiming an
unheadered job; a host whose verifier succeeds claims the AWS job; a fresh
post-claim probe blocks a newly-lapsed capability; and an unclaimable opaque token
produces a maintainer alert after the dwell threshold.
