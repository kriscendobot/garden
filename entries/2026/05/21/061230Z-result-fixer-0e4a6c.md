---
ts: 2026-05-21T06:12:30Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--cdaa6a/project
---

Retcon on PR endojs/endo-but-for-bots#75 (kriskowal-random-chacha12) per maintainer's "Please retcon and shepherd. I am expecting the amendments to be absorbed into the relevant commits. Consider simply resetting and reconstructing the reasonably grouped commits."

**Merge-base:** `9213d2c566dc013da8454af92147c8154c178f80` (against `origin/master`).
**Pre-retcon head:** `04abbe381` (38 commits above merge-base).
**Post-retcon head:** `77f4e0526` (11 commits above the same merge-base).

**Net-diff invariance verified:** `git diff pre-retcon-cdaa6a..HEAD` returned empty; both pre- and post-retcon diffstats against the merge-base report 64 files, 4460 insertions, 299 deletions. The pre-retcon tag was deleted after verification.

**Note:** the first restage attempt missed `packages/random/types.d.ts` because the repo-wide `.gitignore` (`*.d.ts*` at line 88) excluded it. The pre-retcon history must have force-added the file. Caught at the net-diff verification step, the restage was redone with `git add -f packages/random/types.d.ts` after the standard `git add packages/random/` and the invariant then held. Recording for the *Notes from the field* section of `skills/retcon/SKILL.md`: a retcon over a tree containing committed-but-gitignored files must force-add them, and the net-diff invariance check is the only thing that surfaces the omission.

**New commit topology (one per affected package + top-level config, changeset, yarn.lock):**

| SHA | Subject | Stat |
| --- | --- | --- |
| `1a1caf132` | feat(random): add @endo/random source-agnostic samplers | 23 files, +1576 |
| `9cf2c491f` | feat(chacha12): add @endo/chacha12 pure-JS ChaCha12 keystream | 17 files, +2327 |
| `b14218902` | feat(chacha12-fast-check-test): adopt test-package shape | 8 files, +594 |
| `5a86f545c` | refactor(hex): use @endo/chacha12 keystream + @endo/random/seeds for bench inputs | 5 files, +19/-133 |
| `4d9548807` | refactor(ocapn): use @endo/chacha12 + @endo/random for fuzz drivers | 4 files, +16/-120 |
| `5b952ddcd` | fix(ses): tuple-typed args restores `Parameters<typeof compartmentOptions>` overlap | 1 file, +2/-2 |
| `0ce81e15a` | style(evasive-transform): align customVisitor JSDoc continuation indent | 1 file, +1/-1 |
| `662ac97af` | docs: document the thunk-module policy in AGENTS.md | 1 file, +15 |
| `871f41510` | chore: register chacha12, chacha12-fast-check-test, random in root tsconfig and typedoc | 2 files, +10 |
| `b73abdd61` | docs(random,chacha12): changeset for @endo/random + @endo/chacha12 | 1 file, +30 |
| `77f4e0526` | chore: Update yarn.lock | 1 file, +76 |

All round-1/2/3 amendments (per-source multiplier-test split, `bobsCoffee64` -> `bobsCoffee32` rename, prettier table reformat, ASCII-banner removal, magic-multiplier-test simplification, `randomUint53` four-source assertion, maxSource pinning, shared-`ArrayBuffer` uint-reader refactor, per-package PR-citation drops, etc.) are absorbed silently into the package they touched. The `fix(ses)` and `style(evasive-transform)` JSDoc tweaks remain standalone because they touch packages outside the PR's primary scope. One combined `chore` for tsconfig and typedoc registration per the retcon skill's *Top-level config or build changes* bucket. `chore: Update yarn.lock` ships last per `skills/yarn-lock-separate-commit/SKILL.md`.

**Force-push:** `git push --force-with-lease origin HEAD:kriskowal-random-chacha12` succeeded, `04abbe381...77f4e0526` (forced update).

**Summary comment:** posted at https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4505299260.

**Pre-push gate (probes-only):** five findings (`no-inline-import-jsdoc` in `packages/evasive-transform/src/index.js`, `security-md-hash-uniform` divergence across pre-existing `SECURITY.md` files, `sentence-per-line-md` in `AGENTS.md` plus several READMEs/BENCH/SECURITY pages, `test-package-no-main` on `packages/chacha12-fast-check-test/package.json`'s `./package.json`-only exports map). Comparison against the pre-retcon tip confirmed all five are present there too: net-diff invariant, not introduced by the retcon. Out of the retcon's lane; the follow-up shepherd or a subsequent fixer round addresses them.

**Branch base lag:** the PR branch lags `origin/master` (the dispatch scoped the retcon to "reset to merge-base", not "rebase onto current base"). The shepherd or a subsequent weaver may catch the branch up before the next review pass.

Step 2 (shepherd) is the orchestrator's next dispatch on this PR.

Self-improvement: a candidate row for `skills/retcon/SKILL.md` § Pitfalls: "A repo-wide `.gitignore` that excludes file patterns the pre-retcon history force-added (here `*.d.ts*` excluding `packages/random/types.d.ts`) will cause the per-package `git add packages/<P>/` step to silently omit those files. The net-diff invariance check is the only thing that surfaces the omission. Mitigation: after each per-package `git add`, run `git diff pre-retcon..HEAD -- packages/<P>/` to verify the package's slice of the diff is empty before moving on; OR check `git status --ignored -- packages/<P>/` for unstaged-but-tracked-in-the-other-tree files and `git add -f` them."
