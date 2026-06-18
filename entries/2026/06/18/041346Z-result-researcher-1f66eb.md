---
ts: 2026-06-18T04:13:46Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: "*"
short_id: 1f66eb
refs:
  - dispatches/researcher--1f66eb
---

# Result: researcher refinement for proposed designer dispatch on fs-interface-reconciliation

The proposed designer prompt asks for `designs/fs-interface-reconciliation.md`
on the `llm` branch of `endojs/endo-but-for-bots`, investigating where
`@endo/endo-fs` and `@endo/platform/fs` diverge in purpose and where their
interfaces can be reconciled so a filesystem viewer can stand on a coherent
foundation across mount / scratch / memfs / CAS / virtual-filesystem
backings. The maintainer's hint "this work has been done before" maps
directly to `designs/daemon-capability-filesystem.md` (cycle 170, Reference
status) which already proposes a three-layer architecture (Guest Dir/File +
VFS Namespace + four backends), and to `designs/platform-fs.md` (cycle 242,
recently shipped) which already lands the canonical 2x3 type lattice
(Readable / Snapshot / Mutable) x (Blob / Tree) and is named in the library
keyword index as the slug the designer should treat as the live canonical
interface module. The refinement below grounds every load-bearing term in
existing library material and surfaces the prior-art reconciliation that
the maintainer's hint promised.

The orchestrator should inline the fenced block below verbatim into the
designer dispatch prompt, before the *Discipline* section, after the task
statement and required-contents list.

```markdown
## Library and project references

The maintainer's hint "this work has been done before" maps to two
recently-active designs in the corpus that the new design must reconcile
with explicitly rather than re-derive: `designs/daemon-capability-filesystem.md`
(Reference vision; the wider three-layer architecture with four backends)
and `designs/platform-fs.md` (the recently-landed canonical type lattice
plus `packages/platform/src/fs/interfaces.js` as the actual exported
guards). Both are the prior art. The new design should cite them, build on
their vocabulary, and either supersede or extend rather than parallel.

### Library concepts and sections

- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge.md)
  is the prior-art design the maintainer's "this work has been done before"
  refers to. The 966-line Reference document proposes a §three-layer
  architecture (Guest Dir/File + VFS Namespace + Backends) and §four
  backends sharing one Dir/File interface (Physical / Git Tree / Memory /
  CAS). Section §Endo-already-has-this-pattern-map enumerates six existing
  pieces the design extends (pet-name directory, VFS-design-sketch,
  FilePowers, OS-sandbox-plugin, EndoDirectory, attenuate). The Seven
  Open Questions section names the still-unresolved decisions (backend
  interface shape, glob, overlapping mounts, atomicity across mounts,
  large-subtree materialization, `subDir` naming, attenuated-exo
  ownership). The new design either supersedes this Reference (with a
  migration map) or builds atop it.
- [`journal/library/sections/endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation.md)
  is the recently-landed canonical type lattice the new design must adopt
  as vocabulary. The §Type-lattice-as-2x3-axis-table section names the
  six types (File / Directory / ReadableBlob / ReadableTree / SnapshotBlob
  / SnapshotTree) along three roles (Readable / Snapshot / Mutable) by two
  kinds (Blob / Tree); the §Relationship-to-existing-interfaces section
  already explicitly maps each existing interface to the lattice
  (EndoNameHub / EndoDirectory ↔ ReadableTree + Directory mutation
  surface; EndoReadable ↔ SnapshotBlob; daemon-capability-filesystem's
  Dir/File ↔ Directory/File). The §Seven-numbered-Design-Decisions section
  is the recent canonical statement of the layer's discipline (notably
  Decision 4: readOnly returns the readable interface, not a frozen copy;
  structural attenuation, not behavioral). The §Four-phase-implementation
  -plan section reports phases 1-3 shipped, phase 4 (Mutable Directory and
  File with readOnly) outstanding; the new design's catalog must align
  with the live `packages/platform/src/fs/interfaces.js` exports.
