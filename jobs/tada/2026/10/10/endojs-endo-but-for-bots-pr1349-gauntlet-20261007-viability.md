PR #1349 should not enter the gauntlet: the maintainer approved a competing upstream fix for the same bug on 2026-10-09. I spent no clean, panel, fix or CI budget and changed nothing.

**PR facts:** endojs/endo-but-for-bots#1349 is OPEN, not merged and not a draft. Head is `32be2c61d3`, base is the frozen `master-6ee3fda`. The PR does two things:
- adds the XS smoke tests (design test-plan item 6);
- fixes endojs/endo#3369 by wrapping `TextEncoder`/`TextDecoder` in SES-owned constructors. This fix is the PR's title.

**Deciding question:** Is wrapping the codecs (this PR) still the chosen fix for endojs/endo#3369, rather than a newer fix the maintainers now prefer?

**Answer: no.**

**Evidence:**
- **Competing upstream PR approved.** endojs/endo#3372 by danfinlay, "fix(ses): tolerate frozen null arguments/caller pills on API functions", was opened 2026-10-06. Reviews on 2026-10-09:
  - kriskowal **APPROVED** it at 21:18Z.
  - gibson042: "LGTM modulo packaging changes".
  - mhofman: "seems safe to me".
  - naugtur: "this PR is more future-proof and more strict", and "#3372 is fine with me".

  It is approved but not merged yet. Its remaining lint and release failures are packaging problems, not design ones.
- **The reviewers took the approach this PR argues against.** #1349's description argues that a tolerance check keyed on the descriptor shape is unsafe, citing mhofman. mhofman has since said on #3369 (2026-10-09T17:05Z) that "the non-writable non-configurable check in that PR seems sufficient". So the case for wrapping the codecs no longer holds with the reviewers.
- **This PR's own review threads have gone quiet.** kriskowal requested changes on 2026-10-08, and the bot answered on the same day at head `32be2c6`. naugtur's last comment (2026-10-09T11:47Z) asks for the replacement to apply only when needed, and is phrased as "if we were to pull in #1349". Since then the discussion has continued on #3372, not here.
- **The bug itself is still real until #3372 merges.** `lockdown()` still fails on Chromium before 138, and #3369 and #3371 are still open. But the fix that has momentum is #3372, not this PR.

The XS smoke-test commits (the first four, plus the zizmor pin annotation) are not displaced by #3372. If they are worth keeping, they can be cherry-picked into a test-only PR instead of putting the whole of #1349 through the gauntlet.

Option: close as superseded

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (216352 cached reads)
- Output: 3006 tokens
- Cost: $0.46119839999999995
- Wall-clock: 90s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
