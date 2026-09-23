---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 442
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-06-14T09:02:00Z
last_appended_at: 2026-06-25T19:04:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#442

Created from the barrister's first code-panel verdict (26 seats + 2 cross-panel; in-band fallback) on the daemon-cas extraction PR (`feat/daemon-cas-extraction`).
PR carves the filesystem-backed CAS out of `packages/daemon/src/daemon-persistence-powers.js` into a new `@endo/daemon-cas` workspace; the daemon delegates through a 6-line `makeDaemonContentStore` call.
Two deferrals warrant revisit when the PR merges: one is a helper-extraction item that lands when `@endo/git-cas` reframes the dep graph, and one is XS coverage that becomes load-bearing only after Phase 5. (A third item — the `joinPath`-only-path-primitive assertion strengthening — was promoted to `summary-fix` by the appellate `entries/2026/06/14/090825Z-result-appellate-98a88d.md` and is being addressed in the current PR.)

A third revisit item was added 2026-06-25 at the maintainer's explicit request (review-comment 3476885702: "Please add a plan to the journal to revisit") on the `asAsyncIterable` test helper — see Items below.

## Items

- [ ] **Extract a shared `node:fs`-backed `ContentStoreFilePowers` test helper.**
  **Source juror(s)**: assessor, surfacer (overlap).
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding `packages/daemon-cas/test/_node-fs-powers.js` (or a similar helper module) that exposes the `node:fs/promises`-backed `ContentStoreFilePowers` adapter currently inlined in `packages/daemon-cas/test/content-store.test.js:27-81`.
  The daemon has its own `node:fs/promises` adapter and the `packages/daemon/test/_mount-test-helpers.js` carries a parallel memory adapter; both are now duplicated here.
  Wait to extract until the third reproduction surfaces (e.g., when `@endo/git-cas` lands and reaches for the same shape) so the helper's signature is shaped by two distinct call sites rather than one.

- [ ] **Revisit XS coverage for `@endo/daemon-cas` when Phase 5 lands.**
  **Source juror(s)**: engine-realist, integrator (overlap).
  **Round**: 1.
  **Recommended action**: when `designs/daemon-cas-management.md` Phase 5 swaps the package's implementation for a thin shim over the Rust supervisor's `cas-*` envelope verbs, audit whether the package now warrants an XS test (today the `test:xs` script is `exit 0` because the implementation depends on `node:fs` powers the test threads in, not on the production code).
  The Rust-CAS shim is XS-relevant by design (the supervisor protocol is engine-portable); the package's XS surface becomes load-bearing at that point.
  No action required pre-Phase-5; this item exists so the merge-watcher surfaces the question at the right moment.

- [ ] **Point the `asAsyncIterable` test helper at a shared array-to-async-iterable utility once one exists.**
  **Source**: maintainer review-comment 3476885702 on `packages/daemon-cas/test/content-store.test.js:136` (thread root 3431721958, "Check for a reusable utility").
  **Round**: maintainer review, 2026-06-25.
  **Status when parked**: a workspace + `@endo/stream` search (recorded in review-comment 3466197155) found no existing array-to-async-iterable helper, so the PR keeps the local six-line `asAsyncIterable` helper (`content-store.test.js:136-142`):
  ```js
  const asAsyncIterable = chunks => ({
    async *[Symbol.asyncIterator]() {
      for (const chunk of chunks) {
        yield chunk;
      }
    },
  });
  ```
  It wraps an `Array<Uint8Array>` of byte chunks into the async-iterable shape `ContentStore#store` consumes, and is used at ~11 call sites in this one test file.
  **Recommended action**: when a reusable array-to-async-iterable helper lands in the workspace (a natural home is `@endo/stream`, or a shared test-helper module reached for by a second call site — e.g. when `@endo/git-cas` or another CAS test needs the same wrapper), open a follow-up PR replacing the local `asAsyncIterable` with that utility and dropping the inline definition.
  **Trigger**: do not extract speculatively for a single call site; wait for either (a) `@endo/stream` to gain such a helper for production reasons, or (b) the second independent test that reaches for the same array→async-iterable shape, so the utility's signature is pinned by two distinct call sites. This mirrors the "wait for the third reproduction" discipline on the `ContentStoreFilePowers` helper item above.
