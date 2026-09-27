from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-27T17:16:48Z
doom_base: review-improve-cross-platform-test-coverage
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-27T17:16:48Z
last_seen: 2026-09-27T17:16:48Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/review-improve-cross-platform-test-coverage; it stays HELD until a human promotes it
(promote-plan.sh review-improve-cross-platform-test-coverage) or removes it, so nothing is lost.
Original job base: review-improve-cross-platform-test-coverage

--- original job body ---
---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# review-improve-cross-platform-test-coverage

role: builder

Review-retrospective improvement job (skill `skills/review-retrospective/SKILL.md` § 5)
for the review-miss cluster `cross-platform-test-coverage` (journal2:
`review-misses/clusters/cross-platform-test-coverage.md`), which crossed the floor
(3 misses over 3 distinct PRs). Pattern: a multi-platform package or export arm
(`xs`/`endor`/`browser` condition) ships without tests that actually run on that
platform — or with tests encoding one engine's assumptions — and review did not require it.

Members (read each record under `review-misses/misses/`):
1. `endojs-endo-but-for-bots-pr836-review-eda700a0` — endojs/endo-but-for-bots#836:
   `@endo/sha256` shipped without CI-exercised `test:xs`/`test:endor` variants and
   an unconfirmed browser fallback path. missed_by coverage-auditor.
2. `endojs-endo-but-for-bots-pr475-54294cd3` — #475: tests in immutable-arraybuffer/
   bytes asserted shim-only shapes that pass only because Node lacks native support
   and `test:xs` is an `exit 0` stub. missed_by engine-realist.
3. `endojs-endo-but-for-bots-pr1290-review-fe19b903` — #1290: new `@endo/sha256/async`
   `browser` arm (WebCrypto) tested only via Node-side spies; maintainer asked for a
   top-level `browser-test/` Playwright case that bundles via compartment mapper under
   the `browser` condition. No panel ran (builder draft); producer builder.

Two-part contract — BOTH mandatory:

(a) Prevention. Amend the narrowest producing artifact (builder brief and/or a
skill such as `skills/node-parity-test/SKILL.md` or `skills/coverage-driven-testing/
SKILL.md`, and the endo context-library page if one covers testing) with a rule:
when a change adds or alters a platform-conditional arm (`browser`, `xs`, `endor`,
... in package.json `exports`/`imports` conditions, or a `test:xs` stub), the change
carries a test that executes on that platform — for endo-but-for-bots `browser`,
a case in the top-level `browser-test/` Playwright suite bundled through the
compartment mapper with the `browser` condition; for `xs`/`endor`, a real (non-stub)
`test:xs`/`test:endor` run — or states explicitly in the PR body why it cannot.
Tests must not assert shim-only shapes without a native-detection guard.

(b) Sensing. Preferably a panel-hints probe (`skills/panel-hints/probes/`, per the
"Adding a probe" convention, probe + seat-line change in the SAME commit) that fires
`coverage-auditor` (and `engine-realist` for xs/native-shim signals) when the diff
adds/changes a non-`node`/`default` condition key in a package.json exports map, adds
a `*-browser*`/`*-xs*`/`*-endor*` source file, or touches a `test:xs` script that is
an `exit 0` stub; plus an explicit check line in `roles/jurors/coverage-auditor/AGENT.md`
(and engine-realist if touched). Err toward firing.

Re-litigation test: for each of the 3 members, name the check that would now catch
it and demonstrate the probe fires on that PR's historical diff (#836, #475, #1290;
fetch via `gh pr diff`). Then close the cluster:
`scripts/jobs/review-miss-record.sh cluster-status cross-platform-test-coverage closed --improved-by "<commits/files>"`.
Garden edits land directly on main2 (no PR).
