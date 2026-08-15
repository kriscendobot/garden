---
child-ironhorse-js-26-map-methods-reap-count: 0
order: serial
children: ironhorse-js-26-map-methods ironhorse-js-26-map-set-iterator-proto ironhorse-js-26-set-map-metadata ironhorse-js-26-iterator-helpers
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-08-15T04:26:36Z
---

# Orchestration: js-26 residual closure remainder (Iterator + Map/Set)

Owns the remaining work of cluster `ironhorse-js-26-ci-iterator-set-map` after its
first handler landed the 7 ES2025 Set methods + the repeat-array-constructed-collection
bug fix (commit 6b52994a9 on `feat/ironhorse-262-language-completion`, PR
endojs/endo-but-for-bots#970; Set/prototype 174→293 covered, Map construction unblocked,
no regressions, exact-metering corpus 1711/1711 green).

Serial, halt-on-failure. Children in run order:
1. ironhorse-js-26-map-methods — Map.prototype.getOrInsert/getOrInsertComputed + Map.groupBy.
2. ironhorse-js-26-map-set-iterator-proto — Map/SetIteratorPrototype + residual collection aborts.
3. ironhorse-js-26-set-map-metadata — native-function name/length/prototype reflection + delete/redefine (verifyProperty/isConstructor/builtins).
4. ironhorse-js-26-iterator-helpers — the Iterator global + Iterator Helpers (~635 cases); expected to sub-decompose further.

Each child carries the full acceptance bar, pins, and regression invariant inherited from
the js-26 parent. Keep PR #970 open; do not merge.
