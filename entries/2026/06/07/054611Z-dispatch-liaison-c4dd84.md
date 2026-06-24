---
ts: 2026-06-07T05:46:11Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--c4dd84`) to re-ferry bots#79 onto endojs/endo#3231 (namespace-mutation parity test). Single-commit Shape-2 recompute: carries a 1-line typecheck fix and freshens #3231's stale base.

State: bots#79 (head `3e12fef1a`, 1 commit endolinbot, base frozen `master-c49fb04`) mirrors #3231 (head `c6a779d0c`, 1 commit Kris Kowal, branch `kriskowal-namespace-mutation`, MERGEABLE but BEHIND - ahead 1 / behind 77 vs master, REVIEW_REQUIRED, NO reviews/approval). The ONLY content difference is one line in namespace-mutation.test.js: bots#79 has `result.assignErrorName = /** @type {Error} */ (e).name;` vs #3231's `result.assignErrorName = e.name;` (a JSDoc type-cast hygiene fix). The test files are NEW (not on master) so the recompute applies cleanly onto current master `4a04d078b`.

Boatman brief (Shape 2, single commit): fetch origin (exact refs/heads/master = `4a04d078b`); detach at origin/master; cherry-pick bots#79's commit `3e12fef1a` via `refs/pull/79/head` (new files -> clean apply, no base conflict); author+committer `Kris Kowal <kriskowal@kriskowal.com>`; subject `test(ses): pin namespace mutation parity with Node.js`; strip any (#)/Co-Authored-By/Generated-with trailers; RUN `interpret-trailers --parse` EMPTY; verify net diff == bots#79 (the type-cast line present); no yarn.lock change expected (test-only, no dep); force-with-lease against `c6a779d0c` to `kriskowal-namespace-mutation`; confirm MERGEABLE + base freshened (behind 0); create garden-side cross-link on bots#79 (--paginate search; none exists -> create). `identity_switch_authorized: true`.

Expected report: new #3231 head, force-with-lease, the type-cast line present, Kris Kowal + trailers-empty, mergeable + behind=0, CI, created cross-link.
