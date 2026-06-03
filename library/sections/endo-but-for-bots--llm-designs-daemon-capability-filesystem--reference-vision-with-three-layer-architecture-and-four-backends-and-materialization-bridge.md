---
source: designs/daemon-capability-filesystem.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-capability-filesystem.md
source_path: designs/daemon-capability-filesystem.md
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
cycle: 170
lane: designs
status: current
---

# Reference vision with three-layer architecture and four backends and materialization bridge

> §Endo-but-for-bots-design genre (designs-lane). §The-
> §wider-vision-that-cycle-166's-daemon-mount-is-the-
> §concrete-mergeable-slice-of. Status: **Reference**
> (transitioned 2026-03-21 when narrower `daemon-mount`
> absorbed the implementable slice; was originally an open
> proposal 2026-02-15).

`designs/daemon-capability-filesystem.md` (966 lines) is
the **§speculative-vision-document** that lays out the
design space for filesystem capabilities in Endo. The
narrower implementable slice has shipped as cycle 166's
daemon-mount. This document remains as §reference-for-
forward-looking-work with §per-idea-factoring guidance.

The single most structurally interesting move is the §three-
layer-architecture (Guest / VFS-Namespace / Backends) that
decouples §what-the-guest-sees from §how-the-storage-is-
backed, enabling §Bazel-style-selective-mounting where
§absence-is-structural-not-policy.

## §Reference-status-after-narrower-subset-shipped

> *Became a reference document 2026-03-21 when the narrower
> `daemon-mount` design absorbed the implementable slice.*

§Reference-as-design-archive-shape. The document was
originally an open proposal (2026-02-15); cycle 166's
daemon-mount cherry-picked the §physical-backend-with-
symlink-confinement subset and shipped it.

§The-wider-vision-survives-as-reference. Future concrete
designs can §pick-one-facet, write a focused design for
it, and build it without §waiting-for-the-whole-picture-
to-solidify.

§Per-idea-factoring-suggested as the §migration-path: the
document explicitly invites contributors to peel off ideas
into focused designs. §Each-idea-can-be-a-future-cycle.

§Roadmap-calibration-via-git-blame (named in the doc
itself): 14-day design phase (2026-02-15 → 2026-02-28);
reference transition 2026-03-21; no implementation against
this document directly. §Doc-lifecycle-is-recorded.

## §Three-layer-architecture (the spine)

```
┌─────────────────────────────────────────────┐
│               Guest (Dir / File)            │
│  Navigation, read, write, attenuation       │
│  Structural confinement — cannot go up      │
├─────────────────────────────────────────────┤
│        VFS Namespace (host-only)            │
│  Composes backends into a virtual tree      │
│  mount(), root(), control facets            │
├───────────┬─────────────┬───────────────────┤
│ Physical  │  Git Tree   │  Memory / CAS     │
│ Backend   │  Backend    │  Backend          │
└───────────┴─────────────┴───────────────────┘
```

§Three-layer-decoupling:

- **Guest layer** (`Dir` / `File`): the *only* capabilities
  the guest sees. §Structural-confinement — cannot navigate
  above the root.
- **VFS Namespace** (host-only): §composes-backends-into-
  a-virtual-tree. The guest cannot distinguish which paths
  are physical and which are virtual. §Chroot-jail-shape.
- **Backends**: provide storage behind the `Dir`/`File`
  interface. §Single-interface-multiple-backings.

§The-key-property: §the-guest-cannot-tell-which-backend-
serves-which-path. The same `Dir` and `File` methods work
whether the backing is physical, git tree, memory, or CAS.

§Endo-already-has-this-pattern: cycle 161's overview of
ocap-kernel noted the four-layer name-space (kref/vref/
rref/eref); this is the filesystem analog (one Dir
interface; multiple backends).

## §Four-backend-types sharing one Dir/File interface

| Backend | Mutability | Use case |
|---------|-----------|----------|
| **Physical** | Read-write | OS files; §sandbox-compatible (the daemon-mount slice) |
| **Git tree** | Read-only by default | Reference revision; experimentation without touching working tree |
| **Memory** | Read-write ephemeral | Scratch space; lost when VFS discarded |
| **CAS** | Read-only | Immutable content-addressed; build artifacts, datasets |

