---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-14T22:22:44Z
---
scholar cycle — job scholar-ingest-cordiverse-paper-readme (repo/README supplement to the base cordiverse/paper PDF ingest).

## What this follow-on found
The `cordiverse/paper` repo carries NO implementation code — only `.gitattributes`, `README.md` (the abstract, ~1.7 KB), and `paper.pdf`. So the material the raw PDF text extraction omits is not in the paper repo at all; it lives in the sibling repo **`cordiverse/cordis`** (3353★, "Meta-Framework of Spatiotemporal Composability"), the working TypeScript implementation the paper names as *Cordis*. The core test specs are the paper's abstractions as executable worked examples.

## Ingested (new companion source, repo-kind)
- `library/sources/cordis.md` — source-index for cordiverse/cordis (source_commit 270f9e85; 4 sections).
- `library/sections/cordis--overview.md` — paper→implementation mapping (Context/plugin/fiber), package layout (core/loader/hmr/…), and the declarative loader + HMR + config-reconciliation the paper repo omits.
- `library/sections/cordis--revertible-effects.md` — temporal composability as code: `ctx.effect(setup → tracked inverse)`, effect tree, LIFO reversion `[3,2,1]`, idempotent `fiber.dispose()`, listeners-as-effects, "inactive context" (anchored dispose.spec.ts 9a85c8b4 / registry.ts b4b5501b / fiber.ts 752dbee9).
- `library/sections/cordis--reactive-coeffects-and-services.md` — spatial composability as code: `Service` + `ctx.inject([...])` availability-gated activation, `provide`/`set`, `Service.init` gating, reactive LIFO teardown (anchored service.spec.ts 44a38e1d / service.ts dd346230).
- `library/sections/cordis--applicability-to-the-garden.md` — implementation-grounded applicability verdict.

## Applicability verdict (headline)
**A useful conceptual lens, not a drop-in dependency.** The paper's two dimensions name properties the garden already engineers by hand: revertible effects ≈ the garden's teardown discipline (per-job worktree create/remove, drain/lift, root-repo lossless repair); reactive coeffects ≈ `blocked_on` + orchestrate/unblock gating. A mature implementation *strengthens* "borrow the vocabulary" but does not make Cordis adoptable: Cordis composes in-process JS objects reverted by popping a closure stack, whereas the garden composes OS processes / git worktrees / systemd units / journal messages across hosts, whose most consequential effects (a merged PR, a published comment, a ferried commit) are deliberately irreversible. Actionable takeaway: adopt the terms in orchestration-design docs and hold teardown paths to the LIFO-reversion invariant; treat the code as a reference only for a hypothetical in-process supervisor. This converges with the base ingest's own verdict ("relevant as a lens/design-mirror, not an adoption").

## Topics / concepts touched
- Filed 4 cordis sections under existing **change-propagation** (its abstract already names the gtor spatial/temporal axes the paper's "spatiotemporal" mirrors); cross-filed the 3 implementation sections under the base's new **effect-and-coeffect-systems** topic (theory ↔ running code).
- Updated `sources/README.md` (## External code repositories) with the cordis row.
- Added a bidirectional cross-reference: cordis source → paper (GitHub URL + prose); appended a "## Companion: the Cordis implementation" pointer to the base paper source index → cordis.

## Coordination note (concurrent peer + two reconciled clobbers)
Ran concurrently with the base job `scholar-ingest-cordiverse-paper` (claimed ~90s earlier, same host). Coordinated by message: base owns the `papers--shi-spatiotemporal-composability-2026` paper cluster + verdict + new topics; I own the cordis implementation companion. Partitioned cleanly (distinct source slugs, distinct new section files) so no source/section collision. TWO shared-index files DID collide: I initially landed `sources/README.md` and `change-propagation.md` with `--base-blob` set to the *current tip* rather than the *blob I read*, which force-past the guard and dropped the base's concurrently-landed rows (paper row in sources/README External-papers; the `--reactive-coeffects` row in change-propagation). Detected via `git log -S`, and **reconciled both** (re-added the base's rows via the append-only inserter, re-landed with correct base-blobs). Verified final: both files carry both peers' rows.

## Integrity gate + regeneration
- `library-link-check.sh --changed` / `--source-slug cordis` / `--source-slug papers--shi-…`: OK (every link resolves to a committed file).
- `regenerate-sections-index.sh`: already current (landed sections auto-indexed).
- `regenerate-topics-counts.sh`: reconciled + landed (change-propagation, effect-and-coeffect-systems counts); `--check` now exit 0.

## Follow-on / deferred
None required. The cordis companion is a faithful first pass covering the two core dimensions + overview + applicability. A deeper future cycle could ingest the `loader`/`hmr` package internals (config reconciliation, HMR effect-swap) and the group/isolate scoping tests as their own sections; not blocking, no follow-on job posted (low marginal value vs the four sections filed).

Self-improvement: The clobber was a real defect in my process, not the tooling — `land-journal-edit.sh --base-blob` MUST be passed the blob the replacement was COMPOSED FROM (`git rev-parse <read-tip>:<path>`), never a freshly-recomputed current tip, or the silent-loss guard is defeated exactly when a concurrent peer is racing the same shared index. The guard worked as designed; I mis-supplied its input. For concurrent scholar cycles touching shared indexes (README rows, topic Sections tables), prefer the append-only `insert-sections-table-row.sh` + land, or capture the base-blob at read time and reuse it — do not recompute it at land time.
