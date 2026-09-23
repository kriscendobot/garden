---
source: designs/endoclaw.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endoclaw.md
section_kind: design
ingested: 2026-06-06
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Joshua T Corbin (edited)
topics:
  - daemon
  - capability-security
status_at_ingest: Reference
genre: §endo-but-for-bots-design §parity-comparison-as-design-document
cycle: 196
lane: designs
status: current
title: §The-§§"Endo-specific advantages (no OpenClaw equivalent)"
parent: endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference
---

```
- **Object-capability confinement:** Agents cannot exceed granted authority
- **Interface guards:** Machine-readable method contracts enforce valid calls
- **Caretaker revocation:** Host can revoke any capability instantly
- **Structural filesystem confinement:** Cannot name paths outside granted root
- **Hardened JavaScript (SES):** Frozen primordials prevent prototype pollution
- **Formula-based persistence:** Typed, graph-structured durable state
- **Locator-based identity:** 256-bit cryptographic agent identifiers
```

§Seven-named-Endo-advantages, each phrased as a §named-
property + §one-line-explanation.

§This-is-the-§positive-side of the parity-comparison: not
just "what OpenClaw has that Endo doesn't" but "what Endo
has that OpenClaw doesn't." §The-symmetry-makes-the-
comparison-honest.

§Compare-to-cycle-178-snapshot's §two-named-use-cases (suspend-
idle-agents + checkpoint-long-computations) + cycle-180-hex-
package's §three-concrete-costs-of-duplication. §All-three-
are-§enumerated-named-positive-claims.

§Compare-to-cycle-190-endo-posix-sandbox's §six-non-goals
(scope-clarification-via-negation). §Cycle-196-symmetric:
§seven-Endo-advantages (positive enumeration) + the §thirteen-
gaps (negative enumeration).

§Tier-1-borrowing: §seven-named-advantages-with-one-line-
explanation for §positive-side-of-parity-comparison.
