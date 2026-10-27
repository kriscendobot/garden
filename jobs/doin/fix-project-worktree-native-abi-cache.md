---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Make project-worktree warm caches safe across Node ABIs

The `claude-api-p1-registry` job observed that `ensure-project-worktree.sh` restored a `better-sqlite3` native binary built for `NODE_MODULE_VERSION 137` into a Node runtime requiring ABI 127. Real daemon restart acceptance failed until `yarn rebuild better-sqlite3` ran in the isolated project worktree.

Implement the maintainer's chosen probe-then-rebuild fix in `scripts/jobs/ensure-project-worktree.sh`:

- stamp warm caches with the Node module ABI;
- after restore/link, probe each present native module, starting with `better-sqlite3` (exercise actual database construction, since requiring the package alone may load lazily);
- on ABI mismatch or `NODE_MODULE_VERSION`, rebuild the module only in the per-job worktree, never mutate the shared cache;
- use the classic node-modules workaround only if rebuild hits the known EMLINK/native-build abort, remembering that disabled scripts require an explicit rebuild;
- add deterministic regression coverage for matching and mismatched ABIs and document the emitted cache/rebuild signal.

Land the garden change to `main2` with the normal locked rebase/CAS push.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T05:39:03Z
