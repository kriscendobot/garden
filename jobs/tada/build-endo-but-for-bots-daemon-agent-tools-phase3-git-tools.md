Done. All acceptance criteria verified by real execution.

## Completion report

**Job:** Build daemon-agent-tools Phase 3 (Git capability) in endojs/endo-but-for-bots — register `Git`-backed agent tools (status/diff/log/add/commit, argument-validated, network ops excluded), mirroring the Phase 1/2 tool-registration pattern, as a fresh draft PR on `llm`.

**What I found:** `diff`, `log`, and `commit` already ship in the JSON-transparent `makeGitTool` slice. The two missing methods, `status` and `add`, were explicitly deferred in the codebase ("await the capref/result serialization of a later PR") because their native `EndoGit` signatures traffic in live capabilities: `status()` returns rows bearing `EndoMountEntry`/node remotables, and `add()` takes an array of mount-entry remotables — neither is JSON-safe on the tool wire. Phase 3 is that later PR.

**What I built** (in `@endo/agent-tools`):
- **`makeGitMountTools(gitCap)`** (new `src/git-mount-tool.js`) — a sibling maker that bridges both at the wire boundary via the mount reached through `Git.worktree()`:
  - `status` projects each row to JSON-safe `{ path, index, worktree, renamedFrom? }`, stripping the `entry`/`node` remotables.
  - `add` takes mount-relative path strings, resolves each to an `EndoMountEntry` (`E(gitCap).worktree()` → `E(mount).entry(segments)`), then calls `Git.add(entries)`. Argument-validated by an `M.arrayOf(M.string())` guard + JSON Schema; `../` escapes are rejected by the mount capability.
- New `GitMountToolCapability` type slice, so the deliberate wire↔cap divergence lives **outside** `makeGitTool`'s divergence gate — `makeGitTool` and `divergence.test.js` are untouched.
- Wired exports across `index.{js,d.ts}`, `types-index.{js,d.ts}`, `package.json` exports map, and root/`src` `.d.ts` shims (force-added, matching the sibling convention since `*.d.ts` is gitignored).
- Network ops (fetch/pull/push) remain excluded — those are `GitRemote`.

**Verification (real execution):**
- `yarn workspace @endo/agent-tools test` → **58 tests pass**, including new `git-mount-tool.test.js` (8 tests: remotable-stripping, path→entry marshalling, separator normalization, guard/key rejection) and an extended `git-flow.test.js` integration test that drives `add` + `status` through the new tools over a **real native-git-backed `Git` exo on a real on-disk repo** end-to-end.
- `tsc` (lint:types) clean — 0 errors.
- `eslint` — 0 errors, 2 pre-existing `any` warnings in the untouched `filesystemAt` section of `git-flow.test.js` (not introduced by this change).
- `yarn.lock` unchanged (no new dependencies).

**Deliverable:** Draft PR **[#616](https://github.com/endojs/endo-but-for-bots/pull/616)** opened, verified `isDraft: true`, `baseRefName: llm`, head `builder/daemon-agent-tools-phase3-git` — alongside the sibling phase branches (#614 Phase 1, #615 Phase 2).

**Notes / follow-ups:** The `.d.ts` files are gitignored in this repo and were force-added to match the existing sibling shims. Wiring these makers into live Lal/Fae tool discovery is Phase 4 (Integration and discovery), per the design's implementation plan — out of scope here, matching how Phases 1/2 landed their makers without live-agent wiring. The local install needed `TMPDIR` pointed at an exec-capable dir because `/tmp` is `noexec` (blocks `better-sqlite3`'s native build); this is a sandbox-environment detail, not a code issue.
