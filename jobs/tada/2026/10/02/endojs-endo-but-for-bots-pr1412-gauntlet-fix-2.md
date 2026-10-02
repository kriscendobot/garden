I applied the round-2 panel fixes to endojs/endo-but-for-bots#1412 and pushed them. CI is green on the new head `ee861f9bea`: 33 checks, none failed. One fix, the orthographer's spelling change, had to be reverted to get lint passing.

**Fixes pushed** (follow-up commits via `safe-push-pr-head.sh`, never rewinding the head):
- **curator (must-fix):** the two argv builders, `buildArgv` and `buildCliArguments`, now share one helper, `buildConfinementFlags` in `packages/claude/src/argv.js`. A change to the confinement flags now lands in one place. `buildArgv`'s output is unchanged.
- **warden:** `buildSdkOptions` now gives the SDK a fresh copy of the frozen environment, as the CLI backend already does. I left the options record itself unhardened on purpose: `harden` would also freeze the MCP server instance and the abort controller, which the SDK still has to drive. A code comment explains this.
- **breaker:** a message id now continues a turn only while that message is in progress. If an id reappears after a different message, it counts as a new turn, so a replayed id can't get around `maxTurns`. I added a test and updated the type doc.
- **purist:** `@endo/inference` now counts output bytes with `encodeUtf8(...).length` from `@endo/utf8` instead of its own counter. I added the dependency, regenerated `tsconfig.composite.json`, and put the `yarn.lock` change in its own `chore: Update yarn.lock` commit.
- **packager #2:** `@endo/inference` now has the `prepack`/`postpack` scripts that build the types its `./types.js` subpath points to.
- **pruner / coverage-auditor:** I trimmed the PR body: removed the Scaling, Documentation and Upgrade sections and the test count, and cut Security down to the new information. I added a "Platform scope" note saying both packages are Node-only and `test:xs` is a stub on purpose.

**Not applied:**
- **orthographer:** I changed `acknowledgement` to `acknowledgment`, but CI lint failed. It requires every package's `SECURITY.md` to match `packages/skel/SECURITY.md` exactly, so I restored the template text and said so in a PR comment. The spelling can only change in skel and all its copies.
- **packager #1:** I left this as is. `@endo/claude` already exists on the base `llm-80054c3` at `0.0.0` with an unreleased `major` changeset. Changesets combines that with this PR's `minor` into a major bump, so the first publish is still `1.0.0`.

Locally, before pushing: the claude tests (135) and inference tests (48) passed, along with tsc, eslint (0 errors) and prettier for both packages. Two PR comments on #1412 list each finding and what was done about it. I did not change the comment-only items: the dead top-level `"types"` field in `@endo/inference`, the logging for bare `catch {}` in cleanup, and the README subpath table.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3801547 cached reads)
- Output: 16727 tokens
- Cost: $1.9217534
- Wall-clock: 4269s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
