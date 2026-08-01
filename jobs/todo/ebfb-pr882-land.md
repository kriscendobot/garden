---
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-01T09:16:03Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `llm`)
PR: https://github.com/endojs/endo-but-for-bots/pull/882 (restore-xs-bootstrap-generators)

**State as of 2026-08-01T09:15Z — verify before acting, do not assume:** #882 is OPEN,
`mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`, and carries **kriskowal's APPROVED review
(2026-08-01T09:12Z)**. The earlier blocker — a stale 2026-07-28 CHANGES_REQUESTED review —
has been cleared by the maintainer. CI was reported fully green by the prior attempt.

Task: land #882. Re-verify green + mergeable on the exact head, un-draft if still draft,
merge, and post a provenance comment.

**Why this job is narrow:** the prior attempt (`ebfb-pr882-bootstrap-generators`)
deterministically overran the 2400s handler budget (rc=124 at 2401s) doing discovery,
build repair, and CI work. That work is done and the PR is green and approved; only the
landing remains. This job carries `handler-timeout: 7200` for headroom, but should finish
far inside it. If you find the remaining work is genuinely larger than "merge an approved,
green PR", STOP and report rather than expanding scope until you overrun again.

Known gap to report, not to fix here: `daemon_bootstrap.js` still stubs because
`bundle-bus-daemon-rust-xs.mjs` fails on Node-only static imports (`@endo/git`,
`@endo/host-spawner`). Also note no CI job builds the xsnap crate, which is why this
regressed silently — worth a follow-up proposal.
