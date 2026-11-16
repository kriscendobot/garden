Both roadmap docs now match `llm`, and the draft docs PR is open as endojs/endo-but-for-bots#1668. One CI check is red: `zizmor` fails.

The precondition is met: #1641 merged on `llm` at 07:47Z. A prior attempt had already committed the doc edits and opened #1668 as a draft, based on the frozen base `llm-b27c354`. I adopted that PR instead of opening a second one.

In the earlier edits, `designs/daemon-git-next-steps.md` and `designs/daemon-agent-tools.md` record the `diff` and `stashPush` path resolution through the mount. They also record the `diff` tool schema that now documents `cached`, `base`, `head` and `paths`.

I added one fix, pushed as `8ff2787a76`. `designs/daemon-agent-tools.md` § Phase 3.5 still said `makeGitMountTools` ships `status`, `add` and `checkoutConflict`. The code in `packages/agent-tools/src/json-tools/git-mount.js` returns only `status`, so the doc now says that. It also says the path-string forms of `add` and `checkoutConflict` belong to the `makeGitTool` catalog.

I did not look at the `zizmor` failure beyond seeing that it failed. The PR only touches `designs/*.md`, so it is probably the known floating-tag drift on untouched workflows, which is not caused by this PR. CI on the new commit hasn't run or been checked.

Follow-up: a maintainer needs to review #1668 and un-draft it. The `zizmor` failure is worth a separate look.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-daemon-git-agent-tool-adapters-docs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (2 unmetered)
- Input: 48 tokens (1338304 cached reads)
- Output: 6523 tokens
- Cost: $1.433286 (2 engagement(s) unpriced)
- Wall-clock: 607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
