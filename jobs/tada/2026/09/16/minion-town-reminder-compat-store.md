Implemented and pushed commit `e7b3b5a` to `kriscendobot/minion.town` main.

- Promoted the experimental shim into a digest-pinned compatibility store with staged provenance for the plugin, adapter, and deployed daemon.
- Added upstream/compatibility conformance coverage for config, write, list, remove, restart, identical JSON layout, and atomic write-then-move behavior.
- Staged the artifact at `/opt/endo/reminder-compat`.
- Proved `@pins` revival on a throwaway production guest: message count advanced 3 → 5 across restart, then to 8 afterward.
- Confirmed cleanup, active daemon/socket, and unchanged daemon pin `f6650503`.
- Verification: 360 tests passed, 5 optional integration tests skipped; typecheck, shell syntax, and diff checks passed.

Follow-ups: none for this job. Any future daemon migration remains separately authorized work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-reminder-compat-store.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 812s

<!-- garden-usage-end -->
