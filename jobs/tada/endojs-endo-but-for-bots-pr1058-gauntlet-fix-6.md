My commit `840bd481be` is the current PR head, and all five CI checks pass (browser-tests, build, lint, test, zizmor). CI is terminal GREEN. The job is done.

## Completion report

**Job:** Gauntlet FIX round 6 for endojs/endo-but-for-bots PR #1058 (design doc `designs/hardener-indexed-cardinality.md`).

**Panel verdict addressed** (round-6 request-changes, commit pushed as `840bd481be`):

Must-fix:
- **Prototype-enqueue hoist removed.** The round-5 design hoisted `getPrototypeOf(obj)` above the `descs = getOwnPropertyDescriptors(obj)` snapshot, reordering adversarial-interposition on the generic (Proxy) path. Rewrote the `becomes` snippet and § Design prose to compute `descs` conditionally *in place* (`const descs = purelyIndexed ? undefined : getOwnPropertyDescriptors(obj);`), so the generic path stays byte-for-byte ordered as today; only the fast path (Proxy-excluded genuine TypedArray) skips the snapshot. Dropped all "hoist" language and the self-contradiction it caused.
- **Em-dashes eliminated** — all 46 rewritten to periods/parentheses/colons (verified count now 0).

Should-fix:
- Re-derived the consumption-time invariant from a straight-line-code argument (no user code / `await` / trap between the `ownKeys` read and consumption) instead of relying on V8 `preventExtensions` behavior the design itself flags as non-conformant.
- Added an honest limit: both conjuncts read the same `Reflect.ownKeys` snapshot, so the backstop is independence along the two conformance axes the fast path introduces, not immunity to an `ownKeys` that omits a key.
- Added tests asserting a purely indexed view's prototype is still enqueued/hardened under both `makeHardener()` and `{ traversePrototypes: true }`, plus a Proxy-graph ordering case.
- JSDoc now spells the definition inline and links §10.4.5.7 by URL (the cross-tree "see § Design" reference did not resolve from the code file).
- Named the observability seam (`freezeTypedArrayFastPathCount`) and fixed its visibility as a named export in both copies, resolving the `harden` copy's stale `// Exported for tests.` comment.
- Framed the 2x gate as a go/no-go acceptance bar (not a claimed speedup); marked the fail-open/fail-safe mood; trimmed the repeated conjunction rationale.
- Mechanical: one-sentence-per-line in Open Questions; de-hyphenated `-ly` adverbs; single ECMA-262 citation form; fixed "the section section"; period inside quotes; wrapped the over-length line.

**Result:** commit `840bd481be` is the PR head; all five CI checks pass (browser-tests, build, lint, test, zizmor). Did not re-run the panel (per stage instructions; the driver re-posts panel-7).

**Follow-up:** none for this stage. A `freezeTypedArray` cross-file parity test remains noted in the design as a candidate follow-up for the eventual implementation PR (not this design PR).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1058-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 46 tokens (2184498 cached reads)
- Output: 48321 tokens
- Cost: $3.355308
- Wall-clock: 729s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
