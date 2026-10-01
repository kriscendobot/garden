---
handed-off: ebfb-1390-post-panel-r4-sweep4-verdict
deliverable-complete: false
---
Round 4 of the panel on PR #1390 came back **must-fix**, but the review is not on the PR yet. This host's bot token is refused when posting reviews on endojs (`Resource not accessible by personal access token (addPullRequestReview)`). I handed the posting to a successor job pinned to the endolin host.

- **Verdict:** `panel.sh` in single-round mode exited 0 with `must-fix` for head `fa544951bc` against base `llm-8e53cc0`. All 33 seats ran and none errored:
  - **Requested changes (7):** breaker, changeset-auditor, corner-prober, integrator, migrator, stylist and typist.
  - **Comment-only (12):** the rest of the non-approving seats.
  - **Approved (14).**
  - The run is recorded as `panel-runs/endojs-endo-but-for-bots-1390/b6501a8b951a.md`.
- **Must-fix items in the review:**
  1. The chat command executor splits typed names on `/` in some commands (`ls`, `show`, copy/move, the `send` recipient) but not in others (`adopt`, `resolve`, `endow`, `evaluate`). A test pins a `['dir/foo']` value the daemon always refuses, and the PR body says UI callers never split on `/`.
  2. The early name check in `makeUnconfinedFromTree` misses some bad names. `powersName: ['@bogus']`, `resultName: ['@x']` and a `resultName` long enough to push the scratch name past 255 characters all get through it and leave a scratch mount behind.
  3. lal's system prompt and primer still tell the agent to make string-name calls that the daemon now refuses.
  4. lal's `readText`, `writeText` and `editText` require `fileName` to be a string, so they cannot work against a daemon directory.
  5. In `agent-tools`, `LookupPowers.lookup` is still typed `string | string[]`, though every daemon `lookup` now takes only a path.
  6. The changeset needs three corrections: restore the dropped note about the `NameShape` and `NamePathShape` exports, explain why `NamePathArgumentShape` still accepts a string, and say how `@endo/agent-tools` changed behavior (or bump it to `minor`). It should also confirm that the `major` bumps on 0.x `agentry` and `lal`, which take them to 1.0.0, are intended.

  The review also has a should-fix section (stylist naming, `→` glyphs, the design-doc table, commit regrouping, untested edge cases) and the seven request-changes seat outputs. The body is in `/Users/dom/garden/scratch/panel-ebfb-1390-r4-review.md`.
- **Successor:** `ebfb-1390-post-panel-r4-sweep4-verdict` is in `jobs/todo` on `origin/journal2`, pinned with `requires: host=endolin-garden-ece02cb4`. It carries the review text to post word for word as a comment review, and skips posting if a round-4 sweep-4 review already exists. The post took two tries because the journal push timed out under load.
- **Follow-ups:**
  - Until the successor runs, the latest review on #1390 is still the round 6 review from the `sweep-3` gauntlet. A fix stage that runs before then will read that out-of-date verdict.
  - The earlier successor of the same kind, `ebfb-1391-post-panel-5-verdict`, is also still waiting in `jobs/todo`. That suggests endolin may not be picking up these pinned jobs.
  - The lasting fix is to give the oros-studio PAT pull-request write access on endojs.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2653838 cached reads)
- Output: 15155 tokens
- Cost: $1.5308035999999998
- Wall-clock: 4265s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
