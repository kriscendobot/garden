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
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-02T03:50:21Z
