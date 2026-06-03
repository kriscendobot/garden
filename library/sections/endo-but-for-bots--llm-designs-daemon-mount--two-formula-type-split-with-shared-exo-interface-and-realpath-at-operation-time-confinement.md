---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
---

# Two-formula-type split with shared exo interface and realpath-at-operation-time confinement

> §Endo-but-for-bots-design genre (designs-lane; breaks the
> §ocap-kernel-mini-series streak after cycles 162-165).
> Status: **In Progress** (Phases 1-3 + 5 shipped 2026-03-21
> via commit `e22f71327`; Phases 4 and 6 open as PRs #135 /
> #127 / #277). The **direct prerequisite design** for
> cycle 161's filesystem-watchers.md (which adds
> `followNameChanges` to EndoMount via PR #277).

`designs/daemon-mount.md` (708 lines) defines the
**§live-mutable-filesystem-as-capability** primitive for
the daemon. The single most structurally interesting move
is the §two-formula-type-split (`mount` for external host-
managed directories; `scratch-mount` for daemon-managed
workspace) sharing one exo interface, with the entire
security surface anchored on §realpath-at-operation-time-
confinement.

## §The-three-pre-existing-shapes-and-the-gap

The doc opens by naming what the daemon *had* and what was
missing:

| Existing | What it is | What it lacks |
|----------|------------|---------------|
| `readable-tree` | Immutable content-addressed snapshots | Cannot be modified |
| `directory` | Pet-name capability namespace | Not a filesystem |
| (none) | — | **Live mutable filesystem access** |

§Naming-the-shape-of-the-gap. §AI-coding-agent-as-motivating-
use-case: an agent needs to read project files, write
generated code, create build artifacts — all confined.

§Today's-two-bad-options: §ambient-host-permissions
(violates least authority) OR §everything-through-store-
checkin (immutable snapshots only, no incremental edits).
§Mount-bridges-this-gap.

## §Two-formula-type-split

```ts
type MountFormula = {
  type: 'mount';
  path: string;
  readOnly: boolean;
  parent?: FormulaIdentifier;
};

type ScratchMountFormula = {
  type: 'scratch-mount';
  readOnly: boolean;
  parent?: FormulaIdentifier;
};
```

§Mount captures an §absolute-host-path; §scratch-mount
captures §only-the-formula-number (backing path derived as
`{statePath}/mounts/{formulaNumber}`).

§Design-Decision-1: §two-formula-types-rather-than-one.
§Rationale: different §lifecycle-semantics — user-managed-
path vs daemon-managed-storage-with-GC-cleanup. §Separate-
formula-types-make-this-explicit-in-the-formula-store and
§avoid-conditional-logic-for-does-this-mount-own-its-
directory.

§Both-share-the-same-exo-interface-and-implementation. The
only difference is §how-the-mount-root-path-is-derived.
§Implementation-symmetry-but-lifecycle-asymmetry observation.

## §Single-exo-interface (the surface)

```js
export const MountInterface = M.interface('EndoMount', {
  has, list, lookup,                          // ReadableTree-compatible reads
  write, remove, move, makeDirectory,         // Mutation
  readOnly,                                   // Attenuation
  snapshot,                                   // Bridge to immutable
  help,                                       // Discoverability
});
```

§Five-method-groupings: reads + mutation + attenuation +
snapshot + help.

§ReadableTree-compatible-reads — `has`/`list`/`lookup` match
the existing immutable surface. §Polymorphism-by-interface:
code that walks a `ReadableTree` walks a `Mount` the same
way.

§Mutation-suite — `write` / `remove` / `move` /
`makeDirectory`. §No-rename — `move` covers it. §No-chmod —
permissions are §host-controlled-not-mount-controlled.

§Snapshot-as-bridge — `snapshot()` returns a
content-addressed `readable-tree` / `readable-blob`
hierarchy. §Mount→Snapshot-as-round-trip-to-immutable.
§Combined-with-endo-checkin: §complete-round-trip (mount ↔
snapshot).

## §realpath-at-operation-time-confinement (the security spine)

```
function assertConfined(candidatePath, confinementRoot):
  resolved = realpath(candidatePath)
  if not resolved.startsWith(confinementRoot + '/') and resolved != confinementRoot:
    throw error "Path escapes mount root"
```

§Every-filesystem-operation-must-verify-resolved-path-
remains-within-confinement-root. §Realpath-resolves-
symlinks-fully.

§Design-Decision-5: §symlink-confinement-at-operation-time.
§TOCTOU-mitigation. §Checking-symlinks-at-lookup-time-and-
caching-creates-TOCTOU-window where symlink target could
change between lookup and use. §Operation-time-is-the-only-
safe-approach.

§Cycle-161's-filesystem-watchers has a sibling discipline:
§stat-reconciled-rename-events at operation time (filesystem
events don't tell direction; handler must stat at event
time). Both designs commit to §operation-time-verification
because §filesystem-state-can-change.

## §Read-soft-write-hard discipline for escaping symlinks

| Method | Behavior on escaping symlink |
|--------|------------------------------|
| `list()` | §Silently-exclude from returned array |
| `has()` | Return `false` |
| `lookup()` | §Throw |
| `write()` / `remove()` / `move()` | §Throw |

§Read-soft-write-hard. §Reads-pretend-the-escape-doesn't-
exist; §writes-fail-explicitly.

§Why-soft-on-reads: §enumeration-doesn't-leak-existence-
beyond-the-boundary. A `list()` that *threw* on escapes
would let an attacker probe whether escapes exist by trying
operations. §Hidden-not-rejected for reads is the same
discipline as cycle-89's eventual-send pipeline observation
about §don't-let-error-paths-reveal-too-much.

§Why-hard-on-writes-and-lookup: §explicit-mutation-on-
imaginary-state-is-incoherent. The caller needs to know
whether the operation actually targeted anything.

## §readOnly-on-the-exo vs §sub-mount-via-host (GC-race-prevention)

§Design-Decisions-2-and-3 are the §load-bearing-symmetry:

- **§readOnly()-IS-on-the-exo**: §no-new-formula-is-created;
  returns a §restricted-view-of-the-same-object. §No-GC-
  race-possible-because-no-formula-is-involved.
- **§Sub-mount-via-host-method**: §creates-a-new-formula.
  §Formulas-created-in-the-JS-heap-without-being-atomically-
  named-in-a-pet-store-are-vulnerable-to-GC-races. §Host-
  methods-with-deferred-tasks-prevent-this.

§The-axis-is: does-this-operation-create-a-new-formula.
§Creates-formula → host method with deferred-task atomicity.
§Doesn't-create-formula → exo method.

§This-is-an-invariant-not-just-a-pattern: any new daemon
capability must honor it. §Cycle-105's-daemon-capability-
bank touches this territory; cycle 161's filesystem-
watchers reuses the same exo-vs-host axis (followNameChanges
on the exo because it's an attenuated method, not a new
formula).

## §Transient-exos-from-lookup() (Design Decision 4)

> *`lookup()` returns transient exos, not formulas.
> Navigating a mount's directory structure should be
> lightweight and not pollute the formula store with entries
> for every subdirectory visited.*

§Transient-exos-share-the-parent's-confinement-root and are
§garbage-collected-normally-by-the-JS-runtime.

§Two-tier-naming: formulas for §things-the-user-named;
transient-exos for §things-the-system-needed-to-fabricate-
mid-call. §Don't-pollute-the-formula-store-with-internal-
navigation-state.

§Cycle-156's-finalize.js-WeakValueMap pattern is the
mechanism that makes this work: §exos-can-be-collected-
when-no-one-holds-them; the formula store doesn't observe
them.

## §Path-based-not-inode-based with §openat-as-future-strengthening

§Design-Decision-8 is the §honest-limitation-disclosure:

> *The current design binds a mount, file, or directory exo
> to a *path*, not to an underlying inode. ... on platforms
> where the daemon runs under a supervisor with access to
> POSIX `openat` and the rest of the `*at` family ... we
> could open a directory file descriptor at mount time and
> perform all subsequent operations relative to that
> descriptor, pinning the exo to a specific inode
> regardless of path-level motion.*

§Named-limitation-with-named-future-fix. §Today's-Node.js-
fs-API-opens-by-path; future XS/Rust-supervisor with
§POSIX-`*at`-family enables §inode-pinning.

§The-`*at`-family enumerated: `openat`, `renameat`,
`fstatat`, `mkdirat`, etc. §Operations-relative-to-an-
already-opened-directory-fd-cannot-be-redirected-by-
post-hoc-symlink-changes.

§Discloses-current-vulnerability: if backing file/directory
is moved or replaced at the OS level, the exo follows the
*path*, not the original inode. §Path-following-not-
inode-pinning is the current behavior.

§Future-strengthens-confinement-on-supporting-platforms.
§This-is-the-shape-of-a-§future-hardening-target.

## §Scratch-mount-survives-cancellation (Design Decision 7)

> *Scratch mount directories survive cancellation.
> Cancelling a scratch-mount formula does **not** delete
> the backing directory. ... Only GC (unreachability)
> triggers cleanup, ensuring intentional deletion requires
> removing all pet-name references.*

§Cancellation-is-not-deletion. §An-agent's-workspace-should-
not-be-destroyed-by-a-transient-daemon-restart-or-formula-
re-evaluation. §Trade-off-named: §disk-usage-mitigated-by-
GC-when-formula-becomes-unreachable.

§Intentional-deletion-requires-removing-all-pet-name-
references is the §explicit-confirmation pattern (sibling
to cycle 164's §resetStorage-conflict-guard from ocap-
kernel — both encode §single-mistake-cannot-destroy-state).

## §Eight Design Decisions enumerated

1. §Two-formula-types-rather-than-one (lifecycle clarity).
2. §No-mount-method-on-the-exo (host avoids GC races).
3. §readOnly-IS-on-the-exo (no new formula, no GC race).
4. §lookup-returns-transient-exos (formula-store hygiene).
5. §Symlink-confinement-at-operation-time (TOCTOU
   mitigation).
6. §..-is-clamped-not-rejected (POSIX-ergonomic for
   mechanical path construction).
7. §Scratch-mount-directories-survive-cancellation
   (agent-workspace persistence).
8. §Path-based-not-inode-based-with-named-openat-future-
   work (honest-limitation-disclosure).

§Decisions-are-numbered-each-named-rationale. §Decision-2-
and-3-are-load-bearing-symmetry (creates-formula vs not).
§Decision-5-and-1-anchor-security. §Decision-8-is-§future-
hardening-target.

## §Phased-implementation-with-shipped-and-open-state

| Phase | Status | Content |
|-------|--------|---------|
| 1: Core mount exo + `mount` formula | **Complete** | reads + provideMount + `endo mount` CLI |
| 2: Mutation methods | **Complete** | write/remove/move/makeDirectory |
| 3: Scratch mounts | **Complete** | `scratch-mount` formula + `endo mkscratch` |
| 4: Sub-mounts + snapshot | **Not Started** | PR #135 |
| 5: Transient lookup exos | **Complete** | directory + file transient exos |
| 6: CLI commands (endo ls/cat/write) | **Partially Complete** | PR #153 absorbed some |

§Phases-1-3-and-5-shipped-2026-03-21 in commit `e22f71327`.
§Phase-4-and-6-open-as-PRs-#135-/-#127-/-#277.

§Twenty-integration-tests in `packages/daemon/test/endo.
test.js`: 13 core operations + 7 symlink confinement.
§Cross-reference-against-fs.promises ensures the daemon
observation matches direct-filesystem observation.

## §Five-design-dependencies

| Design | Relationship |
|--------|-------------|
| [platform-fs] | Uses `ReadableTree`, `ReadableBlob`, `File`, `Directory`, `SnapshotTree` types |
| [daemon-capability-filesystem] | Speculative vision; mount implements a concrete subset |
| [daemon-checkin-checkout] | `snapshot()` produces `readable-tree` consumable by `endo checkout` |
| [daemon-agent-tools] | Agent filesystem tools backed by mount capabilities |
| [daemon-content-store-gc] | Scratch-mount cleanup + content-store pruning |

§Dependency-graph-is-explicit. §Speculative-vision-realized-
as-concrete-subset observation: §daemon-capability-
filesystem.md is the wider design; mount is the §concrete-
mergeable-slice.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 161 (filesystem-watchers) | Direct sibling — `followNameChanges` on PR #277 extends EndoMount; same §operation-time-verification discipline |
| 156 (finalize.js) | §Transient-exos-from-lookup() relies on §weak-value-map-GC pattern |
| 164 (identity-backup-recovery) | §Existing-identity-conflict-guard analog: §single-mistake-cannot-destroy-state |
| 162 (ken-protocol-assessment) | §Atomic-checkpoint analog: host methods with deferred-tasks are atomic-creation; cranks are atomic-execution |
| 105 (daemon-capability-bank) | Sister daemon-capability design; both use exo/host axis |
| 89 (eventual-send pipeline) | §Read-soft-write-hard sibling: §don't-let-error-paths-reveal-too-much |

## §Single-most-structurally-interesting-move

The §two-formula-type-split-with-shared-exo-interface is
the design's §unique-shape. The split honors §lifecycle-
asymmetry (external-host-managed vs daemon-managed-storage)
without §sacrificing-implementation-symmetry (one exo
interface, one mount.js). §Lifecycle-asymmetry-vs-
implementation-symmetry as a §design-pattern-not-just-this-
design.

§Synthesis-target: future daemon capabilities that have
two lifecycle modes (host-provided vs daemon-provided)
could borrow this split. §Cycle-105's-daemon-capability-
bank might benefit from the same.

## §Reference-not-substrate stance

This is an in-progress *design* in our own ecosystem (not
a sibling implementation like ocap-kernel). §Our-design
status — we *are* the substrate, this is how we're
building it.

§Distinct-from-cycles-162-165's-§reference-not-substrate
stance: those were §read-for-comparison. This is §read-
to-understand-our-own-substrate.
