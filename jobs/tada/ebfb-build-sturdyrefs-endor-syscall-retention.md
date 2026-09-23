Build complete. Final report below.

---

## Completion report — `ebfb-build-sturdyrefs-endor-syscall-retention`

**Result: DRAFT PR [endojs/endo-but-for-bots#541](https://github.com/endojs/endo-but-for-bots/pull/541)** opened, stacked on #521. Clean slice: **654 additions / 9 deletions across 11 files**. tsc, eslint, prettier, and the new unit suites all green. The open-PR gamut (cleaner → judge → fixer-loop → un-draft) will pick it up.

### What I did
1. **Researched first** (researcher-precedence): dispatched an Explore agent to map the daemon + endor code surface (facets, `graph.js`, `residence.js`, `locator.js`, envelope/bus, Rust endor, `listRetentionPaths`), then verified the exact API #521 landed (`makeSturdyRef`/`getStudyRefLocator` in pass-style — note the landed spelling is literally `getStudyRefLocator`; ocapn's `getSturdyRefDetails`/`makeSturdyRefTracker`).
2. **Built cuts 3–5 of design #510** via a builder dispatch, supervised, in a worktree stacked on #521's head.
3. **Recovered from a base rebase mid-build**: the rolling base advanced during the run — #521 was rebased onto a new base (`llm-27f53e6`, head `0ad8d1b0…`) that deleted many packages, leaving my commits on stale history. I rebased my 4 commits onto the current #521 head (clean, no conflicts), then **independently re-validated** — which caught a semantic break the auto-merge hid (`interfaces.js` referenced `NameShape`, which the new base had moved into `type-guards.js`). Fixed the import, folded the fix into its logical commit via autosquash.

### What changed (green, in the PR)
- **`graph.js`** — `ephemeral:<worker>:<turn>` and `retained:<worker>:<handle>` retention edges on the existing labeled-edge machinery (so both surface via `listRetentionPaths`), a per-worker small-integer handle allocator, and `releaseAllRetentionForWorker` for the disincarnate/worker-exit revocation path. `test/retention-edges.test.js` (7 tests) — satisfies the gate's "daemon integration test for retention edges."
- **`interfaces.js`** — read-side guards (`lookup`/`identify`/`locate`/`list`/`listIdentifiers`/`listLocators`/`evaluate` slots) accept `M.kind('sturdyref')`; write/rename/reverse left untouched. No `@endo/patterns` change needed.
- **`sturdyref-resolution.js`** (+ `directory.js`/`host.js`/`guest.js` wiring) — `resolveSturdyRefToId` resolves a SturdyRef at the facet boundary only (swiss number never reaches a worker); local `endo://` locators resolve, remote/OCapN tuples reject cleanly (staged). `test/sturdyref-resolution.test.js` (6 tests).
- **`designs/daemon-endor-architecture.md`** — `retain`/`release` verb rows with payload/response/error shapes.

**Open questions resolved (minimal shape):** `retain` on non-SturdyRef rejects; handle = per-worker small int; `ephemeral:` edge user-visible.

**Validation:** tsc 0 errors; eslint 0 errors (warnings within repo baseline); prettier clean; ava `retention-edges`+`sturdyref-resolution`+`graph`+`graph-refcount` all pass. Forked-daemon integration suites can't run in the sandbox (worker spawn/native prebuilds blocked) — CI covers them.

### Follow-ups (documented in the PR, not landed)
1. **endor `retain`/`release` JS wire + worker `syscall` SDK (cut 5 wiring)** — graph primitives are in place; remaining is envelope/bus/supervisor dispatch + a worker-driven integration test, deliberately held back rather than land unverified in-sandbox.
2. **Rust `endor.rs`/codec verb arms** for retain/release.
3. **OCapN↔daemon locator bridge** for remote/peer SturdyRef resolution (currently rejected cleanly).

### Notes
- Bot repo only (`endojs/endo-but-for-bots`); no agoric-sdk, no endo upstream. Pushed under endolinbot identity.
- Build worktree and local convenience branches torn down; remote branch + PR remain.
- **Garden infra observation** (FYI, not blocking): a fresh `git worktree add` yields only a partial hoisted `node_modules` (missing `@endo/*` workspace links), so `tsc`/`ava` silently mis-resolve until `corepack yarn install` is run in the worktree. This likely explains intermittently optimistic builder validation reports across daemon jobs. Worth a one-line note in the build flow to always install in a fresh worktree before trusting the validation gate.
