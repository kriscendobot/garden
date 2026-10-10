RED on the zizmor gate: environmental pin-comment drift outside this PR's diff (details below).

<<<GARDEN-ORCHESTRATION-FAILED>>>

# Fix round 2 for endojs/endo-but-for-bots#346: CI red on `zizmor`, PR body edit handed off

The panel's one must-fix is not applied yet: this host's bot token gets a 403 when it tries to edit the PR body. I posted a job pinned to an endolin host to make that edit. CI on the new head is red, but only on the `zizmor` workflow-audit check, which looks at a file this PR doesn't touch.

**Panel round 2 (review 5479384785).** The only must-fix (template pre-pass plus the integrator seat) is to put the six PR-template "Considerations" headings back in the PR body. Every other seat was comment-only or should-fix.

**PR body (the must-fix): not applied from this host.**
- I wrote a new body that keeps Description and adds Security, Scaling, Documentation, Testing, Compatibility and Upgrade Considerations, each with real content.
- `gh pr edit` and a REST `PATCH` on `pulls/346` both returned 403 "Resource not accessible by personal access token". This is the known missing PR-write permission on oros-studio.
- I posted job `endojs-endo-but-for-bots-pr346-gauntlet-20261007-fix-2-body` with `requires: host=endolin-garden-ece02cb4`. It carries the exact body text and its only task is to apply it.
- Until that job runs, the body is still nonconforming, and panel-3 will flag it again if it runs first.

**Code (integrator should-fix): pushed.** I renamed `.changeset/bundle-source-aliased-exports.md` to `.changeset/compartment-mapper-aliased-exports.md` so the file name matches the package it bumps. It went up as follow-up commit `1c1e37da2` through `safe-push-pr-head.sh` (advance: `6f11231cc` → `1c1e37da2`).
- I did not squash the earlier chore commit (the integrator's other should-fix), because that rewrites history.
- I did not take the comment-only suggestions (a direct `compartment-mapper` unit test, `q()`-quoting export names).

**CI: `ci-wait-merge.sh` exited rc=3 (RED).** 15 checks, 14 green (CI, lint, all test matrices, cover, build, viable-release). The one failure:
- **Failing check:** `zizmor` reports a warning at `ci.yml:279`: "action's hash pin has mismatched or missing version comment: points to commit 0e4a8c6effa4".
- **Not from this PR:** the diff only touches the changeset, `bundle-mjs.js` and `export-alias.test.js`. On the previous head (`6f11231`) the same audit passed earlier today.
- **Likely cause:**
  - `ci.yml` pins `dorny/paths-filter@d1c1ffe… # v3`, but the `v3` tag was moved on 2026-08-05 and now points to `0e4a8c6effa4`.
  - The zizmor run pulled a newer image (v1.24.1), which probably started enforcing this check.
  - Other branches (`mirror/3047-readmes`, `mirror/3047-abbreviations-style`) are failing `zizmor` too.
- **Fix:** update that pin or its version comment on the base (`master-46d4edf`) or upstream, not in this PR. I made no change for it.

No stage-result marker: none of the three applies to a red CI result.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr346-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1765156 cached reads)
- Output: 10344 tokens
- Cost: $1.0813112000000002
- Wall-clock: 1382s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
