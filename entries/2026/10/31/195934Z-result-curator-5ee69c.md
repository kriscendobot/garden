---
kind: result
role: curator
host: endolin-garden-ece02cb4
at: 2026-10-31T19:59:37Z
---
Originating dispatch: user-requested curator review of endojs/endo-but-for-bots
PR #1504, restricted to `9a14ddf660912ed624e2d9047671d43e3a2f0cec...HEAD`
in worktree `project-wt-shepher-8ec8072bc8d9-06cc0143`.

**Verdict:** request-changes

**Findings:**

- must-fix: `@endo/agent-tools` has an additive public result-shape change: its exported code-mode declaration now requires `ShellInspectResult.engine` at `packages/agent-tools/generated/code-mode-globals/shell-declarations.js:33`, but `.changeset/shell-sandbox-engine.md:4` assigns only a `patch` release. Reclassify this package as `minor` so consumers can discover the new `Shell.inspect()` field through the appropriate feature release. [rule: roles/jurors/curator/AGENT.md]
- must-fix: The PR extends the same cross-package `ShellPolicy` option bag independently in `packages/exo-shell/src/types.ts:1` and `packages/daemon/src/types.d.ts:371`. Choose one canonical type home and re-export it from the other package; otherwise subsequent policy fields can silently diverge at the `provideShell` to `makeShell` boundary. [rule: roles/jurors/curator/AGENT.md]
- must-fix: The new `maxOutputBytes` spawner option is independently declared in the inline `Spawner` options at `packages/exo-shell/src/types.ts:42` and `SpawnerOpts` at `packages/host-spawner/src/types.ts:3`. Canonicalize and re-export this cross-package call-boundary type as well. [rule: roles/jurors/curator/AGENT.md]

Self-improvement: nothing this time.
