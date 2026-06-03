---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--0941af
ts: 2026-06-03T21:23:28Z
ref_id: 0941af
---

# Cycle 170: endo-but-for-bots daemon-capability-filesystem.md (Reference vision; first Endo-internal Reference design)

Cycle 170 — designs-lane after cycle 169's chat-lane.
§Endo-but-for-bots-design genre.

**The §wider-vision-that-cycle-166's-daemon-mount-is-the-
§concrete-mergeable-slice-of**. Together with cycle 168's
daemon-checkin-checkout, this completes the §filesystem-
capability-trilogy: this is the speculative vision; mount
is the concrete live-mutable slice; checkin/checkout is
the snapshot/restore bridge.

## Source

`endojs/endo-but-for-bots designs/daemon-capability-
filesystem.md`. Author Kris Kowal (prompted). Status
**Reference** (transitioned 2026-03-21). 966 lines —
**§first-Endo-internal-Reference-design ingested**.

## Sections written (1)

`endo-but-for-bots--llm-designs-daemon-capability-
filesystem--reference-vision-with-three-layer-architecture-
and-four-backends-and-materialization-bridge.md` (435
lines; commit `48e62e88`).

**§Cohesion-honest section count**: One. §The-three-layer-
architecture is the spine; §splitting-would-fragment-the-
vision.

## Single most structurally interesting move

**§Three-layer-architecture** (Guest / VFS-Namespace /
Backends) that decouples §what-the-guest-sees from §how-
the-storage-is-backed.

§Four-backend-types share one Dir/File interface (Physical
/ Git Tree / Memory / CAS). §Single-interface-multiple-
backings.

§Bazel-style-selective-dependency-mounting: §absence-is-
structural-not-policy. §A-guest-cannot-access-$HOME/.ssh-
if-no-mount-exposes-it.

## Notable structural moves

- **§Materialization-bridge-VFS-to-OS-sandbox**: §two-
  staged-confinement; non-physical subtrees check out to
  temp storage for sandboxed native processes.
- **§Single-dimension-attenuation-via-method-chaining**
  (readOnly + subDir) replaces general §attenuate(opts).
- **§Caretaker-facet-separation** (DirControl + FileControl
  held by host; §canonical-ocap-Miller-1973).
- **§Defense-in-depth-deny-patterns** as §secondary (the
  primary defense is structural confinement via selective
  mounting).
- **§LLM-discoverability-via-help-plus-interface-guards**
  (§two-channels-for-machine-and-human-understanding).
- **§Threat-model-with-citations**: arxiv:2509.22040 +
  IDEsaster report; §84%-attack-success-rate.
- **§Seven-Open-Questions** enumerated (§honest-deferral).
- **§Six-named-relationships** to existing Endo
  abstractions.

## §Reference-design-as-genre

§First-Endo-internal-Reference-design ingested.

§Reference-status distinct from Not-Started / Implemented
/ Complete / Deprecated. §A-reference-design encodes
design-space exploration that doesn't ship as a single
artifact but §seeds-future-concrete-designs.

§Per-idea-factoring as the §migration-path. §Future-
concrete-designs picking specific facets are the
§recommended-path:
- Git tree backend
- Memory backend
- CAS backend
- VFS namespace compositor
- Materialization bridge

§Cycle-166's-daemon-mount is the first §future-concrete-
design that materialized; cycle 168's checkin/checkout is
adjacent. The vision survives as roadmap.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 166 (daemon-mount) | §The-concrete-mergeable-slice of this vision |
| 168 (daemon-checkin-checkout) | §Snapshot-and-restore complement within this vision |
| 161 (filesystem-watchers) | §Live-update extension that this Dir interface would need |
| 105 (daemon-capability-bank) | §Sister capability-design (meta-framework) |
| 107 (daemon-agent-tools) | §Agent-tool-shapes; Filesystem via `Dir` was named here |
| 94 (OCPL paper) | §Threat-model-with-citations precedent |

## §Tier-1 vocabulary borrowing candidates

§Three-layer-architecture, §single-interface-multiple-
backings, §Bazel-style-selective-dependency-mounting,
§absence-is-structural-not-policy, §materialization-
bridges-VFS-to-OS-sandbox, §single-dimension-attenuation-
via-method-chaining, §caretaker-facet-separation,
§defense-in-depth-deny-patterns-as-secondary, §help-plus-
interface-guards-for-LLM-discoverability.

## §Synthesis-target

§Reference-document-as-roadmap-source. §Each-idea-can-be-
a-future-cycle.

§Future-Endo-design-archives can follow §Reference-status-
after-narrower-subset-shipped pattern. §Honest-design-
archival is a tool worth using.

## Files written / edited

- `library/sections/endo-but-for-bots--llm-designs-daemon-
  capability-filesystem--reference-vision-with-three-
  layer-architecture-and-four-backends-and-materialization-
  bridge.md` (435 lines; commit `48e62e88`)
- `library/sources/endo-but-for-bots--llm-designs-daemon-
  capability-filesystem.md` (new source page)
- `library/sources/README.md` (cycle-170 row added in the
  Ingested section above cycle-168's checkin-checkout
  row)
- `library/sections/README.md` (cycle-170 entry; totals
  bumped 674/215 → 675/216)
- `library/topics/daemon.md` (cycle-170 row)
- `library/topics/capability-security.md` (cycle-170 row;
  §Bazel-style-selective-dependency-mounting is the
  §primary-defense; threat-model citations)
- `library/topics/patterns.md` (cycle-170 row;
  §three-layer-architecture as §reusable-decoupling-pattern)
- `library/keywords.md` (66 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

674 / 215 → **675 sections from 216 source documents**.

## Lane rotation note

Cycle 170 was nominally **designs-lane** (after cycle
169's chat-lane). Papers-lane blocked **64+ consecutive
cycles**.

Lane sequence over the last 14 cycles:
- 157-160: designs/chat/designs/chat
- 161: designs + user-directed off-rotation
- 162-165: comments (ocap-kernel mini-series)
- 166-167: designs (break) + chat
- 168-169: designs + chat
- 170: designs

§Designs/chat-alternation maintained since cycle 166.
§The-filesystem-capability-trilogy (cycles 166 + 168 +
170) now complete in the library.

## Cycle 170 — done. Schedule cycle 171.
