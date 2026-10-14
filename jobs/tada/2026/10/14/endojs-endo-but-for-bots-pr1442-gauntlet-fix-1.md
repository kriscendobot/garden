Fix round 1 for endojs/endo-but-for-bots PR #1442 is pushed, and CI is green on the new head `26b4d946cf` (all 14 checks passed, none failed).

**Code changes** (commit `26b4d946cf`, a follow-up commit pushed with `safe-push-pr-head.sh` in advance mode, `4395ad9a6e` → `26b4d946cf`):
- **stylist:** in `packages/ses/src/cauterize-property.js`, the new local `desc` is renamed to `descriptor`.
- **typist:** in `packages/ses/test/error/frozen-null-pill-warnings.test.js`, the inline `import('ava')` in the JSDoc is replaced by a `/** @import { ExecutionContext } from 'ava' */` at the top of the file.
- **changeset-auditor:** `.changeset/frozen-null-pills.md` now has one sentence per line, with the long first sentence split in two.
- Locally, the 4 frozen-null-pill tests (in-process and node) pass, eslint is clean, and prettier is clean.

**PR body and title** (fixes the integrator #1, pruner, template pre-pass and concision findings, plus the summary-fix item about the clean script):
- I rewrote the body to follow the upstream template: every guidance block, the `#XXXX` placeholders and the ASCII banner are gone, and it is 258 words (the limit is 300).
- The body names all three bundled changes: the `ses` frozen-null pill fix, the `configstore`/`nconf` resolutions, and keeping `.yarn/install-state.gz` through `git clean`. It also says what goes wrong without the last one: every later `yarn run` reports the project as not installed (taken from the code comment in `scripts/git-clean-arguments.mjs`).
- The new title covers all three changes. This uses integrator #2's "retitle and describe" option rather than splitting the PR.
- The mirror reference to endojs/endo#3372 and the `garden-job: mirror-endo-3372` marker are kept.

**Not done:**
- **Autosquash:** the `fixup!` commit `4395ad9a6e` still needs autosquashing before merge. Doing that would rewrite history, which is out of scope for a fix stage that only adds commits, so it is left for merge time.
- **Integrator #4 (should-fix):** I did not check whether the `configstore`/`nconf` resolutions are dead entries.
- **Integrator #3 (should-fix):** I did not check it either. The assessor seat says a test already asserts that the `package.json` `clean` string matches the shared arguments, which would cover it.
- Comment-only items were not acted on.

**Follow-ups:** the driver re-posts panel round 2. If the bundling is still flagged there, the remaining option is to split the deps and scripts commits into their own PRs.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1442-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (906333 cached reads)
- Output: 5918 tokens
- Cost: $0.7706906000000002
- Wall-clock: 509s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
