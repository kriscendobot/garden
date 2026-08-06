---
gate: go-ahead
priority: normal
posted_by: fixer
posted_at: 2026-08-06T06:35:59Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Make `packages/daemon`'s XS **daemon** bundle build again, on `llm`.

`rust/endo/xsnap/src/lib.rs` `include_str!`s three generated sources
(`ses_boot.js`, `worker_bootstrap.js`, `daemon_bootstrap.js`).  None of
the three is tracked, and `rust/endo/xsnap/build.rs` does not generate
them, so they come only from `yarn --cwd packages/daemon bundle:xs`.
That command cannot produce `daemon_bootstrap.js` on current `llm`,
which means **`cargo build -p xsnap` fails on a clean `llm` checkout**.
`llm` has no Rust/XS CI workflow, so nothing notices; the workflow
endojs/endo-but-for-bots#124 adds (`.github/workflows/rust.yml`) is what
surfaced it.  Every import below is `llm`'s own and byte-identical on
`llm` and on the `slot-machine` branch, so this is not #124's
regression -- but #124 cannot go green until it is fixed.

Reproduce (about 90 seconds, no Rust needed):

    yarn --cwd packages/daemon bundle:xs

The ses-boot and worker bundles write; the daemon bundle throws with 16
underlying "Cannot find external module" failures.

Root cause.  `bus-manager-rust-xs.js` imports `./manager.js`, whose
static imports reach three Node-only surfaces:

1. `@endo/git` (`makeNativeGitBackend`, manager.js:24) -- node:fs,
   node:child_process, node:crypto, node:util, node:process,
   node:timers, node:url, node:path, node:buffer.  Used only inside the
   `git` formula maker.
2. `@endo/host-spawner` (`makeHostSpawner`, manager.js:34) --
   child_process, node:fs/promises, path.  Used only inside the `shell`
   formula maker.
3. `@endo/exo-git`, which imports `readOnly` and `wrapBackend` from the
   `@endo/platform/fs/extended` **barrel**
   (`packages/exo-git/src/git.js:7-10`).  The barrel re-exports
   `backends/node-fs-backend.js` (node:fs, node:fs/promises,
   node:path), and `wrap-backend.js` reaches
   `shared/blob-ref.js`, which imports `createHash` from node:crypto.

Note that no dependency-graph pruning can fix any of these: they are
reached by static import.  #124 removed the daemon bundler's
`EXCLUDED_PACKAGES` hook after measuring it to be a no-op (see the
review thread at
https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548845562),
so do not reintroduce one.

Likely shape of the fix, to be settled with the maintainer before
building:

- (3) is the cheap half: deep-import `@endo/platform/fs/extended/readonly.js`
  and `.../wrap-backend.js` from `@endo/exo-git` instead of the barrel,
  which sheds `node-fs-backend.js` outright.  The residual `createHash`
  in `shared/blob-ref.js` still needs an answer -- inject the hash, or
  give `@endo/platform` an `xs` export condition for it.
- (1) and (2) are host-authority seams that the daemon already injects
  for its sibling tiers ("its root authority is a host-owned `fetch`
  (and `now`) seam, injected here in the daemon (host) process exactly
  as the shell maker injects its host spawner" -- manager.js, the
  `http-client` formula).  Making `makeNativeGitBackend` and
  `makeHostSpawner` injected powers rather than static imports would
  match that existing pattern and is the change with the widest blast
  radius; agree it with kriskowal first.

Definition of done: `yarn --cwd packages/daemon bundle:xs` writes all
three bundles and exits 0 on `llm`, and `cargo build -p xsnap` succeeds
from a clean checkout after it.  Then flip `continue-on-error` to
`false` on the "Generate XS bootstrap bundles" step of
`.github/workflows/rust.yml` (on #124, or after it merges), and report
back on #124 so it can un-draft.
