---
ts: 2026-05-18T04:33:27Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Drafted `designs/garden-as-primer-and-journal.md` against the `llm`
branch of `endojs/endo-but-for-bots`, proposing how to express the
garden's roles, skills, journal, dispatches, standing monitors, bot
identity, and authorization shapes in terms of the Endo daemon's
primer + familiar primitives (modelled on `packages/lal/primer/`
and `packages/familiar/`) and a daemon-resident journal exo backed
by the formula graph. The design walks the Sleeper Channels paper's
persistence x firing-separation matrix against the proposed shape,
identifies which cells (M2xC2, M5xC4, M3xC2, M4xC4) the design
closes and which (M1xC0, side-channel persistence) it leaves open,
and sketches a three-phase implementation path culminating in D2
attestation on the boatman.

Pivotal claim: the garden's existing knowledge structure (sparse,
just-in-time, per-engagement isolation) is already shaped for the
Structure of Authority paper's nested-POLA argument; expressing
roles as primers and dispatches as familiar spawns converts the
knowledge structure into a matching authority structure where the
sleeper-channel-class attacks the Maloyan-Namiot paper formalises
deny at the D2 gate rather than being mitigated only by the
in-context Monitoring safety constraint.

Branch `garden-as-primer-and-journal-design` pushed to origin; no
PR opened (the maintainer decides whether to ferry; the designer
default for `endo-but-for-bots` on the `llm` roadmap branch is to
open a draft PR but in this case the dispatch report-only path was
named in the dispatch prompt and the maintainer will choose).

Library reads (the section files this design cites):
- papers--maloyan-namiot-sleeper-channels-2026--{sleeper-channel-taxonomy-and-running-scenario,provenance-gate-d2-and-soundness-theorem,executable-policy-and-measurement-plan}
- papers--miller-tulloh-shapiro-structure-of-authority-2004--{excess-authority-and-designation,fractal-structure-of-authority,multiplicative-pola-and-security-as-modularity}
- papers--miller-tribble-shapiro-concurrency-among-strangers-2005--{vat-and-event-loop-model,partial-failure-and-when-catch}
- papers--miller-capability-myths-demolished-2003--{four-models-and-seven-properties,advantages-pola-confused-deputy}
- concepts/{formula-graph,per-agent-keypair,space}

Open questions flagged (six, in the design): primer-evolution
discipline; cross-host Property F (delegation channels for
kriskowal identity); canonical-form schema for action-instance
digests per dispatch kind; the journal exo's method-surface
richness; the fate of `references/`; the relation to the existing
`@endo/genie` framework.

Self-improvement: nothing this time.