- [`journal/library/sections/endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation--relationship-to-existing-interfaces-section.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation--relationship-to-existing-interfaces-section.md)
  is the specific subsection that already does part of the reconciliation
  job the new design extends. It names §stops-at-the-filesystem-boundary
  as a design discipline (platform/fs deliberately excludes
  formula-system concepts like `identify`, `locate`,
  `followNameChanges`) and explicitly defers `subDir()` to a §future-VFS
  -layer-that-composes-`@endo/platform/fs`-primitives. The new design
  IS that future VFS layer; it stitches platform/fs's tree primitives
  into the broader mount / scratch / memfs / CAS / virtual-filesystem
  surface.
- [`journal/library/sections/endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation--push-interface-treewriter-vs-p.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation--push-interface-treewriter-vs-p.md)
  carries the canonical `TreeWriter` minimal-push-interface (writeBlob +
  makeDirectory) that decouples checkout target from any specific mutable
  tree implementation. Filesystem-viewer write paths against
  graceful-degradation backings (read-only CAS, snapshot-only tree)
  consume this distinction directly: a viewer's "save" path can be a
  TreeWriter target rather than a full Mutable Directory; partial
  implementations are first-class via the push/pull split.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement--single-exo-interface-the-surface.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement--single-exo-interface-the-surface.md)
  is the canonical `MountInterface` definition (has / list / lookup /
  write / remove / move / makeDirectory / readOnly / snapshot / help).
  This is the load-bearing prior art for the method catalog the new
  design must produce. §Five-method-groupings (reads + mutation +
  attenuation + snapshot + help) is the existing template; the new
  catalog either adopts these names directly or supersedes them with a
  migration map. Note: `move` covers rename; permissions are
  host-controlled-not-mount-controlled (no chmod).
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement--two-formula-type-split.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement--two-formula-type-split.md)
  is the §two-formula-type-split (`mount` host-managed + `scratch-mount`
  daemon-managed) sharing one exo interface; the §lifecycle-asymmetry-vs
  -implementation-symmetry pattern. Two of the five backing
  implementations the maintainer named (mount + scratch) are this design;
  the catalog must respect the shared-exo discipline.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge--four-backend-types-sharing-one-dir-file-interface.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge--four-backend-types-sharing-one-dir-file-interface.md)
  is the prior-art conformance-row table (Physical / Git tree / Memory /
  CAS, each with Mutability column and Use-case column). The new design's
  conformance enumeration extends this table with the maintainer's named
  fifth row (Virtual filesystem / endo directory / name hub) and folds
  scratch-mount into the Physical row (or splits Mount and Scratch as
  separate rows per the daemon-mount two-formula-type split).
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md)
  defines the CAS substrate the new design must conform with. The seven
  envelope verbs (`cas-store`, `cas-fetch`, `cas-has`, `cas-retain`,
  `cas-release`, `cas-store-tree`, `cas-gc`) plus the streaming variants
  (`cas-store-stream`, `cas-content-stream`) bound how a CAS-backed
  ReadableTree / SnapshotTree exposes blob retrieval and tree walking.
  The four content-types table (blob / snapshot / tree / archive) shows
  the typed-content discipline the reconciled interface must preserve.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md)
  carries the refcount semantics for `readable-blob` / `readable-tree`
  content. A filesystem-viewer that "saves" a CAS-resident snapshot
  reduces to refcount changes, not byte motion; the reconciled interface
  must align with sweep-time refcount, not introduce a parallel counter.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation--decision-3-readable-tree-stores-formula-ids-not-content-hashes.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation--decision-3-readable-tree-stores-formula-ids-not-content-hashes.md)
  is the bidirectional bridge between local filesystem and daemon's
  immutable formula store. The §pair-design-with-daemon-mount observation
  (mount = live-mutable; checkin/checkout = point-in-time-snapshot-and-
  restore) is the round-trip the new design must support: a filesystem
  viewer can both observe a live Mount and snapshot it through checkin,
  yielding the same readable-tree / readable-blob hierarchy. The
  no-metadata-preservation discipline (content-only, not filesystem-
  replica) bounds what the reconciled interface promises across backings.
