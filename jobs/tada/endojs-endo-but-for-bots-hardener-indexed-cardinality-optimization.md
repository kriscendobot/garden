Completed design proposal `hardener-indexed-cardinality` in draft PR endojs/endo-but-for-bots#1058.

- Specifies `%TypedArray%.prototype.length` as the O(1) indexed-property count.
- Documents that total own-key enumeration remains O(n), while descriptor walks are avoided.
- Proves correctness for expandos, symbols, accessors, holes, proxies, detached/resizable views, and subclasses.
- Adds implementation tests, benchmark requirements, and roadmap indexing.
- Verified formatting, diff integrity, TypedArray cardinality behavior, and draft PR state.
- Follow-up: implementation should branch independently from `master`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-hardener-indexed-cardinality-optimization.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 558s

<!-- garden-usage-end -->
