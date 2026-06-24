---
ts: 2026-05-20T06:41:29Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

G15 (macOS arm64 + x64 build matrix for familiar) from the design's `designs/familiar-release.md` L387 followups list.

PR: https://github.com/endojs/endo-but-for-bots/pull/321 (DRAFT, base `llm`).
Branch: `feat/familiar-macos-arm64-x64-matrix`.
Commit: `0b2c72fcf` (`ci(familiar): wire macOS arm64 + x64 matrix end-to-end (G15)`).

Affected packages: `@endo/familiar` (scripts only; no source-of-truth code changed) and `.github/workflows/familiar-release.yml`.

Matrix-vs-universal choice: matrix. The release workflow already declared `macos-14` (arm64) and `macos-13` (x64) runners, but two gaps kept the matrix from actually emitting both artifacts: (1) the `make` job invoked `step:make` without ever running `step:package` first (so `make-distributables.mjs` always failed at the appDir existence check), and (2) `package-app.mjs` / `make-distributables.mjs` hardcoded `process.arch` / `process.platform`. The PR adds the missing `package-app.mjs` invocation between prepare and make, plumbs the matrix's `target-os` / `target-arch` through both scripts as optional arguments (matching the convention `download-node.mjs` and `prepare-package.mjs` already used), and embeds the architecture in the DMG filename so the two macOS slices coexist on the release page. The universal-binary path (via `@electron/universal`) stays tracked as the design's multi-day post-MVR followup; the workflow carries an in-place comment naming the choice so a future reader does not have to chase back through the design.

Pre-push gate: `yarn format` and `yarn lint --fix` ran clean on the three changed files; the gate's auto-fixer touched a handful of unrelated daemon / evasive-transform / ses / hex-test files which I reverted to keep the diff scoped to G15. The probes `security-md-hash-uniform` and `no-inline-import-jsdoc` report pre-existing fails outside the diff (missing `packages/endo/SECURITY.md`, daemon/host inline `import()` usage); both are out of scope for a CI-only change. `yarn tsc` on `packages/familiar` is clean.

Self-improvement: nothing this time.