- [`journal/library/sections/endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail--the-reuse-platform-interface-not-daemon-interface-discipline.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail--the-reuse-platform-interface-not-daemon-interface-discipline.md)
  names `packages/platform/src/fs/interfaces.js` explicitly as the
  canonical interfaces source (`ReadableTreeInterface` with
  `has`/`list`/`lookup`; `ReadableBlobInterface` with `streamBase64`/
  `text`/`json`). The §reuse-platform-interface-not-daemon-interface
  discipline is the load-bearing precedent: the reconciled interface
  catalog lives in this package, not in daemon-specific shapes. The
  §which-side-of-CapTP-determines-the-interface observation (client side
  has narrower surface than daemon side) is relevant when the
  filesystem viewer is a CapTP client of the daemon.
- [`journal/library/sections/endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface--cap-not-string-mounts-the-load-bearing-constraint.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface--cap-not-string-mounts-the-load-bearing-constraint.md)
  carries the cap-not-string-mounts discipline the new catalog must
  honor: every method signature takes a capability (a Mount, a
  Directory, a File), never a string host path. This applies as a
  constraint on `lookup(name)` (name is a path-segment string within
  the holder's confinement; not a host path) and `move(source, target)`
  (both arguments are capabilities or relative path-segments within one
  holder's confinement).
- [`journal/library/sections/endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout--viewer-panel-view.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout--viewer-panel-view.md)
  is the existing chat-side `/view` viewer (and §editor-panel-edit for
  `/edit`) that the filesystem-viewer-contract section of the new design
  builds atop. Renderer table (text / markdown / json / images), Monaco
  read-only mode, extension-as-content-type discipline. The reconciled
  interface defines what the viewer reads via its `text()`,
  `streamBase64()`, and `lookup()` calls; the viewer's
  graceful-degradation surface (write disabled when readOnly, mutation
  surface absent on a snapshot) is the contract this design must spell
  out.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls--streamreply-and-streamsend-with-stream-formula-and-captp-rides-method-calls.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls--streamreply-and-streamsend-with-stream-formula-and-captp-rides-method-calls.md)
  is the streaming substrate. The reconciled interface must decide
  whether reads of large blobs use a synchronous `read(path) -> Bytes`
  on small payloads with a separate `streamRead` / `streamBase64` for
  large; the design's open-question on streaming maps to this design's
  streamReader / streamWriter interfaces.
- [`journal/library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md)
  is the type-aware UI surface the filesystem-viewer extends. Formula-
  inspector's `@info` name hub and the §26-formula-types-with-type-
  specific-metadata table (live count today: 33 per the cc9a57
  designer's note; includes `mount`, `readable-tree`, `scratch-mount`,
  `make-from-tree`) is the inventory the viewer surfaces. The
  reconciled interface tells the viewer which methods are present on
  each type instance and which graceful-degradation messages to render
  when a method is absent.
- [`journal/library/sources/endo-but-for-bots--llm-designs-filesystem-watchers.md`](../../../journal/library/sources/endo-but-for-bots--llm-designs-filesystem-watchers.md)
  is the followNameChanges parity-fix design: gives EndoMount a
  `followNameChanges` method matching EndoDirectory so polymorphic hub
  abstractions stop breaking at the subscription edge. Relevant to the
  filesystem viewer's "observe" surface: the reconciled interface should
  enumerate which backings can followNameChanges (mount, scratch, name
  hub) and which cannot (CAS is immutable; memfs may or may not).

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md)
  carries the project's standing rules: designs land DRAFT against the
  `llm` branch (§ Rules of engagement), the standing relaxation lets the
  designer open the PR without per-action authorization (§ Standing
  authorizations covers comment + review + reactji + cross-reference on
  this repo only), and every commenter is maintainer-equivalent for
  routing purposes (§ Authority structure). The designer can open the
  DRAFT PR and reply on inline threads without additional authorization.
- Related designs on the `llm` branch the designer should cite by
  relative path from the new `designs/fs-interface-reconciliation.md`:
  - `designs/daemon-capability-filesystem.md` (the prior-art Reference
    vision; the new design either supersedes with a migration map or
    builds atop).
  - `designs/platform-fs.md` (the canonical 2x3 type lattice and the
    `packages/platform/src/fs/interfaces.js` export source; the new
    design's catalog MUST adopt this vocabulary).
  - `designs/daemon-mount.md` (the live MountInterface with
    has/list/lookup/write/remove/move/makeDirectory/readOnly/snapshot/
    help; the catalog's reference shape).
  - `designs/daemon-cas-management.md` (the CAS substrate; the
    conformance row for CAS-backed reads).
  - `designs/daemon-content-store-gc.md` (refcount semantics for the
    CAS conformance row).
  - `designs/daemon-checkin-checkout.md` (the snapshot round-trip;
    pair-design with daemon-mount).
  - `designs/daemon-move-transfer-negotiation.md` (PR #432; the move
    method's negotiated transfer ladder; the catalog's `move(source,
    target)` signature defers to this design's negotiation contract).
  - `designs/endo-posix-sandbox.md` (the cap-not-string-mounts
    discipline; constraint on every catalog signature).
  - `designs/chat-view-edit-commands.md` (the existing chat-side
    /view and /edit; the filesystem-viewer-contract builds on these).
  - `designs/chat-value-modal-formula-view.md` (PR #439; the type-
    aware modal viewer the filesystem viewer extends).
  - `designs/formula-inspector.md` (the type-aware UI surface; the
    @info name hub and 33-formula-type inventory).
  - `designs/filesystem-watchers.md` (followNameChanges parity; the
    observe surface for the reconciled interface).
  - `designs/exo-zip-package.md` (the §reuse-platform-interface-not-
    daemon-interface discipline; the precedent for catalog reuse).
  - `designs/daemon-message-streaming.md` (the streaming substrate;
    relevant to the streamRead open question).

### Why each reference is relevant

- daemon-capability-filesystem: THE prior-art design the maintainer's
  hint "this work has been done before" points at; reconcile or supersede.
- platform-fs (and its Relationship-to-existing-interfaces section):
  the live canonical type lattice and the package the catalog must
  export from; the new design IS the future-VFS-layer that section
  defers `subDir()` to.
- daemon-mount: the live MountInterface; the catalog's reference shape
  for method names and groupings.
- daemon-cas-management + daemon-content-store-gc: the CAS conformance
  row; refcount semantics constrain the reconciled `remove` / `move`.
- daemon-checkin-checkout: the snapshot round-trip the viewer must
  support without losing fidelity.
- daemon-move-transfer-negotiation (PR #432): the move catalog entry
  defers to this design's negotiation contract for cross-backing moves.
- endo-posix-sandbox: cap-not-string-mounts; every signature is
  capability-bearing or path-segment-confined, never a host-path string.
- chat-view-edit-commands + chat-value-modal-formula-view +
  formula-inspector: the type-aware UI surfaces the filesystem-viewer
  extends; the graceful-degradation contract bears on what the viewer
  shows when a method is absent on a particular backing.
- filesystem-watchers: the observe surface (followNameChanges parity);
  the conformance enumeration must say which backings can observe.
- exo-zip-package: the §reuse-platform-interface-not-daemon-interface
  discipline; precedent for exporting from `packages/platform/src/fs/
  interfaces.js` rather than minting daemon-specific names.
- daemon-message-streaming: substrate for the streamRead open question
  the prompt enumerates.

### Open questions (load-bearing terms the library could not fully resolve)

- **`@endo/endo-fs` location and surface**: the library has keyword
  references to "endo-fs FsBackend seam" and "endo-fs source + endo-fs-
  exec" in app-sharing-milestone pillar 3, but no dedicated ingest of an
  `@endo/endo-fs` package design or README. The library indexes it as a
  daemon-topic concept, not as a section. The designer should treat the
  endo-fs survey as a direct read of `packages/endo-fs/` (or the
  package the symbol resolves to) on the `llm` branch rather than from
  the library, and may want to surface this gap as a librarian or
  scholar task.
- **The "virtual filesystem like an endo directory or name hub"
  backing**: the library has `@info name hub` (formula-inspector) and
  `EndoDirectory` references (daemon-capability-filesystem
  §Endo-already-has-this-pattern map). There is no dedicated section
  on the name-hub-as-VFS-backing; the conformance row will need to be
  written from package source (`packages/daemon/src/directory.js` per
  the pattern map) rather than from a prior library section.
- **memfs (in-process memory filesystem)**: named by the maintainer as
  one of the five backings, but unindexed in the library beyond the
  Reference's four-backend-types table (Memory row, no further
  elaboration). The designer should propose the memfs shape as a new
  contribution rather than expecting a prior design to inherit.
- **Async vs sync surface**: the platform-fs §Push-interface-TreeWriter
  -vs-pull-interface-ReadableTree section names the push/pull axis but
  the library does not directly address the in-process-memfs-can-be-sync
  vs CAS-necessarily-async question the prompt raises. This is a
  genuine open question for the new design.
- **The retired d256 / daemon-256-bit-identifiers formula-type count
  drift**: the cc9a57 designer's note (2026-06-12, PR #439) records the
  live `packages/daemon/src/formula-type.js` count as 33 (not the
  historical 26 in the d256 ingest). When the design enumerates the
  type-aware viewer's coverage of formula types, the live count is
  authoritative.
```

## Library writeback

No keyword-index shortcuts added this engagement: the four primary terms
(`daemon-capability-filesystem`, `platform-fs`, `daemon-mount`, `endo-posix-
sandbox`) all resolved cleanly from `keywords.md` to their concept-pointer
sections. No concept-page drafts. No distractions pruned. The library's
existing indexing for filesystem-interface reconciliation is already strong
because cycle 242 platform-fs ingestion and cycle 170 daemon-capability-
filesystem ingestion did the heavy lifting; this engagement is downstream
beneficiary, not source of new index entries.

## Open questions (raised to librarian / gardener)

- The `@endo/endo-fs` package has no dedicated library section; only
  scattered keyword pointers ("endo-fs FsBackend seam",
  "endo-fs source + endo-fs-exec"). When the scholar next ingests
  package READMEs, `packages/endo-fs/README.md` on the `llm` branch
  would close this gap.
- The "virtual filesystem like an endo directory or name hub" backing
  has only an indirect citation in `daemon-capability-filesystem`'s
  §Endo-already-has-this-pattern map. A standalone concept page for
  `endo-directory-as-vfs-backing` or `name-hub-as-vfs-backing` would
  let future researchers ground the term without reading the prior-art
  design in full.

Self-improvement: nothing this time.
