Job complete. PR #618 is an open DRAFT based on `llm`; inbox is empty.

## Completion report

**Task:** daemon-agent-tools Phase 4 (Integration and discovery) in `endojs/endo-but-for-bots` — wire the Phase 1/2/3 tool makers into live Lal/Fae dynamic tool discovery and extend form-based provisioning with capability configuration.

**Result:** Opened **DRAFT PR #618** (`builder/daemon-agent-tools-phase4-integration` → `llm`).

### What I did
1. **Built the integration stack.** The three phase PRs (#614/#615/#616) each based independently on `llm`, not stacked. I cherry-picked them into a clean linear stack (llm → Phase 1 → Phase 2 → Phase 3), resolving union merge-conflicts in the agent-tools re-export files (`index.js`/`index.d.ts`/`types-index.*`), `types.ts`, and `package.json` exports.

2. **Discovery primitive** (`@endo/agent-tools/src/discover.js`): `discoverCapabilityTools(powers, opts)` looks up the well-known pet names (`fs`/`shell`/`git`) in an agent's namespace and returns the `ToolRecord`s each *granted* capability backs — mount→`Filesystem` via `mountAsFilesystem` then `makeMountFsTools`; `makeShellTool`; `makeGitTool` + `makeGitMountTools`. Missing name → no tools (the discovery signal). Exported through the index + package.json; hand-authored `.d.ts` force-added per the repo's `*.d.ts` ignore convention.

3. **Fae** (`src/capability-tools.js` + `agent.js`): adapts `ToolRecord`→Fae's `{schema,execute,help}` shape; `spawnWorkerLoop` runs discovery at startup, filling the former `// no filesystem tools for guest` gap.

4. **Lal** (`agent.js`): `spawnWorkerLoop` discovers the same tools, bridges via `toPiAgentTool` (static names win). The provisioning form gains `projectPath` + `capabilities` fields; on submit the manager mints one writable project mount and grants `fs`/`git`/`shell` into the new guest under the canonical names (following the existing `provisionPrimer` identify+storeIdentifier pattern), with a bounded default Shell policy.

### Verified by execution (in the worktree)
- `@endo/agent-tools`: `tsc` clean, eslint 0 errors, **84 tests pass** (Phase 1/3 suites + 7 new discovery tests).
- `@endo/fae`: eslint 0 errors, **48 pass / 2 known-failures** (pre-existing), 5 new adapter tests pass.
- `@endo/lal`: eslint 0 errors, **34 pass / 1 skip**.
- Lal `tsc`: only pre-existing third-party `.store` type-resolution errors — **identical count (12) with and without my change** (confirmed by stash), and `agent.js` is `@ts-nocheck`, so Phase 4 adds zero type errors.
- Test binaries had to be invoked via `node <ava-cli>` because the sandbox blocks executing `node_modules/.bin` shims (also why `better-sqlite3`'s native build fails — environmental, unrelated to these packages).

### Not verified / follow-ups
- **No live daemon end-to-end run** of the form-provisioning grant path (mint mount → `provideGit`/`provideShell` → `storeIdentifier` into guest → guest startup discovery registers tools). It follows established interfaces/patterns but wants an integration test on a running daemon before un-drafting — flagged in the PR body.
- PR is intentionally DRAFT and stacked over Phases 1–3; base `llm` means the diff includes those phases until they merge.
