---
role: builder
---

Build the `filesystem-watchers` design in endojs/endo-but-for-bots (M3): add a `followNameChanges(...pathSegments)` method to `EndoMount` emitting a snapshot-then-diff stream over `pubsub` (NameHub-compatible), backed by a new `watchDirectory` primitive on `FilePowers` wiring `node:fs.watch` with an `fs.watchFile` polling fallback — bringing EndoMount to subscription parity with `EndoDirectory`, per the design's Design/Multiplexing/Lifecycle/Test Plan sections. Open as a fresh draft PR on base `llm`.
