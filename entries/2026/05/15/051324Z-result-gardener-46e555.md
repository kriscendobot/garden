---
ts: 2026-05-15T05:13:24Z
kind: result
role: gardener
project: garden
to: liaison
refs:
  - entries/2026/05/15/045700Z-dispatch-liaison-46e555.md
  - entries/2026/05/15/045000Z-dispatch-liaison-fa2b1e.md
---

# Result: four reviewer-modeled juror seats carved into the code panel

Dispatch root: `dispatches/gardener--46e555/`. Garden-only (no project worktree). Concurrent with `gardener--fa2b1e` (Hickey + interface critic). The fa2b1e dispatch landed on `main` first (commit `56b4cc6` adding `decomplector` and `ergonomist` to the design panel, 5 to 7 seats); this dispatch rebased on top and merged the inventory text by hand. No slug collision (see *Collision check* below).

## Four slugs + panel assignments

All four joined the **code panel**; none are primarily design-panel-only. The design surface is one prose artifact (a `designs/<slug>.md` file); each of these four lenses targets code- or wire-shaped material the design surface does not carry. The code panel grew from twelve to sixteen seats.

### 1. `purist` — empirical source `@erights`

Primary surface: **ocap purity and conceptual integrity**. The lens walks six axes distilled from erights's PR-feedback corpus:

- **Passability.** Is an introduced value actually passable (frozen, no own enumerable function properties on the prototype shape, no internal references to unpassable objects, no late-binding of methods from outside the passable surface)?
- **Property hygiene on frozen prototypes.** "These should not be enumerable" is the recurring purist finding (verbatim from `endojs/endo#3153`).
- **Side-channel closure.** "Only the setting side pierces the opacity" (NaN side-channel framing from `#3153`); the purist asks whether the getting side preserves opacity.
- **Type-vs-value namespace separation.** "I remember when we had both a `Remotable` type and a `Remotable` runtime value. The collision kept causing annoyance so we renamed the type to `RemotableObject`" (from `#3133`).
- **Family-consistency across related symbols.** "What about `cause` and `errors`? Do they have this problem too?" (from `#3130`).
- **Minimum viable abstraction.** "I don't like introducing a new type for this purpose if possible" (from `#3130`).

Disambiguation: distinct from `warden` (SES boundary specifically) and `breaker` (invariant attacks specifically); the purist's lens is conceptual integrity of the symbol family across the module.

### 2. `spec-keeper` — empirical source `@gibson042`

Primary surface: **ECMA-262 / WebIDL / TC39-proposal rigor and engine-variance awareness**. Distilled axes:

- **Spec citation.** "via [section X], doesn't care about flag Y" (from `#3224`, citing RegExpBuiltinExec); "as noted in WebIDL" (from `#3214`).
- **Engine variance.** Multi-engine `eshost` dumps comparing V8, SpiderMonkey, JavaScriptCore, XS, QuickJS, Hermes, GraalJS, engine262, LibJS (from `#3214`); "slowdowns hurt much more in an already-slow engine" (from `#3208`, framing XS-consciousness).
- **Primordial preservation.** "We should continue to prefer use of a captured `Reflect.apply` over `.call`" (verbatim from `#3208`).
- **Forward-compat with proposals.** "Given that the proposal is at stage 1, this claim is too strong. I'd prefer to pare down the API..." (verbatim from `#3232`).
- **Less coupling.** "Why introduce a new type? What breaks if `CopyArray` is instead updated to use `ReadonlyArray` rather than `Array`?" (from `#3061`).
- **Brittle-test resistance.** Recurring objection to tests that pin engine-defined behavior as if it were spec-defined (the NaN-bit-pattern thread on `#3214`).
- **Hygiene nits.** "Ensure a name for this function" (from `#3216`).

Disambiguation: distinct from `migrator` (downstream-caller compat); the spec-keeper's frame is upstream-spec compat.

### 3. `wire-watcher` — empirical source `@warner`

Primary surface: **security-protocol correctness on the wire**. Distilled axes:

- **Check before trust.** "The wrong code has already had a chance to execute with whatever authorities you passed in. A safer API would be to pass the expected hash *in*..." (verbatim from `endojs/endo#1091`).
- **In-band-marker trust-bypass.** "In-band security markers that have broken many other systems (the JWT `\"alg\": \"none\"` field comes to mind)" (verbatim from `#1091`).
- **Parser divergence.** "Do our specs say anything about repeated keys in JSON? That would be a way for two different readers to interpret the same compartment map in divergent ways" (verbatim from `#1085`).
- **Identifier discipline.** Bundle-ID format design (`b1-`, `v0-`, `v1-`) and regex assertion (`^b1-[0-9a-f]{128}$`) from `#1094`.
- **Protocol state-machine invariants.** From `Agoric/agoric-sdk` PRs `#9942`, `#10268`, `#10758`: every vref appears in either `dispatch.retireImports` or `syscall.retireImports`, never both; refcount preservation across upgrade and failure; c-list invariants under vat deletion.
- **Failure-mode test catalog.** "Let's also test against a syntactically-valid but almost-certainly wrong hash" (verbatim from `#1094`).
- **Paranoid extras.** Recurring request for one or two tests beyond the happy path's natural coverage.

