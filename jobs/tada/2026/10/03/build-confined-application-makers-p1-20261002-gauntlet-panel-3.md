Round-3 panel for endojs/endo-but-for-bots#1417 came back **must-fix**, and the verdict is posted on the PR.

**Panel run**
- I reviewed head `608cafdbcf` in an isolated checkout of `endojs/llm-confined-application-makers-p1`. The base was the PR's actual base commit `e4fcd7b234` (`llm-e4fcd7b`), not a possibly stale `origin/` ref.
- `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with disposition **must-fix**. All 33 seats returned a verdict with no errors: 2 request-changes (integrator, pruner), 13 comment-only and 18 approve.
- The must-fix comes from the PR description, not the code. The template check found the PR body nonconforming, which forces must-fix. No seat raised a must-fix against the code this round.

**Review posted**
GitHub refused a request-changes review because the bot can't request changes on its own PR. I posted it as a COMMENTED review starting "Panel verdict — round 3: MUST-FIX", submitted 2026-10-03T16:53:52Z. That is the same shape as the round 1 and 2 verdicts. The full 78 KB set of seat reviews is over GitHub's size limit for a review, so I posted a 4.4 KB summary that keeps every must-fix and should-fix finding:
- **Must-fix:**
  - The PR body is missing two template headings, Scaling Considerations and Documentation Considerations.
  - The PR body is too long: 375 words against a 300-word limit, with file bullets that each start with a code span.
- **Should-fix (to fold into the fix round):**
  - The follow-up `isAbsent` check can hide the original lookup error.
  - The default `canonical` treats different spellings of one location as different locations.
  - The commits need regrouping: one adds an export that a later one removes.
  - The design doc's signature for `canonical` disagrees with the code.
  - The segment check duplicates the existing `assertChildName` helper.
  - "File or directory" is decided two different ways.
  - A lone surrogate throws a raw `URIError`.
  - `assertRoot` doesn't check percent-escapes.
  - The path encoding matches one Node version while the package declares a wider engine range.

I did not fix anything or un-draft the PR; that belongs to the next stage. Nothing was committed to the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 28 tokens (782759 cached reads)
- Output: 5685 tokens
- Cost: $0.8023638000000002
- Wall-clock: 402s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
