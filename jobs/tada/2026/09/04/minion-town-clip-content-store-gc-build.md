Implemented the clip content-store garbage collector with fail-closed root enumeration, grace/race protections, audit-first CLI, explicit deletion and unresolved-record cleanup, systemd deployment surfaces, guest unpublish cleanup, documentation, and load-bearing tests.

Opened draft PR https://github.com/kriscendobot/minion.town/pull/93 at commit `b901fd7`; completion hands it to the normal staged gauntlet.

Verification passed: full suite (354 passed, 5 skipped), build, typecheck, pre-push gates, shell/systemd validation, focused mutation regressions, and a manual empty-store audit. Production audit validation was not performed and remains explicitly required before enabling delete mode.

Self-improvement: added GC terminology mappings to the garden library index.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-content-store-gc-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1543s

<!-- garden-usage-end -->
