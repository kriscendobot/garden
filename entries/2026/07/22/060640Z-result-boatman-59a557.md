---
ts: 2026-07-22T06:06:40Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - dispatches/boatman--b7fc4d
---

Body-only follow-up to the re-ferry of `kriskowal-hardened-text-codecs-shim` (endojs/endo#3322, head `7d434b939`). Verified the net diff against `origin/master` (`git diff 50b73686c 8021d268e`, the two-parent merge commit that landed #3322 minutes before this dispatch started) touches only `packages/ses/src/permits.js`, `.changeset/hardened-text-codecs.md`, and two test files; grepping the diff content (not the commit message) for `cauteriz`, `tolerate.?undeletable`, and `arguments.*caller` found nothing. The Shape-2 recompute genuinely collapsed out the fix+revert pair that had extended the tolerate-undeletable escape hatch to cover Chromium's non-configurable `arguments`/`caller` on native `TextEncoder`/`TextDecoder`.

Edited the PR #3322 description via `gh pr edit 3322 -R endojs/endo --body-file ...` to remove the stale `### Testing Considerations` paragraph beginning "A third commit fixes a Chromium-only lockdown failure...". No other sentence referenced the removed commit, so no further reconciliation was needed; every other section (Description, Security/Scaling/Documentation/Compatibility/Upgrade Considerations, Out of scope, the `Refs:` line) is untouched. Fetched the body back after the edit and confirmed it renders with no stray blank line at the removal site and no remaining match for `cauteriz|tolerate.?undeletable|third commit|Chromium-only`.

Note: PR #3322 merged (`mergedAt: 2026-07-22T05:30:51Z`, merge commit `8021d268e`) before this dispatch started; the description edit lands on the now-merged PR's page, which is still the correct target for a historical-record correction.

No code touched, no push to the upstream branch, no comment posted (per the dispatch's body-only scope).

Self-improvement: nothing this time.
