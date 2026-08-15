---
child-ironhorse-js-26-cb-with-eval-closure-host: endolin-garden2-5bcdff64
child-ironhorse-js-26-cb-with-eval-closure-reap-count: 0
child-ironhorse-js-26-cb-with-env-core-host: endolin-garden-ece02cb4
child-ironhorse-js-26-cb-with-env-core-reap-count: 0
order: serial
children: ironhorse-js-26-cb-with-env-core ironhorse-js-26-cb-with-eval-closure ironhorse-js-26-cb-with-annexb ironhorse-js-26-cb-with-statements-exprs ironhorse-js-26-cb-with-builtins-strict
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-08-14T22:41:07Z
---

# orchestration ironhorse-js-26-cb-with-closure

Decomposition of the js-26 cb-with-statement cluster (949 actionable cases, reason family unsupported-opcode:with + strict:unsupported-opcode:with, measured on PR endojs/endo-but-for-bots#970 head b3c3ae93). The whole cluster is a single VM feature — the XS environment-chain model behind the `with` statement and the sloppy direct-eval closure-publishing prelude — but it exceeds one handler's safe budget: it needs a full mxEnvironment register/chain rewrite of ironhorse-vm name resolution plus exact-computron calibration across many case shapes, all without regressing the large covered baseline. Split into 5 serial, halt-on-failure children. Child A (env-core) is foundational and unblocks the rest.

Children (run order): env-core -> eval-closure -> annexb -> statements-exprs -> builtins-strict.
All target the existing shared branch feat/ironhorse-262-language-completion / draft PR #970 (kept open, not merged), each in its own isolated checkout keyed by its base with fetch+rebase+CAS push. Every child must convert its slice to covered via real XS-oracle differential execution, add focused Rust tests, pass cargo test --workspace --release and ironhorse-xst --gate-meter-exact, and introduce no baseline-covered regression / new ironhorse-failure / changed exact expectation. Mechanism analysis and per-child specs are in each parked child body.
