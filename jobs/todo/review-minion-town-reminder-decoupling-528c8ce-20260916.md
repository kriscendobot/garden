---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Review what landed on `kriscendobot/minion.town` main at `528c8ce` — the
decoupling of @endo/reminder from the daemon upgrade. MAINTAINER DIRECTIVE
(kriskowal, liaison muster 2026-09-16): this landed on main WITHOUT a review
surface, so review it now.

WHAT LANDED (job `reminder-daemon-revival-failure`, 2026-09-16). After the
authorized state-revival dry-run failed, that gardener did NOT retry or improvise
a production-state migration. Instead it updated minion.town main at `528c8ce` to:
- keep `@endo/reminder` as the unconfined, VFS-persistent plugin that superseded
  endojs/endo-but-for-bots#609, #617 and #619;
- turn the proven old-VFS store adapter into a REVIEWED/PINNED compatibility path
  with conformance and `@pins` revival coverage;
- treat any future daemon migration as separately authorized operations work.
It also established that the exact missing-`registry` repair exists in CLOSED
draft endojs/endo-but-for-bots#1106 (`fbf0c7f28`), which kumavis explicitly closed
as back-support he likely does not want merged.

REVIEW IT FOR:
1. Does the compatibility path actually hold? The claim is that it is "proven" and
   "pinned" with conformance and @pins revival coverage — verify that coverage
   exists and is load-bearing, rather than taking the claim at its word.
2. Is anything now depending on a pin that will drift? Say what breaks, and when,
   if the daemon or the old VFS store moves.
3. Does the decoupling leave the live daemon in a supportable state, or does it
   defer a cost that grows? The daemon sits at `f6650503`, 1317 commits behind.
4. Is a review PR warranted retroactively for `528c8ce`, given it landed on main
   bare? Recommend.

IMPORTANT CONTEXT — A COMPETING, COMPLEMENTARY PATH NOW EXISTS. Job
`design-endo-legacy-host-registry-migration-20260916` completed in parallel and
landed `designs/endo-legacy-host-registry-migration.md` (main2 `98303c33e5`,
draft review PR kriscendobot/garden#98). It found:
- The crash is TWO Endo-side bugs, not one: `seedFormulaGraphFromPersistence` ->
  `onFormulaAdded` -> `extractLabeledDeps` emits `['registry', undefined]` ->
  `isLocalId(undefined)` -> `parseId(undefined)`. The sibling reader
  `getFormulaGraphSnapshot` already guards this exact case with `if (dep && ...)`;
  the seed path does not. And the incarnator's clean fail-fast ("Host formula
  missing registry") is UNREACHABLE because the seed crashes first.
- The migration Endo asks for already exists ON PAPER and was never built:
  `registry-capability.md` § "Migration for already-formulated hosts" specifies a
  one-shot idempotent per-host backfill. No such pass exists at `0eb88836` or at
  today's `llm` tip (`387ea6614`, verified). What shipped instead was a changeset
  saying the store "must be re-initialized" — i.e. discard the 61 names and 14
  guests.

So: report explicitly whether these two paths CONFLICT or COMPOSE. The plausible
reading is that the decoupling is the correct near-term unblock and the migration
is the durable fix — but say so on evidence, and if one undermines the other, say
which should be reverted. Do NOT touch the live daemon; it stays at `f6650503`.
