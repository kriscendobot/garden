---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-16T06:16:49Z
---
Completed minion-town reminder compatibility store work at kriscendobot/minion.town commit e7b3b5a (pushed to main).

- Renamed the experimental shim to a digest-pinned deployment compatibility store and staged plugin source/provenance at /opt/endo/reminder-compat.
- Added shared upstream/compatibility config, write, list, remove, atomic-move, and restart conformance coverage.
- Exercised production @pins revival on throwaway guest g-reminder-revival-20260916-0612: messageCount 3 before restart, 5 after revival, then 8; cleanup confirmed; daemon remained active at f6650503.
- Verification: npm test (360 passed, 5 skipped), npm run typecheck, bash -n, git diff --check, remote main equals e7b3b5a.

Self-improvement: nothing this time.
