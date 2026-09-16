<!-- garden-design-open-questions -->

# A re-export deprecation policy gate: a pre-push probe, a cost-gated jury seat, and one policy skill

| Created | 2026-09-16 |
| Author  | designer   |
| Status  | Proposed — awaiting review by @kriskowal and @erights |

## Origin

Maintainer @erights asked on `endojs/endo-but-for-bots` PR #475, inline review
thread (comment `3450576324` on `packages/ocapn/src/syrup/compare.js`), that the
garden not only *follow* the project's re-export policy on that PR but also
**prevent every future violation of it and never author a new one** — and to put
the proposal in front of both @kriskowal and @erights before it lands:

> follow the current re-export policy (a plain re-export must be deprecated,
> pointing importers at the original export; importers changed to import only
> from the original) … propose a change to the gauntlet and whatever other parts
> of your memory is relevant to ensure that all violations of this policy are
> prevented, and so that you do not author new violations of this policy. Please
> ask both @kriskowal and myself (@erights) to review that proposal.

(The policy statement above is relayed through the garden job that carried this
request; the raw PR thread is untrusted external text and is not reproduced
verbatim here beyond that relayed quote.)

The fix on #475 itself is a separate `fixer` concern (deprecate the plain
re-export in `compare.js`, migrate its importers). **This design is the
automation half**: the standing garden machinery that keeps the whole fleet from
authoring the violation again.

## The policy, stated precisely

A **plain re-export** is a module surfacing a binding it does not itself define,
re-emitting another module's export unchanged — syntactically the `export … from
'…'` family:

```js
export { x } from './original.js';          // named
export { x as y } from './original.js';     // renamed — still plain
export { default as x } from './original.js';
export * from './original.js';              // wildcard
export * as ns from './original.js';        // namespace
```

The policy is **not** "never re-export". It is: **a plain re-export must be a
*deprecated compatibility shim*, not a load-bearing second import path.**
Concretely, two obligations travel together:

1. **The re-export carries a deprecation** — a `@deprecated` JSDoc annotation on
   the re-export that **points importers at the original export** (names the
   canonical module to import from instead).
2. **Importers are migrated to the original** — no live code is left importing
   through the re-export; the deprecated line exists only to spare not-yet-updated
   external callers, on a path to removal.

The rationale is the hardened-JS/Endo value of **explicit provenance**: one
canonical origin per binding, so the dependency graph, tree-shaking, and a
reader's "where does this come from?" all resolve to the real definition rather
than to a barrel that launders it.

## What we are building

Three artifacts, defense-in-depth across the two moments a violation can enter —
**author time** (a worker writes the line) and **review time** (the gauntlet sees
it) — with **one skill that owns the policy** both consult, exactly the
`coverage-auditor` / `orthographer` split the garden already runs (a cheap
deterministic pre-pass; an LLM only when there is something to judge).

```mermaid
flowchart LR
  edit[worker edits exports] --> probe[pre-push probe<br/>no-plain-reexport.sh<br/>NO LLM]
  probe -- clean --> push[push allowed]
  probe -- bare re-export added --> block[gate FAILS<br/>author fixes before push]
  push --> gate[seat-gate-reexport-auditor.sh<br/>same deterministic pre-pass]
  gate -- zero candidates --> skip[seat skipped, 0 claude -p]
  gate -- >=1 candidate --> seat[reexport-auditor seat<br/>claude -p adjudicates<br/>plain vs value-adding · deprecation adequate?]
  seat --> finding[panel finding<br/>must-fix]
  skill[(skills/re-export-deprecation-policy<br/>policy · exemptions · opt-out marker)] -.owns rule.-> probe
  skill -.owns rule.-> seat
