# Skill: re-export-deprecation-policy

## Purpose

The single documented home for the garden's **re-export deprecation policy**: a
plain re-export must be a *deprecated compatibility shim*, not a load-bearing second
import path. This skill states the rule, enumerates the `export … from` forms,
defines what a compliant `@deprecated` shim looks like, lists the exemptions and the
`reexport-policy-exempt` file marker, and — because the garden does **not**
`npm install` or fetch a dependency at run time — **carries the tooling** the
detector needs (a vendored Babel parser). The
[`no-plain-reexport`](../../scripts/jobs/gardening/pre-push-gates/probes/no-plain-reexport.sh)
pre-push probe and the
[`reexport-auditor`](../../roles/jurors/reexport-auditor/AGENT.md) jury seat both
consult this skill; the roles reference it rather than restating the rule.

Origin: @erights asked on `endojs/endo-but-for-bots` #475 that the garden not only
follow the project's re-export policy but *prevent every future violation and never
author a new one*, and that the proposal be reviewed by @kriskowal and @erights. The
design `designs/reexport-deprecation-policy-gauntlet.md` is that proposal; @kriskowal
approved it in PR #95 and resolved five open questions (the **Decisions** below). This
skill is the "so that you do not author new violations" half.

## The policy, stated precisely

A **plain re-export** is a module surfacing a binding it does not itself define,
re-emitting another module's export unchanged — syntactically the `export … from
'…'` family:

```js
export { x } from './original.js';           // named
export { x as y } from './original.js';      // renamed — still plain
export { default as x } from './original.js';
export * from './original.js';               // wildcard
export * as ns from './original.js';         // namespace
```

The policy is **not** "never re-export". It is: **a plain re-export must be a
deprecated compatibility shim, not a load-bearing second import path.** Two
obligations travel together:

1. **The re-export carries a deprecation** — a `@deprecated` JSDoc annotation
   immediately preceding the re-export that **points importers at the original
   export** (names the canonical module to import from instead).
2. **Importers are migrated to the original** — no live code is left importing
   through the re-export; the deprecated line exists only to spare not-yet-updated
   external callers, on a path to removal.

The rationale is the hardened-JS / Endo value of **explicit provenance**: one
canonical origin per binding, so the dependency graph, tree-shaking, and a reader's
"where does this come from?" all resolve to the real definition rather than to a
barrel that launders it.

### What a compliant deprecation shim looks like

```js
/**
 * @deprecated Import `makeThing` from './thing.js' instead; this re-export is a
 * compatibility shim scheduled for removal.
 */
