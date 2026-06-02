---
ts: 2026-06-02T05:12:45Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - entries/2026/06/02/050200Z-dispatch-steward-79db55.md
  - https://github.com/endojs/endo-but-for-bots/pull/358
---

# result: designer — #358 monolith decomposed into 4 layered designs

Decomposed `designs/daemon-worker-import-from-mount.md` (1164 lines)
into four sibling design documents per kriskowal's CHANGES_REQUESTED
of 2026-06-02T04:59:01Z. Pushed five commits to
`endojs/endo-but-for-bots:design/daemon-worker-import-from-mount`.

## Head SHA after push

`0257affa7` (5 new commits on top of `e72b355ff`).

## Choice on the monolithic file

**Option (c) from the dispatch: repurpose the original
`daemon-worker-import-from-mount.md` as the integration layer.**

Rationale:

- The PR branch slug, the README dependency-graph node id (`dwimp`),
  and the M1 summary-line callout all reference
  `daemon-worker-import-from-mount` by name. Preserving the path
  keeps every external cross-reference valid and the existing PR's
  review history coherent.
- The original document's title and emphasis were already
  integration-flavored ("Daemon Worker `importLocation` from
  EndoMount"); repurposing reads as a focusing pass rather than a
  rename.
- The other three filenames are new and follow the existing slug
  convention (`registry-capability`, `mvs-resolver`,
  `snapshot-mapper`); they sort alphabetically and read cleanly in
  the README summary table.

## Files added / modified / deleted per commit

| Commit | Files |
|--------|-------|
| `3238894b5` design(registry-capability): split EndoRegistry capability shape | add `designs/registry-capability.md` (+445) |
| `139d789be` design(mvs-resolver): split MVS resolution algorithm | add `designs/mvs-resolver.md` (+342) |
| `ae3ed01e0` design(snapshot-mapper): split JS-snapshot to compartment-map-snapshot mapper | add `designs/snapshot-mapper.md` (+392) |
| `d70215728` design(daemon-worker-import-integration): restructure as integration layer | modify `designs/daemon-worker-import-from-mount.md` (-853 / +355; rewritten as integration layer at 666 lines) |
| `0257affa7` design(README): index new layered designs | modify `designs/README.md` (3 new summary-table rows, 3 new M1 rows, 3 new estimates, dependency-graph nodes `dwicap`/`dwimvs`/`dwisnap`, totals updates) |

Diffstat across the five commits:

```
 designs/README.md                          |   71 +-
 designs/daemon-worker-import-from-mount.md | 1208 ++++++++--------------------
 designs/mvs-resolver.md                    |  342 ++++++++
 designs/registry-capability.md             |  445 ++++++++++
 designs/snapshot-mapper.md                 |  392 +++++++++
 5 files changed, 1586 insertions(+), 872 deletions(-)
```

No `packages/` files touched.

## Section-to-layer mapping

The mapping below lists each H2/H3 section from the original
monolith and the layer that now owns it. "Moved" means the content
appears in exactly one place (the new owner). "Stitched" means the
integration layer keeps a one-paragraph version that names the
owning layer and refers the reader to it.

| Original section | New owner | Treatment |
|------------------|-----------|-----------|
| Summary | integration | rewritten as a four-layer-stack table + a paragraph stitching the three sibling layers |
| What is the Problem Being Solved? | integration | kept verbatim; this is the integration-layer motivation |
| Goals | integration | rewritten to reference the layer where each goal lives |
| Non-Goals | integration | kept the integration-layer goals; capability/algorithm/mapper non-goals moved to their layers |
| Where This Sits Among Existing Designs | integration | kept; refined to name the new layers |
| Capability shape > New host method: `makeFromPackage` | integration | moved |
| Capability shape > New host method: `makeFromMount` | integration | moved |
| Capability shape > New formula type: `MakeFromPackageFormula` | integration | moved |
| Capability shape > New daemon capability: `EndoRegistry` | **registry-capability** | moved |
| Capability shape > Interaction model | **registry-capability** | moved |
| Capability shape > Failure surface | **registry-capability** | moved |
| Capability shape > Resolver vs store separation | **registry-capability** | moved (now Open Question #1) |
| Worker dispatch | integration | moved; body refactored to call into the new `mapSnapshot` trio |
| `ReadPowers` synthesis: `makeMountReadPowers` | **snapshot-mapper** | moved verbatim |
| Resolution path: who walks the graph | **mvs-resolver** | moved |
| `mapSnapshot` lane in `compartment-mapper` | **snapshot-mapper** | moved |
| Lockfile interaction: out of scope | **mvs-resolver** | moved (expanded with constraint-pass sketch) |
| Mount snapshot vs live read | **registry-capability** | moved (the capability-side contract); the integration layer keeps the `E(source).snapshot()` call site itself |
| Host special name: `@registry` | **registry-capability** | moved verbatim, including the migration-for-already-formulated-hosts subsection |
| CLI shape | integration | moved |
| XS bridging | integration | moved |
| Architecture diagram | integration | moved (the diagram is the integration view by construction) |
| Phased Implementation > Phase 1 | **registry-capability** + **mvs-resolver** | split; capability Phase 1 lands the exo, algorithm Phase 1 implements MVS |
| Phased Implementation > Phase 2 | **snapshot-mapper** + integration | split; mapper Phase 2 lands `mapSnapshot` and `makeMountReadPowers`, integration Phase 2 lands `makeFromPackage` worker dispatch |
| Phased Implementation > Phase 3 | integration | moved (host method + CLI) |
| Phased Implementation > Phase 4 | integration | moved (snapshot-before-import) |
| Phased Implementation > Phase 5 | **registry-capability** + integration | split; capability layer documents the Rust-backed backend, integration layer stitches it |
| Phased Implementation > Phase 6 | integration | moved (XS-hosted compartment-mapper deferral) |
| Design Decisions > Snapshot the mount before resolution | **registry-capability** | moved |
| Design Decisions > Eager resolution, not lazy per-import | **mvs-resolver** | moved |
| Design Decisions > MVS only in the first cut; lockfile honoring deferred | **mvs-resolver** | moved |
| Design Decisions > `@registry` is host-scoped | **registry-capability** | moved |
| New integration-layer Design Decisions | integration | added: 'One stack, four layers', 'makeFromPackage/makeFromTree share a dispatcher', 'CLI delegates to makeFromMount', 'XS bridging is a deferred phase' |
| Open Questions > Per-condition resolution | **mvs-resolver** | moved |
| Open Questions > Workspace protocol | **mvs-resolver** | moved |
| Open Questions > Private-registry credentials | **registry-capability** | moved |
| Open Questions > `peerDependencies` / `optionalDependencies` | **mvs-resolver** | moved |
| Open Questions > Caching the synthesized `ReadPowers` | **snapshot-mapper** | moved |
| Open Questions > `EndoRegistry` naming | **registry-capability** | moved |
| Open Questions > Resolver / store capability split | **registry-capability** | moved |
| Open Questions > Two-scheme URL split | **snapshot-mapper** | moved |
| Dependencies table | each layer | each layer carries its own dependency table; the integration layer's table cross-links the three sibling layers plus the original external dependencies |
| Prompt | each layer | each layer carries a one-line Prompt tying it to kriskowal's #358 directive; the integration layer also keeps the original 2026-05-22 prompt and notes the 2026-06-02 decomposition |

## Open questions exposed by the decomposition

The decomposition surfaced the following new design choices that
the maintainer may want to weigh in on. None blocks the decomposition
itself; they are clarity items for the next review pass:

1. **`makeFromPackage` vs `makeFromMount` as the primary surface.**
   The CLI uses `makeFromMount` and delegates internally. Should the
   host API documentation pitch `makeFromMount` as the recommended
   entry and treat `makeFromPackage` / `makeFromTree` as advanced
   explicit-shape methods? Captured as integration-layer Open
   Question #1.

2. **`compartment-mapper` extension-point shape.** The
   `snapshot-mapper` design names "one small extension point in
   `packages/compartment-mapper/`" (the package-descriptor walker
   re-export plus a synthesized-URL-scheme hook). The shape of that
   extension point is the one piece of cross-package surface the
   decomposition leaves underspecified; a builder dispatch will need
   to nail it down. This is not raised to an Open Question because
   it is implementation detail to be discovered during builder work,
   but worth flagging now so the maintainer can pre-shape the
   extension point if they have a preferred form.

3. **Sequencing of the four phases.** The integration layer's Phase
   1 / 2 / 3 / 4 / 5 / 6 now delegate to the per-layer phases. A
   builder may want to land all four layers' Phase 1 first (the
   capability + algorithm) as one PR before Phase 2 (mapper +
   worker dispatch), or interleave them. The decomposition does not
   prescribe a single sequencing; the dependency graph allows
   either. The previous monolithic phasing implicitly sequenced
   things; the new layered phasing is the same content but the
   per-layer view may make a different ordering more attractive.

