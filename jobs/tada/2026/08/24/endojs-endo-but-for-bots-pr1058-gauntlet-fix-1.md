CI is **GREEN** (rc 0). The fix stage is complete.

---

## Completion report — Gauntlet FIX round 1, endojs/endo-but-for-bots PR #1058

PR #1058 is a **design-doc PR** (`designs/hardener-indexed-cardinality.md` + `designs/README.md` bookkeeping). I read the panel's round-1 verdict (disposition **must-fix**) and applied its items as review-feedback follow-up commits, then pushed and watched CI to green.

**Must-fix items applied:**
- **Two-snapshot read-order race** (critic, skeptic, decomplector — all three independently reproduced it on V8). The design compared `ownKeys` (read first) against the intrinsic length (read second); a growable `SharedArrayBuffer` grown by another agent between the reads could inflate the later length up to the key count, hiding an expando on the fast path (a `harden` escape). **Fixed** by reading the intrinsic length **first**: since SAB grow is monotone (`Lk ≥ L1`), growth can now only push `keys.length` past the pre-read length and select the slow path. I verified the reordering at a node prompt. The Correctness Argument now argues the direction of skew and the fail-open direction explicitly and states the ordering as load-bearing.
- **`freezeTypedArray` return contract** (ergonomist): pinned to `=> Array<string|symbol> | undefined` — returns the already-materialized `keys` on the slow path (a *fact*, per decomplector's mechanism-vs-policy) and `undefined` on the fast path, with the call-site reading spelled out.
- **novice ×3**: problem statement now names the O(1)-cardinality criterion and reconciles the "no descriptors" win against the residual O(n) `ownKeys`; "expando" and "genuine TypedArray" glossed at first use; rationale for leaving indexed descriptors writable added.
- **copyeditor**: the ambiguous "Equality is safe only when…" sentence rewritten.

**should-fix / copyedits also applied** (cheap and clearly correct): named the SES duplicate `packages/ses/src/make-hardener.js` as in-scope/lockstep; corrected the stale `non-configurable` spec attribute (in-range indices are `configurable: true` post-ES2021, verified); added the single-pass last-key-ordering alternative to Alternatives Considered; added the concurrent-grow SAB test case + both `traversePrototypes` settings + engine names to the test/benchmark plan; naming consistency (`typedArrayLength`, reuse `indexedPropertyCount`); "own outbound references"; parallel list structure; dangling referents named; `read-only` hyphenation, `§`→`section`, `→`→`->` in the touched README paragraph, README Updated column filled + header Updated row added. Confirmed **zero em-dashes / curly quotes / `§`** remain in the new prose.

**Pushed:** `b3ec00b5d0 → 6e6b4a6251` on `origin/design/hardener-indexed-cardinality` via `safe-push-pr-head.sh --mode advance`.
**CI:** GREEN — `total=5 failed=0` (rc 0).

Per stage instructions I applied fixes once and stopped; I did **not** re-run the panel (the driver re-posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1058-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3059019 cached reads)
- Output: 30940 tokens
- Cost: $3.2221735000000007
- Wall-clock: 868s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
