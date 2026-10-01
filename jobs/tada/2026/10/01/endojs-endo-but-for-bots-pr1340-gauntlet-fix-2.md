Fix round 2 on endojs/endo-but-for-bots#1340 is finished. I pushed commit `7fa9ac097d` to `design/agent-confined-application-makers` (it builds on `07768c3d44`), and CI came back green: `ci-wait-merge.sh --no-merge` returned 0, with 28 checks and none failed.

**Must-fix items from the panel's round-2 review:**
- **PR body (integrator, the binding template check):** I rewrote the body to follow the PR template, with every template heading in order and the invented `## Summary` section removed. It now describes the design as it stands, with the settled decisions instead of the old "four open questions" wording. The issue line changed from `Closes:` to `Refs: #1339, #1336`, so merging the design won't close the tracking issue.
- **pnpm claim (critic):** I corrected Decision 4 and the paragraph about how trees are read from a mount. `node-linker=hoisted` turns ordinary dependencies into real directories, but pnpm keeps workspace (`workspace:`/`link:`) dependencies as links under every linker setting. To make those work, the user mounts the workspace root or uses pnpm's injected-dependency setting. The test plan now expects a workspace link that points outside the mount to be rejected under both linker settings.
- **Pedant:** I rewrote phased-plan items 4 and 5 so they match items 1 to 3. I left the headings alone: all five `###` headings already use sentence case, so that finding looks mistaken.

**Comment-only items I also addressed:**
- **skeptic:** the design now lists the `endo` condition that `mapNodeModules` always adds. The Yarn test case now specifies `nodeLinker: node-modules`, and a Yarn Plug'n'Play tree is rejected.
- **decomplector:** if no layout is given, the daemon detects it again each time the application restarts. If the caller fixed a layout and the tree no longer matches it, that restart fails.
- **ergonomist:** a sentence explains why the guest and MCP tools keep the name `makeArchive` instead of `makeFromArchive`.
- **copyeditor and novice:** small wording fixes, plus a pointer from the problem statement to the table that follows it.
- **critic's out-of-scope note:** I added the design's row to the summary table in `designs/README.md`.

**Follow-ups:**
- The design still isn't fully added to `designs/README.md`. It has no milestone, dependency-graph entry or size estimate yet, all of which `designs/AGENTS.md` requires for a new design. That's a small job for a later pass.
- I didn't add the one-line host/guest reminder that novice asked for.
- Panel round 3 has not run yet; the gauntlet driver posts it next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1318235 cached reads)
- Output: 9820 tokens
- Cost: $1.135311
- Wall-clock: 2131s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
