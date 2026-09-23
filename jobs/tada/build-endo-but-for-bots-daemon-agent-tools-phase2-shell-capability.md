Draft PR #615 confirmed (draft, base `llm`, open). Inbox is empty. The job is complete.

## Completion report

**Job:** Builder — daemon-agent-tools **Phase 2 (Shell capability)** on `endojs/endo-but-for-bots`, base `llm`.

**Delivered:** Draft PR **#615** → base `llm`, branch `builder/daemon-agent-tools-phase2-shell`.

### What I built
- **`@endo/exo-shell` (new, portable exo — mirrors `@endo/exo-git`):** `makeShell({ cwd, policy, spawner })` + `ShellInterface`. Enforces allowlist-before-spawn, argv-only (no shell string), sanitized env, per-stream output cap (`truncated`), narrow-only per-call timeout with kill; `inspect()` hides cwd/env/searchPath; refuses a read-only mount.
- **`@endo/host-spawner` (new):** the `Spawner`/`makeHostSpawner` seam **extracted verbatim from `@endo/genie`** so the daemon reuses the exact engine without a dependency cycle (genie → daemon). Genie's `src/tools/spawner.js` is now a thin re-export shim — all genie importers and `Spawner` type refs unchanged.
- **`@endo/daemon`:** net-new `provideShell(mountCap, petName, policy)` mirroring `provideGit` — writable-mount-only (early reject + reincarnation defense), cwd resolved host-side from the mount backing, formula-owned policy baked into a persisted `shell` formula, executed through the host spawner. Wired the `shell` formula type/maker, `formulateShell`, the `EndoHost` guard, and full `types.d.ts` surface.
- **`@endo/agent-tools`:** `makeShellTool(shellCap, { rejectPatterns, rejectFlags })` emitting `exec`/`inspect` `ToolRecord`s over hand-authored schemas pinned to `ShellInterface` by a divergence gate; genie's policy closures ported as advisory tool-layer inputs.

### Verification
- New test suites all pass: exo-shell hardening (9), daemon composition over a real mount (5), agent-tools schema⟷guard divergence + dispatch/veto (6). Existing agent-tools/git and genie spawner suites still green (genie's one real-`kill()` test times out — environmental sandbox restriction, not a regression; `host-spawner.js` is byte-identical to genie's original).
- `@endo/agent-tools` `tsc` clean, `@endo/daemon` `tsc` clean, all changed files lint with 0 errors. Composite tsconfigs need no update (new packages lack `tsconfig.build.json`, like `exo-git`).

### Follow-ups (deferred, noted in PR)
- Phase 2c: sandbox-spawner engine behind a `provideShell` option (kernel boundary).
- Streaming stdio for long-running processes.
- CLI grant surface / form-based provisioning (Phase 4).
- Full daemon-boot integration test (blocked here only by native sqlite build in the sandbox).
