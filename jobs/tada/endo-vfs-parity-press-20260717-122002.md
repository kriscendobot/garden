VFS-parity press dispatch 2026-07-17 12:20Z: rescued the delegated mount glob/grep stack from a dead-branch trap; #713 is now a self-contained, mergeable PR against `llm`.

**What I did**

- **Assessed the open set:** #656 (provideSubMount) is CLEAN/MERGEABLE with all 24 checks green (the prior dispatch's 4 pending slow suites landed green — its follow-up 1 confirmed). #713/#655/#657 were green but I found a structural problem the green state was hiding: their stack rungs (#653 B, #679 B′) were **closed unmerged**, and #680 (C′ grep) merged only into #679's now-dead branch — so all three targeted branches that could never reach `llm`. `llm` carries the `@endo/platform/fs/search` engine (`934d339153`, plus the deliberate conservative-regex seam removal `729a0b98f7`) but `EndoMount` on `llm` had no glob/grep/glorp at all.
- **Wove #713:** rebased its branch (which carries B′ glob + C′ grep + G′ glorp) onto `llm` `41cb5806ac`, resolving in favor of `llm`'s engine — the duplicate engine commit dropped in transit, the superseded `isConservativeRegex` re-additions resolved away, and a stale `daemon-node-powers.js` import (pre-#598-rename) fixed in a trailing commit. Pushed as `2b107db3df` (force-with-lease) and **retargeted the PR base to `llm`**, making it the self-contained carrier of the whole delegated mount-search surface. Updated title/body and posted evidence (comment 5003436753).
- **Execution evidence:** 11 platform search tests + 23 mount glob/grep/glorp tests + 123 mount regression tests (mount, platform-fs-conformance, revocation, snapshot-and-entry) all pass locally at the new tip. PR is MERGEABLE against `llm`; CI re-running at close (UNSTABLE = pending, zero failures).
- **Messaged the maintainer** (delivered 20260717T124846Z-815188) with the finding and one disposition call: close #655 (old non-delegated grep, now fully superseded by #713's C′) and re-stage #657's orthogonal mount-JSON commits onto `llm` — awaiting the word.
- No new surface opened (correctly deferred: #713 needed this weave). Secondary short-path worktree and tmp dirs cleaned up.

**Follow-ups for the next dispatch**

1. Confirm #713's CI landed green against `llm`.
2. Act on the maintainer's reply re closing endojs/endo-but-for-bots#655 and re-staging endojs/endo-but-for-bots#657's JSON commits; silence keeps both open.
3. Once the set is review-blocked only, the next parity gap stands as previously scoped: glob+grep in genie/lal/fae (none has a standalone glob or grep; genie has only a `listDirectory` glob filter) and edit parity (lal `editText` and fae `edit` landed; genie has no edit tool).
4. Press-runner notes that held: daemon tests need a short-path worktree (socket-path limit) and `TMPDIR` off noexec `/tmp` for the better-sqlite3 build; run ava via `node node_modules/ava/entrypoints/cli.js` (sandbox blocks `.bin` exec).
