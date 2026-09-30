---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: gardener
split_source_handler_timeout: 2400
split_orchestration: fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-09-30T03:43:05Z
---

# Deliberate overrun decomposition for `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-split`, then record `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-split` with `post-orchestration.sh`.
- **Indivisible:** record a concrete `split-indivisible-reason:` in both the child body and orchestration description, choose a `handler-timeout:` strictly greater than 2400 and no greater than 14339, record that value as `split-indivisible-handler-timeout:` in the orchestration description, park exactly one child (normally `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-expanded-window`) under `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-split`, then record the single-child orchestration. A generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Containment drift check for kriscendobot/minion.town gateway records

RETUNED 2026-09-02 (maintainer decision, muster). Two defects in the previous
version are corrected here; read both before changing this check again.

## What to verify

The two records de-registered by `minion-town-containment-gateway-endo-sock`
(`f1d754fc…`, `fe0a8e60…`), plus the third de-registered on 2026-08-31
(`09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f`), must
remain ABSENT from the live active store, and no OTHER unexpected active
dckc-owned record may be present.

**SCAN RECURSIVELY.** The live vhost store is
`/var/lib/endo-gateway/store/vhosts/` — a SUBDIRECTORY. The previous version of
this check used a ROOT-ONLY glob and therefore could not see active records at
all. On 2026-08-30 and 2026-08-31 it reported "no change" on two consecutive
daily ticks while an exposed dckc-owned record (`09201a3162…`, powers value
exposed, public bootstrap returning HTTP 404) sat active in that subdirectory.
It was found only because a separate job scanned recursively. A root-only scan
here manufactures false confidence; it is worse than no check.

Use a whitespace-tolerant match, as the 2026-08-25 check did — that is how the
third record was distinguished in the first place.

## What NOT to verify

Do **NOT** assert that the systemd containment drop-in is in place. The previous
version did, and that assertion now INVERTS: the maintainer deliberately opened
the weblet powers plane on 2026-08-27 under `kriscendobot/minion.town` issue #58.
The drop-in is renamed `…disabled-issue58`, the powers plane is ENABLED in the
live process (`GATEWAY_ENDO_SOCK` present; boot log "powers plane : ENABLED"),
and that state correctly survives restarts. Containment being OPEN is the
authorized state, not drift. Do not alarm on it and do not re-arm it.

## Why the record check still matters

A CD gateway redeploy leaves configuration intact but CAN restore the
de-registered records. That risk is unchanged by the containment opening — which
is precisely why this half of the check is retained while the other half is not.

## On a reappearance

Re-run the de-registration exactly as recorded in the originating job's report
(move the record to the revoked store), prove the recursive active-store scan
comes back clean afterward, and report the recurrence to the maintainer inbox.

## Reporting

Report no-change QUIETLY. Report any reappearance, any unexpected active
dckc-owned record, or any inability to complete the recursive scan to the
maintainer inbox — an inability to scan is itself a finding, not a quiet pass.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T04:30:49Z
