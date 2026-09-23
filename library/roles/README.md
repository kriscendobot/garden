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

The three densest-coverage specialist designer landings exist as seeds; the gardener-side role-multiplexing is queued separately (see the cycle's missive at `entries/2026/05/15/005759Z-message-liaison-c7c53c.md`):

- [designer-protocol](designer-protocol.md) — protocol engineering: OCapN, CapTP, daemon retention/persistence wire formats, formula identifiers.
- [designer-security](designer-security.md) — capability-security and policy engineering: revocation discipline, allowlist mechanisms, threat models, identity claims. Citing the densest topic in the library (`capability-security`, 117 sections).
- [designer-exo-captp-api](designer-exo-captp-api.md) — Exo class design, interface guards, CapTP API surface. Citing the mature topics `exo`, `eventual-send`, `captp`, `marshal`, `pass-style`.

## Pending: thinner-coverage specialists

The maintainer's proposal (2026-05-15) included three more specialists whose library coverage is currently thin; their landings will be seeded as ingestion fills out the relevant topics:

- `designer-frontend` (web UI engineering) — will draw from the chat-ui topic (currently 2 sections, ~20 chat designs in backlog).
- `designer-language` (language and DSL design) — will draw from `hardened-javascript`, `compartments`, `pass-style`, and the SES shim cluster.
- `designer-ux` (color theory, accessibility, interaction) — will draw from the chat-ui topic and chat-related designs as they ingest. Color theory / accessibility material is essentially absent from the library today.

The role-multiplexing on the gardener side is queued as a separate missive; landings will follow as the specialist roles are defined.
