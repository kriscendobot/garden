---
role: fixer
priority: urgent
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: the container-hardening probe's EXPECTED failure blocks rolling deploys and drains followers

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).

## Observed (2026-09-24 06:44Z)
The leader's rolling deploy drained the follower endolin-garden2-5bcdff64:
`op: drain … reason: rolling-deploy: canary FAILED validation, retry 0/3 pending (1 failed unit(s) (first: garden-container-hardening.service))`.
The unit failed because `scripts/check-container-hardening.sh` (from 3d453e30784) correctly reports that this
container has NOT yet been recreated with the hardened launcher flags: sudo works, host block devices
are visible. That is the KNOWN, expected state until each host is recreated per
`context/operations/harden-container.md`. The recreate is a deliberate maintainer step that has not happened
on either host. The service runs through `self-heal-run.sh --expect 2`, so exit 1 marks the unit failed,
and the canary unit-health check treats any failed `garden-*` unit as a failed canary. The result: every
deploy canary fails and drains its host until the containers are recreated, twice a day. The liaison
cleared it with `systemctl --user reset-failed garden-container-hardening.service` as a stopgap.

## Ask
1. Separate "not yet recreated" (known, and already announced to the maintainer) from "hardening
   REGRESSED" (a container that was recreated hardened and later lost it). For example: record a per-host
   marker when a hardened recreate is first verified. Before that marker exists, the probe reports through ONE
   coalesced `watchdog-notice.sh` notice (pending recreate) and exits cleanly. After it, any failure is a real
   regression and fails loudly.
2. Independently, make the rolling-deploy canary unit-health check ignore advisory, periodic probe units
   (container-hardening and any similar posture checks) or classify them. Their failure is not
   a deploy regression and must never drain a host. Keep the check strict for real service units.
3. Tests: an unrecreated host does not fail its unit and does not fail the canary; a regressed hardened host
   does fail loudly; a real service unit failure still fails the canary. Run the rolling-deploy and
   hardening-probe suites and push. Complete via the normal completion path.

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T06:46:15Z
