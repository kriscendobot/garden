---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
MAINTAINER AUTHORIZATION GRANTED (kriskowal, via liaison muster 2026-09-16) for
the minion.town @endo/reminder daemon redeploy — WITH the state-revival dry-run
you recommended, not a bare redeploy.

This job resumes the work reported by `minion-town-reminders-daemon-redeploy-
unblock` (maintainer-inbox message 20260904T063018Z-6a1c2e, 2026-09-04). Re-verify
its premises before acting; they are ~2 weeks old.

Verified then, to be re-confirmed now:
- Live daemon pin /opt/endo/ENDO_COMMIT = f6650503 (active, socket present).
- The design's byte-identical claim HOLDS: packages/daemon/src/client.js
  (0859aeab) and mail.js (6ef7c33b) are identical at f6650503 and 0eb88836. The
  app's ported CapTP client is protocol-safe for the bump. Recorded in
  designs/endo-reminder-minion-town.md §8 (minion.town main 89904a9).
- So §7's "stop and report if the claim no longer holds" abort is NOT triggered.

THE RISK THAT SHAPES THIS AUTHORIZATION (the reporting gardener's own finding,
which §7 did not weigh): client.js byte-identity covers only the WIRE protocol.
Across the 1317-commit gap the daemon's PERSISTENCE layer changed heavily
(+7733/-1090 across 60 files: manager-database.js, manager.js, formula-record.js,
mount.js reconciliation, new registry.js/secret-manager.js). Wire compatibility
is therefore NOT evidence of state compatibility.

REQUIRED ORDER:
1. Re-confirm the pin and the byte-identity claim still hold. If either has
   moved, STOP and report rather than improvising.
2. Run the state-revival DRY-RUN first: exercise revival of the live daemon's
   persisted state against 0eb88836 WITHOUT mutating the live store (work from a
   copy/snapshot). Report exactly what revives and what does not.
3. Proceed to the redeploy ONLY if the dry-run is clean. If it is not clean,
   STOP and report the specific revival failures to the maintainer inbox — do
   not attempt a migration on your own judgment.
4. Capture a restorable snapshot of the live state before any mutating step.

handler-timeout: 7200
