Done. The work is complete with real-execution evidence.

## Completion report

**Job:** Write and run the live-daemon end-to-end integration test that Phase 4 (PR #618, `endojs/endo-but-for-bots`) flagged as the un-draft blocker, and land it as a follow-up commit on `builder/daemon-agent-tools-phase4-integration`.

**What I did**
- Added `packages/lal/test/form-provisioning-daemon.test.js` — a live-daemon test that boots a real Endo daemon, launches the *actual* Lal manager caplet (`agent.js`) as an unconfined guest, and drives its "Add an agent" form the operator's way (submitting `projectPath` + `capabilities=fs,shell,git` via `E(host).submit(...)`). It asserts the full grant path against the running daemon: mint mount → `provideGit`/`provideShell` → `storeIdentifier` into guest → guest startup discovery.
- Committed as `6e81647f6` and pushed to the PR head branch (rebase-CAS push succeeded: `772eb562d..6e81647f6`).
- Posted a verification summary comment on PR #618.

**Verified by real execution** (not inspection):
- `npx ava test/form-provisioning-daemon.test.js` → **1 test passed** on multiple runs (deterministic; ~0.9s), logs confirming: form received (#0), submitted, `Manager reply: Agent "coder" is now running`, and `Discovered tools: add, branches, commit, createBranch, currentBranch, diff, exec, inspect, log, mountList, mountReadText, mountStat, mountWriteText, show, status, switchBranch` (all 16: fs 4 + shell 2 + git 10).
- Assertions that passed live: host-agent minted `coder-project-mount`/`coder-git`/`coder-shell`; guest holds `fs`/`git`/`shell`/`primer` under canonical names; `discoverCapabilityTools(guest)` returned all 16 records; discovered fs tools read→overwrite→read-back a file with on-disk confirmation (mount is writable).
- Full lal suite via `ava`: **35 pass / 1 skip** (was 34/1). `eslint` 0 errors; `prettier --check` clean.

**Environment work required to run it:** the worktree had no `node_modules` — installed deps (`corepack yarn install`), and rebuilt the native `better-sqlite3` from its cached prebuild (yarn's `enableScripts:false` blocks the build). Fixed a real portability issue the test surfaced: the long scratch-worktree path overflows the unix-socket `sockaddr_un` limit (also breaks the daemon package's own tests here), so the test keeps the socket in `os.tmpdir()`.

**Incidental findings encoded in the test:** `provideGit` requires the mount root to be a real git worktree (test `git init`s the project dir); the guest's own namespace is reached via its `profile-for-<name>` agent powers, since the pet-name lookup returns only the messaging handle.

**Follow-ups:** PR remains **Draft** — this closes the integration-test blocker, but un-drafting is still gated on Phases 1–3 landing (the stack's stated precondition). No un-draft was performed.
