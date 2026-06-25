# Reconcile PR #96 Phase 7: land the general dependency-subtree case (maintainer decision: RECONCILE)

Wear the **builder/fixer** role. Repo: `endojs/endo-but-for-bots`, PR **#96**
(compartment-mapper auxiliary package.json). Communicate the response **as a GitHub
comment on #96**, NOT a maintainer reply — the maintainer wants the PR to be the channel.

## Situation (from the finish-ebfb-pr96 collision report)

Phase 7 ("honor `languageForExtensionByPrefix` at parse time") split into two parts:
- **Entry-path case** — already landed on #96 by a peer (commit `905cb7204`, current head
  of branch `design/compartment-mapper-auxiliary-package-json`): a `.js` under a
  `{"type":"module"}`/`{"type":"commonjs"}` auxiliary on the entry module's own path now
  parses correctly. The peer **deferred** the general case as "future work".
- **General dependency-subtree case** — NOT yet on #96: auxiliary subtrees inside a
  DEPENDENCY package reached by relative import (e.g. app imports `aux-pkg` by name;
  `aux-pkg/index.js` does `import "./cjs-sub/leaf.js"` where `cjs-sub/` is a
  `{"type":"commonjs"}` auxiliary) are still misparsed. It WAS implemented on a side
  branch **`origin/pr96-auxiliary-lazy-parse-general-case`** (`5483f04ba`) via a **lazy
  per-module walk in the import hook** (covers BOTH paths; 917 tests pass, 12 known
  failures unchanged, tsc+eslint clean, regression-proven).

The two implementations overlap (both touch map-parser `resolveLanguage`, the
`languageForExtensionByPrefix` field, and types) with different architectures (peer:
precompute on the entry compartment at map time; side branch: lazy per-module at parse
time), so they do not compose trivially.

## Maintainer decision: RECONCILE (do not defer the general case)

1. Rebase the side branch `pr96-auxiliary-lazy-parse-general-case` (`5483f04ba`) onto the
   **current #96 head** (`905cb7204`).
2. Reconcile the two mechanisms into ONE coherent implementation. The **lazy per-module
   parse-time** approach is the general one (covers entry + dependency-subtree paths), so
   reconcile **onto the lazy approach** so the general case lands — but do **not** regress
   the peer's entry-path fixtures/coverage; make them pass under the unified mechanism, and
   remove the now-redundant precompute path only if the lazy mechanism truly subsumes it.
   Keep the diff coherent for review.
3. All 917 compartment-mapper tests green (12 known failures unchanged), tsc+eslint clean,
   regression evidence intact (neutralizing the override must fail the integration tests).
4. Push the reconciled result to the #96 branch (bot identity; bot-fork PR — no identity
   switch).
5. **Post a GitHub comment on #96** explaining: the general dependency-subtree case is now
   reconciled in, how the two mechanisms were unified (entry-path precompute → lazy
   per-module), and the test/regression status. Reply on any relevant inline threads on #96.

## Definition of done

#96 carries the unified implementation landing BOTH the entry-path and the general
dependency-subtree cases, tests/lint/types green with regression evidence, pushed under the
bot identity, and a #96 comment communicates the reconciliation. Report the new head SHA.
If the two mechanisms genuinely cannot be unified cleanly, report the precise obstacle on
#96 rather than forcing a broken merge.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 6
  claimed_at: 2026-06-25T16:49:25Z
