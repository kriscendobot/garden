# Role landings

Per-role *landing pages* curating the topics, concept pages, sources, and conventions most relevant to one specialist's domain. A fourth indexing axis next to:

- `sources/` (by provenance — which upstream document said this)
- `topics/` (by broad subject taxonomy — what the material is about)
- `concepts/` (by lookup unit — the specific term a reader is looking up)
- **`roles/`** (by who's reading — the specialist's corner of the corpus)

Where the first three axes are *content-organized*, roles are *reader-organized*. A landing is a fast orientation — *"you are a protocol-engineering designer; here is your corner of the library"* — pointing at deeper material rather than re-stating it.

## When a landing is added

A role landing exists when:

1. A role file in `garden/roles/<role>/AGENT.md` references it as part of dispatch orientation, OR
2. A specialist sub-role is gardener-recognized as recurring enough to warrant pre-curated material.

The gardener owns role-file content; the scholar owns landing content. The gardener edits `roles/<role>/AGENT.md` to point at the corresponding `journal/library/roles/<role>.md` landing. Either side can land first — they couple at the dispatch prompt.

## Landing shape

```yaml
---
role: <role-name>          # matches garden/roles/<role>/AGENT.md when one exists
status: seed | active
authored: <ISO date>
---
```

Body sections (kept short — a landing is an orientation, not a primer):

- **When this landing is your starting point** — 1-3 sentences on when the role applies.
- **Start here (read first)** — 3-5 anchor concept pages or topic pages, ordered.
- **Topics in scope** — bulleted list with one-line context each.
- **Concepts in scope** — bulleted list with one-line context each.
- **Cluster overviews** — source documents grouped by design cluster, with a one-line synthesis of each cluster.
- **Conventions and constraints** — cross-cutting rules, project engagement constraints (e.g. OCapN-specific language), or style notes specific to the role.
- **Adjacent landings** — links to other role-landings for cross-discipline questions.

A landing that grows past one screen probably wants to split (e.g. `designer-protocol` would split into `designer-protocol-ocapn` and `designer-protocol-daemon` if the corpus pulled the two apart).

## Current inventory (seed, 2026-05-15)

- [designer-protocol](designer-protocol.md) — protocol engineering: OCapN, CapTP, daemon retention/persistence wire formats, formula identifiers. *(proof-of-concept; awaiting gardener-side role-multiplexing for the rest of the specialist designer roles.)*

## Pending: specialist designer roles

The maintainer proposed (2026-05-15) multiplexing the generic `designer` role into specialist sub-roles, each with its own landing:

- `designer-frontend` (web UI engineering)
- `designer-security` (capability-security policy + threat modelling)
- `designer-exo-captp-api` (Exo/CapTP API surface design)
- `designer-protocol` (OCapN / CapTP / daemon wire formats — **landed this cycle**)
- `designer-language` (language and DSL design)
- `designer-ux` (color, accessibility, interaction)

The role-multiplexing on the gardener side is queued as a separate missive; landings will follow as the specialist roles are defined.
