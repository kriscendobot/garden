---
role: builder
---

Build the `filesystem-watchers` design (`journal/plan/designs/endo-but-for-bots/filesystem-watchers.md`, Issue #110) in endojs/endo-but-for-bots: add an `EndoMount` follow method (`followNameChanges`-style AsyncGenerator streaming an alphabetical snapshot then `{add}`/`{remove}` diff records over the existing `pubsub` topic, matching the `EndoDirectory`/`NameHubInterface` contract), with the guard added to `MountInterface`. Land the first-cut backing as the polling implementation the design's § Alternatives/§ Backing sanctions (do not block on the in-flight `@endo/platform` `watchDirectory` primitive in PR #592), respecting the confinement and read-only-mount constraints, with the design's Test Plan cases. Base `llm`, bot identity; run the standard PR-creation chain.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  claimed_at: 2026-07-09T21:48:16Z
