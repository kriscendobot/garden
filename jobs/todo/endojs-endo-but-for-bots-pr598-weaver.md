# weaver on endojs/endo-but-for-bots PR #598 (rebase onto moved base llm)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only, no upstream endojs/endo touch).

PR #598 (base `llm`) fell behind its base: `llm` advanced from 2b2e32006 to 1132289243
(the #590 "repoint @endo/far consumers and deprecate its plain re-exports" refactor landed).
GitHub now reports `mergeable_state: dirty` / `mergeable: false`, so no merge ref is created and
**no `pull_request` workflow dispatches on new pushes** — CI is stuck empty on the head SHA
(65dbaeb36), not red. There is **no real conflict**: a local `git rebase origin/llm` of the branch
replays both commits (the phase-1 rename + a shepherd bundle fix) **completely cleanly, zero
conflicts**. The `dirty` is stale mergeability after the base move.

Task: rebase #598's head branch `daemon-rename-manager-phase1-llm` onto current `origin/llm` and
force-with-lease push (anchor 65dbaeb36) to refresh mergeability and re-trigger CI dispatch. It
should rebase clean; if a genuine conflict surfaces on a fresher base, resolve per conflict-resolution.

Shepherd context (already landed on the branch, will ride the rebase): commit 65dbaeb36
"fix(familiar): point bundle entry at renamed manager-node.js" repoints the esbuild entryPoint in
packages/familiar/scripts/bundle.mjs (and stale doc refs) from the renamed
packages/daemon/src/daemon-node.js to manager-node.js. This was the sole root cause of the prior red
(familiar-bundle + all four `test` matrix jobs, via bundle.test.js). Verified locally: `yarn node
scripts/bundle.mjs` produced endo-daemon.mjs and `yarn ava test/bundle.test.js` -> 1 test passed.
After the rebase lands and CI dispatches, the previously-red checks should go green.

Provenance: auto-dispatched shepherd (endojs-endo-but-for-bots-pr598-shepherd) handoff, next: weaver.
Standing comment auth applies.
