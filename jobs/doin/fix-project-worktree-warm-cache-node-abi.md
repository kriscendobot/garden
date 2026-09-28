---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer

Repo: kriscendobot/garden, main2 (garden's own repo; land directly). Reported by a gardener on the liaison bus (msgs/role/liaison/20260928T225008Z-2309c1.md, from endolin-garden-ece02cb4) while it was working on https://github.com/endojs/endo-but-for-bots/pull/1343. Routed by the endolin-garden2 liaison.

**Defect:**
- `scripts/jobs/ensure-project-worktree.sh` reported a warm native-build cache hit built for Node ABI 127 (Node 22).
- `local-verify.sh` then, correctly, switched to the repository-pinned Node 24 (ABI 137).
- So every daemon-backed CLI test failed to load `better_sqlite3.node`.
- The targeted suite passed under Node 22, and CI (26 checks) was green. The failure was purely local-verification infrastructure.

**Fix:** key the warm native caches (and any cached `node_modules` native builds) by the Node runtime and ABI that local verification will actually select, or rebuild them for that runtime. Concretely:
- resolve the repo-pinned Node version (`.nvmrc`, `engines`, `volta`, or the same logic local-verify.sh uses) BEFORE the cache lookup;
- include `process.versions.modules` (the ABI) in the cache key;
- on mismatch, `npm rebuild` / `yarn rebuild` the native modules (better-sqlite3 at minimum) under the selected runtime;
- have ensure-project-worktree.sh and local-verify.sh share one runtime-selection helper so they can't disagree again.

Add a test that reproduces the mismatch (a cache populated under one ABI, then verification under another) and proves the rebuild or re-key. Note the related garden memory: ebfb's floating Node 24.x plus better-sqlite3 has bitten CI before.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-28T22:52:12Z
