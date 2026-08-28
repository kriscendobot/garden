---
created: 2026-08-28
updated: 2026-08-28
author: designer
---

# Hardened262 skipped-scenario harness

Source:
[maintainer question on endojs/endo-but-for-bots#1070](https://github.com/endojs/endo-but-for-bots/pull/1070#issuecomment-5447955080)

## Problem

`packages/hardened262/scripts/test.js` generates the full product of agent,
mode, Lockdown, and Compartment, but `agentRunsScenario` executes only `module`
and `lockdownModule`.
The other products remain visible as skips.
At `llm` commit `ad430fb83`, the baseline contains 1,605 skipped lines, 1,595
from the pre-#1070 corpus plus ten introduced by its two cases.

The skipped scenarios do not share one cause.
The XS driver can already execute ordinary sloppy and strict scripts.
The Node driver imports every subject as an ES module, and neither driver can
put a subject and its test262 harness into a fresh Compartment.
A single global widening would therefore label module execution as sloppy on
Node and would claim Compartment coverage that no child process performed.

## Scope

This design adds faithful start-realm script execution on `sesNode`, adds a
Compartment runner for Node and XS, and makes scenario admission depend on the
agent's installed capabilities.
It preserves the current test selection, result reporting, timeout, and textual
baseline formats.
It does not add test262 host APIs such as `$262.agent`; a case that needs a host
capability no agent supplies remains a named failure or skip.

## Execution matrix

`agentRunsScenario` should accept the scenario record, not only its composed
name, and consult a capability table keyed by `test.agent`.
The table distinguishes start-realm modes from Compartment modes; Lockdown is
an independent setup bit and does not duplicate the capability entries.

| Execution site | `xs` | `sesXs` | `sesNode` |
| --- | --- | --- | --- |
| start realm, sloppy or strict script | existing `xst` path | existing `xst` path | new indirect-eval path |
| start realm, module | existing `xst -m` path | existing `xst -m` path | existing dynamic-import path |
| Compartment, strict script | new native runner | new shim runner | new shim runner |
| Compartment, module | new native runner | new shim runner | new shim runner |
| Compartment, sloppy script | skip | skip | skip |

The last row is not an implementation backlog.
The SES shim's `makeEvaluate` creates a strict inner evaluator, and pinned XS's
`fx_Compartment_prototype_evaluate` parses with `mxStrictFlag`.
Running unmodified source through it would repeat the same mislabeling the Node
module path has today.
Keep `compartmentSloppy` and `lockdownCompartmentSloppy` visible as explicit
skips unless the product model is changed in a separate design.
Raw cases continue to omit strict and module products, so a raw Compartment
product also remains skipped rather than acquiring strict semantics silently.

Represent the table by mode, for example `start: Set<mode>` and
`compartment: Set<mode>`, instead of enumerating composed scenario strings.
Unit tests should pin every agent, mode, Compartment, and Lockdown combination
and reject unknown agents.
During staged delivery, widen only the row whose runner landed in that commit.

## Node script execution

Extend `testSesNode` and `node-helper.js` to pass and consume `test.mode` and
`test.compartment` explicitly.
For a non-Compartment script, the helper reads the temporary subject and calls
a pre-Lockdown capture of indirect global eval.
The capture is necessary because default `lockdown()` replaces the start
realm's global `eval` with SES safe eval, which evaluates strict code.
The harness owns the captured evaluator and never exposes it to the subject or
to a Compartment.

The Node order is:

1. Load the SES shims and capture the start realm's indirect evaluator.
2. For a non-raw case, evaluate `scenarioIncludes(test)` in start-global scope.
3. Install `globalThis.print` so `$DONE` reaches the existing stdout capture.
4. Call `lockdown()` when `scenarioIsLockdown(test)` is true.
5. Import module subjects as today; evaluate sloppy or strict subjects with the
   captured evaluator.

`generateScenariosForTests` already prepends the strict pragma to
`test.contents`, and `testSesNode` already writes those contents to the
temporary file.
The helper must not infer strictness from the package's `type: module` setting.
Append a source URL for useful stacks without wrapping the body in a function,
which would change top-level script semantics.

## Compartment execution component

Add a shared source builder used by both child drivers.
It should expose named operations such as `makeHarnessInstallerSource` and
`makeCompartmentRunnerSource` so the Node and XS paths cannot drift on include
publication or module loading.

### Harness globals

Create the subject Compartment after optional Lockdown with only a `print`
endowment that forwards to the child process's stdout.
Do not endow the start global, file APIs, `process`, or the captured Node eval.

For a non-raw case, concatenate the additive `scenarioIncludes(test)` sources
into one installer evaluation inside the target Compartment.
Read each include's test262 `defines` frontmatter, reduce dotted definitions to
their root binding (`assert.compareIterator` becomes `assert`), and append code
that publishes each root on `globalThis` as a writable, enumerable,
configurable property.
One evaluation lets the include files share lexical bindings; publication lets
the separately evaluated subject see them as Compartment globals.
Functions and errors are consequently created with the Compartment's
intrinsics rather than borrowed from the start realm.
The parser and publisher need fixtures for inline `defines`, block lists,
dotted definitions, duplicate roots, and a requested include with no
definitions.

Raw scenarios do not build or evaluate the installer.
Async scenarios require no separate execution branch: `doneprintHandle.js`
publishes `$DONE`, the `print` endowment forwards its marker, and the existing
`scenarioOk` applies the completion/failure protocol to captured stdout.

### Subject

For strict script mode, call `compartment.evaluate(test.contents)`.
The strict pragma remains in the source even though current Compartment
implementations also require strict evaluation, so the scenario's input stays
the same on every agent.

For module mode, construct a `ModuleSource` from `test.contents` with the test
path as its source URL, place it at a private entry specifier in the
Compartment's module map, and await `compartment.import(entry)`.
Use the options-bag form with `__options__: true`, `globals`, and `modules`,
which the SES shim accepts and the XS adapter passes to the native
implementation.
Awaiting import preserves module parse/link/evaluation errors and future
top-level-await cases.

On Node, `ses-shims.js` supplies shim `Compartment` and `ModuleSource`.
On bare `xs`, use the native globals.
On `sesXs`, load the existing SES/ModuleSource prelude before constructing the
runner.
`agents/xs.js` should write a generated runner file: strict scenarios run it as
a script, while module scenarios pass `-m` so the runner can top-level-await
the Compartment import.
The existing stdout capture, timeout, result classification, and temporary-file
cleanup remain outside this component.

## Baseline ratchet and review evidence

Each capability slice lands with its own regenerated baseline, using
`yarn test262:update`, followed by `yarn test262:baseline` against that exact
tree.
The diff is the coverage evidence: every newly admitted test path leaves that
scenario's `skipped.txt` and appears exactly once in `passed.txt` or
`failed.txt`.
Failures are useful conformance findings and should not be hidden to make the
ratchet look green.

Before accepting a slice, mechanically compare the old and new flattened
reports and require:

- no previously passed entry moves to failed or skipped;
- no newly admitted entry disappears from all three outcomes;
- no path appears in more than one outcome for an agent/scenario; and
- all still-skipped entries belong to an unsupported matrix cell or the
  existing `zeroCoverage` class.

Run `yarn test`, `yarn lint`, `yarn test262:update`, and
`yarn test262:baseline` for every slice.
XS slices require the pinned `xst` used by `test-xs`; Node-only evidence does
not clear them.
Add focused fixtures that distinguish sloppy from strict `this`/unbound-write
behavior, prove include visibility and realm identity in a Compartment, prove
raw omits includes, exercise module syntax, and exercise both `$DONE` markers.

If all designed cells are admitted against the current corpus, 1,421 of the
1,605 skipped baseline lines will be reclassified.
The 184 remaining lines are the 174 strict-by-definition Compartment/sloppy
products and ten zero-coverage records.

## Build sequence

1. **Per-agent admission and XS scripts.** Change `agentRunsScenario` to the
   capability-table form, enable start-realm sloppy/strict for `xs` and
   `sesXs`, add semantic probes, and regenerate only those baselines.
2. **Node scripts.** Add the captured indirect-eval path, enable start-realm
   sloppy/strict for `sesNode`, and ratchet its baselines.
3. **Shared Compartment installer and Node runner.** Land the include-definition
   parser, publisher, raw/async fixtures, and strict/module Node execution; then
   enable the four Node Compartment cells.
4. **XS Compartment runner.** Reuse the same generated sources for native `xs`
   and shimmed `sesXs`, enable their strict/module Compartment cells, and
   ratchet with the pinned XS binary.

Each step is independently buildable and reviewable.
Do not enable a later matrix cell in an earlier step, even if its runner appears
close enough, because the baseline would then certify an unproved execution
path.
