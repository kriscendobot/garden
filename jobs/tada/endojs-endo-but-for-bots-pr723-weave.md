Weave complete. PR #723 restored to a clean mergeable state.

**What I did**
- Set up an isolated project worktree for `endojs/endo-but-for-bots` on `build/endo-fetch-plugin` and surveyed divergence: head was 10 ahead / 71 behind base `llm`.
- The PR targets `llm` directly (not a frozen-base snapshot), so I rebased the head onto current `origin/llm`; the base ref stays `llm`.
- **Conflicts:** only commit `42191287e ci(zizmor): update actions/setup-node hash pin to match v6 tag` conflicted, across 8 `.github/workflows/*.yml` files. Reading both sides: base `llm` had **independently** updated the setup-node pin to the **exact same security-critical hash** (`249970729…`) the PR intended, with a more precise `# v6.5.0` comment vs the PR's `# v6`. The base fully subsumes the PR's intent, so I resolved every hunk to the base version. The zizmor commit consequently became empty and git dropped it (noted per weaver discipline — the change had already landed on base).
- No other conflicts; the 9 `@endo/fetch` commits replayed cleanly.

**What changed**
- `build/endo-fetch-plugin` force-with-lease pushed (`94bba2766…f797ca8a7`). Post-rebase diff vs `llm` is exactly the PR's original intent: the `@endo/fetch` package, the `@endo/exo-http-client` persistence seam, the changeset, the typedoc exclusion, and the small yarn.lock addition — no workflow diff remains.
- `yarn install --immutable` produced no lockfile-mismatch (YN0028), so the rebased `yarn.lock` is consistent with the new base.
- Tests on both affected packages pass on the rebased tree: `@endo/fetch` 8/8, `@endo/exo-http-client` 35/35.

**Result:** PR #723 went from `CONFLICTING`/`DIRTY` to `MERGEABLE` (`mergeStateStatus: UNSTABLE` = CI running post-push, not a conflict).

**Follow-ups**
- CI will re-run; a shepherd may be needed if any check goes red (the fetch package carries `checkJs:false` / `@ts-expect-error` suppressions from the pre-weave fix commits — unchanged by this weave).
- Environment note: the repo's full `yarn install` can't complete here (`better-sqlite3` native build blocked — `permission denied: prebuild-install`/`node-gyp`); I ran ava directly from the pnpm store to verify. Unrelated to this change.
- No PR comment posted (not authorized in this job body; force-with-lease is the implicit weave mutation).