4. **Combined / split capability decision deferred.** The
   resolver-vs-store split (Open Question #1 in
   `registry-capability`) is still listed as a follow-up rather
   than decided. The decomposition treated it as scoped to the
   capability layer; if kriskowal wants the split now, it lands
   cleanly in `registry-capability` without touching the other
   three layers.

## Authorizations honored / declined

- Authorized: created 3 new files under `designs/`, edited the
  monolithic file in place (restructured), edited `designs/README.md`,
  regular append push.
- Declined: no force-push; no `packages/` changes; no review-thread
  resolution; no draft / un-draft state change (PR is currently
  non-draft and remains so); no PR close.

## PR state

PR #358 head moves from `e72b355ff` to `0257affa7`. Draft state
unchanged (per dispatch instruction). The new commits add the
three layered designs and the README index update; the
restructure commit on the monolithic file is a net-negative-line
rewrite (-853 / +355) that preserves the slug for branch and
cross-reference continuity.

Self-improvement: nothing this time. The dispatch was clear, the
project's design conventions (frontmatter table, status field,
markdown line-wrap, mermaid for diagrams) were ready to follow,
and the layer split kriskowal named in the review mapped cleanly
onto the original section structure. No reusable lesson surfaced
that the existing designer role or `prompt-section-discovery`
skill does not already encode.
