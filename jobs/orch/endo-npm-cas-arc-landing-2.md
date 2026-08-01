---
child-ebfb-pr875-review-response-host: endolin-garden2-5bcdff64
child-ebfb-pr875-review-response-reap-count: 0
child-ebfb-pr873-lint-fix-host: endolin-garden-ece02cb4
child-ebfb-pr873-lint-fix-reap-count: 0
child-ebfb-pr882-land-host: endolin-garden-ece02cb4
child-ebfb-pr882-land-reap-count: 0
order: serial
children: ebfb-pr882-land ebfb-pr873-lint-fix ebfb-pr875-review-response ebfb-pr876-conduct ebfb-pr877-rebase ebfb-pr878-rebase
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-08-01T09:15:33Z
---

Second attempt at landing the endo npm-via-CAS gap family on endojs/endo-but-for-bots.

Attempt 1 (`endo-npm-cas-arc-landing`) HALTED at child 1/6: `ebfb-pr882-bootstrap-generators`
deterministically overran the 2400s handler budget (rc=124 at 2401s) and its five downstream
children were swept. Every child here therefore carries `handler-timeout: 7200`.

Child 1 is narrowed: #882 is now APPROVED by kriskowal (2026-08-01T09:12Z) and MERGEABLE/CLEAN,
so only the landing remains — the discovery, build repair, and CI work that blew the budget is
already done.
