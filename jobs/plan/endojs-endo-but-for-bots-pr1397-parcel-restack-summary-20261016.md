---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin-split
priority: normal
posted_by: orchestrator
posted_at: 2026-10-16T03:54:21Z
---

---
role: shepherd
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Post the completion summary for endojs/endo-but-for-bots PR #1397

Work on https://github.com/endojs/endo-but-for-bots/pull/1397 after the serial CI
stage in orchestration
`endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin-split`
has completed. Read and follow `skills/pr-completion-summary-comment/SKILL.md`.
Inspect current remote PR state and the predecessor reports; do not rely on stale
SHAs from this body if the base/head changed during the orchestration.

Post the required PR completion summary comment. Cover the frozen base and
restacked commits, the `lookupSecretBytes` refactor, and this design-conformance
point: the base already reads OCapN coordinates with privileged `locate` from
`@endo/parcel` in `getParcelDetails` and keeps the `ocapn-sturdyref` wire tag;
the home-open path and bootstrap `fetch` lookup (`ParcelTracker.lookup`) both use
the helper, while remote opens still use peer-bootstrap `fetch`, so there is no
behavior change. Include accurate local and CI test status, and verify the PR
body names the current frozen base rather than the stale b0778fa line. Avoid a
duplicate if the required durable completion comment was already posted.

Verify the posted comment remotely. If all fleet-available work is complete and
only interactive maintainer auth is missing, use the orchestration
auth-unavailable completion signal. For another genuinely finished-but-gated
failure, use the orchestration failure signal.
