All done. The builder stage is complete: draft PR #614 is open on the frozen `llm-1132289` base with load-bearing, real-execution-verified tests.

---

## Completion report

**Job:** Deliver Phase 1 of the `daemon-agent-tools` design (draft PR #611) — the `Dir`-backed filesystem tools in `@endo/agent-tools` giving agents file browsing and editing over the landed mount/`Dir` (`@endo/platform/fs/extended` `Filesystem`) capability.

**Delivered:** Draft PR **[endojs/endo-but-for-bots#614](https://github.com/endojs/endo-but-for-bots/pull/614)** — `feat(agent-tools): list / stat / edit filesystem tools (daemon-agent-tools Phase 1)`, base `llm-1132289` (frozen snapshot of live `llm` per the fork's frozen-base convention; the conductor unfreezes at merge).

**Affected package:** `@endo/agent-tools` (only).

**What changed** (all in `packages/agent-tools/`):
- `src/mount-fs.js` — three new makers plus an aggregate, next to the landed `makeMountReadTool`:
  - `makeMountListTool` → `mountList`: sorted `{name, kind}` directory entries (`""` = root).
  - `makeMountStatTool` → `mountStat`: `kind` (one-send `getQid()` probe) + `size`/`mtime`/`atime`, `bigint`s decimal-string-encoded so the record stays JSON-safe on the wire.
  - `makeMountEditTool` → `mountWriteText`: whole-file create-or-overwrite via the `Directory` whole-blob write (truncates a longer prior file); parent must exist.
  - `makeMountFsTools(fs, opts)` → `ToolRecord[]` with a build-time `scope` tag that drops the write slice under `opts.readOnly`, so a read-only catalog never advertises an edit tool (mirrors `makeGitTool`'s `isGitReadOnly` discipline; the tag never reaches the wire). Shared `pathToSegments`/`assertOnlyKeys` helpers.
- Export surface: `src/index.js`/`.d.ts`, `types-index.js`/`.d.ts`, `mount-fs.d.ts`, `src/mount-fs.d.ts`, `src/types.ts` (new `MountFsToolsOptions`), and README (new Filesystem-Tools section + table).
- `test/mount-fs-tools.test.js` (new, 13 tests).

**Verified by real execution** (not inspection):
- `ava` full suite: **63 tests pass** (13 new), driving every tool over **both** a real `makeNodeFilesystem` and a daemon `mountAsFilesystem(makeMount)` backing, reading written files back from disk (no petstore stubs).
- `tsc -p tsconfig.json`: exit 0. `eslint '**/*.js'`: exit 0 (0 errors; the 3 `any`-cast warnings in `mount-fs.js` match the existing `git-flow.test.js` precedent). Prettier clean.
- **Regression evidence** (deliberate breaks, then reverted): neutering the read-only filter fails the "omits the edit tool" test; neutering the write fails the create/overwrite/fail-closed tests. Green restored.
- Edit over a `readOnly()`-attenuated cap fails closed with `EACCES` at the capability, while read/list/stat still work.

**Decisions / notes for reviewers:**
- No changeset: the immediate predecessor `feat(agent-tools)` commit (#523) added none for this `private` package; followed that convention. No dependency changes, so no `yarn.lock` commit.
- Design's `isGitReadOnly` precedent is aspirational (the current `makeGitTool` doesn't yet consult it, and `@endo/platform` exports no synchronous `isFilesystemReadOnly`). Since a `Filesystem` is an `ERef` with no sync read-only probe, the host declares the attenuation via `opts.readOnly`; documented in code, README, and the PR body.

**Follow-ups (out of scope):** Phases 2 (Shell), 3 (`makeGitRemoteTool` push tier), and 4 (full petname/`storeIdentifier` provisioning + the worked M3 loop). PR left **draft** for the panel/gauntlet to un-draft.

**Env note for the next builder on this fork:** the worktree uses the pnpm linker + a sandbox that blocks `node_modules/.bin/*` execution, so `yarn … exec ava` reports `permission denied: ava`; run tools directly via `node ../../node_modules/ava/entrypoints/cli.js` (and `.../typescript/bin/tsc`, `.../eslint/bin/eslint.js`, `.../prettier/bin/prettier.cjs`).
