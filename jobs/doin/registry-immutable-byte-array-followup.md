---
role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-29T02:36:06Z -->

# Immutable byte-array RegistryInterface follow-up

Replace the temporary string-only `RegistryInterface.resolve` argument with a Passable immutable byte-array shape. Specify the boundary conversion, update the host and caller paths, and add a CapTP-boundary regression test.

Promotion condition: the unblock watcher must promote this job automatically when https://github.com/endojs/endo-but-for-bots/pull/671 merges or closes, because this follow-up depends on the registry capability interface introduced there.

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-29T17:22:43Z
