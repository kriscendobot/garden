Shepherd complete on endojs/endo-but-for-bots PR #306.

**What I did**
- Re-fetched live PR state: OPEN, base `llm`, previously CONFLICTING/DIRTY.
- Got an isolated project worktree and rebased the PR's 9 commits onto current `origin/llm` (`2b2e3200`, the bucketed `scripts/eslint-repo.sh` lint-ceiling fix).
- Resolved genuine conflicts in two commits — all clean three-way unions:
  - Commit 1 (`host.js`, `mail.js`, `endo.test.js`): llm added the message-edit/`messageHistory`/`receiveEdit`/`openEdit` surface and the `readLog` test while the PR added the persona `epithets`/`verify` surface and its test block. Kept both, re-inserting the shared trailing close-brace each side had folded onto the other. Took llm's `agentName → NameOrPath` type evolution while preserving the PR's `epithets` field.
  - Commit 2 (`host.js` fixup): took llm's `NameOrPath` param type + the fixup's `MakeHostOrGuestOptions` opts revert (the whole point of that TS2741 lint-repair).
- Verified locally on the daemon package: **tsc exit 0**, **eslint 0 errors**, **prettier clean**.
- Force-pushed with `--force-with-lease`; PR flipped **CONFLICTING → MERGEABLE**.

**CI outcome**
- After a multi-hour repo-wide GitHub Actions runner backlog cleared, CI ran: `lint` passed (ceiling fix confirmed effective on the rebased branch). One flaky failure — `test (22.x, macos-15)` in the unrelated `@endo/chat` channel suite, a SIGINT interruption (41 passed, 50 pending), while the other three `test` matrix legs passed. Re-ran just that job.
- Final state: **all 26 checks pass, mergeStateStatus CLEAN, MERGEABLE.**

**What changed**: PR #306 head branch `feat/daemon-capability-persona` rebased onto `origin/llm` at `af5f4082e`; no upstream endojs/endo touched (bot-repo only).

**Follow-ups**: none for shepherd — CI is green and the PR is clean/mergeable. Merging is a separate (conductor) concern. No comment posted (job didn't request one).
