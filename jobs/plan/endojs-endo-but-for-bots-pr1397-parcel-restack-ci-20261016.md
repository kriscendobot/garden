---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin-split
priority: normal
posted_by: orchestrator
posted_at: 2026-10-16T03:54:10Z
---

---
role: shepherd
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Drive endojs/endo-but-for-bots PR #1397 CI green

Work on https://github.com/endojs/endo-but-for-bots/pull/1397 after the metadata
stage of orchestration
`endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin-split`
has completed. Read the current PR base/head from GitHub; do not assume an old
SHA if the predecessor had to re-weave it.

Drive all required CI checks green. If no runs start after the base move,
retrigger them safely (closing/reopening the PR is an allowed option). Diagnose
failures and fix only failures attributable to #1397, using this job's isolated
project checkout and lease-safe pushes. Re-run proportionate local validation
for any project change and wait for the resulting remote checks in the
foreground. The previous head's unrelated failures were Prettier findings in
pass-style/patterns outside #1397 and a flaky macOS daemon
`provider-listener-runtime` PID-replacement timeout; do not fold unrelated
changes into this PR merely to mask them. Existing evidence from head 8f3d801:
`packages/ocapn` `yarn test` passed 546 tests (28 skipped), `yarn lint` had zero
errors, and touched files were Prettier-clean.

Report the final head, required-check status, reruns, and any fixes. If all
fleet-available validation is complete and only interactive maintainer auth is
missing, use the orchestration auth-unavailable completion signal. If the gated
green outcome genuinely cannot be achieved for another reason, use the
orchestration failure signal.
