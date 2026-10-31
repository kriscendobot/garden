Fix round 2 for endojs/endo-but-for-bots PR #1589 is pushed and CI is green: all 36 checks passed (`ci-wait-merge` returned rc 0).

The style pre-pass flagged two blocking findings, and I fixed both in commit `deaf3d9e2e` on `build-daemon-git-capability`. It was pushed with `safe-push-pr-head.sh --mode advance` from `fb40b59e0a`.

- **Bare `Far` stubs (prefer-endo-primitives):**
  - In `packages/fae/test/workspace-tools.test.js`, the recording remote and recording Git test doubles are now built with `makeExo`, using interface guards that skip argument and return checks (`defaultGuards: 'raw'`).
  - The recording Git used to override `__getMethodNames__`. It now has real `add`, `commit` and `reword` methods that throw if called, plus the forwarding `scope` method. The provisioner's writability check still sees the same method names.
  - In `packages/fae/test/subagent-loop.test.js`, a small `makeStub` helper (`makeExo` with raw guards) replaces the four stubs this PR added: `RecordingHost`, `RecordingGuest`, `FactoryPowers`, and the new `DriverPowers`. I left the `Far` uses that were already in the file before this PR alone. The raw guards are needed because the driver-powers stub returns a provider record containing functions, which a stricter guard would reject.
- **Abbreviated `ok` (spell-out-identifiers):** the recording remote now returns `{ success: true }`, and the matching assertion was updated.
- **Pruner advisory on `packages/agent-tools/src/types.ts:363` (non-blocking):** I kept the comment. It explains why the history-rewriting (`'rewriter'`) catalog can't be selected, which you can't tell from the code alone.

**Checks run:**
- Both probes pass on the committed range against `llm-9a14ddf`.
- `ava` on the two changed test files: 32 tests passed.
- `eslint` on the two files: no errors. Its 15 warnings are all the `safe-await-separator` rule and are not on the lines I changed.

No follow-ups. The driver posts panel-3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1073645 cached reads)
- Output: 6932 tokens
- Cost: $0.8606090000000001
- Wall-clock: 125s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
