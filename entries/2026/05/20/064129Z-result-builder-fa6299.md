---
ts: 2026-05-20T06:41:29Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/builder--233e5c/project
---

G8 from #231 review: consolidated daemon stop/purge solution via CapTP.

Branch: `feat/familiar-consolidated-stop-purge` off `origin/llm`.

Commits:

- `b7c62f4a2` feat(familiar): consolidate daemon stop/purge via CapTP control helper (#231 G8)
- `f76d80ea0` chore: Update yarn.lock

PR: https://github.com/endojs/endo-but-for-bots/pull/320 (DRAFT, base `llm`).

Shape: `packages/familiar/daemon-control.js` is a tiny SES-locked-down helper that takes one argv verb (`stop`, `purge`, or `restart`), boots `@endo/init`, and delegates to the matching export of `@endo/daemon`.
Those exports invoke `terminate()` (`packages/daemon/index.js`), which sends a single `E(bootstrap).terminate()` CapTP message over the daemon's Unix-socket harbinger bootstrap and then runs the local cleanup sweep.
The Electron main process now spawns `bundles/daemon-control.cjs` (562 KB) per lifecycle action instead of the 2.7 MB `endo-cli.cjs` bundle.

Subprocess (rather than direct from Electron main) because Electron main cannot import `@endo/init` (SES lockdown freezes Electron internals; per `packages/familiar/CLAUDE.md` § Architecture constraints), and `@endo/captp` relies on `harden` from SES.

PR body labels the work "Deferred per #231 G8" as instructed: the MVR can still ship the existing CLI path; the actual drop of `endo-cli.cjs` from the production runtime ships in a separate followup.

Affected packages: `@endo/familiar` (private). Changeset added.

Lint: clean (one pre-existing `safe-await-separator` warning in `daemon-manager.js` line 309 is unrelated to this change).
Types: pass.
Bundle: builds, `daemon-control.cjs` smoke-tested for unknown-verb rejection and `stop` against a non-running daemon (exit 0).

Self-improvement: nothing this time.
