---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
pr: https://github.com/endojs/endo-but-for-bots/pull/1340
fallback-tier: minion
dispatch: automatic
---

# Apply refreshed PR body to endojs/endo-but-for-bots#1340

Gauntlet fix-1 (`endojs-endo-but-for-bots-pr1340-gauntlet-fix-1`) pushed the design fixes (head 07768c3d4) but host oros-studio-garden-ce242c49's PAT cannot edit endojs PRs (403 on updatePullRequest). The panel's round-1 must-fix requires the PR body to follow `.github/PULL_REQUEST_TEMPLATE.md` and describe the landed state.

Task: write the body between the BODY markers to a file and run
`gh pr edit https://github.com/endojs/endo-but-for-bots/pull/1340 --body-file <file>`. Verify with `gh pr view 1340 --json body`. Change nothing else. Do this promptly: the gauntlet's panel-2 pre-pass checks the body.

----- BODY -----
Refs: #1339

## Description

Design for the makers the maintainer asked the agent MCP stdio server to expose, from review comment https://github.com/endojs/endo-but-for-bots/pull/1336#discussion_r4098195295: makers for confined applications from a bundle, an archive, or a virtual filesystem, with or without `node_modules` in situ, and with or without a pre-generated `compartment-map.json`. The only file is `designs/agent-confined-application-makers.md`.

- **Archives** carry original sources and a compartment map only; `makeArchive` refuses a compartment map that names a precompiled parser.
- **Bundles** keep their precompiled sources. `EndoHost.makeFromBundle` decodes the `endoZipBase64` payload into the CAS and formulates `make-archive` with precompiled parsers enabled, without bringing back the `make-bundle` formula and without re-capturing to sources.
- **Trees and mounts** keep a live reference. `makeFromTree` gains `layout` (`archive`, `node-modules-with-map`, `node-modules-scan`, `package`) and `entry`; each incarnation captures the tree to archive bytes through a new `makeTreeReadPowers` in `@endo/platform/fs`, and the worker's existing `makeArchive` runs them. A caller who wants immutability passes a snapshot.
- A tree read from a mount requires a hoisted `node_modules` layout, because pnpm workspace links and its global virtual store resolve outside the mount root.
- The guest gains `makeArchive`, `makeFromTree`, and `makeFromBundle`, bounded by its own authority (no `workerTrustedShims`, no unconfined makers, the guest's metering by default). Guests making guests is out of scope.
- `@endo/agent-mcp-stdio` projects the three makers as MCP tools, with `resultName` required because a remotable cannot cross the JSON tool boundary.

All review questions are resolved as Design Decisions 4 through 7; none remain open.

### Security Considerations

The design adds makers to the guest, so a guest can run confined code it names. Each guest maker resolves its worker and powers in the guest's own name hub, omits `workerTrustedShims`, and has no unconfined variant. `makeTreeReadPowers` rejects `..`, empty, and encoded-separator segments before any lookup, and capture reads through the tree's capability, so a map or `package.json` cannot reach a file outside the tree. Mounts already refuse any path whose physical form leaves the root.

### Scaling Considerations

Each incarnation of a tree-backed application re-reads the tree and builds archive bytes in the daemon. Large `node_modules` trees make that capture proportionally slow; a snapshot avoids nothing on capture but replays the same bytes.

### Documentation Considerations

This PR is the design document. The implementation PRs will document the new methods in `types.d.ts`, the guest help text, and the MCP tool catalog.

### Testing Considerations

This is a design; it adds no code. The design's § Test plan lists the tests the implementation must carry, including npm, hoisted pnpm, and Yarn trees on Node and XS workers, aliased-package deduplication, and confinement of `../` paths.

### Compatibility Considerations

`EndoHost.makeArchive` would newly refuse archives whose compartment map names a precompiled parser; such inputs move to `makeFromBundle`. Other changes are additions.

### Upgrade Considerations

None for this design PR. Existing `make-archive` formulas holding precompiled archives would need migration in the implementation PR that adds the refusal.

<!-- garden-job: design-agent-mcp-confined-app-makers -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
