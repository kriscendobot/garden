Implemented and opened draft PR: https://github.com/kriscendobot/minion.town/pull/165

- Added opt-in, per-guest pinned Claude responders with restart-stable agent capabilities, mailbox-number deduplication, idempotent effects, and dismissal.
- Added durable responder configuration and deterministic server-side effect storage.
- Added unit, restart-wiring, and pinned-Endo daemon integration tests.
- Verified build, quality gates, 844 tests, pinned-daemon restart behavior, and all three GitHub checks.
- Known unrelated limitation: 19 existing Caddy environment-sync tests fail locally due to command-stub interception; affected files were untouched.
- Recorded a project note about Endo’s passable-reader protocol and unpublished `@endo/exo-stream` boundary.

Follow-up: PR remains draft for panel review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-pinned-responder.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2703s

<!-- garden-usage-end -->
