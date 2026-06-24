---
ts: 2026-05-22T04:48:47Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
---

# Dispatch: designer authors a daemon-worker `importLocation` design — read modules from `EndoMount`, resolve via npm-registry-proxy + Go-like MVS

Dispatch root: `dispatches/designer--68b800/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

## Maintainer directive (verbatim)

> Do I already have a design document open that describes running a JavaScript program in an Endo Daemon worker using a mechanism like importLocation (Compartment Mapper) but reading from an Endo Daemon mount filesystem? It would depend on the npm registry fetch/cache and Go-like resolution algorithm.

The liaison's audit on `endo-but-for-bots@llm` answered **no — that exact combination isn't in the corpus**. The maintainer's reply was: *"Please do."* — dispatch a designer to author it.

## Prior art the new design integrates

| Design | What it carries forward into the new design |
|---|---|
| [`designs/endor-run-expanded.md`](../../../worktrees/endojs-endo-but-for-bots/.../designs/endor-run-expanded.md) | The Rust-side `endor run` CLI's Phases 4-5 — entry-point + Compartment Mapper from CAS — establish the program-from-entry-point shape this new design ports to the daemon-worker side. **In Progress.** |
| [`designs/endor-npm-registry-proxy.md`](.../designs/endor-npm-registry-proxy.md) | npm registry fetch/cache backed by SQLite + CAS, `select_versions` literally implementing **Go-like MVS** (greatest available version per major satisfying all ranges). The new design reuses this resolver, exposed to the daemon worker via a capability. **In Progress.** |
| [`designs/daemon-make-archive.md`](.../designs/daemon-make-archive.md) | The JS-side daemon-worker entry shape. Phase 7's `makeFromTree` (running a compartment from a readable tree) is the nearest existing rung; the new design adds the rung above it — `makeFromMount` (or whatever name the designer picks) that reads from a live `EndoMount` rather than a static tree, and pulls dependencies from the npm-registry proxy on demand. The new design **explicitly relates** to `daemon-make-archive.md` § Phase 7 — designer decides supersede vs. sibling. |
| [`designs/daemon-mount.md`](.../designs/daemon-mount.md) + [`designs/daemon-mount-capabilities.md`](.../designs/daemon-mount-capabilities.md) | The `EndoMount` formula + capability completion plan. The new design's read-source. Note that mounts may be *live* (Phase 4 sub-mounts, watchers per `designs/filesystem-watchers.md`) — the worker reads from a snapshot or a live mount; the design picks the semantics. |

## Task

Produce a single design document at `designs/<slug>.md` (suggested slug: `daemon-worker-import-from-mount`; designer picks final name). Sections, in the project's `designs/CLAUDE.md` order:

1. **Metadata table** — Created 2026-05-22; Author `Kris Kowal (prompted)`; Status `Proposed`. If the design supersedes `daemon-make-archive.md` § Phase 7 in whole, add a `Supersedes:` row pointing to it; if it sits sibling, do not.
2. **Problem framing.** Why this design exists. The maintainer's question (audit return) frames it: the Rust `endor run` pair covers a similar shape end-to-end, but there's no daemon-worker analog. The forcing functions: (a) JS-side workflows shouldn't have to round-trip through the Rust `endor` CLI for development-loop work; (b) `EndoMount` is the natural read-source for an in-daemon worker that needs to read modules without a static bundle; (c) the npm-registry-proxy already exists as a Rust capability the daemon can expose; reusing it (rather than spawning a parallel JS-side fetcher) keeps the cache coherent.
3. **API surface.** A new daemon-side method, candidate names: `makeFromMount` (matching `makeFromTree`), `runFromMount`, `importFromMount`. Inputs: `mount: EndoMount`, `entryPath: string` (relative to mount root), optional `policy: ImportPolicy`, optional `registry: NpmRegistry` (the proxy capability from `endor-npm-registry-proxy.md`; defaults to the daemon's host-issued registry capability). Output: a worker handle (same shape as `makeBundle` / `makeFromTree`'s output) that the caller can `E(handle).<method>()` against.
4. **The Compartment Mapper invocation.** The design names which Compartment Mapper API the worker invokes — `importLocation` (the canonical entry) is the maintainer's hint; possibly `loadLocation` + `importArchive` if a tree-snapshot step happens server-side. The read-hook closes over the `EndoMount` instead of a `node:fs` URL. The require-hook closes over the npm-registry-proxy capability for `node_modules`-style lookups that fall outside the mount's bounds.
5. **Resolution algorithm.** The design states explicitly that resolution uses **Go-like MVS** per `endor-npm-registry-proxy.md` (greatest available version per major satisfying all ranges). When a mount root has its own `package.json` with dependencies, the design names the policy: do those constrain MVS, are they hints, do they pin? When dependencies-of-dependencies are encountered, the daemon's registry capability fetches them; the design states whether fetch is eager (resolve full tree before any module evaluates) or lazy (fetch on first require). Recommend eager for determinism but surface as a design decision with the alternative.
6. **Capability discipline.** The worker's compartment is the smallest set of capabilities required: read access to the mount, the registry capability (one-way fetch — the worker cannot publish), and whatever the entry-point itself requires. The design picks where SES lockdown runs, who passes `harden`, and what the worker's `globalThis` carries. The pattern from `daemon-make-archive.md` § Phase 7 (the XS bridging subsection) is the reference shape.
7. **Mount semantics.** Snapshot at entry (the worker sees a frozen view of the mount as of the call) vs. live (the worker observes mount edits during execution). Recommend snapshot for first cut — determinism, no module-cache-invalidation problem; cite `designs/filesystem-watchers.md` as the live-mount affordance and mark it as a future variant. The design picks.
8. **Cache coherence.** The npm-registry proxy already caches under content-address; the design names whether the daemon-worker invocation hits the cache or always re-fetches metadata (the `package_meta` row's `fetched_at` is the cache key), and whether `.npmrc` policy (offline, registry-override) is honored or fixed.
9. **Errors and partial states.** What happens when a `package.json` references a version that resolves to no fetchable artifact? When the mount is unmounted mid-execution? When the worker crashes after starting evaluation? The design names the error envelope.
10. **Phased implementation.** Suggested split: Phase 1 — the read-hook over `EndoMount` plus a synchronous tree snapshot at entry; Phase 2 — the npm-registry-proxy hookup (eager resolution); Phase 3 — lazy resolution and live-mount semantics. Designer picks final phasing.
11. **Design decisions.** Numbered list of non-obvious picks: name of the new API (`makeFromMount` vs. alternatives), snapshot vs. live, eager vs. lazy resolution, registry-capability default, MVS-vs-package-lock interaction, where SES lockdown runs.
12. **Dependencies table.** All four prior designs above with one-line annotations stating *depends on*, *generalizes*, or *adjacent*. Relation to `daemon-make-archive.md` § Phase 7 is the decisive one (supersede vs. sibling).
13. **Open questions.** Anything the directive leaves under-specified. Candidates: how the daemon distinguishes "this mount is a JS package" (presence of `package.json`?) from "this mount is a tree of modules with no package metadata", how the new API interacts with the policy mechanism from `endor-run-expanded.md`'s Phase 5, what version-pin precedence applies when a `package-lock.json` is also present in the mount, how the new entry interacts with `daemon-make-archive.md`'s `@node` special name.
14. **Prompt.** Capture the maintainer's verbatim directive under `## Prompt` at the bottom per `designs/CLAUDE.md`.

