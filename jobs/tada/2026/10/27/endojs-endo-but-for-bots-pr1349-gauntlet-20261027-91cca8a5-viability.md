**Viability report: endojs/endo-but-for-bots#1349** ("fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors")

**Result: proceed.** The PR is still needed and nothing has replaced it. I spent no clean, panel, fix or CI-wait budget.

**Deciding question:** Is upstream endojs/endo#3369 (lockdown fails on undeletable `caller`/`arguments` on the codec constructors) still unfixed, with no landed upstream or llm change that replaces this PR, and does the maintainer still want this PR landed?

**Evidence:**
- **PR state:** open, not merged, not a draft. Head `91cca8a551`, base `master-6ee3fda`. The latest follow-up comment (2026-10-27T18:39Z) reports all 16 checks passing on that exact head.
- **The problem is still open upstream:** endojs/endo#3369 is open. The work it builds on, endojs/endo#3322 (permit the codecs as universal intrinsics), was merged 2026-07-22, and that merge is what causes the lockdown failure.
- **No competing fix has landed:** the latest commit touching upstream `packages/ses/src/lockdown.js` is `d745d3fb4b` (2026-08-21, URL permits), and its title doesn't mention the codecs. One alternative is open upstream: endojs/endo#3371 by naugtur, which simply permits the bogus `caller`/`arguments`. It has had no activity since 2026-10-05, has no changeset and still needs review. After that, naugtur reviewed this PR (2026-10-09), and commit `b43f86c0d3` adopted their request to encapsulate only when the constructor has an own `arguments` property. This PR now carries their direction, so #3371 doesn't displace it.
- **The maintainer still wants it:** kriskowal reviewed on 2026-10-27T18:33Z: "@kriscendobot Please ferry upstream." A ferry directive is already staged at `jobs/ferry/endojs-endo-but-for-bots-pr1349.md`. Its gate is the changeset-range fix landing (that is `91cca8a551`) and an in-flight fixer landing, both with CI green.

**Follow-ups (not handled here):**
- The draft design endojs/endo-but-for-bots#1431 still describes replacing the constructors unconditionally. The PR thread says this will be updated in a separate job.
- The maintainer may want to close or reconcile upstream endojs/endo#3371 once this PR is ferried.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-91cca8a5-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (255289 cached reads)
- Output: 2037 tokens
- Cost: $0.5279818000000001
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
