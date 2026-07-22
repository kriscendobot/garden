---
role: designer
---
# Make README.md the explainer, weaving applicable pieces from archive/4-compartment.md

Repo `kriscendobot/proposal-compartments` (branch `main`, bot-owned fork; land directly on
`main` as the bootstrap did — no PR). Work in an ISOLATED worktree keyed by YOUR job base
(`scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/proposal-compartments main`),
explicit-pathspec commits, rebase-CAS push. Maintainer @kriskowal directive (2026-07-22, via the
liaison). This is EXPLAINER/prose authoring — NOT a git rebase-weave. Ground everything on the
charter `journal/projects/proposal-compartments/README.md` (design tenets + the additional
completion criteria) and stay consistent with `spec.emu` (normative text stays there).

## 1. README.md becomes the explainer document

The fork currently has a template landing-page `README.md` and a stub `explainer.md`. Consolidate:
**`README.md` is the canonical explainer.** Fold the useful landing content + the `explainer.md`
stub into a single well-structured explainer in `README.md` (problem → approach → the Compartment
surface → motivating examples & rationales → design questions → links). Keep the "browse the
ecmarkup output / source" links and the stage line. Then **remove `explainer.md`** (or leave a
one-line pointer to `README.md`), and update EVERY reference to `explainer.md` (in `spec.emu`, the
charter, any index) to point at `README.md`. Normative prose stays in `spec.emu`; the explainer
carries motivation, examples, and rationale.

## 2. Weave the APPLICABLE pieces from archive/4-compartment.md

Read `archive/4-compartment.md` (the prior iteration; ~32 KB). Bring forward what still holds under
the new design, RE-FRAMED — do not paste verbatim:
- **Motivation / Interfaces** prose that remains true.
- **Motivating Examples & Design Rationales** — the high-value section: multiple-instantiation;
  virtualized web compartment; virtualized Node.js compartment; bundling/archiving; **inter-compartment
  linkage**; linking with a virtual module source; export aliases & module-imports namespace; virtual
  module source reexports; the **Thenable Module Hazard**; and the design questions. Several map directly
  onto the maintainer's completion criteria (esp. importing the same module source across multiple
  compartments → distinct instances while still supporting cross-compartment, possibly cyclic, linkage;
  and realm-global reuse for Node.js).

**Re-frame under the new tenets** (charter): a **`ModuleSource` is the opaque key** indexing a module
instance in a Compartment — translate the old **module-descriptor** vocabulary away, it is ABANDONED;
do **not** presume **SES lockdown**; account for **realm-global sharing** (Node viability, nodejs#62720)
and **top-level await**; frame the surface as the **intersection** with module harmony (source phase
imports, the source phase import expression, import defer), minimizing an additional global runtime
context.

**Discard legacy that contradicts the new design** — module descriptors, SES-lockdown-specific
assumptions, anything superseded by module harmony's first-class machinery. Where a prior concept is
deliberately dropped, note it briefly (one line, in a "What changed from earlier iterations" note or the
relevant rationale) so a reader who knew the old design isn't confused — but carry no dead vocabulary.
Frame the result as derived-from the archived iteration, not a copy.

## 3. Prose discipline + done

- Apply the `ai-writing-tells-and-avoidance` guidance (scholar concept, if landed) — natural, specific,
  non-formulaic prose; no boilerplate scaffolding.
- If weaving surfaces a genuine SPEC gap or contradiction, note it for the daily press
  (`proposal-compartments-press`) / a `progress` entry rather than inventing normative `spec.emu` changes
  here beyond keeping cross-references consistent.
- Report: the README/explainer commit, a short list of what was WOVEN and what was DROPPED (and why), and
  confirmation that `explainer.md` references were repointed. Real-execution evidence only (e.g. the
  `npm run build` still renders if you touched `spec.emu` links).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: cleric
  claimed_at: 2026-07-22T04:58:48Z
