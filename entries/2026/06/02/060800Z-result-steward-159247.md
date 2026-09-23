---
ts: 2026-06-02T06:08:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/055200Z-dispatch-steward-159247.md
  - entries/2026/06/02/060529Z-result-designer-a56206.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
---

# result: designer r2 chain on #358 — answers incorporated, caching/retention scope added, 8 threads resolved

The designer round-2 chain to incorporate kriskowal's CHANGES_REQUESTED
answers on #358 (8 inline directives + new caching scope) completed
cleanly.

## Designer outcome (result `a56206`)

- **Five commits** atop `0257affa7` (head `affa19d32`):
  1. `aa9a9a5d4` — `design(registry-capability): conflate @registry
     slots; drop credentials; add caching+retention scope (round-2)`.
     New **Caching and retention** section (transparent refetch,
     bounded LRU+size cap growth, hard retention link from
     snapshot-mapper CAS captures). Two new Phase-1 tests.
  2. `4e875c5d6` — `design(mvs-resolver): drop conditions from dep-graph
     scope; add workspace resolution; expand test scope (round-2)`.
     Workspace resolution: search parent package.json with workspaces
     enabled. peerDependencies + optionalDependencies in scope. Five new
     Phase-1 tests. `condition?:` dropped from `EndoRegistry.resolve`;
     `workspaceRoot?:` added.
  3. `108e17f01` — `design(snapshot-mapper): adopt archive precedent
     for layout; drop endo-mount: URL scheme; link to registry caching
     (round-2)`. Structural rewrite: top-level `compartment-map.json` +
     peer directories (`<name>@<version>/` registry-resolved, bare
     `<name>/` workspace members). `endo-mount:` URL scheme dropped
     entirely. node_modules layout dropped. Two new Phase-2 tests.
  4. `e78e052ba` — `design(daemon-worker-import-integration): reflect
     snapshot-mapper layout change (round-2)`. read() signature,
     importLocation entry-specifier shape, architecture diagram
     alt-branches updated. Conditions threading moved from
     mapSnapshot/resolve to importLocation (link time, not graph time).
  5. `affa19d32` — `design(README): sync stale endo-mount: /
     node_modules prose`. Three references across overview + summary
     table + size-estimate table. No dependency-graph node/edge changes.
- **Inline-comment-to-commit map**:
  - snapshot-mapper:362 → `108e17f01`
  - snapshot-mapper:371 → `aa9a9a5d4` (caching) + `108e17f01` (cross-link)
  - registry-capability:422 → `aa9a9a5d4`
  - registry-capability:408 → `aa9a9a5d4`
  - registry-capability:397 → `aa9a9a5d4`
  - mvs-resolver:323 → `4e875c5d6`
  - mvs-resolver:314 → `4e875c5d6`
  - mvs-resolver:300 → `4e875c5d6`
- **New open questions surfaced**: two implementation-detail notes
  (workspace-root discovery memoization; workspace-vs-registry
  coexistence test). Neither rises to a design open question; captured
  inline.

## Steward post-designer actions

- **Posted summary comment**:
  https://github.com/endojs/endo-but-for-bots/pull/358#issuecomment-4599189969
  — maps the 8 round-2 inline directives to the addressing commits +
  filenames.
- **Resolved 8 round-2 threads**:
  - `PRRT_kwDORRE4FM6GUx10` (mvs-resolver:300)
  - `PRRT_kwDORRE4FM6GUyde` (mvs-resolver:314)
  - `PRRT_kwDORRE4FM6GUyxX` (mvs-resolver:323)
  - `PRRT_kwDORRE4FM6GUz0-` (registry-capability:397)
  - `PRRT_kwDORRE4FM6GU0NU` (registry-capability:408)
  - `PRRT_kwDORRE4FM6GU0mk` (registry-capability:422)
  - `PRRT_kwDORRE4FM6GU24X` (snapshot-mapper:362)
  - `PRRT_kwDORRE4FM6GU4gB` (snapshot-mapper:371)
- **Older daemon-worker-import-from-mount.md threads** (10 unresolved
  pre-decomposition) NOT touched — those are from earlier rounds, may
  carry context the maintainer wants to keep open until full
  re-review.

## Cleanup

`dispatches/designer--159247` torn down.

## Next

Watch for maintainer re-review on #358 round-2.

## Steward queue post-engagement

- **#358** round-2 landed; 8 new threads resolved; CI pending; awaiting
  maintainer re-review.
- **#387** retcon landed; clean 2-commit shape; DRAFT; awaiting re-review.
- **#379** parity infrastructure landed; awaiting re-review.
- **#390** rename PR APPROVED + un-drafted; awaiting kumavis/0xpatrickdev.
- **#345, #382** MERGED.
- **#244** REOPENED with rebase+reshepherd ask; pending steward
  engagement.
- **#343** CHANGES_REQUESTED with systemd-install + 4 inline fixes;
  pending engagement.
- **#388, #389, #392, #393, #394, #395, #396, #397, design/gateway-
  package-phase-7/8/9** kriscendobot gateway-stack DRAFTs;
  parallel-orchestrator domain.
- **#377** awaiting kriskowal reply.
- **#357** APPROVED, UNSTABLE.
- **#335, #329, #231, #138, #241, #320, #79** unchanged.
- **kriskowal/garden#3** CHANGES_REQUESTED on two reviews; awaits user
  alignment.
