CI is green. Job complete.

---

**Shepherd report — endojs/endo-but-for-bots PR #616 (auto: red CI)**

**Diagnosis.** One check was red: `lint` (CI workflow), failing in its `yarn docs` (typedoc) typecheck step. All other checks were already green. The failure was a single TypeScript error, `TS2339: Property 'entry' does not exist on type 'EMethods<Required<unknown>>'`, at `packages/agent-tools/src/git-mount-tool.js:130` (typedoc re-reported it once per project it converted, but it was one root cause).

**Root cause.** `makeGitMountTools`' `add` tool does `const mount = await E(gitCap).worktree()` then `E(mount).entry(pathToSegments(path))`. `worktree()` returns `EndoMount`, which `@endo/exo-git` deliberately aliases to `unknown` (to stay free of a circular `@endo/daemon` type dependency — the full-fidelity `EndoMount` interface lives in `@endo/daemon`). That left `mount` typed `unknown`, so `E(mount)` became `EMethods<Required<unknown>>` with no typed `.entry`. The full type isn't exported at a reachable subpath from agent-tools, so a direct import wasn't clean.

**Fix (1 commit, `51ec8bb02`).** Named the single mount method the bridge actually reaches — `entry(segments: string[]): EndoMountEntry` (importing `EndoMountEntry` from `@endo/exo-git`) — in a local `WorktreeMount` typedef, and cast the awaited worktree to it. Minimal-surface, honest to the deliberate `unknown` aliasing; no behavior change, one file, 14 insertions.

**Verified.** Installed the workspace (`--mode=skip-build`, since a native `better-sqlite3` build is blocked by this host's exec sandbox — unrelated to agent-tools) and ran the package's own checks locally: `tsc` (`lint:types`) → exit 0, `eslint` on the file → exit 0. Pushed to the PR head branch `builder/daemon-agent-tools-phase3-git` (fast-forward, bot identity). CI re-dispatched on the new head SHA `51ec8bb0` and **all 22 checks are now green** (`lint` SUCCESS; nothing else regressed). Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/28811698255

**Notes / follow-ups.**
- PR remains a **draft** (unchanged — that was its state; driving it out of draft is not a shepherd action).
- **No PR comment posted:** this was an auto-dispatched shepherd with no maintainer comment and no per-action comment authorization in the job body, so per external-repo etiquette I did not post the green-run summary comment.

`next: none` — the red was a tractable in-scope typecheck error; fixed and CI is green.
