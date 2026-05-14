---
ts: 2026-05-14T05:06:42Z
kind: dispatch
role: liaison
project: endo
to: "*"
---

# Dispatch: designer proposes exo-import + exo-npm-registry packages

Dispatch root: `dispatches/designer--exo-import-and-exo-npm-registry--20260514-050642--e3b1aa/`. Project worktree at `endojs/endo@master` (detached). Two sibling designs land in `designs/` in this engagement; no code.

The maintainer wants two design documents proposing two related new packages. Read both prompts as a pair; the second feeds the first.

## Design 1: `exo-import`

**Purpose.** A new import mechanism for the endo daemon platform. Accepts:

- Any readable filesystem tree from the daemon platform's filesystem interfaces (treat this as a snapshot, identified by content hash — sha256 of the tree).
- The name-path to an entrypoint module inside that tree (i.e., the package's `main` or an explicit subpath).
- Endowments (the host-supplied capabilities the imported program may receive).
- A new interface for looking up readable trees for packages downloaded from npm, indexed by version vector.
- A cache that maps from a readable-tree sha256 (the input snapshot) to a resulting application-readable-tree sha256 (the linked application).

**Behavior.** Translate a program standing in a (potentially virtual) filesystem into the corresponding linked application by using the existing compartment-mapper primitives in a new way — *instead of* `mapNodeModules`. The new mechanism constructs a new readable tree that includes the package and its transitive dependencies. The semantics are plug-and-play: no lockfile is consulted; the resolution algorithm rebuilds the tree from package.json metadata each time, and the cache key (input-tree-sha256) lets the daemon skip the work when the snapshot is unchanged.

**Resolution algorithm.** Go-modules-style:

- The working set may include exactly one `minor.patch` version for each `<major>` of each dependency.
- For each `<major>` mentioned anywhere in the transitive graph's `package.json` files, exo-import picks the *largest* `minor.patch` mentioned in that graph.
- No lockfile is required (this is the consequence, not an axiom): the resolved set is a deterministic function of the input snapshot.
- Resolution is **not** as exhaustive as Node.js. Supported only: packages that can be confined in Compartments via the compartment-mapper, potentially in a locked-down worker.
- **No git versions** (only versions vendable from the npm-registry-like lookup interface).

**Output: the resulting application readable tree.** A new readable tree, content-addressed, that the daemon can hand to a worker or to its own importer. The mapping `input-tree-sha256 → output-tree-sha256` is the cache.

**Strictness.** The whole mechanism operates on *snapshots* of a filesystem, never on a live, mutable filesystem. That is a hard constraint; surface it in the design's invariants.

## Design 2: `exo-npm-registry`

**Purpose.** Provide the capability to capture readable-trees for arbitrary `(packageName, version)` couples (the input to design 1's lookup interface) and index them in a daemon virtual directory, such that it can vend out readable-trees on demand.

**Behavior.** Capture is the input side: fetch the npm tarball, extract into a readable-tree-shaped directory (no extraneous files, no .git, no node_modules), index by `(name, version)` in a daemon virtual directory. Vending is the output side: given `(name, version)`, return a readable-tree handle the daemon can hand to `exo-import`'s lookup interface.

The exact wire to npm (HTTPS to registry.npmjs.org, an offline mirror, a content-addressed cache) is the daemon-platform integrator's choice; the design proposes the *capability shape*, not the implementation of the fetcher.

## Per-action authorization

The designer reads `endojs/endo` (read-only) and writes two `designs/*.md` files in the dispatch's `project/` worktree. **No commit, no push, no PR.** The output is the two markdown files; the maintainer reviews them in this terminal before any branch / PR work.

## Task

1. **Orient.** Read `roles/COMMON.md`, then `roles/designer/AGENT.md`. Read `designs/CLAUDE.md` (or whatever the project's design conventions doc is — likely `designs/README.md` or a top-of-`designs/` doc) to match the project's status-table / section conventions. Skim 2-3 existing `designs/*.md` files (the project worktree's `designs/` directory) for the local voice.

2. **Read background.** The compartment-mapper's `mapNodeModules` is the prior art the new design replaces. Find it: `packages/compartment-mapper/` is the natural location. Read enough of its surface to cite the primitives the new design reuses (the "primitives" the maintainer referenced) and to call out what `mapNodeModules` does that `exo-import` does *not* (Node.js exhaustive resolution, lockfile-driven set).

3. **Identify the readable-tree interfaces.** The endo daemon platform exposes filesystem interfaces; the readable-tree abstraction lives in those packages. Find them and cite their types in the design. Likely candidates: `packages/exo/`, `packages/daemon/`, `packages/fs-*` (the gardener does not know the exact name; the designer locates them).

4. **Draft `designs/exo-import.md`.** Sections (adapt to the project's convention if different): status table; problem statement; scope; non-goals (one of which: not a drop-in Node.js replacement; not git-version-aware); design (the four inputs, the resolution algorithm, the cache, the snapshot-strictness invariant, the use of compartment-mapper primitives instead of `mapNodeModules`); a Go-style `select-modules` pseudocode block; alternatives considered (one-liner each: lockfile-driven, pnpm-style, Node.js-style); test plan; open questions.

5. **Draft `designs/exo-npm-registry.md`.** Sections: status table; problem statement; scope; design (capture API, vend API, virtual-directory layout, indexing scheme `(name, version) → readable-tree-handle`); the integration point with `exo-import` (the vend API is exactly the lookup interface design 1 names); alternatives (in-memory vs on-disk index, content-addressed dedup); test plan; open questions.

6. **Diagrams.** One mermaid diagram per design at minimum (architecture or sequence). For `exo-import`, a sequence diagram showing: caller → exo-import (with input tree + entrypoint + endowments + lookup capability) → resolution loop (consulting exo-npm-registry's vend API per `(name, version)`) → constructed output tree → returned handle. For `exo-npm-registry`, a state diagram of capture / index / vend.

7. **Open questions.** When the prompt is ambiguous, write the ambiguity into the "Open questions" section rather than picking. Likely candidates to surface: how does the cache invalidate when registry contents change for an immutable `(name, version)` (it shouldn't, but malicious republishes happen); how is the version vector represented when the package.json uses a range (`^1.2.3`) — the design picks the largest `minor.patch` for that major mentioned *elsewhere* in the graph, but what if no other dep pins it? does endo-import vend itself, or does the daemon platform inject the capability; what is the failure mode when a dep requires an unsupported feature (CJS-only, native bindings, postinstall script).

8. **Length.** Each design 1-3 screens; cross-link aggressively between the two rather than copy-pasting. Each stands alone but they reference each other.

## Out of scope

- No code (no JavaScript files in `packages/`; designs only).
- No commits, no branches, no PRs.
- No changes to compartment-mapper or any existing package; references-only.

## Report

≤ 500 words: path to each design file (`project/designs/exo-import.md`, `project/designs/exo-npm-registry.md`), the one-paragraph abstract each design opens with, the open questions list (so the liaison can surface them to the maintainer for resolution before a future builder dispatch), and one-line `Self-improvement: ...` per the skill.
