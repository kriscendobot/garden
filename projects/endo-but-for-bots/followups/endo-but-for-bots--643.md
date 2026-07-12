---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 643
created_at: 2026-07-12T05:31:24Z
last_appended_at: 2026-07-12T05:31:24Z
status: parked
---

# Follow-ups for endo-but-for-bots#643

## Items

- [ ] daemon.js:2613-2614 `assertValidId(from)`/`assertValidId(to)` is a runtime hardening (malformed persisted message formulas now throw on reincarnation) unrelated to the path-types refactor and shipped with no regression test.
  **Source seat(s)**: assessor, prover, saboteur, breaker, purist, wire-watcher, locksmith
  **Round**: 1
  **Recommended action**: at merge, split the assert into its own commit or add a pinning test that reddens if the two asserts are removed.

- [ ] packages/exo-git/src/interfaces.js deliberately-untagged `M.remotable()` returns lack a rationale comment.
  **Source seat(s)**: integrator, migrator, wire-watcher, spec-keeper, breaker
  **Round**: 1
  **Recommended action**: add a one-line comment explaining the untagging admits multiple minters (writable mount or read-only ReadableTree), so a future reader does not re-tag it as an oversight.

- [ ] EndoMountStat now enumerates kind 'file' | 'directory' | 'symlink' but only 'file' is exercised (mount.test.js:315).
  **Source seat(s)**: corner-prober
  **Round**: 1
  **Recommended action**: add a two-line stat() assertion for a directory (and symlink) to pin the corner the new type documents.

- [ ] Head commit c089e3f8 is an unsquashed `fixup!` (pure prettier reflow); daemon types.d.ts carries incidental exports (LeastAuthorityFormula, KnownPeersStoreFormula, an @endo/exo-git re-export block); exo-git back-compat aliases would benefit from a one-line JSDoc pointing at the daemon superset.
  **Source seat(s)**: releaser, scribe, changeset-auditor, assessor, gateway, spec-keeper, migrator
  **Round**: 1
  **Recommended action**: at merge, `git rebase --autosquash` for chain cleanliness (squash-merge collapses it regardless); add the justification/JSDoc notes if a follow-up PR touches these files.
