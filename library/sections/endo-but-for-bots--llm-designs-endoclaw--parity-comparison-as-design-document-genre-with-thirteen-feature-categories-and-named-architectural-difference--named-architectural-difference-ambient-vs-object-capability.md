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
title: §Named-architectural-difference (ambient-vs-object-capability)
parent: endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference
---

§The-design-anchors-on §one-load-bearing-difference: OpenClaw
grants agents ambient authority; Endo uses object-capability
discipline.

```
The fundamental architectural difference is the capability
model.  OpenClaw grants agents ambient authority — any tool
the agent calls operates with the user's full permissions.
Endo's object-capability model means agents hold only the
specific `Dir`, `Shell`, `Git`, and other capabilities
explicitly granted to them.  This is Endo's primary
differentiator for security.
```

§The-§§"fundamental architectural difference" phrase is the
§named-anchor for every comparison-row that follows. §Reader-
must-know-this-before-reading-the-tables.

§Compare-to-cycle-178-snapshot's §single-most-structurally-
interesting-move (§snapshot-as-internal-implementation-detail).
§Both-name-one-load-bearing-difference at the design's
opening; the rest of the design unfolds from that anchor.

§Compare-to-cycle-190-endo-posix-sandbox's §three-rules-of-
security-boundary-clarity. §Both-are-§named-security-
discipline-anchors; cycle 190 enumerates rules; cycle 196
names the §axis-of-disagreement.

§The-§§"primary differentiator for security" claim is repeated
in the Security-Model section with concrete attack examples:

```
OpenClaw's agent has ambient authority — it can read
`~/.ssh/id_rsa`, run `curl` to exfiltrate data, or modify
`~/.bashrc` for persistence.  Endo's object-capability model
makes these attacks structurally impossible: the agent
literally cannot name paths outside its granted `Dir` root,
cannot execute commands outside its `Shell` allowlist, and
cannot access network endpoints outside its granted scope.
```

§Three-named-attacks (~/.ssh/id_rsa + curl-exfiltration +
~/.bashrc-persistence) + §three-structural-defenses (Dir
confinement + Shell allowlist + network scope). §Symmetric-
enumeration.

§Compare-to-cycle-186-break-dev-deps' §three-cited-costs-of-
the-cycle (cosmetic noise + silent-by-default conflict +
weaker cache hash). §Both-are-§three-named-instances of an
underlying claim. §Cycle-186-on-process; cycle-196-on-attack-
surface.
