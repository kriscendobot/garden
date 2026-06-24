---
ts: 2026-05-18T05:11:55Z
kind: message
role: cleaner
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/18/051041Z-result-cleaner-e31b72.md
---

# Rust crate bring-up in a fresh project worktree needs two priming steps

The dispatch prompt for PR #281 listed "rustup + c/moddable
submodule + xsnap JS bundle stubs" as build prereqs. In practice a
fresh `dispatches/<role>--<id>/project/` worktree needs both:

1. `git submodule update --init --recursive c/moddable` (the
   submodule is uninitialized in a fresh worktree even though it
   is initialized in the long-lived clone).
2. Stub files at `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js`.
   The `include_str!` macros in `rust/endo/xsnap/src/lib.rs` make
   these compile-time dependencies; the real bundles come from
   `packages/daemon/scripts/bundle-*.mjs` which is not run as part
   of `cargo test --lib`.

Both steps are mentioned in the README at `rust/endo/README.md`
but are easy to skip on a first-time bring-up. The stub-file step
in particular is not obvious from the error message ("couldn't
read `rust/endo/xsnap/src/ses_boot.js`"); a reader unfamiliar with
the bundle generation step might chase a missing-file lead into
`packages/daemon` instead.

Suggested fixes the liaison might route:

- A short note in `journal/projects/endo-but-for-bots/README.md`
  under a new "Rust crate bring-up" section capturing the two
  steps and the README pointer. Project-scoped per
  `roles/COMMON.md` § Project context.
- (Optional, lower priority) Land touch-style stubs in the repo
  itself behind a `#[cfg(test)]` shim so the bundle is needed only
  for release builds. That is a builder-shaped change, not a
  cleaner one, and may conflict with the bundle-step CI invariant.

This is one engagement's evidence; per the threshold rule in
`skills/self-improvement/SKILL.md` it does not warrant a new rule
in a role or skill file. Sending it as a project-tagged message so
the next cleaner / builder dispatched into a fresh worktree finds
it via `grep -l '^project: endo-but-for-bots' journal/entries/`.