export { makeThing } from './thing.js';
```

The `@deprecated` JSDoc block sits **immediately above** the re-export (Decision 2)
and **names the canonical module** importers should move to. The deterministic probe
requires the adjacent `@deprecated` block; the jury seat judges whether the message
actually names the right original and whether importers have in fact migrated.

## Scope and exemptions

- **Garden-universal (Decision 4).** The rule applies fleet-wide across every project
  worktree the garden pushes, not only the endo forks. It runs inside a project
  worktree's pre-push gate, so it is naturally scoped to whatever repo is being
  pushed; it does not touch the garden's own `main2` (this repo has no `export … from`
  source of its own to police).
- **Barrels / `index.js` are NOT exempt (Decision 1).** A new barrel that re-exports a
  package's surface is a plain re-export like any other and must be a deprecated shim
  or carry the file marker. There is no automatic entry-point exemption.
- **Type-only re-exports ARE exempt (Decision 5).** `export type { T } from '…'`,
  `export type * from '…'`, per-specifier `export { type A } from '…'`, and any
  `.d.ts` declaration file are out of scope. Types have no runtime provenance to
  launder; the probe and seat skip them and police only value re-exports.
- **Per-file opt-out marker.** A file may opt out of the rule with the literal
  `reexport-policy-exempt` in its **first five lines** (mirroring
  `no-inline-import-jsdoc`'s `inline-import-exempt`). This is the sole escape hatch for
  a deliberately-reviewed exception — including a barrel a maintainer has sanctioned.
  There is no per-project opt-out; the rule is universal.

```js
// reexport-policy-exempt: <state the reviewed reason here>
export { a, b, c } from './surface.js';
```

## The tooling this skill carries (Decision 4)

The garden does not rebuild its scripts or fetch its dependencies at run time, so the
detector's dependency travels **inside this skill**:

- **`vendor/babel-parser.cjs`** — the self-contained `@babel/parser` 7.29.7 CommonJS
  bundle (no external `require()`), plus `vendor/LICENSE` (Babel's MIT license) and
  `vendor/README.md` (provenance + how to refresh).
- **`reexport-parse.cjs`** — the small parse helper the probe and seat call. It reads
  a module's source on stdin and prints one JSON descriptor per **value** qualified
  re-export: a position-independent `key` (for the set difference), the `line`, and
  whether the node is a `@deprecated` shim. It selects Babel plugins by file
  extension (TypeScript for `.ts`/`.tsx`, JSX otherwise) and parses with
  `errorRecovery` so one stray syntax error does not blind the detector.

## The detector pipeline (Decision 3)

`no-plain-reexport.sh` implements the maintainer's three-stage pipeline; there is
**exactly one detector**, reused by the pre-push gate and the jury seat's pre-pass:

- **(a) heuristic grep** — cheap: does the change ADD a line bearing `export` as a
  bare word? A genuinely new `export … from` always does, so a file with no added
  `export` word is never parsed.
- **(b) Babel set-difference** — parse the file BEFORE and AFTER (via
  `reexport-parse.cjs`), take the set difference of qualified value re-exports
  (after − before) so only a **newly introduced** re-export is a candidate, and drop
  any candidate immediately preceded by a `@deprecated` JSDoc block.
- **(c) LLM responder** — the `reexport-auditor` jury seat spends a `claude -p` only
  when (a)+(b) surface at least one candidate, to adjudicate plain-vs-value-adding and
  deprecation adequacy (`seat-gate-reexport-auditor.sh`).

Stages (a) and (b) are the deterministic core the probe runs at author time (it
**fails the push gate** — non-auto-fixable, because complying needs importer
migration and a chosen message); stage (c) is the review-time backstop.

## Inputs

- A changed source file (`.js`/`.mjs`/`.cjs`/`.jsx`/`.ts`/`.tsx`/`.mts`/`.cts`; never
  a `.d.ts`) and its base/HEAD version, from which the probe reads the diff and the
  before/after content.

## Procedure (for a role author or maintainer editing the policy)

1. Change the rule **here** — the forms, the exemptions, the marker — as the single
   source of truth. The roles reference this file; do not restate the rule in them.
2. If the detector's behavior changes, edit `no-plain-reexport.sh` and
   `reexport-parse.cjs`, then re-run their tests
   (`scripts/jobs/test/no-plain-reexport-probe-test.sh`,
   `scripts/jobs/test/seat-gate-reexport-auditor-test.sh`).
3. To adopt a newer Babel parser, follow `vendor/README.md`.

## Output shape

- The probe prints `pass` (exit 0) when clean, or one `fail: <path>:<line> …` line per
  newly-introduced non-deprecated plain re-export (exit 1). As a seat pre-pass its
  `check` subcommand exits 0 (candidates) / 1 (clean or no base) / 2 (undetermined),
  and `report` prints the digest plus a `summary: N candidate(s) across M file(s)` line.

## State

None. The detector is stateless: each invocation reads the change and the vendored
parser, and exits. The vendored bundle is the only durable artifact and changes only
on a deliberate refresh.

## Notes

- **Author-facing memory.** The builder, fixer, and web-builder roles carry a one-line
  norm ("never add a bare plain re-export; make it a `@deprecated` shim pointing
  importers at the original, and migrate importers — see this skill; the
  `no-plain-reexport` pre-push probe enforces it") rather than restating the policy.
- **No auto-fixing role.** Unlike a spelling swap, complying requires migrating
  importers and choosing a deprecation message — judgment, not a mechanical
  replacement. The ordinary `fixer` does it; there is no `americanizer`-style role.
- **Related:** [pre-push-gates](../pre-push-gates/SKILL.md) (the gate the probe runs
  in), [panel](../panel/SKILL.md) (the review panel the seat sits on).
