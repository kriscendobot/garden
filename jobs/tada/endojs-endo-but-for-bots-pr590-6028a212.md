All work is complete and verified. Inbox is empty; PR #660 is open, non-draft, and mergeable.

## Completion report

**Job:** attention directive from @erights on endojs/endo-but-for-bots #590 — "simplify all other inter-package re-exports according to the agreed design in #548."

**Preflight:** Recheck preflight returned PROCEED (no peer resolution). #590 (the `@endo/far` stage-1 slice) is merged; the directive asks for the remaining plain-re-exporter slices #590's body enumerated.

**What I did** — opened **PR #660** (base `llm`) doing the three sibling slices with #590's identical recipe (repoint importers → originating package, deprecate the re-export with `@deprecated` JSDoc, add workspace deps):

- **`@endo/marshal` slice:** deprecated `export * from '@endo/pass-style'` and `deeplyFulfilled`; repointed **31 files** importing pass-style-origin names (`Far`, `Remotable`, `passStyleOf`, `makeTagged`, `isPassable`, `isObject`, `getTag`, the `Passable` type) off `@endo/marshal` onto `@endo/pass-style`. Added `@endo/pass-style` to `goblin-chat` (dependencies) and `ocapn-noise` (devDependencies).
- **`@endo/captp` slice:** deprecated `Nat`, `export * from '@endo/marshal'`, and the `E` re-export; repointed the 4 `@endo/exo-stream` captp tests importing `E` onto `@endo/eventual-send`. (Discovered the `E` re-export — not in #590's enumeration but a genuine plain re-export — and included it.)
- **`@endo/patterns` slice:** deprecated `export type { FullCompare } from '@endo/marshal'` (no in-repo importers → deprecate-only).

Three changesets (patch on each re-exporter; no consumer bumped — no runtime binding changes). Two commits: the refactor + a separate `chore: Update yarn.lock`.

**Verification:** ESLint **0 errors** across all changed files (confirms all repoints resolve and deps are declared); Prettier clean; `tsc --build` composite **clean** for marshal, captp, patterns, ocapn, exo-stream, goblin-chat, ocapn-noise, daemon; `@endo/exo-stream` captp runtime tests **pass under real SES** (exercising the repointed `E`). Full suite left to CI, as #590 documented for this sandbox.

**Codemod caveat surfaced/fixed during work:** two regex bugs (over-matching across a preceding import; matching inside JSDoc `@import`) were caught and fixed before landing; final diffs verified by re-scanning that zero in-repo importers still pull a plain-re-exported name through the re-exporter.

**Follow-ups / open questions (raised, not acted on):** flagged 3 further cross-package `export … from` edges I was unsure are *plain* re-exports — `@endo/init`'s `export * from '@endo/lockdown/*'` (import-for-side-effect entry point), `@endo/spaces-util`'s `assertValidLocator` from `@endo/daemon`, and `@endo/pass-style`'s `Checker` type from `@endo/common`. Documented in #660's body and in a reply on #590, **tagging @erights** per his "if uncertain, ask" instruction. Will fold any in if confirmed in scope. The breaking stage-2 removal remains deferred to the next major per the design.
