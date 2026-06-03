---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_branch: master
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 168. Designs-lane after cycle 167's chat-lane.
  §Endo-but-for-bots-design genre. §Pair-design to cycle
  166's daemon-mount.md.

  Status: **Complete** (shipped 2026-03-20 commit
  `d60ba38b2`; zip support 2026-04-17 commit `a6e20c5e2`;
  verb unification 2026-05-18 PR #153 commit `8a8e872d4`).

  578 lines. §Complete-bidirectional-bridge between local
  filesystem and daemon's immutable formula store
  (readable-tree + readable-blob).

  §The-pair-with-cycle-166-daemon-mount: mount = §live-
  mutable filesystem capability; checkin/checkout = §point-
  in-time-snapshot-and-restore. §Mount.snapshot()-produces-
  a-readable-tree connects the two. §Round-trip: mount ↔
  snapshot ↔ checkout ↔ local directory.

  **Single most structurally interesting move**: §single-
  substrate-four-modes (directory mode + zip mode for both
  checkin and checkout, all producing the same readable-
  tree / readable-blob hierarchy). §Six-modes-from-four-
  axes (input-or-output × dir-or-zip × file-or-stream).
  §Same-formula-tree-from-two-input-sources (Design
  Decision 4) — checkin from directory and checkin from zip
  produce §structurally-identical formula trees.

  §Seven-Design-Decisions:
  1. CLI-side-formulation-not-daemon-side (§don't-grant-
     daemon-ambient-FS-access; capability-security at
     architectural axis)
  2. Checkout-entirely-CLI-side (zero new daemon methods)
  3. readable-tree-stores-formula-IDs-not-content-hashes
     (§identity-vs-content distinction; §formula-graph-for-
     GC needs identity edges)
  4. Zip-mode-reuses-tree-formulation (§zip-is-just-
     serialization)
  5. No-metadata-preservation (§content-only-not-filesystem-
     replica; §future-extension-as-sidecar-formula-not-
     baked-in-field)
  6. Symlinks-skipped-with-warning (§readable-tree-has-no-
     symlink-concept; §different-substrate-different-policy
     from cycle 166's mount which follows-with-confinement)
  7. .endoignore-not-new-flag (§reuse-familiar-discipline;
     .gitignore syntax)

  §CLI-side-formulation discipline: §push-the-FS-side-to-
  the-component-that-already-has-FS-authority. §Cycle-166's
  §realpath-at-operation-time-confinement is the operation-
  time discipline; this is the architectural-time
  discipline.

  §Type-discrimination-via-locator: readable-blob vs
  readable-tree distinguished via §locator-encodes-formula-
  type (`?type=readable-tree`). §Cycle-135's-daemon-
  locator-reference defines this format; §this-design-uses-
  it. §Locators-encode-type-information-too.

  §The-relationship-to-mkweblet: zip extraction §extracted-
  from-mkweblet into §standalone-command. §Mkweblet-now-
  accepts-readable-tree-directly. §Decomposition-of-bundled-
  verbs is the §refactor-discipline.

  §Roadmap-calibration-via-git-blame: 62-day-calendar-window
  with §three-discrete-bursts and §long-unattended-gaps.
  Same shape as cycle 95's chat-rename-dismiss-to-clear and
  cycle 149's unhandled-rejection-display. §Documentation-
  tracks-reality not the other way around.

  §Five-phase-implementation (all complete; all S-sized).
  §Each-phase-can-ship-independently. §No-flag-day-required.

  §Two-design-dependencies: daemon-weblet-application
  (defines readable-tree) + daemon-capability-filesystem
  (Dir/File complementary; live access vs snapshot).

  §Gap-revealing-comparison with cycles 166/141/135/157/161.

  §Synthesis-target: §bidirectional-bridge-pattern (two
  symmetric commands not one bigger thing). §CLI-side-
  formulation discipline (when adding daemon capabilities,
  ask §does-the-daemon-actually-need-the-authority).

  §Tier-1 vocabulary borrowing: §single-substrate-four-
  modes, §CLI-side-formulation, §bidirectional-bridge-
  pattern, §locator-encodes-formula-type, §reuse-familiar-
  discipline, §don't-bake-metadata-in-yet, §decomposition-
  of-bundled-verbs.

  §Reference-not-substrate stance contrast: cycles 162-165
  were §read-for-comparison; this is §our-design — we *are*
  the substrate.

  Cycle 168 was nominally designs-lane (after cycle 167's
  chat-lane). Papers-lane blocked 62+ consecutive cycles.
---

> Abstract: `designs/daemon-checkin-checkout.md` (578
> lines) is the **§complete-bidirectional-bridge** between
> local filesystem and the daemon's immutable formula
> store. Status: **Complete** (shipped 2026-03-20 + zip
> 2026-04-17 + verb unification 2026-05-18 PR #153).
>
> **Pair-design to cycle 166's daemon-mount.md**: mount =
> live-mutable; checkin/checkout = point-in-time-snapshot.
> §Mount.snapshot()-produces-a-readable-tree connects them.
>
> **Single most structurally interesting move**: §single-
> substrate-four-modes (directory + zip; checkin + checkout
> = 6 mode-combinations producing the same readable-tree /
> readable-blob hierarchy).
>
> §Seven-Design-Decisions including §CLI-side-formulation-
> not-daemon-side (capability-security at architectural
> axis), §readable-tree-stores-formula-IDs-not-content-
> hashes (§identity-vs-content), §no-metadata-preservation,
> §symlinks-skipped-with-warning, §.endoignore-not-new-flag.
>
> §Type-discrimination-via-locator (§locator-encodes-
> formula-type) reuses cycle 135's daemon-locator-reference
> format.
>
> §The-relationship-to-mkweblet: zip extraction §extracted-
> from-mkweblet; §decomposition-of-bundled-verbs as
> refactor discipline.
>
> §Roadmap-calibration-via-git-blame: 62 days, three
> discrete bursts, long unattended gaps. Same shape as
> cycle 95 + 149.
>
> §Synthesis-target: §bidirectional-bridge-pattern, §CLI-
> side-formulation discipline applies beyond this design.
>
> §Tier-1 borrowing: §single-substrate-four-modes, §CLI-
> side-formulation, §bidirectional-bridge-pattern, §locator-
> encodes-formula-type, §reuse-familiar-discipline,
> §don't-bake-metadata-in-yet, §decomposition-of-bundled-
> verbs.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation](../sections/endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation.md) | daemon, tooling, capability-security | current |

One cohesion-honest section. §The-single-substrate-four-
modes pattern is the spine; the seven Design Decisions
reinforce it; splitting would fragment.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@master`.
- Author: Kris Kowal (prompted).
- Cycle 168 was nominally **designs-lane** (after cycle
  167's chat-lane). §Pair-design to cycle 166's daemon-
  mount. Papers-lane blocked **62+ consecutive cycles**.
- One cohesion-honest section.