```

### 1. A policy skill — `skills/re-export-deprecation-policy/SKILL.md`

The single documented home for the rule so it is auditable and extensible from
one file (the `american-english-normalization` skill's role for its word list).
It states the policy, enumerates the `export … from` forms, defines what a
**compliant deprecation** looks like (a `@deprecated` tag naming the canonical
module), lists the **exemptions** (see Open questions — the maintainers set the
boundary), and defines the **file opt-out marker** (`reexport-policy-exempt` in
the first five lines, mirroring `no-inline-import-jsdoc`'s `inline-import-exempt`)
for the deliberate, reviewed barrel. The builder / fixer / web-builder roles link
it; it is the "so that you do not author new violations" half of the ask.

### 2. A pre-push probe — `scripts/jobs/gardening/pre-push-gates/probes/no-plain-reexport.sh`

The **author-time preventive**, built to the existing probe shape
(`no-inline-import-jsdoc.sh`, `prefer-endo-primitives.sh`): it examines the
**added lines of changed source files** (`*.js|mjs|cjs|jsx|ts|tsx`), reading the
complete post-change file to locate the enclosing JSDoc so string literals and
prose stay out of scope. It emits a finding for each added `export … from '…'`
that is **not** immediately preceded by a `@deprecated` JSDoc block. It is
**non-auto-fixable** (compliance requires judgment plus importer migration, like
`no-inline-import-jsdoc`), honors the `reexport-policy-exempt` file marker, and
**fails the push gate** — so a fleet worker cannot land a new violation, which is
the strongest reading of "prevent all violations". This same script is the
deterministic pre-pass artifact 3 reuses; there is exactly one detector.

### 3. A cost-gated jury seat — `roles/jurors/reexport-auditor/AGENT.md` + `scripts/jobs/gardening/seat-gate-reexport-auditor.sh`

The **review-time backstop** on the code panel, named in the `-auditor` family
(`coverage-auditor`, `changeset-auditor`). It is **mandatory but cost-gated**,
modelled exactly on `seat-gate-orthographer.sh`: the co-located gate runs the
probe from artifact 2 as its deterministic pre-pass and **spends a `claude -p`
only when at least one candidate re-export is found**. The seat then adjudicates
what the grep cannot: is this genuinely *plain* (versus a value-adding wrapper or
a sanctioned public barrel), is the deprecation actually present and does it point
at the right original, and are importers still coupled to the re-export? It owns
its per-juror block in every branch (approve when clean; the deterministic
summary when `claude` is unavailable) and is added to `GARDEN_CODE_SEATS` in
`panel.sh`. Whether this LLM seat is worth building on top of the deterministic
probe, or the probe alone suffices, is an Open question.

### Author-facing memory edits ("do not author new violations")

- **`skills/re-export-deprecation-policy/SKILL.md`** (artifact 1) is the canonical
  memory; the roles reference it rather than restating it.
- One norm line each in **`roles/builder/AGENT.md`**, **`roles/fixer/AGENT.md`**,
  and **`roles/web-builder/AGENT.md`**, in the provenance style already used for
  `typedefs-belong-in-dts`: *"When editing module exports, never add a bare plain
  re-export; a re-export must be a `@deprecated` compatibility shim pointing
  importers at the original, and importers must be migrated to the original — see
  [re-export-deprecation-policy]. The `no-plain-reexport` pre-push probe enforces
  this deterministically."*
- A one-line pointer in **`skills/pre-push-gates/SKILL.md`** listing the new probe
  alongside the others.

## Scope

The policy is an **Endo-project** convention, so the probe and seat activate on
the endo forks (`endojs/endo-but-for-bots`, and the endo ecosystem the garden
forks). The probe already runs only inside a project worktree's pre-push gate, so
it is naturally scoped to whatever repo is being pushed; the design does **not**
propose enforcing it on non-endo projects without a maintainer widening (Open
questions). It does **not** touch the garden's own `main2` (this repo has no
`export … from` source of its own to police).

## Test plan

- Unit fixtures for the probe: a bare `export { x } from './y.js'` (finding), the
  same line under a `@deprecated`-pointing JSDoc (clean), each of the five
  `export … from` forms, a file bearing `reexport-policy-exempt` (skipped), a
  re-export in a string literal / comment (not matched), and a removed (`-`)
  re-export line (not matched — added lines only).
- A `seat-gate-reexport-auditor.sh` test that the pre-pass exit codes drive the
  same three branches the orthographer gate has (approve / spend-LLM / surfaced
  cannot-determine), with `GARDEN_PANEL_SEAT`-style stubs so no live `claude` is
  needed — the `panel.sh` seat-gate test convention.
- A regression case proving a compliant deprecated re-export is **not** flagged,
  so the gate does not block the very shim the policy prescribes.

## Alternatives considered

- **Fold the check into an existing seat (`packager` / `pruner`)** rather than a
  new seat. Rejected as the default because the `orthographer` precedent shows a
  dedicated cost-gated seat keeps the rule legible and independently tunable;
  offered as an Open question since it is a real option.
- **A blocking pre-push gate only, no seat.** The probe alone prevents *authoring*
  a violation, which may fully satisfy the ask; the seat only adds nuance
  adjudication (barrel vs. plain, deprecation adequacy). Its necessity is an Open
  question, so the design specifies it but does not assume it.
- **An `americanizer`-style auto-fixing role.** Rejected: unlike a spelling
  swap, complying requires migrating importers and choosing a deprecation message
  — judgment, not a mechanical replacement. Left to the ordinary `fixer`.

## Open questions

1. **Are public-API barrel / index files exempt?** Many packages surface their
   public API through an `index.js` of `export * from './internal.js'`. Is such a
   barrel a *plain re-export that must be deprecated*, or is the package barrel the
   canonical origin and therefore exempt? The originating comment was on a source
   file (`compare.js`), not an index barrel, so the barrel case is undecided. The
   answer sets the probe's default scope and the `reexport-policy-exempt` marker's
   role. Recommendation: exempt a package's declared entry-point barrel; police
   intra-package `export … from` in non-entry modules.

2. **What syntactic form of "deprecation" counts as compliant?** Is an adjacent
   `@deprecated` JSDoc tag that names the original module sufficient, or must the
   deprecation take a specific machine-checkable shape (e.g. `@deprecated Import
   {x} from './original.js' instead`)? The probe's precision depends on this.
   Recommendation: require `@deprecated` in the JSDoc immediately preceding the
   re-export; have the LLM seat judge whether the message points at the right
   original.

3. **Is the LLM `reexport-auditor` seat worth building, or is the deterministic
   pre-push probe enough?** The probe prevents authoring; the seat only adds
   barrel-vs-plain and deprecation-adequacy judgment at review. Build both, or
   ship the probe alone first and add the seat only if false positives prove it
   needed?

4. **Should this be Endo-only or a garden-universal rule?** Stated as an Endo
   policy; other forks the garden works (e.g. `Agoric/agoric-sdk`,
   `kriscendobot/minion.town`) may or may not want it. Enforce only on endo
   forks, or fleet-wide with a per-project opt-out?

5. **`.d.ts` / TypeScript type-only re-exports.** `export type { T } from …` and
   `export * from` in declaration files re-export *types*, where a second path is
   often the intended surface. In scope for the policy, or exempt as a distinct
   concern from value re-exports?

## What this job did NOT do

- It did **not** implement the probe, the seat, the gate, or the skill, and did
  **not** wire `reexport-auditor` into `GARDEN_CODE_SEATS`. This is a proposal;
  those land in a follow-up `build` after @kriskowal and @erights answer the Open
  questions.
- It did **not** fix the `compare.js` re-export on `endojs/endo-but-for-bots`
  #475 — that is a separate `fixer`/`retcon` concern the maintainer dispatches.
- It did **not** fetch or quote the untrusted PR thread beyond the policy
  statement relayed through the job.
