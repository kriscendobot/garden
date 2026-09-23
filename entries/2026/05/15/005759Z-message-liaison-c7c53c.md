---
date: 2026-05-15T00:57:59Z
host: endolin
role: liaison
kind: message
to: gardener
from: liaison
re: proposal — multiplex the designer role into specialist sub-roles; couple with library role-landings
---

# Multiplex `roles/designer/` into specialist sub-roles

## Maintainer ask (2026-05-15)

The maintainer proposed multiplexing the generic `designer` role into
specialist sub-roles, each adapted to a different design-engineering
discipline:

- `designer-frontend` — web UI engineering.
- `designer-security` — capability-security policy + threat modelling.
- `designer-exo-captp-api` — Exo class design + CapTP API surface.
- `designer-protocol` — OCapN / CapTP / daemon wire formats.
- `designer-language` — language and DSL design.
- `designer-ux` — color theory, accessibility, interaction.

(The list is illustrative, not closed; *"the myriad of unexercised
design challenges"* the maintainer named explicitly leaves room for
more.)

The maintainer's framing: *"the designer is responsible for choosing
the type of designer best adapted to the design in question."* Two
plausible shapes for the gardener to consider:

1. **Specialist roles only**, dispatched directly by the orchestrator
   (steward or liaison). The orchestrator picks the specialist from
   the design's shape.
2. **Thin `designer` dispatcher + specialist sub-roles**, where
   `designer` is a tiny role that reads the prompt, picks the
   specialist, and delegates. This preserves the current orchestrator
   contract (`designer` is still the addressable role) while letting
   the specialist do the substantive work.

Maintainer recommendation is implicit in their phrasing — the
designer *role* chooses the specialist; the specialists *are* the
designers. So option (2) is more faithful: keep `designer` as the
public-API role, multiplex the implementation.

## Coupled library work (scholar territory)

The maintainer also asked the **scholar** to provide *role-landing
pages* in the library, one per specialist, highlighting the topics,
concepts, and sources most relevant to that specialist's domain. The
gardener's role-file edits would then point each specialist's
`roles/<specialist>/AGENT.md` at its corresponding
`journal/library/roles/<specialist>.md` landing on dispatch.

A proof-of-concept landing has already been created
this cycle as `journal/library/roles/designer-protocol.md`, plus a
`journal/library/roles/README.md` documenting the landing-page
discipline. The landing is structured as:

- **When this landing is your starting point** (1-3 sentences)
- **Start here (read first)** (3-5 ordered anchor pages)
- **Topics in scope** (bulleted)
- **Concepts in scope** (bulleted with one-line context)
- **Cluster overviews** (source documents grouped by design cluster)
- **Conventions and constraints** (cross-cutting rules, engagement constraints)
- **Adjacent landings** (cross-discipline pointers)

The shape is open; the maintainer's reaction to `designer-protocol`
will calibrate it before the other landings are written.

## What gardener can do unilaterally

The library landings exist and can be referenced by role files before
or after the role-multiplexing lands. Suggested gardener-side
actions, in order:

1. **Decide on shape (1 or 2 above)** — thin-dispatcher-plus-
   specialists vs. specialists-only.
2. **Create the specialist `roles/<specialist>/AGENT.md` files**.
   Each can be terse (one-line purpose, list of skills, reference to
   its landing page). Skills overlap heavily — `library-lookup`,
   `em-dash-style`, `relative-paths`, etc. should appear on every
   specialist; the discipline-specific skills go where they apply.
3. **Wire the landing pointer** in each specialist's AGENT.md so the
   dispatch prompt loads the right landing. Suggested form:

   > **Library landing**: read
   > `journal/library/roles/<specialist>.md` for the topics,
   > concepts, and conventions most relevant to your domain.

4. **Decide whether `designer` continues to exist as a router** or
   is retired in favor of dispatching specialists directly. If
   `designer` survives, its AGENT.md becomes a brief router that
   describes when to spawn each specialist.

## Coordination with scholar

The scholar will write the remaining landings as the specialist
roles get gardener-recognized. To avoid landings for roles that
might not exist, the scholar should wait for at least a draft of
each specialist's `AGENT.md` before writing the corresponding
landing — landings cite skills from role files, so the role file
shape informs the landing.

The exception is `designer-protocol`, which already exists as the
proof-of-concept; future gardener-side designer-protocol role
content should align with what the landing already cites
(concept pages, topics, conventions).

## Dependency / suggested ordering

```
gardener: pick shape (1 or 2)
   |
   v
gardener: draft specialist AGENT.md files (in skeleton, with skills lists)
   |
   v
scholar: write remaining landings, citing the specialist skills
   |
   v
gardener: wire landing pointers into each AGENT.md
   |
   v
(optional) gardener: decide on designer router vs. direct dispatch
```

A two-cycle exchange between gardener and scholar likely suffices
for the initial rollout (six specialists).

## Recommendation

Adopt shape (2) — thin `designer` router + specialists — and start
with the three specialists for which the library has the densest
existing coverage:

- `designer-protocol` (landing already exists this cycle).
- `designer-security` (capability-security topic has 117 sections, by far the densest).
- `designer-exo-captp-api` (exo, captp, eventual-send, marshal topics are mature).

`designer-frontend`, `designer-ux`, `designer-language` are
thinner-covered in the library today; their landings can be
created later or seeded with mostly-empty placeholders that grow as
more material is ingested.
