**Gauntlet viability: endojs/endo-but-for-bots PR #1442**

PR #1442 should go through the gauntlet: it is open, nothing has replaced it, and the bug it fixes is still present in the base code. I spent nothing on clean, panel, fix or CI-wait.

**PR facts:** the PR is OPEN, not merged, and not a draft. Title: "fix(ses): tolerate frozen null arguments/caller pills on API functions". Head is `mirror/endo-3372-ses-frozen-null-pills` @ `4395ad9a`; base is `master-356d6e7`. It mirrors endojs/endo#3372 and was created today.

**Deciding question:** Does current `master`, on either the fork or upstream endo, still lack a merged fix that lets `lockdown()` tolerate undeletable frozen-null `arguments`/`caller` on Web IDL functions? (Yes means the PR's premise still holds and nothing has replaced it.)

**Evidence:**
- **The bug is still in both bases.** `packages/ses/src/cauterize-property.js` on `master` in both endo-but-for-bots and endojs/endo only tolerates `Tolerating undeletable ${subPath} === undefined` (line 60). Neither has a frozen-null tolerance.
- **Upstream is still open, with positive review.** endojs/endo#3372 is OPEN, and the bug it fixes, issue #3369, is also OPEN.
  - kriskowal approved it.
  - gibson042 said "LGTM modulo packaging changes".
  - mhofman called the approach safe.
  - naugtur, author of the competing permits PR endojs/endo#3371, called #3372 "more future-proof and more strict". #3371 is still OPEN and not merged.
- **Nothing replaces it on the fork.** The nearest overlap is #1349 (wrap TextEncoder/TextDecoder in SES-owned constructors). It is OPEN and not merged, and it only covers the two codec classes. #1442 covers frozen-null pills on any Web IDL function.
- **The maintainer wants it pushed through.** Today kriskowal commented on #1442: "Please gauntlet, and particularly make sure to shepherd", and asked that upstream feedback be answered there. Jobs `endojs-endo-but-for-bots-pr1442-shepherd` and `endojs-endo-but-for-bots-pr1442-69bf491a` were already posted for those.

**Notes for later stages:** Upstream still has two open asks.
- kriskowal asked danfinlay why the config version pins are needed (this is the "packaging changes" gibson042 mentioned).
- Lint and release are failing upstream.

The PR's diff also includes `package.json`, `scripts/git-clean-arguments.mjs` and `scripts/pack-all.mjs`, which go beyond the SES fix. These are probably the packaging changes in question; the clean and fix stages should look at them.

No garden files changed.
<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1442-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156290 cached reads)
- Output: 1980 tokens
- Cost: $0.3789060000000001
- Wall-clock: 151s

<!-- garden-usage-end -->
