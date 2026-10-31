Viability verdict for endojs/endo-but-for-bots#1117: **proceed**. The gauntlet may begin.

**Deciding question:** Does the current `llm` branch still lack a directory-tree `@registry` and still expose the old `EndoRegistry` method surface, with no other PR having delivered the approved design?

Yes, on every point.

**Evidence:**
- **The PR is still live.** It is open, unmerged, a draft, and `MERGEABLE`. It was woven at 2026-10-31T02:37Z onto the frozen base `llm-9a14ddf` (`9a14ddf660…`), and that base matches current `llm` exactly (0 commits ahead, 0 behind). The current head is `2d958113dc7c…`.
- **The implementation is not on `llm`.** `packages/exo-npm/src/registry-tree.js` and `registry-tree-resolver.js` don't exist there. The `llm` copy of `packages/daemon/src/manager.js` still imports `makeEndoRegistry` / `makeRegistryTable` from `./registry.js`, which is the old method surface this PR replaces.
- **The design is still unimplemented.** It was approved in #1083 (merged 2026-08-31), and `designs/npm-registry-as-directory-tree.md` on `llm` still says **Status: Not Started**.
- **Nothing else delivered it.** A search of registry PRs found no other implementation. The related merged PRs are different work:
  - #1329 migrates persisted hosts that are missing a `registry`.
  - #1362 is the npm-registry-server for staged releases.
  - #892 and #862 are Endor registry-proxy design and CLI.
- **No review from anyone outside the bot.** All reviews are automated panel rounds 1–5 with must-fix findings, answered by fix-loop rounds. There is no comment from the maintainer or anyone else saying to close it or that it has been superseded.

**Note for the panel:** the PR body says older daemons must be re-initialized because `@registry` becomes required. `llm` now has #1329, which migrates persisted hosts that are missing a `registry`. The panel should check that the woven head keeps that migration and that the upgrade note is updated to match. This doesn't block the gauntlet.

I changed nothing: no clean, panel, fix or CI spending, and no garden commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1117-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (246527 cached reads)
- Output: 2189 tokens
- Cost: $0.5003253999999999
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
