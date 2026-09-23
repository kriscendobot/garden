---
source: designs/daemon-capability-filesystem.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-capability-filesystem.md
source_branch: master
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 170. Designs-lane after cycle 169's chat-lane.
  §Endo-but-for-bots-design genre. §The-wider-vision-that-
  cycle-166's-daemon-mount-is-the-§concrete-mergeable-slice-
  of.

  Status: **Reference** (transitioned 2026-03-21 when the
  narrower `daemon-mount` design absorbed the implementable
  slice; was originally an open proposal 2026-02-15).

  966-line speculative-vision document. §The-first-Endo-
  internal-Reference-design ingested.

  §Reference-status-after-narrower-subset-shipped: this
  document was originally an open proposal; cycle 166's
  daemon-mount cherry-picked the §physical-backend-with-
  symlink-confinement subset and shipped it. The wider
  vision survives as §reference-for-forward-looking-work
  with §per-idea-factoring guidance.

  §14-day-design-phase (2026-02-15 → 2026-02-28); §reference-
  transition 2026-03-21. §Roadmap-calibration-via-git-blame
  is recorded in the doc itself.

  **Single most structurally interesting move**: §three-
  layer-architecture (Guest / VFS-Namespace / Backends)
  that decouples §what-the-guest-sees from §how-the-
  storage-is-backed.

  §Three-layer-decoupling:
  - Guest (Dir/File): only capabilities the guest sees;
    structural confinement
  - VFS Namespace (host-only): composes backends into a
    virtual tree; §chroot-jail-shape
  - Backends: provide storage behind Dir/File interface;
    §single-interface-multiple-backings

  §Four-backend-types: Physical (read-write; OS files;
  sandbox-compatible) / Git Tree (read-only by default;
  commit/branch/tag) / Memory (ephemeral scratch) / CAS
  (immutable; content-addressed). §Each-independently-
  useful; §each-can-be-built-incrementally.

  §Bazel-style-selective-dependency-mounting: §absence-is-
  structural-not-policy. §Undeclared-dependencies-are-
  absent-not-denied. §No-amount-of-clever-prompting-can-
  construct-authority-it-doesn't-have.

  §Materialization-bridge-VFS-to-OS-sandbox: non-physical
  subtrees (git tree, memory, CAS) check out to temp
  physical storage for sandboxed native processes;
  syncBack validates changes within scope. §Two-staged-
  confinement (VFS-mount + materialized-path).

  §Single-dimension-attenuation-via-method-chaining:
  `readOnly()` + `subDir(path)`. §Composable-by-chaining.
  §Replaces-the-sketch's-`attenuate(opts)`-with-composable-
  chainable-calls. §Attenuation-is-irreversible.

  §Caretaker-facet-separation: DirControl + FileControl
  held by host; structurally separate from Dir/File granted
  to guest. §setWritable(false) + revoke() without guest's
  cooperation. §Canonical-ocap-caretaker-pattern from
  Miller-1973.

  §Defense-in-depth-deny-patterns: §primary structural
  confinement via selective mounting + §secondary hardcoded
  deny patterns at backend level (`.ssh/`, `.aws/`,
  `.env`, `.pem`, etc.). §Backend-level-not-Dir-exo-level
  so guest cannot circumvent. §Configurable-by-host.
  §Non-physical-backends-don't-need-these-patterns.

  §LLM-discoverability-via-help-plus-interface-guards:
  help() text comprehensive prose for LLM that has never
  seen this capability; interface guards machine-readable
  for tools. §Two-channels-for-machine-and-human-
  understanding. §Help-as-LLM-onboarding.

  §Path-segment-validation-multi-layer: PathSegment type
  rejects `/`, `\`, `..`, null byte; checks in Dir exo
  not just backend; §enforced-even-for-in-memory-backends.
  §subDir-resolves-eagerly to §avoid-TOCTOU.

  §Endo-already-has-this-pattern map: §six-named-
  relationships to existing abstractions (pet-name
  directory, VFS sketch, FilePowers, OS sandbox plugin,
  EndoDirectory, existing attenuate). §Map-to-existing-
  substrate-not-parallel-abstractions.

  §Seven-Open-Questions enumerated. §Honest-deferral-
  discipline. §These-questions-belong-to-future-concrete-
  designs.

  §Threat-model-with-citations: arxiv:2509.22040 (Liu
  et al., *Your AI, My Shell*) + IDEsaster report
  (Marzouk). §84%-success-rate-against-unprotected-
  editors. §Defense-driven-by-evidence-not-theoretical.

  §Gap-revealing-comparison with cycles 166/168/161/105/
  107/156/94.

  §Synthesis-target: §reference-document-as-roadmap-
  source. Future concrete designs picking specific
  facets: §Git-tree-backend, §Memory-backend, §CAS-
  backend, §VFS-namespace-compositor, §Materialization-
  bridge.

  §Reference-design-as-genre: first Endo-internal-
  Reference-design ingested. §A-reference-design encodes
  design-space exploration that doesn't ship as a single
  artifact but §seeds-future-concrete-designs.

  §Tier-1 vocabulary borrowing: §three-layer-architecture,
  §single-interface-multiple-backings, §Bazel-style-
  selective-dependency-mounting, §absence-is-structural-
  not-policy, §materialization-bridges-VFS-to-OS-sandbox,
  §single-dimension-attenuation-via-method-chaining,
  §caretaker-facet-separation, §defense-in-depth-deny-
  patterns-as-secondary, §help-plus-interface-guards-for-
  LLM-discoverability.

  Cycle 170 was nominally designs-lane (after cycle 169's
  chat-lane). Papers-lane blocked 64+ consecutive cycles.
---

> Abstract: `designs/daemon-capability-filesystem.md` (966
> lines) is the **§speculative-vision-document** that lays
> out the design space for filesystem capabilities in
> Endo.
>
> Status: **Reference** — transitioned 2026-03-21 when
> the narrower `daemon-mount` (cycle 166) absorbed the
> implementable slice. The wider vision survives as
> §reference-for-forward-looking-work with §per-idea-
> factoring guidance.
>
> **Single most structurally interesting move**: §three-
> layer-architecture (Guest / VFS-Namespace / Backends)
> decouples §what-the-guest-sees from §how-the-storage-
> is-backed.
>
> §Four-backend-types sharing one Dir/File interface
> (Physical / Git Tree / Memory / CAS). §Single-interface-
> multiple-backings.
>
> §Bazel-style-selective-dependency-mounting — §absence-
> is-structural-not-policy. §No-amount-of-clever-
> prompting-can-construct-authority-it-doesn't-have.
>
> §Materialization-bridge-VFS-to-OS-sandbox enables sand-
> boxed native processes to see non-physical subtrees.
>
> §Single-dimension-attenuation-via-method-chaining
> (readOnly + subDir) replaces general attenuate(opts).
> §Caretaker-facet-separation (Dir / DirControl pair).
> §Defense-in-depth-deny-patterns as secondary.
>
> §LLM-discoverability-via-help-plus-interface-guards.
> §Threat-model-with-citations (arxiv:2509.22040,
> IDEsaster; 84% attack success rate).
>
> §Seven-Open-Questions enumerated (§honest-deferral).
> §Endo-already-has-this-pattern map with §six-named-
> relationships.
>
> §Synthesis-target: §reference-document-as-roadmap-source
> — Git tree backend, Memory backend, CAS backend, VFS
> namespace compositor, Materialization bridge are
> §future-concrete-design candidates.
>
> §First-Endo-internal-Reference-design ingested.
> §Reference-design-as-genre.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge](../sections/endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge.md) | daemon, capability-security, patterns | current |

One cohesion-honest section. §The-three-layer-architecture
is the spine; §splitting-would-fragment-the-vision.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@master`.
- Author: Kris Kowal (prompted).
- Cycle 170 was nominally **designs-lane** (after cycle
  169's chat-lane). §The-wider-vision-document for cycle
  166's daemon-mount. Papers-lane blocked **64+
  consecutive cycles**.
- One cohesion-honest section.