§Single-interface-multiple-backings = §polymorphism-by-
interface (sibling to cycle 166 daemon-mount's §ReadableTree-
compatible-reads-and-Mount-walk-the-same-way).

§Each-backend-is-independently-useful. §Each-can-be-built-
incrementally. The doc names the §good-candidates-for-
first-step:

1. Minimal physical-backend Dir/File (✓ shipped as cycle
   166 daemon-mount).
2. Read-only git-tree backend.
3. Materialization bridge.
4. VFS namespace compositor mounting multiple backends.

## §Bazel-style-selective-dependency-mounting

> *This is the same trick Bazel uses: a build step sees
> only the dependencies explicitly mounted into its
> sandbox. If a dependency is not declared, it is not
> mounted, and the build step cannot see it — the absence
> is enforced structurally, not by policy.*

§Absence-is-structural-not-policy. §A-guest-cannot-access-
$HOME/.ssh-if-no-mount-exposes-it, regardless of what the
physical filesystem contains.

§The-Bazel-property: §undeclared-dependencies-are-not-
denied-they-are-absent. §Structural-invisibility-not-
denylist.

§Why-this-matters-for-AI-agents: a prompt-injected agent
trying to read `~/.ssh/id_rsa` finds *no path* to it in
the VFS. The path doesn't exist as far as the agent is
concerned. §No-amount-of-clever-prompting-can-construct-
authority-it-doesn't-have.

§Cite-academic-research: the doc references
arxiv:2509.22040 (*Your AI, My Shell*) and the IDEsaster
report with §84%-success-rates-against-unprotected-
editors statistic. §Threat-model-with-citations is the
discipline.

## §Materialization-bridge-VFS-to-OS-sandbox

> *Materialization would bridge this gap: the VFS (or a
> subtree of it) is checked out to temporary physical
> storage, the sandboxed process runs against that
> checkout, and changes are read back into the VFS.*

§Two-staged-confinement: the §VFS-confines-what-can-be-
mounted; the §materialized-path-confines-what-the-
sandbox-can-see. §Defense-in-depth via §two-different-
confinement-mechanisms.

§Why-not-pass-non-physical-backends-directly-to-sandbox:
sandboxed native processes need *real* filesystem paths.
§Git-tree-and-memory-backends-aren't-filesystem-paths.
§Materialize-first-then-sandbox.

§syncBack-validates-changes-are-within-scope before
writing them back. §Materialization-is-a-controlled-
rights-expansion (named in Security Considerations).

