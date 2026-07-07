role: designer

Design a translation of Mark Miller's PhD thesis "Robust Composition: Towards a Unified
Approach to Access Control and Concurrency Control" (2006) for publication at
docs.endojs.org/thesis/.

## Venue & mechanism
- The translation ships as documentation in Endo's `docs/` directory, published at
  docs.endojs.org/thesis/.
- Propose it as a PR on the `endojs/endo-but-for-bots` fork, based on `master`. No
  upstream `endojs/endo` interaction beyond the fork.

## The defining move — modernize the thesis into today's Hardened JavaScript / Endo world
- Swap the **E language** for the **Jessie subset of Hardened JavaScript**: translate E
  code examples and E-specific constructs (eventual sends, when-catch, makers, facets,
  sealer/unsealer pairs, …) into Jessie / Hardened JavaScript idioms.
- Swap **CapTP** for **OCapN**: the thesis's distributed-object protocol and
  rights-transfer discussion re-expresses in OCapN terms.

## The design should specify (self-contained enough for a builder to implement)
- **Scope & phasing.** It is a large work — recommend which parts to translate first
  (full vs. key chapters) with a chapter/section mapping and a phased plan.
- **E → Jessie approach.** How each major E construct maps to a Jessie / Hardened JS
  idiom; where no clean equivalent exists, how to translate faithfully and flag it.
- **CapTP → OCapN approach.** How the protocol/rights-transfer material re-expresses.
- **Docs structure & site routing.** How the pages live under `docs/` and route to
  docs.endojs.org/thesis/, respecting Endo's existing docs tooling / site generator and
  navigation.
- **Fidelity vs. modernization.** What stays verbatim (Miller's prose and arguments) vs.
  what is updated (code, protocol names, dead links), and how each substitution is
  visibly flagged to the reader.
- **Provenance, attribution, licensing.** The thesis is Mark Miller's copyrighted
  academic work. Surface how attribution and permission are handled (faithful
  re-typesetting with attribution vs. derivative translation vs. quoting) and whether
  explicit author permission is warranted — flag this as a maintainer/author decision;
  do NOT assume a license.
- **Builder-ready implementation plan.** The docs PR structure and the first-phase
  deliverable a builder can start from.

## Deliverable
A DESIGN document (a plan), not the translation itself — a later builder implements the
docs PR from it. Land the design where the project's design docs belong per your role
conventions. Surface open questions for the maintainer rather than guessing.
