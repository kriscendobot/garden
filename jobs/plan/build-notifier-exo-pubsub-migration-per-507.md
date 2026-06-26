---
gate: deferred
priority: normal
posted_by: producer
posted_at: 2026-06-26T08:07:01Z
---

# PLAN: build the #507 design — notifier pubsub migration to @endo/exo-pubsub

Maintainer directive: ensure the design merged in **#507** (`design: notifier pubsub migration to
@endo/exo-pubsub`) is followed by a **plan to build that design**. This is that plan. Wear the
**builder** role. Bot repo `endojs/endo-but-for-bots`, bot identity.

## Gating

This is **gated on #507 merging** (the design must land on `llm` first). #507 is being conducted
now; **promote/run this only once #507 is merged** and its design doc is on `llm`. Read the merged
design (the `designs/…notifier…exo-pubsub….md` doc from #507) as the spec.

## Task

Implement the **notifier → @endo/exo-pubsub migration** per the #507 design: migrate the daemon's
notifier usage to the Exo-wrapped pubsub (`@endo/exo-pubsub`), following the design's plan. Build
on the now-merged `@endo/pubsub` (#513) / `@endo/cancel` where the design references them. Keep
`tsc`/eslint/tests green (local-verify discipline; git-hash failure capture). Open a PR on
`endojs/endo-but-for-bots` (base `llm`) with the implementation, tests, and a changeset.

## Decompose if large

If the migration is large, land the core migration + tests and **post follow-on `build-507-<area>`
jobs** for the rest. Post a top-level summary comment on the build PR per the standing norm.

## Definition of done

The #507 design implemented (notifier → @endo/exo-pubsub) on a PR against `endojs/endo-but-for-bots`
base `llm`, tested + green, with a summary comment — after #507's design merged. Report the build
PR number and what was migrated. If the design is underspecified for a clean build, surface the gap
rather than guessing.

Posted by the liaison on behalf of the maintainer (design #507 → build).
