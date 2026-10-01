# Gauntlet fix round 1: endojs/endo-but-for-bots PR #1409

The panel's must-fix items are fixed and pushed, and CI is green: all 31 checks passed with no failures.

The fix is commit `526964f492`, pushed to the head branch `bot/build/claude-broker-catalog-pruning` as a fast-forward from `32f76e4660` using `safe-push-pr-head.sh`.

**Must-fix items applied:**
- **Wrong version bump (changeset-auditor):** I raised the bump in `.changeset/agent-mcp-stdio-confined-catalog.md` from `minor` to `major`.
  - `startGuestBroker` now serves a smaller tool catalog by default, which breaks existing callers.
  - `CONTRIBUTING.md` reserves `major` for that kind of change, and this package has used `major` before (`agent-tools-mcp-adapter.md`), even though it is at 0.1.0.
- **Error wording (archivist):** I kept `tool-not-permitted` rather than replacing it with `name-scope` as the archivist asked. Both are real (the packager checked this):
  - `tool-not-permitted` is the JSON-RPC error message.
  - `name-scope` is the `error.data.reason`.

  The docs now name both, in `src/confined.js`, the package README and the changeset.

**Smaller items also applied:**
- The README now lists all 11 withheld identifier and locator tools instead of ending the list with "and kin".
- The changeset, README and `broker.js` JSDoc now say that `allowedToolNames` *replaces* the default allow-list rather than narrowing it. It is not checked against the default, so a caller can use it to serve a withheld tool again.
- The changeset now has one sentence per line.

**Not done:** I left the PR description as it is. The pruner only flagged the test-count list in it as padding, which was not a must-fix.

**For the next panel:** the locksmith noted, as a comment only, that `allowedToolNames` can widen what is served. That is now documented, but the code does not prevent it. If the maintainer wants it to only ever narrow the allow-list, the option should be intersected with the default allow-list (`confinedToolNames`) in a follow-up.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (821790 cached reads)
- Output: 5505 tokens
- Cost: $0.745042
- Wall-clock: 1599s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
