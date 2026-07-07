## Completion report: design-endo-thesis-translation

**Deliverable:** design slug `thesis-translation`, landed as `designs/thesis-translation.md` on branch `design/thesis-translation`, **draft PR endojs/endo-but-for-bots#631 against `llm`** (verified: draft, base `llm`, diff is the design file plus the `designs/README.md` plan sync).

**What the design specifies** (per the job's required sections):

- **Scope & phasing:** full 27-chapter/5-part treatment inventory extracted from the actual PDF table of contents (downloaded via the papers.agoric.com mirror; erights.org is currently unreachable), with per-chapter prose/code/protocol classification and five phased docs-only builder PRs. Phase 1 (scaffolding, provenance landing page, conventions page, chapters 1-2) is specified to builder-ready detail; a "key chapters only" stopping point after Part III is named.
- **E → Jessie:** a normative mapping table (`E()` from `@endo/far` rather than tildot, `E.when` for when-catch with the turn-semantics rationale, makers/facets as hardened closures and `@endo/exo`, `@endo/patterns` for guards, `makePromiseKit`, `Compartment` for the loader chapter, inline WeakMap sealer/unsealer), plus a no-clean-equivalent rule (keep the original E, add a translator's note; never invent a mapping).
- **CapTP → OCapN:** the thesis's protocol is Pluribus (CapTP's ancestor); mapping grounded in this fork's own `@endo/ocapn` (sturdyrefs, netlayers, third-party handoffs), with chapter 19 (E-ORDER) explicitly labeled normative ancestry rather than a current OCapN guarantee.
- **Docs routing:** TypeDoc-native (`projectDocuments` entry with child chapters, category `Annex`), with a `/thesis/` redirect installed by `scripts/posttypedoc.sh`, riding the existing `ci-docs.yml` docs-only CI.
- **Fidelity contract:** Miller's prose verbatim; every code substitution flagged with a caption and the original E preserved in a collapsed block; translator's notes are additive blockquotes; mermaid redraws instead of reproduced figures.
- **Licensing (flagged, not assumed):** the PDF title page grants verbatim copies and cited excerpts only, so the design gates every phase's publication on Mark Miller's explicit recorded permission; the PR asks @erights directly (he is maintainer-authority on this fork). Six open questions surfaced for the maintainer, permission being the gate.

**Also done:** `designs/README.md` synced per project conventions (summary row, M10 parallel-track bucket with reconciled count, per-design estimate, dated last-updated note; milestone totals untouched since the work is off the critical path and permission-gated). Journal `result` entry pushed to `journal2`, plus library writeback: new concept page `robust-composition-thesis` and keyword shortcuts. A peer job (`translate-distributed-confinement-to-docs`) asked mid-flight for exactly these conventions; my reply was dead-lettered (their job had completed) and will be promoted to a fresh job by garden-deadmail.

**Follow-ups:** (1) erights' permission disposition on PR #631 is the publication gate for all phases; (2) phase 1 builder job can be posted once the design is accepted; (3) upstream-ferry intent for docs.endojs.org proper remains an open maintainer question.

Self-improvement: nothing this time.
