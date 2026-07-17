---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T10:52:10Z -->

---
model: opus
---
# Stage-8 child 1/6 — daemon-bundle Node-only import fix (README item 1)

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** You are a build child of the serial orchestration
`xs2rust-endor-build-stage8`; report via your tada completion report ONLY (never inbox-send the
parked supervisor). Size: one 2400s invocation.

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor` and reset to
it — the hourly press may have rebased the branch). Push with a rebase CAS loop
(`git push origin HEAD:xs2rust-endor`), verify pushes by git EXIT CODE.

**Task.** The daemon bundler (`packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs`, target
`daemon_bootstrap.js`) currently fails on eager Node-only imports (documented in
`rust/endo/README.md` item 1):
1. `@endo/git`'s `makeNativeGitBackend` imported eagerly by `daemon.js` — make the git backend
   **injectable** the same way `better-sqlite3-xs.js` already is (find that pattern in
   `packages/daemon` and mirror it).
2. A `@endo/platform/fs/lite` path pulls `node:` builtins not in the bundler's
   `EXCLUDED_PACKAGES` — extend the exclusion set to cover that transitive.

**Definition of done:** `yarn install` (repo root; see practical notes), then the daemon bundler
runs to completion and emits `daemon_bootstrap.js` (gitignored — NEVER commit it, nor the other
boot bundles). Behavior of the daemon under Node must not regress: run the relevant
`packages/daemon` unit tests you judge affected (`yarn test` scoped if the full suite is too
big; capture output to a file, check `$?`). Commit ONLY source changes (injectable backend,
bundler exclusions), with clear messages referencing PR #600 stage 8.

**Practical notes:** `$HOME` inside the container is `/home/kris/garden`; `mkdir -p $HOME/tmp`
and redirect long logs there. `/tmp` is noexec. The endo monorepo needs a yarn install; if yarn
is not on PATH there are PATH-shim notes in the repo's memory of prior jobs — a
`corepack`/`yarn` shim under `$HOME/bin` usually suffices. NEVER `git add` `c/moddable` or any
gitignored bundle output. If you cannot finish honestly in one invocation, commit what is done,
report precisely what remains, and mark your report `orchestration-failed: true` ONLY if the
work is actually broken (an honest partial with a clear remainder is a completion — the
supervisor reads your report).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 19
  worker_kind: gardener
  claimed_at: 2026-07-17T10:52:21Z
