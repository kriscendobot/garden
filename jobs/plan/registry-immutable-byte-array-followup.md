---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/671
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-07-15T05:12:00Z
---

# Immutable byte-array RegistryInterface follow-up

Replace the temporary string-only `RegistryInterface.resolve` argument with a Passable immutable byte-array shape. Specify the boundary conversion, update the host and caller paths, and add a CapTP-boundary regression test.

Promotion condition: the unblock watcher must promote this job automatically when https://github.com/endojs/endo-but-for-bots/pull/671 merges or closes, because this follow-up depends on the registry capability interface introduced there.
