Weave complete. PR #705 is `MERGEABLE` with the corruption repaired and CI's previously-red `lint` step now green.

## Completion report — weave endojs/endo-but-for-bots PR #705

**Finding.** The PR was *not* blocked by a rebase conflict. Its branch (`build/agent-tools-git-remote-push-tier`) already sat directly on the current `llm` tip (`cec551638f`) — 2 ahead / 0 behind, zero conflict markers, git-mergeable. The real blocker was **content corruption baked into the feature commit** `1fa5f4a130`: a bad prior merge/apply had silently dropped every capability-type line from `packages/agent-tools/src/types.ts` across the whole file — the `export type X = Pick<…>` openers and `>;` closers, the `args:`/return-type lines on `ToolSpec.execute` and `ToolRecord.invoke`, and each maker's capability parameter (`gitCap`, `shellCap`, `fs`, `httpCap`). The result was syntactically invalid TypeScript, so CI `lint` failed at the Prettier step (`SyntaxError: Expression expected` at the dangling `WritableEndoGit,`) and the PR read as red/dirty.

**Resolution.** Rather than resolve a phantom conflict, I reconstructed `types.ts` from the `llm` base plus only the three additions this PR actually intends (confirmed against the *uncorrupted* sibling `src/git-remote-tool.d.ts` and `git-remote-tool.js`):
- import `GitRemote` from `@endo/exo-git`,
- add `GitRemoteToolCapability = Pick<GitRemote, 'inspect' | 'fetch' | 'pull' | 'push'>`,
- declare `makeGitRemoteTool(remoteCap: ERef<GitRemoteToolCapability>): ToolRecord[]`.

The corruption had also spuriously added an **unused `EndoGit`** import; I dropped it (the real surface uses only `GitRemote`, which `@endo/exo-git` publicly re-exports and whose shape is exactly those four keys). Runtime files were untouched by the corruption and are unchanged.

**Verification.** Committed as `c24fac7d11` (repair commit on top; fast-forward push, no history rewrite) under the bot identity. Prettier clean locally on all PR-touched files; CI now shows `Run yarn lint` (Prettier + `tsc` + eslint), `Check composite tsconfig files are up to date` (no drift), and `Check package uniformity` all **green** on the new head. PR is `MERGEABLE`, head `c24fac7d11`.

**Notes / follow-ups.**
- No PR comment posted — the job carried no commenting authorization (weaver external-repo etiquette).
- History cosmetics: the broken intermediate commit `1fa5f4a130` remains in the branch's history (fixed at the tip). A later retcon/squash could fold the repair in if a clean single-commit history is wanted before ferry.
- The M3 stack peers (#706–#708) may have been rebased on this branch's prior (corrupt) state; whoever weaves them should confirm they pick up head `c24fac7d11`.
