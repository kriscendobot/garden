Working tree clean, local tip equals remote, 7 ahead / 0 behind `llm`. The weave is complete.

## Weave complete — endojs/endo-but-for-bots PR #615

**Result:** PR #615 rebased from `CONFLICTING` to `MERGEABLE`. Head is now `4eca0d0fe126646d6f447579c31c6d70bf9dd634` (7 commits replayed onto current `origin/llm`; was 7 ahead / 36 behind, now 7 ahead / 0 behind). The PR targets live `llm` directly (no frozen base), so no base-field change was needed. Force-with-lease push landed; CI is re-running (`UNSTABLE`).

**Conflicts resolved:** All conflicts were in the first commit and confined to `packages/agent-tools/`, from one collision — `llm` independently added the `git-mount-tool` catalog (`makeGitMountTools` / `GitMountToolCapability`) while this branch added the shell catalog (`makeShellTool` / `ShellToolCapability`). Both are additive and touch disjoint symbols, so every resolution kept **both** sides (no `--ours`/`--theirs`):
- `package.json` (both `./` and `./src/` export maps): both `git-mount-tool.js` and `shell-tool.js` export entries.
- `src/index.js`, `src/index.d.ts`, `types-index.js`, `types-index.d.ts`: both `makeGitMountTools` and `makeShellTool` re-exports.
- `src/types.ts`: base's `makeGitMountTools` declaration plus this branch's full shell type block, each with its own closing signature.

The remaining 6 commits (exec-timeout hardening, `.d.ts` localization, prettier/ses follow-ups, doc corrections, changesets) replayed with zero conflicts.

**Verification (run against the rebased tree, evidence cited):**
- `packages/agent-tools` typecheck (`tsc -p tsconfig.json`): exit 0, clean.
- `packages/agent-tools` ava: **68 passed** — `git-mount-tool` (base), `shell-tool` + schema↔guard `divergence` gate (branch), and `git-flow` all green together, proving the two catalogs coexist correctly.
- `packages/exo-shell` ava: **12 passed**; `packages/host-spawner` ava: **5 passed**.
- `packages/daemon/test/shell.test.js`: **not run** — its `better-sqlite3` dependency's native build is blocked in this sandbox (`node-gyp` permission denied), a pre-existing environment limit unrelated to the rebase. Those daemon commits applied with no conflicts; CI covers them.

**Comment:** Posted the required top-level weave summary on the PR (standing authorization on this repo): https://github.com/endojs/endo-but-for-bots/pull/615#issuecomment-4911373517

**Follow-ups:** None blocking. Watch CI converge on the new head; the M3 daemon-agent-tools line is unblocked.

**Note (not routed as a skill change, may be host-specific):** Running the affected-package tests hit sandbox friction — `corepack yarn`'s bin runner returned `permission denied: tsc`, and `better-sqlite3` failed its native build. The workaround that let me verify was invoking `tsc`/`ava` directly via `node` with the absolute path into `node_modules/.store/`. The fleet's normal `local-verify` runs through a different (shell-handler) path, so this friction may not generalize; flagging in case a peer gardener hits the same wall when running local-verify under the Bash tool.

Self-improvement: nothing this time.