§Connects-to-daemon-os-sandbox-plugin design (named in
the doc's dependency list). §Cross-design-coordination
encoded.

## §Single-dimension-attenuation-via-method-chaining

> *Attenuation happens by calling methods that each narrow
> in a single dimension. These methods return new
> capabilities and compose by chaining.*

§Each-method-narrows-one-dimension:

- **`readOnly()`** — removes write authority.
- **`subDir(path)`** — scopes to a subtree.

§Composable-by-chaining: `readOnly().subDir('src')` gives a
read-only Dir scoped to src/.

§Replaces-the-sketch's-`attenuate(opts)`-with-composable-
chainable-calls. §General-options-bag → §single-purpose-
methods. §Reading-the-chain-tells-you-the-attenuations.

§Attenuation-is-irreversible: §the-guest-cannot-recover-
authority-that-was-removed. The host can also revoke via
the caretaker facet.

§Cycle-166's-mount.readOnly() honors the same pattern.
§This-document-is-the-conceptual-parent of mount's
attenuation API.

## §Caretaker-facet-separation

> *The host holds control facets that are structurally
> separate from the capabilities granted to the guest.*

§Two-paired-facets-per-capability:

- `Dir` (granted to guest) / `DirControl` (held by host).
- `File` (granted to guest) / `FileControl` (held by host).

§DirControl.setWritable(false) — locks writes without the
guest's cooperation.
§DirControl.revoke() — invalidates the corresponding Dir.

§The-guest-cannot-discover-access-or-influence-the-control-
facet. §Structural-separation-not-policy.

§Caretaker-pattern from Miller-1973 cited in cycle 84
(Miller-Van-Cutsem-Tulloh's *Concurrency Among Strangers*)
applied here. §Canonical-ocap-pattern.

## §Defense-in-depth deny patterns

> *As a secondary safety net, the physical backend may
> apply hardcoded deny patterns to catch mistakes in VFS
> construction.*

§Two-tier-defense:

1. **§Primary**: §structural-confinement-via-selective-
   mounting (the Bazel property).
2. **§Secondary**: §hardcoded-deny-patterns at backend
   level (`**/.ssh/**`, `**/.aws/**`, `**/.env`,
   `**/*.pem`, etc.).

§Why-secondary-not-primary: structural confinement is *the*
defense; deny patterns catch §granting-mistakes. If a host
accidentally mounts `$HOME` instead of `$HOME/project`,
deny patterns block access to `.ssh/` etc.

§Backend-level-not-Dir-exo-level — §cannot-be-circumvented-
by-the-guest.

§Non-physical-backends-don't-need-these-patterns: they
contain only what was explicitly placed. §The-defense-is-
specific-to-physical-backing.

§Configurable-by-host: a credential-management agent
might legitimately need `.ssh/` access. §Sensible-default-
but-overridable.

## §LLM-discoverability via help() + interface guards

> *An LLM agent receiving a `Dir` or `File` capability can
> discover its interface through two mechanisms:
> 1. `help()` text — comprehensive natural-language
> documentation
> 2. Interface guards — machine-readable method signatures*

§Two-mechanisms-for-LLM-discovery:

- §Help()-as-prose: the help() text for Dir is ~70 lines,
  with method-by-method docs, parameter shapes, return
  types, examples.
- §Interface-guards-as-machine-readable: M.interface
  signatures that LLM tools can inspect.

§Help-as-LLM-onboarding: written for an LLM *that has
never seen this capability before*. §The-LLM-needs-to-
understand-only-the-Dir/File-methods-to-use-the-
filesystem.

§Guest-sees-only-Dir-and-File. Not Vfs, not backend types,
not control facets. §Minimal-LLM-vocabulary.

§Synthesis-target: future capability designs that target
LLM agents should follow the §help()-plus-interface-guards
shape. §Two-channels-for-machine-and-human-understanding.

## §Path-segment-validation-multi-layer

> *The `PathSegment` type must reject names containing
> `/`, `\`, `..`, or the null byte. These checks occur in
> the `Dir` exo, not just in the backend, so they are
> enforced even for in-memory or CAS-backed filesystems.*

§Defense-in-depth-applies-even-to-in-memory-backends.
§Validation-at-the-exo-layer-not-just-backend-layer.

§subDir(path)-splits-on-`/`-validates-each-segment-and-
resolves-eagerly. §Eager-resolution-avoids-TOCTOU between
scoping and use. §Returned-Dir-holds-direct-reference-to-
resolved-subtree.

§Cycle-166's-mount has the operation-time confinement
check. §This-document-says-the-segment-validation-is-
exo-layer-not-backend-only.

## §Endo-already-has-this-pattern map

> *Any concrete design should build on these existing
> pieces rather than introducing parallel abstractions.*

§Six-named-relationships:

1. **§Pet-name-directory** (`packages/daemon/src/directory.
   js`): same structural pattern; different purpose.
2. **§VFS-design-sketch** (`docs/virtual-filesystem-design.
   md`): the architectural foundation.
3. **§FilePowers** (daemon types): raw path-based ops;
   this layer §wraps-and-confines.
4. **§OS-sandbox-plugin** (`daemon-os-sandbox-plugin.md`):
   filesystem endowments; materialization bridges.
5. **§EndoDirectory**: pet-name store maps names to
   formula IDs; filesystem Dir maps names to file nodes.
6. **§Existing-`attenuate(opts)`-in-sketch**: this design
   replaces with composable methods.

§Map-to-existing-substrate-not-parallel-abstractions. §The-
new-design-extends-existing-vocabulary.

## §Seven-Open-Questions enumerated

The doc names §seven-deferred-decisions:

1. What is the right backend interface?
2. Should `glob()` live on `Dir` or as a separate utility?
3. How should the VFS handle overlapping/shadowing mounts?
4. What are atomicity semantics for cross-mount writes?
5. How should materialization handle large subtrees?
6. Is `subDir(path)` the right name? (Alternatives:
   `chroot(path)`, `scope(path)`.)
7. Should `readOnly()` and `subDir()` return new exos with
   their own control facets?

§Honest-deferral-discipline. §These-questions-belong-to-
future-concrete-designs.

§Cycle-149's-three-open-questions (unhandled-rejection-
display) follow the same shape. §Open-Questions-as-design-
artifact across the design corpus.

## §Threat-model-with-citations

> *Ambient access lets a prompt-injected agent read
> credentials (`~/.ssh/id_rsa`, `~/.aws/credentials`),
> poison configuration (`~/.bashrc`, `.git/hooks`), or
> exfiltrate source code — attacks demonstrated at 84%
> success rates against unprotected editors [1][2].*

§Cited-academic-research:
- arxiv:2509.22040 (Liu et al., *Your AI, My Shell*, Sep
  2025)
- IDEsaster report (Marzouk, Dec 2025)

§84%-success-rate-against-unprotected-editors. §The-
problem-is-empirically-documented.

§Cycle-94's-OCPL paper cited Mark Stiegler 2006 HPL-2006-
116 in similar fashion. §Cited-research-anchors-the-
motivation.

§This-design-is-the-response-to-documented-attack-
patterns. §Defense-driven-by-evidence-not-theoretical-
threat-model.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 166 (daemon-mount) | §The-concrete-mergeable-slice of this vision; mount = physical-backend slice |
| 168 (daemon-checkin-checkout) | §Snapshot-and-restore complements mount; both within this vision |
| 161 (filesystem-watchers) | §Live-update extension that this vision's Dir interface would need |
| 105 (daemon-capability-bank) | §Sister capability-design (meta-framework); this is one capability in the bank |
| 107 (daemon-agent-tools) | §Agent-tool-shapes; Filesystem via `Dir` mentioned this design |
| 156 (finalize.js) | §WeakValueMap pattern; Dir/File exos would use it |
| 94 (OCPL paper) | §Threat-model-with-citations precedent |

## §Synthesis-target

§Reference-document-as-roadmap-source. Future cycles can
pick:

- **Git tree backend** — currently un-designed; would
  let agents experiment against a revision without
  touching working tree.
- **Memory backend** — ephemeral scratch space.
- **CAS backend** — immutable artifacts.
- **VFS namespace compositor** — the multi-mount layer.
- **Materialization bridge** — non-physical → sandbox-
  visible.

§Each-of-these-is-a-future-concrete-design. §Per-idea-
factoring as the §recommended-path.

§Why-this-stayed-reference: the §wider-vision was too
broad to implement at once; §absorbing-the-implementable-
slice into a narrower design is the §correct-refactor-
of-design-effort.

## §Tier-1 vocabulary borrowing candidates

§Three-layer-architecture (Guest / VFS-Namespace /
Backends), §Single-interface-multiple-backings, §Bazel-
style-selective-dependency-mounting, §Absence-is-
structural-not-policy, §Materialization-bridges-VFS-to-
OS-sandbox, §Single-dimension-attenuation-via-method-
chaining, §Caretaker-facet-separation, §Defense-in-depth-
deny-patterns-as-secondary, §help()-plus-interface-guards-
for-LLM-discoverability.

§Tier-2: §Per-idea-factoring (reference-document-as-
roadmap), §Threat-model-with-citations.

## §Reference-design-as-genre

§Reference status is distinct from §Not-Started,
§Implemented, §Complete, §Deprecated. §A-reference-
design encodes design-space exploration that doesn't
ship as a single artifact but seeds future concrete
designs.

§Cycles-49 (daemon-locator-terminology), §94 (OCPL),
§85 (Drossopoulou) are §reference-shape but in different
genres. This is the first §Endo-internal-reference-
design ingested.

§Synthesis-target: future Endo design archives could
follow §Reference-status-after-narrower-subset-shipped
pattern. §Honest-design-archival is a tool worth using.
