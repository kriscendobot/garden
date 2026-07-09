The weave is complete. Empty inbox, no messages to handle.

## Completion report

**Job:** Weave (rebase) endojs/endo-but-for-bots PR #618 ("daemon-agent-tools Phase 4 — dynamic capability tool discovery + form provisioning") onto current `llm`, reconciling against landed #614's file-tool makers.

**What I did:**
- Rebased head `builder/daemon-agent-tools-phase4-integration` (was 10 commits over an old `llm` merge-base, DIRTY/CONFLICTING) onto current `origin/llm`.
- The branch redundantly carried Phases 1–3, which had since landed on `llm` via their own PRs (#611/#614 file tools, #615 Shell, Phase 3 git-mount tools). Git auto-skipped 3 exact-match commits; I manually verified and `--skip`ped 3 more (`2720cda66` #611 makers, `c402edb5d` Phase 2 Shell, `0332eabf0` Phase 3) after confirming `llm` already contains equivalent-or-evolved versions of every file each added (e.g. head's `mount-fs.js` at #611 was byte-identical to llm's; llm's shell/git makers had evolved *past* the branch's copies, so keeping the branch's would have regressed llm).
- Resolved the real Phase 4 commit's conflicts: `llm` had already landed `makeShellTool` exports (via #615), and Phase 4 needed to add `discoverCapabilityTools`. Reconciled `packages/agent-tools/src/index.js`, `index.d.ts`, `types-index.js`, `types-index.d.ts`, and `package.json` to keep **both** the landed `makeShellTool` and the new `discover.js` exports (no duplicates).

**Result:** Net diff over `llm` is now exactly the Phase 4 work (agent-tools `discover.js`, `fae/src/capability-tools.js`, `lal/agent.js` wiring, and tests) — all the already-landed Phase 1–3 files dropped out. Force-pushed with lease; **PR #618 is now MERGEABLE** (was CONFLICTING). Base stayed live `llm` (this PR targets `llm` directly, no frozen base to move). New head: `f8f101f3f`.

**Verification:**
- `@endo/agent-tools`: `tsc` clean; full ava suite **98 tests pass**, including the 7 new `discover.test.js` cases that exercise `discoverCapabilityTools` against llm's evolved `makeShellTool`/`makeGitTool`/`makeGitMountTools`/`makeMountFsTools` (the exact reconciliation risk) — shell/git/fs/readOnly/union/custom-name all green.
- `@endo/fae`: new `capability-tools.test.js` **5 tests pass**; production source `tsc`-clean.
- `@endo/lal`: production `agent.js` `tsc`-clean.
- Remaining `tsc` noise in fae/lal test files is **pre-existing on llm** (proven: unchanged files like `channel-mention.test.js`/`tools/edit-file.js` error identically) or environmental module-resolution.

**Follow-ups / caveats:**
- The `lal/test/form-provisioning-daemon.test.js` **live-daemon integration test could not be run in this sandbox**: the daemon fails to boot because `better-sqlite3`'s native binding can't be compiled here (yarn's build env denies `node-gyp`/`prebuild-install` even with the sandbox disabled). The failure is at daemon-database init, never reaching Phase 4 logic — it is an infra limitation, not a code defect, and will run in CI. `mergeStateStatus` is currently `UNSTABLE` (CI running on the new SHA); driving CI to green is the shepherd's job, not the weave's.
- No PR comment posted (none authorized by the job; the weave push is the implicit action).
