I wrote the design, opened it as draft PR #1340, filed tracking issue #1339, and commented on two related issues. The PR diff is the one design file, `designs/agent-confined-application-makers.md`, against the frozen base `llm-6726b0f` (which equals current `llm`). Its one diagram parses as valid mermaid. Nothing in it was built or tested: it is a design only.

**1. Gaps, from reading the daemon, compartment-mapper and `@endo/platform` code:**
- **Guest makers:** the guest facet has `evaluate` and `define` but no makers. Only the host has `makeArchive` (a source-only ZIP) and `makeFromTree` (a tree laid out as an archive, with `compartment-map.json` at the root).
- **Bundles and precompiled archives:** there is no daemon path. `makeBundle` was deliberately removed by `designs/daemon-make-archive.md`, although compartment-mapper's `parseArchive` and `@endo/import-bundle` can read them.
- **`node_modules` in situ, with or without a pre-generated map:** there is no daemon path. Compartment-mapper already has the pieces (`mapNodeModules`, `loadFromMap`, `captureFromMap`), but nothing turns a daemon tree or mount into the file-reading interface it needs. `designs/snapshot-mapper.md` explicitly rejects `node_modules` layouts, so no existing design covers this case.
- **`package.json` with no `node_modules`:** already designed as `makeFromPackage` in `designs/daemon-worker-import-from-mount.md`, not started, and waiting on #1027.
- **XS worker:** its bus-side `makeArchive` is still a stub, a gap that already exists and that this design does not widen.
- **Followed streams:** the fixer's tools read them in bounded pulls, but nothing pushes updates to the agent. This is a gap in the MCP layer, not the daemon.

**2. Issues:**
- New issue #1339 (https://github.com/endojs/endo-but-for-bots/issues/1339) records the gap table above and the design PR.
- #731 (parked JSON agent-tools): a comment explaining why the MCP maker tools require a `resultName`.
- #1027 (registry convergence): a comment noting that the `package.json`-only case still depends on it.
- No existing issue covered the makers, which is why I filed a new one.

**3. The design (PR #1340, https://github.com/endojs/endo-but-for-bots/pull/1340):**
- **Core idea:** every new input (a bundle, a precompiled archive, or a `node_modules` tree with or without a map) is converted into a source-only archive and stored in the daemon's content store. The existing `make-archive` step then runs it, so no new worker method or record type is needed.
- **Reading trees:** a new `makeTreeReadPowers` in `@endo/platform/fs` gives compartment-mapper read access to a tree, and refuses any path that points outside it.
- **Host changes:** `makeFromBundle` (without restoring `makeBundle`), plus `layout` and `entry` options on `makeFromTree`.
- **Guest makers:** limited to the guest's own authority. They drop the `workerTrustedShims` option (it runs code outside confinement), and guests get no unconfined makers.
- **MCP tools:** `makeArchive`, `makeFromTree` and `makeFromBundle`, with `resultName` required because the made object cannot pass through a JSON tool call.
- **Four open questions for you:**
  - Should pnpm's symlinked stores be followed?
  - Should precompiled inputs be converted back to source?
  - Should a tree stay live or be snapshotted when the application is made?
  - Should guests get makers at all?

**Follow-up job:** I posted `design-agent-mcp-follower-push` (a designer job) to design pushing followed-stream updates over MCP. The board filed it under the same source as the review comment (#1336, comment 4098195295), so check it wasn't merged into another job for that comment.

**Notes:**
- The fixer job `endojs-endo-but-for-bots-pr1336-fix-review-5307103246` was still in progress while I worked, and hadn't posted its gap list. I worked the gaps out from its pushed commit `7d3cf4eb7f` and the daemon source.
- PR #1340 is a draft and no review panel has been started; say **run the gauntlet #1340** when you want one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-agent-mcp-confined-app-makers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2583842 cached reads)
- Output: 22759 tokens
- Cost: $1.7531564000000002
- Wall-clock: 335s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