Disambiguation: distinct from `locksmith` and `warden` (capability flow / SES boundary); the wire-watcher's lens is the identifier or hash that gates the capability the others audit.

### 4. `engine-realist` — empirical source `@mhofman`

Primary surface: **V8 / XS realism and vat-lifecycle awareness**. Distilled axes:

- **V8 vs XS reality.** "I would like to see a test where an error is manually frozen (without using possibly fake harden)" (from `endojs/endo#2990`).
- **Resilience against capability override.** "Why don't we build an error by syntax instead for one of the candidates, to be resilient against global `Error` override?" (verbatim from `#2990`).
- **Vat-lifecycle phase.** From `Agoric/agoric-sdk#10359` (async-flow): work that is safe during BOYD vs unsafe during unmarshalling; syscall-trace determinism by phase.
- **Allocation and GC budget.** "I think we shouldn't burden ourselves with weak collections and their gc costs since we have delimited lifetimes" (verbatim from `#10359`).
- **Storage choice.** Ephemeral vs virtual vs durable; "I'm trying to deprecate fakeStore" (from `#10299`).
- **Engine-version compat.** "Older versions of node don't support type stripping" (verbatim from `#3137`).
- **Work-deferral.** "I'm wondering if it might not be too early to make this. Any way to delay until we `makePassStyleOf`?" (verbatim from `#2990`).
- **Naming clarity around mechanism.** "Isn't `thisArg` a little misleading as a name if it records the proxy's target" (verbatim from `#10359`).

Disambiguation: distinct from `prover` (regression evidence generally); the engine-realist's frame is the *runtime* a future caller will be on.

## Collision check vs `gardener--fa2b1e`

fa2b1e landed first with `decomplector` and `ergonomist` on the **design panel**. The four chosen here (`purist`, `spec-keeper`, `wire-watcher`, `engine-realist`) joined the **code panel**. No slug collision; no panel overlap; the merge resolved by sequencing both expansions into `CLAUDE.md` § Current inventory, `skills/pr-creation-flow/SKILL.md` § Jury composition, and `roles/judge/AGENT.md` § Panel-kind discrimination. Total jury seats: 23 (16 code + 7 design).

## Files edited

- `garden/roles/purist/AGENT.md` (new, 70 lines).
- `garden/roles/spec-keeper/AGENT.md` (new, 71 lines).
- `garden/roles/wire-watcher/AGENT.md` (new, 73 lines).
- `garden/roles/engine-realist/AGENT.md` (new, 75 lines).
- `garden/skills/pr-creation-flow/SKILL.md` (added the four seats to *Jury composition* § Code panel; expanded *Why twelve seats with halved responsibilities* into *Why sixteen seats* and described the 2026-05-15 additions; updated header sentence and flow-diagram comment from "twelve" to "sixteen"; added 2026-05-15 *Notes from the field* row; bumped `updated`).
- `garden/CLAUDE.md` § Current inventory (added four new role slugs to the roles list; updated "seventeen jury-seat roles" to "twenty-one"; updated "twelve seats" to "sixteen"; added the 2026-05-15 history bullet).
- `garden/roles/judge/AGENT.md` (updated header and *Panel-kind discrimination* § Code panel from "twelve seats" to "sixteen seats"; added the four seats to the seat list; updated aggregated-body word-count band to 1600 to 2600 words; bumped `updated`).
- `journal/entries/2026/05/15/051324Z-result-gardener-46e555.md` (this file).

## Notes

- The "change names to protect the innocent" rule is honored: the four slugs name the lens, and the empirical source is recorded in each role file's one-line frontmatter-adjacent note (the second paragraph after the purpose). Future judges reading the panel see "purist" / "spec-keeper" / "wire-watcher" / "engine-realist" without prejudging from the reviewer's name.
- The expanded code panel has overlap structure consistent with the existing 12-seat design: every primary surface has at least one adjacent seat (purist <-> breaker, spec-keeper <-> prover, wire-watcher <-> locksmith/warden, engine-realist <-> prover). The aggregation body's upper bound widened to 2600 words in `roles/judge/AGENT.md`.
- The judge's panel concurrency unchanged: all sixteen seats fire in parallel; aggregation waits for all to land.

Self-improvement: when authoring a reviewer-modeled juror seat, the empirical-source step (sampling 5+ PRs and 30+ comments per reviewer) is the load-bearing input; the slug-selection and role-file-authoring steps fall out of the distilled lens. Document this in `roles/gardener/AGENT.md` § Operating norms if the maintainer asks for additional reviewer-modeled seats; the same methodology generalizes.
