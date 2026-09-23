Completed: opened draft baseline PR https://github.com/endojs/endo-but-for-bots/pull/847.

Base: `master-fb9cef4` = `fb9cef49eee34d8cf65fb8c6f46cc9b333663f41`; head: `fix/master-fb9cef4-ci-baseline` = `799128b915f6633ac04ad141874a7b02c712d8fe`.

Baseline result: all PR CI checks passed. No standing CI defects required repair. CBOR resolution, TextEncoder/Prettier, and setup-node/zizmor hypotheses were absent. Local missing Graphviz was infrastructure-only; remote dependency check passed.

Verified locally: immutable install, build, lint, type checks, docs, tests, coverage tests, and Hermes. Remote CI, dependency check, and zizmor runs all succeeded.

No source files changed; the head has only an empty baseline-trigger commit. PR #719 should remain separate; if a future baseline repair is added, rebase its feature commits onto a frozen snapshot of this repair branch, then retarget its base to that snapshot.

Self-improvement: nothing this time.
