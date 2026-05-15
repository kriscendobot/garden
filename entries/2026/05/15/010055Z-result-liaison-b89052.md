---
ts: 2026-05-15T01:00:55Z
kind: result
role: liaison
project: garden-library
refs:
  - entries/2026/05/15/005759Z-message-liaison-c7c53c.md
---

# Liaison: role-landings proof-of-concept + missive to gardener for designer multiplexing

## Maintainer ask

> *"We may need to ask the gardener to multiplex the designer role,
> so that the designer is responsible for choosing the type of
> designer best adapted to the design in question, albeit frontend
> engineering, security engineering, exo or captp API engineering,
> protocol engineering, language engineering, or the myriad of
> unexercised design challenges that UX involves from color theory
> to accessibility. I mention this to the scholar because these
> roles might be well differentiated by providing a landing in the
> journal for each of these roles that highlights the topics that
> are most relevant to the role, and the gardener can shape the
> roles to draw attention to these landings."*

Two coupled pieces of work split between gardener and scholar:

- **Gardener**: multiplex `roles/designer/` into specialists.
- **Scholar**: create `journal/library/roles/<role>.md` landing pages curating the topics, concepts, sources, and conventions per specialist.

The two don't have a strict ordering — landings can exist before
specialist role files; gardener wires the pointers when role files
land.

## Landed this dispatch (library territory)

`journal/library/roles/` is a new fourth indexing axis next to
sources, topics, and concepts:

- **`roles/README.md`** — landing-page discipline; explains the role-as-fourth-axis framing (sources / topics / concepts are content-organized; roles is reader-organized); landing shape spec; current inventory.
- **`roles/designer-protocol.md`** — proof-of-concept landing for the protocol-engineering specialist. Covers OCapN / CapTP / daemon wire formats / formula identifiers. Cites 15 concept pages, 7 topic pages, 3 design cluster overviews (daemon, OCapN family, implementation infrastructure), and the OCapN engagement constraints from `garden/CLAUDE.md`.

Landing structure (open for revision):

```
- When this landing is your starting point (1-3 sentences)
- Start here (read first) (3-5 anchor pages, ordered)
- Topics in scope
- Concepts in scope (with one-line context each)
- Cluster overviews (sources grouped by design cluster)
- Conventions and constraints (cross-cutting rules)
- Adjacent landings
```

The library README at `journal/library/README.md` is updated to:

- Add `roles/` to the Layout block.
- Add a fourth bullet to *"How to find something"* — *"A specialist role you're dispatched as"*.
- Note the content-organized vs reader-organized distinction.
- Add `[Roles](roles/README.md)` to the *Indexes* block.

## Queued for gardener (missive landed)

`entries/2026/05/15/005759Z-message-liaison-c7c53c.md` proposes the
designer-multiplexing approach. Key recommendations:

- Adopt the **thin `designer` router + specialists** shape (preserves the orchestrator-facing `designer` role; multiplexes the implementation).
- Start with the three specialists for which the library has densest coverage: `designer-protocol` (landing exists), `designer-security` (capability-security topic has 117 sections), `designer-exo-captp-api` (exo, captp, eventual-send, marshal are mature).
- Thinner-coverage specialists (`designer-frontend`, `designer-ux`, `designer-language`) can land later or as mostly-empty placeholders that grow with ingestion.

## Coordination protocol

To avoid landings for roles that might not survive gardener
deliberation, the scholar should wait for at least a draft of each
specialist's `roles/<specialist>/AGENT.md` before writing the
corresponding landing. The exception is `designer-protocol`, which
already exists this cycle as the proof-of-concept; future gardener-
side designer-protocol role content should align with what the
landing already cites.

## Why scholar (not liaison) should write future landings

This dispatch was done as liaison because:

1. The user was in the loop with a fresh proposal worth reacting to.
2. The shape of a landing was open and worth iterating on before the scholar's autonomous cycle picks it up.
3. The library README updates and the new `roles/` directory bootstrap belong at the same time as the first landing.

Future per-specialist landings are scholar work — they fit the
scholar's library-cycle pattern, and the scholar already has the
muscle memory for cross-cluster cross-referencing.

## Library state

- Sources: 102 (unchanged).
- Sections: 457 (unchanged).
- Concepts: 19 (unchanged).
- Keywords: ~167 (unchanged).
- Topics: 26 (unchanged).
- **Roles: 1 (new)** — `designer-protocol` proof-of-concept.

## Awaiting maintainer reaction

The landing shape is open. If the proof-of-concept reads wrong, the
shape changes before the other landings are written. If it reads
right, the gardener missive can proceed and the scholar can produce
the remaining landings as specialist roles get gardener-recognized.
