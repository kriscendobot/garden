In `scripts/jobs/self-heal-run.sh`, treat the offline/transient-connectivity case as a CLEAN exit so a network blip never marks a unit failed or spawns a `claude -p` responder. Two parts: (1) add `GARDEN_OFFLINE_RC` (75) to the expected/clean set alongside the existing `0/143/130/--expect` handling (around line 104-110) so a `sync_clone`-classified outage returns 0 and systemd records success; (2) as belt-and-suspenders for paths that don't return that code (e.g. a raw `ssh … git fetch` outside `journal_fetch`), grep the bounded capture tail for the connectivity signatures (`Could not resolve hostname`, `Temporary failure in name resolution`, `Could not read from remote repository`) before the throttle/responder block (line 117+) and short-circuit to a clean exit with a single `transient connectivity outage; skipping responder` log line. This eliminates the recurring fleet-wide `Failed with result 'exit-code'` noise and the wasted self-heal responder spend whenever DNS/GitHub is briefly unreachable. Add a unit test under `scripts/jobs/test/` feeding a captured offline tail and asserting no responder invocation and a clean exit.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot
  gardener: 47
  claimed_at: 2026-06-27T05:44:50Z
