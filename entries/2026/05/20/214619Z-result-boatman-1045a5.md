---
ts: 2026-05-20T21:46:19Z
kind: result
role: boatman
project: endo
repo: endojs/endo
refs:
  - entries/2026/05/20/214118Z-dispatch-liaison-410186.md
---

Recomputed `endojs/endo#3256` (`feat/syrups-package`) onto the new master tip. Source `endojs/endo-but-for-bots#109` head was unchanged at `2627e81a3d5881e817eb0e11c4596ae4c060f9c9` (four-commit shape), but `endojs/endo` master had advanced 11 commits since the prior recompute (`c063631fed` -> `ec3dcbc0cbf65b0b65725d041d4ee8f2ccf1610f`). User asked to ferry again.

- New master tip used: `ec3dcbc0cbf65b0b65725d041d4ee8f2ccf1610f` (`fix(skel): remove too-broad includes from default tsconfig (#3271)`, 2026-05-20 21:28Z).
- Source head: `2627e81a3d5881e817eb0e11c4596ae4c060f9c9`.
- Upstream head after force-push: `da5a9b48edbc6a0609a3fd4086676e797008dacb`.
- Four new commit SHAs (in order):
  1. `38fe6787d8187ec6614fc8f2dcb5b08088cbb0d2` feat(syrup-frame): add @endo/syrup-frame package
  2. `bdb9ddc50d3aa9cef17b61a4d587a14a39142470` feat(ocapn): add opt-in syrup framing to TCP-testing netlayer
  3. `7ea0a9eb03cddb14c5807dcd289e4f6746e9848f` chore: Update yarn.lock
  4. `da5a9b48edbc6a0609a3fd4086676e797008dacb` chore: regenerate composite tsconfig files

Attribution verified: `git log origin/master..HEAD --pretty=fuller` shows author + committer `Kris Kowal <kriskowal@kriskowal.com>` on all four. `git interpret-trailers --parse` over each commit message returns empty: no `Co-Authored-By:`, no `Generated with [Claude Code]`, no bot trailers.

Pre-flight ancestor/lease check: `git fetch origin feat/syrups-package` confirmed `origin/feat/syrups-package` still at the lease tip `f5182df1751df5b809e8b245ee9f86e279e20f79` immediately before push. No concurrent push detected.

Push mode: `git push origin HEAD:feat/syrups-package --force-with-lease=feat/syrups-package:f5182df1751df5b809e8b245ee9f86e279e20f79`. Accepted as `f5182df17...da5a9b48e`. No unsafe `--force`.

Conflict resolution notes:
- Commits 1 and 2 (syrup-frame package, ocapn netlayer): clean cherry-picks. New master's notable churn (`f22f4b5d` Node 18/20 drop, `36104778` actions/checkout bump) does not touch the packages this PR touches.
- Commit 3 (yarn.lock): cherry-pick applied cleanly. Validated lockfile consistency against the new master baseline by running `YARN_ENABLE_IMMUTABLE_INSTALLS=false YARN_ENABLE_SCRIPTS=false YARN_NODE_LINKER=node-modules yarn install --mode=update-lockfile`; yarn reported only pre-existing peer-dep warnings and produced zero diff against the cherry-picked lockfile. No yarn regeneration needed.
- Commit 4 (composite tsconfig regen): cherry-pick applied cleanly. The new master's most recent commit `ec3dcbc0` (`fix(skel): remove too-broad includes from default tsconfig`) only touches `packages/skel/tsconfig.json`, which is the skel template, not the generated composite tsconfigs. Verified by running `node scripts/generate-composite-tsconfigs.mjs --check`: "All composite tsconfig files are up to date." No regeneration drift.

kumavis approval persistence verified post-push: `gh pr view 3256 -R endojs/endo --json reviewDecision,reviews` reports `reviewDecision: APPROVED` with kumavis's `PRR_kwDODR4qQ87_hIym` (2026-05-14T02:42:25Z) still attached. GitHub's stale-on-push-rebase policy did not strip the approval.

Source-side cross-link comment posted under `kriskowal`: https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4502904461. Names the new upstream head SHA, four-commit shape preserved, and the rebase onto the new master tip.

Title and body of `endojs/endo#3256` untouched.

Self-improvement: when the cherry-pick of a `chore: regenerate composite tsconfig files` commit applies cleanly atop a moved master, still run `node scripts/generate-composite-tsconfigs.mjs --check` (or the project's equivalent `--check` mode) before pushing. A clean textual cherry-pick is necessary but not sufficient evidence that the regenerated artifacts are in sync with the current generator inputs; the `--check` invocation is the canonical drift detector. Same pattern applies to any generated-file recompute commit on a moved baseline: prefer running the generator's check mode over trusting that a clean apply means "still correct".
