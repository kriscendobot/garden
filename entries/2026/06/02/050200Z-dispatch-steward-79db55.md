---
ts: 2026-06-02T05:02:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--79db55
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/358
---

# dispatch: designer — #358 decompose monolithic design into 4 layered designs

kriskowal CHANGES_REQUESTED on #358 at 2026-06-02T04:59:01Z:

> Please decompose this design into layers:
> * Registry capability
> * MVS resolver
> * JS snapshot to compartment-map snapshot mapper
> * Integration
>
> Or layers as you see fit that roll up to the design as stated.

## Task

The existing monolithic design at
`designs/daemon-worker-import-from-mount.md` (1164 lines, 23 H2/H3
sections covering capability shape, worker dispatch, ReadPowers synthesis,
resolution path, mapSnapshot, registry naming, CLI, XS bridging,
architecture, and 6 phased implementation steps) should be decomposed into
~4 layered design documents that roll up to the same vision but factor
out the independently-reviewable concerns.

### Proposed layering (kriskowal's named layers; adjust if you find a
cleaner factoring)

1. **Registry capability** — defines the `EndoRegistry` capability shape,
   `@registry` host special name, snapshot vs live read semantics, and the
   Rust-backed-future-implementation roadmap (Phase 5). The "what the
   registry is and what it offers" layer.

2. **MVS resolver** — the Go-like Minimum Version Selection algorithm
   adapted to JS package versioning, including the lockfile-interaction
   stance (out of scope) and the resolution-path question. The "how
   imports get pinned to specific versions given a registry" layer.

3. **JS snapshot → compartment-map snapshot mapper** — `mapSnapshot` in
   compartment-mapper, the `ReadPowers` synthesis layer
   (`makeMountReadPowers`), and the npm-shape ↔ compartment-map-shape
   translation. The "how registry+MVS state becomes a compartment-map
   snapshot" layer.

4. **Integration** — the `importLocation`-from-EndoMount surface, worker
   dispatch, CLI shape, `makeFromPackage` host method, XS bridging, and
   the architecture-diagram view. The "how the layered pieces come
   together at the daemon-worker surface" layer.

### Procedure

1. Read `designs/daemon-worker-import-from-mount.md` fully.
2. Read `designs/README.md` to understand the index format.
3. Read sibling designs in `designs/` to match the doc structure
   conventions (frontmatter table, section ordering, status field).
4. For each of the 4 layers, create a new design doc:
   `designs/registry-capability.md`,
   `designs/mvs-resolver.md`,
   `designs/snapshot-mapper.md`,
   `designs/daemon-worker-import-integration.md` (rename suggestions —
   pick names consistent with existing patterns).
   Each new doc should:
   - Carry its own frontmatter table (Created, Updated, Author, Status).
   - State its own goals / non-goals scoped to that layer.
   - Cite the other layered designs as dependencies in a "Related" or
     "Where this sits" section.
   - Reproduce or move (your judgment) the relevant subsections from the
     monolithic doc. Prefer move (each section ends up in exactly one
     place) over reproduce (avoid drift). The phased-implementation
     section may need per-layer breakouts.
5. Either: (a) update the original `daemon-worker-import-from-mount.md`
   to become a short top-level "Overview" linking the 4 layered docs and
   summarizing how they roll up; (b) delete the original and add a
   "Daemon Worker importLocation from EndoMount" entry to designs/README
   that links the 4 layered designs as a stack; or (c) keep it as the
   integration-layer doc (option 4 above) and merge the
   integration-layer content in. Pick the cleanest option and document
   the choice.
6. Update `designs/README.md` to index the new docs in the correct
   alphabetical/topical order.
7. No code changes — `packages/` should remain untouched.

### Verification

- `git grep -n 'designs/daemon-worker-import-from-mount'` in `designs/`
  → all references point to current files (no broken cross-references).
- `git log -p --stat HEAD~..HEAD` on each commit shows a clean per-layer
  factoring.

## Commit structure

Suggested split (one commit per layer + index update):

1. `design(registry-capability): split EndoRegistry capability shape out
   of daemon-worker-import design`
2. `design(mvs-resolver): split MVS resolution algorithm out of
   daemon-worker-import design`
3. `design(snapshot-mapper): split JS-snapshot→compartment-map-snapshot
   mapper out of daemon-worker-import design`
4. `design(daemon-worker-import-integration): restructure as integration
   layer over registry/MVS/mapper`
5. `design(README): index new layered designs` (or fold into 4)

Commits under endolinbot identity. Push regular append (no force) to
`endojs/endo-but-for-bots:design/daemon-worker-import-from-mount`.

## Per-action authorizations

- Create new files under `designs/`. Authorized.
- Edit `designs/daemon-worker-import-from-mount.md` (restructure or
  remove). Authorized.
- Edit `designs/README.md` (index update). Authorized.
- Regular append push to
  `endojs/endo-but-for-bots:design/daemon-worker-import-from-mount`.
  Authorized.

## Not authorized

- Force-pushing.
- Modifying any code under `packages/`.
- Resolving the review thread (steward does that after designer reports).
- Un-drafting (PR already non-draft; preserve that state — the maintainer
  will weigh in after seeing the decomposition).
- Closing the PR.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/designer--79db55/garden/roles/COMMON.md`
2. `/home/kris/dispatches/designer--79db55/garden/roles/designer/AGENT.md`
3. Skills referenced by the designer just-in-time. Relevant:
   `process-documents`, `prompt-section-discovery`,
   `design-to-pr-pipeline`.

Project worktree at `project/` on
`design/daemon-worker-import-from-mount` (head `e72b355ff`).

## Report

A `result` journal entry. Include: new head SHA after push, list of files
added/modified/deleted per commit, the choice on what to do with the
original monolithic file (replaced as overview / removed / repurposed as
integration layer), section-to-layer mapping table, any open questions
that the decomposition exposed that the maintainer should address.
