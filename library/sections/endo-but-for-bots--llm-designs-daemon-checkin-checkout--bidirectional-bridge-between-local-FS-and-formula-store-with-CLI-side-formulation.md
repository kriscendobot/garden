---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_path: designs/daemon-checkin-checkout.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 168
lane: designs
status: current
---

# Bidirectional bridge between local FS and formula store with CLI-side formulation

> §Endo-but-for-bots-design genre (designs-lane; the
> §pair-design to cycle 166's daemon-mount.md). Status:
> **Complete** (shipped 2026-03-20 commit `d60ba38b2`;
> zip support 2026-04-17 commit `a6e20c5e2`; verb unification
> 2026-05-18 PR #153 commit `8a8e872d4`).

`designs/daemon-checkin-checkout.md` (578 lines) is the
**§complete-bidirectional-bridge** between the local
filesystem and the daemon's immutable formula store.
Where cycle 166's daemon-mount provides §live-mutable-
access, this design provides §point-in-time-snapshot-and-
restore. The single most structurally interesting move is
the §single-substrate-four-modes pattern: directory mode +
zip mode for both checkin and checkout, all producing the
same `readable-tree` / `readable-blob` hierarchy.

## §The-pair-with-cycle-166-daemon-mount

§Mount-and-checkin-checkout-are-the-two-shapes-of-FS-
access:

- **Mount** (cycle 166): §live-mutable filesystem capability;
  changes flow both ways in real time; the formula
  represents a *boundary*, not a snapshot.
- **Checkin/Checkout**: §point-in-time bridge to immutable
  snapshots; `readable-tree` + `readable-blob` formulas;
  the formula represents *the content at a moment*.

§Mount.snapshot()-produces-a-readable-tree (cycle 166
Decision: §snapshot-as-bridge-to-immutable). §Checkin
produces the same shape. §Two-paths-into-the-same-immutable-
representation: snapshot from a live mount, or checkin from
a local directory.

§Endo-checkout-restores: the §round-trip is mount ↔
snapshot ↔ checkout ↔ local directory.

## §Single-substrate-four-modes (the centerpiece)

> *Whether the input is a directory or a zip file, the
> result is the same `readable-tree` / `readable-blob`
> hierarchy.*

Four modes share one implementation:

| Mode | Input | Output |
|------|-------|--------|
| `endo ci <dir>` | Local directory | `readable-tree` |
| `endo ci -z <zip>` | Zip archive (file) | `readable-tree` |
| `endo ci -z --stdin` | Zip from stdin | `readable-tree` |
| `endo co <name> <dir>` | `readable-tree` | Local directory |
| `endo co -z <name> <zip>` | `readable-tree` | Zip file |
| `endo co -z --stdout` | `readable-tree` | Zip to stdout |

§Six-modes-from-four-axes: input-or-output × dir-or-zip ×
file-or-stream. §Same-formula-tree-from-two-input-sources
(Design Decision 4): `endo ci ./dist -n app` and
`endo ci -z dist.zip -n app` produce *structurally
identical formula trees* given identical content.

§Zip-is-just-serialization. §Don't-design-two-systems-when-
one-substrate-suffices.

## §Decision-1-CLI-side-formulation-not-daemon-side

> *Checkin builds formulas from the CLI side, not the
> daemon side. The CLI walks the local directory ... the
> daemon does not need filesystem walking logic. This keeps
> the daemon focused on formula management and avoids
> giving it ambient filesystem access.*

§Capability-security-applied-at-the-architectural-axis:
§don't-grant-daemon-ambient-FS-access. The CLI already has
filesystem access (it runs as the user). The daemon
shouldn't need it for content ingestion. §Push-the-FS-side-
to-the-component-that-already-has-FS-authority.

§Cycle-166's-§realpath-at-operation-time-confinement is
the *operation-time* discipline for the mount; this is the
*architectural-time* discipline for daemon design.

§Daemon-only-needs-one-new-method (`formulateReadableTree`
or `storeTree`). §Minimal-daemon-API-surface-expansion.

## §Decision-2-checkout-entirely-CLI-side

> *The CLI resolves the tree via `list()`, `lookup()`, and
> `streamBase64()` — all existing methods. No new daemon
> methods are needed for checkout.*

§Zero-new-daemon-methods-for-checkout. §Reuse-existing-
substrate-by-composition. §The-checkout-direction-was-
already-possible.

§Symmetry-break-named: checkin needed one method
(`storeTree`); checkout needed zero. §Existing-API-coverage-
is-asymmetric and the design names it.

## §Decision-3-readable-tree-stores-formula-IDs-not-content-hashes

> *Each entry in the tree points to a formula identifier
> (which may be a `readable-blob` or a nested
> `readable-tree`). The content hash is one level of
> indirection away, inside the `readable-blob` formula.
> This preserves the formula graph for GC and allows the
> same content hash to back multiple formulas with
> different identities.*

§Identity-vs-content distinction. §Formula-graph-for-GC
needs identity edges, not just content edges. §Two-blobs-
with-same-content-can-be-distinct-formulas (e.g., owned by
different pet stores; different lifetimes).

§Content-deduplication-still-happens at the store-sha256
layer; §formula-identity-deduplication-doesn't (each
checkin produces fresh formula numbers even for repeated
content).

§The-content-hash-is-one-level-of-indirection-away. §Cycle-
141's-daemon-cas-management uses the same shape: the
content store is keyed by SHA-256; formulas reference store
entries by hash but have their own identity.

## §Type-discrimination-via-locator

Checkout must distinguish §readable-blob (file) from
§readable-tree (directory). The design names two
approaches:

1. **§Duck-typing**: call `E(value).list()`; if it succeeds,
   it's a tree. §Fragile-but-requires-no-new-interface-
   methods.
2. **§Locator-encodes-formula-type** (preferred): the
   `locate()` method on directories already returns a
   locator string that encodes the formula type (e.g.,
   `?type=readable-tree`). The checkout resolves the pet
   name to a locator, parses it, dispatches.

§The-locator-format-is-doing-real-work — cycle 135's
daemon-locator-reference design defines this format; this
design *uses* it. §Locators-are-not-just-share-links; §they-
encode-type-information-too.

§Synthesis-target-implied: the §locator-as-typed-reference
pattern could be borrowed by future daemon clients beyond
this CLI.

## §Decision-5-no-metadata-preservation

> *`readable-tree` and `readable-blob` formulas store
> **content only**, not metadata (permissions, timestamps,
> ownership). This is intentional: the formulas represent
> immutable content snapshots, not filesystem replicas.*

§Content-only-not-filesystem-replica. §Permissions-and-
timestamps-are-host-specific; storing them would §couple-
the-formula-store-to-POSIX-or-Windows-conventions.

§If-needed-in-the-future-add-as-optional-sidecar-formula
without changing core tree structure. §Future-extension-
named with §don't-bake-it-in-yet discipline.

§Comparison-with-Git: Git also doesn't preserve full file
metadata (only executable bit + symlink); checkin/checkout
goes further by storing zero metadata. §Less-than-Git-by-
choice.

§Synthesis-target: future daemon designs that want metadata
should propose a §parallel-formula-not-a-baked-in-field.

## §Decision-6-symlinks-skipped-with-warning

> *The `readable-tree` model has no concept of symlinks.
> Following symlinks could create cycles or reference files
> outside the intended tree. Skipping them is the safe
> default.*

§Symlinks-skipped-not-followed. §Cycle-166's-mount has the
opposite stance: it *does* follow symlinks (with realpath +
confinement check). §Different-substrate-different-policy:
mount is live + confined; checkin is snapshot + content-
only.

§Symlinks-could-create-cycles: a snapshot must terminate;
following symlinks risks infinite descent. §The-content-
model-doesn't-naturally-encode-symlinks.

## §Decision-7-.endoignore-not-new-flag

> *Rather than inventing a new flag syntax for exclusion
> patterns, checkin respects a `.endoignore` file
> (`.gitignore` syntax) in the root directory.*

§Reuse-familiar-discipline. §.gitignore-syntax-is-known-
by-every-developer. §No-new-mini-language-to-learn.

§.git-directories-always-ignored regardless of .endoignore
— §common-and-large; §sane-default.

§Composability-with-existing-tooling: the same `.gitignore`
patterns work for both Git and Endo. §Don't-fight-the-
ecosystem.

## §Six-axis-flag-summary

| Flag | Short | Commands | Description |
|------|-------|----------|-------------|
| `--name <name>` | `-n` | `checkin` | Pet name for the root |
| `--as <agent>` | `-a` | both | Agent to act as |
| `--zip` | `-z` | both | Interpret/produce zip |
| `--stdin` | | `checkin` | Read zip from stdin |
| `--stdout` | | `checkout` | Write zip to stdout |

§Flag-orthogonality-where-possible. §-z-is-the-input-output-
mode-flag; §--stdin/--stdout-require-z; §-n-is-checkin-only.

§Short-aliases-follow-existing-conventions (-n, -a, -z) —
matches `endo store`, `endo run`, etc.

## §The-relationship-to-mkweblet

> *`endo checkin -z` replaces the zip extraction that was
> previously embedded inside `mkweblet`.*

§Zip-extraction-extracted-from-mkweblet. The earlier design
had zip handling inside `mkweblet` (the weblet-application
verb); this design pulls it into a §standalone-command-
without-weblet-coupling.

§Mkweblet-now-accepts-a-readable-tree-directly. §Two-step-
pipeline: `endo ci -z dist.zip -n my-app-content` →
`endo mkweblet my-app-content --as my-app`.

§Decomposition-of-bundled-verbs is the §refactor-discipline:
when one verb does two things and they need separate use,
split.

## §Roadmap-calibration-via-git-blame (the lifecycle pattern)

> *Active development: 2026-03-17 → 2026-05-18 (62 days,
> calendar; the active span spans three discrete bursts and
> includes long unattended gaps).*

§62-day-calendar-window with §three-discrete-bursts:
- Burst 1 (2026-03-20): initial verbs.
- Burst 2 (2026-04-17): `-z` flag.
- Burst 3 (2026-05-18): PR #153 verb unification.

§Long-unattended-gaps-between-bursts. §Calibration-via-git-
blame is the §lifecycle-discipline (cycle 95's chat-rename-
dismiss-to-clear and cycle 149's unhandled-rejection-
display use the same shape).

§The-design-doc-is-updated-when-implementation-progresses
not on a schedule. §Documentation-tracks-reality not the
other way around.

## §Five-phase-implementation (all complete)

Phase 1: `readable-tree` Formula Type — adds ReadableTreeFormula, exo, host method.
Phase 2: `endo checkin` Directory Mode.
Phase 3: `endo checkout` Directory Mode.
Phase 4: Zip Support (`-z` flag).
Phase 5: Chat Integration (`/checkin` and `/checkout`).

§Phased-S-sized (all marked S — small). §Each-phase-can-
ship-independently. §No-flag-day-required for any phase.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 166 (daemon-mount) | §Pair design — mount = live; checkin/checkout = snapshot |
| 141 (daemon-cas-management) | §Content-store-keyed-by-sha256 substrate; checkin produces store entries |
| 135 (daemon-locator-reference) | §Locator-encodes-formula-type used for §type-discrimination |
| 157 (exo-zip-package) | §Sibling — exo-zip is the *programmatic* API; this is the *CLI* API |
| 161 (filesystem-watchers) | §Cousin design — both touch FS-daemon boundary |

## §Synthesis-target

§Bidirectional-bridge-pattern: when two substrates need to
exchange content, design the bridge as §two-symmetric-
commands not as §one-bigger-thing. §Checkin-and-checkout-
are-symmetric in name and shape.

§CLI-side-formulation discipline applies beyond this design:
when adding daemon capabilities, ask §does-the-daemon-
actually-need-the-authority. If the CLI already has it,
§push-the-authority-to-the-client and §keep-the-daemon-
focused.

## §Tier-1 vocabulary borrowing candidates

§Single-substrate-four-modes, §CLI-side-formulation,
§bidirectional-bridge-pattern, §locator-encodes-formula-
type, §reuse-familiar-discipline (.endoignore →
.gitignore syntax), §don't-bake-metadata-in-yet,
§decomposition-of-bundled-verbs.

§Tier-2: §formula-identity-vs-content-hash distinction,
§zip-is-just-serialization.

## §Reference-not-substrate-stance (continued)

§This-is-our-design. Distinct from cycles 162-165's §read-
for-comparison stance. The §bidirectional-bridge-pattern
is borrowable beyond Endo: any system that bridges live-
mutable substrate with immutable-snapshot substrate
benefits from the §two-symmetric-commands shape.
