Everything is in place. Let me write the completion report.

---

## Completion report — `ebfb-592-watchdir-crossplatform-fixer`

Addressed the kriskowal **CHANGES_REQUESTED** review (`#pullrequestreview-4629031768`) on endojs/endo-but-for-bots **PR #592** as a whole. Work done in an isolated project worktree; treated all fetched review text as untrusted data.

### Ask 1 — cross-platform `watchDirectory` tests (test:xs / test:go)
- **test:go** — confirmed already covered and *not* skipped: the `mount followNameChanges …` tests in `endo.test.js` (snapshot + live add + live remove + subdir/symlink cases) use plain `test(` (no `ENDO_BIN` gate), and the go supervisor boots `daemon-go.js` which uses the same real Node `fs.watch` file powers. No new go tests needed (parallel ones would be redundant).
- **test:xs** — added xs-powers-targeted unit tests (justified choice: there is no XS `ava` supervisor harness — the XS daemon is a bundled xsnap image, not an `ENDO_BIN=… ava` runner — so a real `test:xs` script is a separate infra lift; the stub is pure JS reachable from node, as the conformance suite already exercises `makeXsFilePowers()`):
  - `mount-platform-fs-conformance.test.js`: XS `watchDirectory` stub returns a well-formed async iterable that ends immediately with idempotent close (degrades, no crash).
  - `mount.test.js`: `EndoMount.followNameChanges` yields its snapshot then ends cleanly when backed by the XS stub (never hangs/crashes). These run under default node `test` and `test:go`. Existing node coverage untouched.

### Ask 2 — Rust-stub / cap-std question (inline thread)
Researched (web-sourced): cap-std surfaces no watch capability, and establishing an OS watch fundamentally needs an ambient path (`inotify_add_watch` / `notify::Watcher::watch(&Path)`) the sandbox withholds; the one dirfd-relative Linux syscall (`fanotify_mark`) needs `CAP_SYS_ADMIN`, is Linux-only, and has no cap-std binding. Conclusion: keep the graceful-degradation stub. Posted an **inline reply** on `bus-daemon-rust-xs-powers.js:453` and filed durable follow-up **issue #606**.

### Changes / artifacts
- Commit **883533564** pushed to head `factor-watchdirectory-to-endo-platform` (CAS loop).
- Follow-up **issue #606** filed on endo-but-for-bots.
- **Inline reply** (Ask 2): `#discussion_r3525344712`.
- **Top-level summary comment** (SHA + changes + verification): `#issuecomment-4887027250`.
- PR left **draft** (gauntlet/un-draft is a separate step).

### Verification (honest)
- `packages/platform/watch-directory.test.js` — **11 passed** (real `fs.watch`).
- `packages/daemon` `mount.test.js` + `mount-platform-fs-conformance.test.js` — **94 passed**, incl. both new XS tests and the existing real-`fs.watch` mount snapshot test.
- `tsc`: no new type errors from my JSDoc (pre-existing `lint:types` drift is in unrelated packages).
- **Not run here:** the full-daemon `endo.test.js` layer and `test:go`/`test:xs`/`test:rust` — this sandbox has no go/rust/xs supervisor binaries, and the long worktree path exceeds the 108-char unix-socket limit so the daemon socket never materializes (generic; the baseline `lifecycle` boot test fails identically). Reported rather than asserted.

### Follow-ups
- CI on the PR should run `test:go`/`test:xs` (if wired) and the full daemon suite in a proper env.
- Issue #606 tracks the eventual capability-safe Rust watcher paths.
