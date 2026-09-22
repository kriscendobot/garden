The work is complete. Here is my report.

---

## Completion report: attention directive on endojs/endo-but-for-bots PR #1290

**Directive:** kriskowal's review comment on `packages/sha256/test/browser-entry.js` — *"This seems extraneous. The importer could import these facets directly."*

**Preflight:** exit 2 (HINT). Corroboration showed the "resolution" text on the thread was **aspirational, not landed**: the peer replied (00:07) that "the committed browser-entry.js is gone," but **#1290 had already merged at 23:57** (merge commit `38cce7ebba`) with the file still present. A later reply (00:26) posted *this* job to actually do it. So exit 2 was correctly treated as PROCEED — no artifact resolved the ask.

**What I did**
- Confirmed the sole importer of `packages/sha256/test/browser-entry.js` is `browser-test/tests/sha256.spec.js` (`makeBundle` over a filesystem `read` power).
- **Deleted** `packages/sha256/test/browser-entry.js` (7 lines).
- **Inlined** its two re-export lines into the test's `read` power, served from a **virtual** location under `packages/sha256/test/` (never written to disk): the `read` returns the inlined bytes for the entry URL and delegates to `fs.promises.readFile` otherwise. Wrapped in `Promise.resolve` to satisfy the file's `@ts-check` `ReadFn` (`Promise<Uint8Array>`) contract.
- **Verified** by running the same `makeBundle` path in Node against the virtual `read`: it builds a valid 40 KB bundle that (1) resolves `@endo/sha256` and `@endo/sha256/async` as package self-imports and (2) selects the WebCrypto `subtle.digest` browser async arm — both properties the peer worried about are preserved (conditional-export selection coverage and package resolution anchoring).

**Artifacts**
- Follow-up PR **endojs/endo-but-for-bots#1328** (draft), head `pr1290-inline-browser-entry`, base pinned to frozen snapshot `llm-db664fa` (created the snapshot since ensure-pr refuses a floating base). Commit `d9077c4d08`.
- Threaded reply on the original review comment (`r4067990104`) linking #1328 and stating what landed.

**Follow-ups:** #1328 is a draft per the manual-gauntlet regime; it awaits **run the gauntlet #1328** and maintainer review/merge. Nothing on #1290 itself remains (already merged).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-87327676.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (3 unmetered)
- Input: 68 tokens (1692136 cached reads)
- Output: 18736 tokens
- Cost: $2.2299130000000003 (3 engagement(s) unpriced)
- Wall-clock: 1115s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