## Procedure

1. Read `garden/roles/COMMON.md`, then `garden/roles/designer/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md` (the prompt names many domain terms — `importLocation`, `EndoMount`, `npm registry`, `Go-like MVS`, `compartment mapper`, `daemon worker`, `package.json`, `node_modules`, `tree`, `archive` — index on the fly per writeback procedure).
3. Read `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md`, `garden/skills/prompt-section-discovery/SKILL.md`.
4. Read `project/designs/CLAUDE.md` and `project/designs/README.md`.
5. Read **all four prior designs** named in the table above. Take notes; they become the `## Dependencies` table.
6. Read **adjacent designs** referenced by the four above: `daemon-cas-management.md`, `filesystem-watchers.md`, `weblet-next.md` (the Weblet design carries a similar "run JS from a mount-like source" shape, may be a useful cross-reference), `daemon-locator-terminology.md` (locator terminology applies to mount references).
7. Decide on supersede vs. sibling for `daemon-make-archive.md` § Phase 7. If you supersede, add a `Superseded by:` row to that file in the same PR; if you sibling, cross-link and leave the parent alone.
8. Draft the design.
9. Sync `designs/README.md` — new row, milestone assignment (likely M2 daemon-worker tooling or M1 if part of remote-access work; designer's call), dependency-graph edges to the four prior designs and to `daemon-make-archive.md`'s phase-7 box, size estimate (L is likely — this integrates four prior designs).
10. Open as DRAFT PR against `endojs/endo-but-for-bots@llm`. Branch: `design/daemon-worker-import-from-mount` (or your final slug). Title: `design(daemon): importLocation from EndoMount with npm-registry-proxy + Go-like MVS`. Body: cite the maintainer directive, name the four prior designs, summarize the API surface and the supersede/sibling decision, flag the open questions.

## Per-action authorization

Standing on `endojs/endo-but-for-bots`: push to your `design/<slug>` branch, open draft PR against `llm`. No comment authority outside the new PR's body. READ-ONLY on `endojs/endo`.

## Out of scope

- No implementation.
- No edits to existing `packages/daemon/` source.
- No upstream ferry.
- No un-draft.
- No re-rendering of the four prior designs (other than the supersede-side-edit on `daemon-make-archive.md` if you choose supersession).

## Report

≤ 500 words. PR URL + head SHA. The design's file path. The supersede vs. sibling decision (with one-sentence rationale). The chosen API name. The four key design decisions (snapshot vs. live, eager vs. lazy, MVS-vs-package-lock, registry-capability default). Open questions surfaced rather than answered. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-designer-68b800.md` and push journal (rebase if non-fast-forward).
