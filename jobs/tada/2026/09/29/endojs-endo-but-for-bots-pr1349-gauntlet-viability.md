I checked endojs/endo-but-for-bots PR #1349 and it should go ahead: nothing has replaced it and the reason for it still holds. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** The PR is open, still a draft and unmerged: "test(ses): XS smoke check for hardened TextEncoder/TextDecoder". Its head is `build/hardened-text-codecs-shim` at `d98467c6`, and its base is the frozen snapshot `master-6ee3fda`. It has no reviews or comments yet.

**Deciding question:** Does current `master` still lack an XS-runner (`packages/ses/test/_xs.js`) check that compartments see the host's `TextEncoder`/`TextDecoder`, or their absence, hardened after `lockdown()`, while the Phase 1 permits it tests are still on `master`? The answer is yes.

**Evidence:**
- `master` is still at `6ee3fda77bf2`, the PR's own base, and a compare shows it 0 commits ahead of that base. So `master` has had no newer changes to `_xs.js` or `ci.yml`.
- `packages/ses/test/_xs.js` on `master` has no `TextEncoder`/`TextDecoder` references, so the XS smoke check the design asks for (test-plan item 6) is still missing.
- `packages/ses/src/permits.js` on `master` still lists `TextEncoder`/`TextDecoder` as universal intrinsics, with their prototype permits. The thing the new test checks is still there.
- A PR search turned up no other open or merged PR that adds this XS codec check. The older #259 (the permits PR) is closed; the permits themselves reached `master` through upstream endojs/endo#3322.
- The diff is small: 25 lines added to `_xs.js`, plus a one-line comment change in `ci.yml` (`# v3` → `# v3.0.3` on the paths-filter pin). That `ci.yml` line is unrelated to the PR's purpose, so the panel should look at it.

No garden files were changed and nothing was committed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 8 tokens (235009 cached reads)
- Output: 1603 tokens
- Cost: $0.6222538
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
