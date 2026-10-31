The clean stage for endojs/endo-but-for-bots#1597 is done: I pushed nothing, and CI is green on head `ca6f7c53af`.

- **Starting state:** The PR was an open draft based on `llm-9a14ddf`. Two macOS test runs were still in progress when I started.
- **Coverage:** The PR is itself a coverage change. It adds `packages/agent-tools/test/git-surface-contract.test.js`, which checks that each Git access level (read-only, read/write, history-rewrite) exposes the same method list in its runtime guards, its TypeScript types and the generated declarations an agent is shown. I didn't run the tests locally. The new tests passed in CI, and I found no gaps needing more tests.
- **Dead code:** The PR orphans nothing. It removes `GIT_READONLY_MEMBERS` together with its only uses, in `code-mode-git-extract.js` and in the assertion in `code-mode-types.test.js`. The `memberFilter` option it stopped using for read-only git is still used by the read/write and history declarations.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0: all 36 checks finished with no failures.

Follow-ups: none for this stage. The panel stage comes next.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1597-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (420540 cached reads)
- Output: 2266 tokens
- Cost: $0.5361480000000001
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
