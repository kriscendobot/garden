---
title: 'endo-but-for-bots designs/endoclaw.md — EndoClaw: Feature Parity with OpenClaw'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endoclaw.md
source_paths:
  - designs/endoclaw.md
authors:
  - Kris Kowal (prompted)
  - Joshua T Corbin (edited)
created: 2026-03-03
updated: 2026-03-04
status_at_ingest: Reference
ingested: 2026-06-06
ingested_by: scholar
topics:
  - daemon
  - capability-security
sections:
  - endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference.md
genre: §endo-but-for-bots-design §parity-comparison-as-design-document
cycle: 196
lane: designs
---

# EndoClaw: Feature Parity with OpenClaw — design (Reference)

## §Abstract

444-line **Reference**-status design (Created 2026-03-03,
Updated 2026-03-04; two-author with editor comments
preserved inline) that maps §OpenClaw features to Endo
equivalents across §thirteen-feature-categories.

§The-design-genre: §parity-comparison-as-design-document
(not §propose-implement-ship). §The-Reference-status names
the lifecycle marker for §inventory-documents that inform
but don't propose new work.

§The-key-anchor: §honest-architectural-difference-named at
the design's opening — OpenClaw grants agents §ambient-
authority; Endo's §object-capability model means agents
hold only §specific-Dir-Shell-Git-capabilities-explicitly-
granted. §This-is-the-load-bearing-anchor that every
comparison-row references.

§Five-status-tags (Complete / Available / Designed / Not
designed / Not planned) cover the §feature-implementation-
and-intent space. §The-tags-are-distinct-from-design-
lifecycle-status (Complete / In Progress / Proposed /
Active / Reference / Implemented / Not Started).

§Gap-priority-classification (High/Medium/Low) with §one-
line-note-per-gap at the design's end. §Three-High-priority-
gaps: Web-Fetch-and-Search + Core-workspace-memory +
Heartbeat-Timer (§"core engine that constitutes a claw"
and §"core there that makes a claw tick").

§Inline-co-author-quote-blocks (`> Josh:` prefix; seven
blocks total) preserve §editorial-disagreement-without-
flattening. §Future-readers-see-both-perspectives.

§Seven-Endo-specific-advantages (no OpenClaw equivalent)
enumerate the §positive-side-of-parity-comparison.

§Seven-Related-Designs cross-links as §hub-and-spoke
navigation from Reference document to concrete-design slices.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/endoclaw.md` | 444 | This design (Reference) |
| `packages/chat/` | — | Chat UI (Complete) |
| `packages/lal/` | — | Anthropic + OpenAI + Ollama SDK integration |
| `packages/familiar/` | — | Familiar Electron shell |

## §Provenance and dependencies

- §Inventories-OpenClaw (formerly ClawdBot, formerly
  Moltbot) — Peter Steinberger's free + open-source personal
  AI assistant.
- §Cross-links to seven other Endo designs (Related-Designs
  section).
- §Cites-three-external-URLs (Anubis bot-protection; Home
  Assistant; Voxtral mini realtime).
- §Two-authors (Kris Kowal prompted; Joshua T Corbin
  edited).

## §Related sources in the library

- §Cycle 170 (`endo-but-for-bots--llm-designs-daemon-
  capability-filesystem.md`) — sibling Reference-status
  design at filesystem layer. §Both-are-§wider-vision-
  documents that concrete slices implement.
- §Cycle 174 (`endo-but-for-bots--llm-designs-gateway-
  package.md`) — §the-junction-design at gateway layer;
  sibling Reference-style.
- §Cycle 188 (`endo-but-for-bots--llm-designs-daemon-rust-
  xs-performance.md`) — §working-copy-inventory sibling
  pattern at the architecture-investigation layer.
- §Cycle 190 (`endo-but-for-bots--llm-designs-endo-posix-
  sandbox.md`) — §six-non-goals-explicitly-named sibling
  for §scope-clarification-via-explicit-refusal.
- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-snapshot.md`) — §revised-scope-discussion-2026-04-15
  sibling for §honest-design-evolution-preserved-in-source.
- §Cycle 49 (daemon-locator-terminology) — §rename-history-
  preserved-as-design sibling. §Cycle-196-preserves-OpenClaw's-
  three-rename-history (OpenClaw / ClawdBot / Moltbot).

## §Comment fragments worth preserving

```
OpenClaw (formerly ClawdBot, formerly Moltbot) is a free and
open-source personal AI assistant created by Peter
Steinberger.
```

§Three-rename-history-in-parenthetical-aside. §Future-reader-
searching-for-any-of-the-three-finds-this-document.

```
The fundamental architectural difference is the capability
model.  OpenClaw grants agents ambient authority — any tool
the agent calls operates with the user's full permissions.
Endo's object-capability model means agents hold only the
specific `Dir`, `Shell`, `Git`, and other capabilities
explicitly granted to them.  This is Endo's primary
differentiator for security.
```

§The-design's-load-bearing-anchor. §Every-comparison-row
references this difference.

```
> Josh: Only need a full-fat browser to evade countermeasures
>       like [Anubis][anubis].
```

§Five-§Josh-quote-blocks preserve §editorial-disagreement-
without-flattening. §Future-readers-see-both-perspectives.

```
| Web Fetch and Search capability                     | High     | Basic fetch and search provider API usage           |
| Core workspace / memory system                      | High     | This is the core engine that contitues a claw       |
| Heartbeat Timer                                     | High     | This is the core "there" that makes a claw tick     |
```

§Three-High-priority gaps named with §domain-vocabulary
(§"a claw"; §"contitues" sic — typo preserved). §The-§§"core
engine that contitues a claw" phrasing names the §gap-
priority-rationale in claw-user-vocabulary.

```
- **Object-capability confinement:** Agents cannot exceed granted authority
- **Interface guards:** Machine-readable method contracts enforce valid calls
- **Caretaker revocation:** Host can revoke any capability instantly
- **Structural filesystem confinement:** Cannot name paths outside granted root
- **Hardened JavaScript (SES):** Frozen primordials prevent prototype pollution
- **Formula-based persistence:** Typed, graph-structured durable state
- **Locator-based identity:** 256-bit cryptographic agent identifiers
```

§Seven-named-Endo-advantages with §one-line-explanation.
§The-§positive-side of the parity-comparison.
