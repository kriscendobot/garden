---
title: "endoclaw-skill-registry — Skills directory built on EndoDirectory with no new abstractions; capability declaration via directory structure"
source-slug: endo-but-for-bots--llm-designs-endoclaw-skill-registry
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-skill-registry.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-skill-registry.md
total-lines: 252
status: Not Started (Parent: endoclaw)
ingest-cycle: 222
ingest-date: 2026-06-08
lane: designs
---

# endoclaw-skill-registry.md

A 252-line **Not Started** design (created and updated 2026-03-03; Parent: endoclaw). The most structurally interesting move is §the-no-new-abstractions discipline — a skill registry is *just an EndoDirectory*; skill descriptors are *just EndoDirectories*; metadata is *just string values*. The §named-Endo-Idiom-section enumerates the five disciplines that emerge from that substrate choice.

## Key design moves

- **§Parent-pointer-as-explicit-frontmatter-field** — §twentieth honest-design-evolution-record family member with a new shape.
- **§No-new-abstractions** — registry IS a directory; descriptors ARE directories; metadata IS string values.
- **§Three-recursive-EndoDirectory-levels** with §uniform-shape-with-recursive-nesting.
- **§Capability-declaration-via-directory-structure** — `requires/` subdirectory enumerates needs as pet-name entries; §encode-structured-metadata-as-directory-structure + §don't-invent-a-new-metadata-format.
- **§No-ambient-authority** — installing creates a confined guest; `requires` is advisory not authoritative.
- **§Five-step-CLI-installation** composing existing verbs (no new verbs) + §single-convenience-command wrapping the flow.
- **§Decentralized-by-default** — any agent creates a registry; §the-built-in-registry-is-convenience-not-authority.
- **§Federation-by-reference** with §three-named-federation-patterns (multiple-roots + cross-reference + filtered-view-via-copy).
- **§Live-discovery via followNameChanges** — same mechanism as Chat UI inbox watching.
- **§Discriminated-union-via-key-presence** (`'add' in change`) not via discriminator string — §rare-and-load-bearing.
- **§Built-in-registry as Specials-mechanism** (same as `@apps`, `@lal`, `@fae`).
- **§Publishing-flow as send-to-registry-operator** — §publishing-as-a-mail-message-not-an-RPC.
- **§Depends-On section with status-per-dependency** — three already-implemented + one precondition.
- **§The-named-Endo-Idiom-section** enumerating five emergent principles.

## Section files

- [§no-new-abstractions + §capability-declaration-via-directory-structure + §decentralized-by-default + §federation-by-reference](../sections/endo-but-for-bots--llm-designs-endoclaw-skill-registry--no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference.md) — full design ingested as one section.

## Ingest scope

Cycle 222 (designs-lane): full ingest of the 252-line design as one section. The design is a §component-of the endoclaw parent (not yet ingested); demonstrates the §no-new-abstractions discipline at the §capability-storage substrate.
