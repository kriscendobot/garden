---
child-ebfb-pr882-bootstrap-generators-host: endolin-garden-ece02cb4
child-ebfb-pr882-bootstrap-generators-reap-count: 0
order: serial
children: ebfb-pr882-bootstrap-generators ebfb-pr873-lint-fix ebfb-pr875-review-response ebfb-pr876-conduct ebfb-pr877-rebase ebfb-pr878-rebase
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-08-01T08:26:53Z
---

Land the endo npm-via-CAS registry gap family on endojs/endo-but-for-bots (base `llm`).

Context: the arc's finish line is MET and verified with real-execution evidence (press tick
2026-07-30: `endor run` fetching and executing is-odd, semver, and react@18.3.1 from the real
npm registry with zero node_modules, zero lockfiles, no npm CLI; offline mode cache-only;
`cargo test --lib` 189 passed / 0 failed). #857, #859, #860, #862 already merged.

Maintainer decisions carried into these children (kriskowal via liaison, 2026-08-01):
- #876 stands approved and awaits a conductor. This resolves the default-condition-set policy
  as opt-in via `--conditions` (not browser-by-default, not node-shims).
- #882 is prioritized as load-bearing for a standalone `rust/endo` build.

Serial order is deliberate — the PRs interlock at file level:
  882 (build unblock) -> 873 (lint) -> 875 (EXPORTS_RESOLVER_JS) -> 876 (conductor, merges)
  -> 877 (__archiveEndowments, rebase only) -> 878 (web globals, rebase only)
