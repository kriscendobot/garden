Added `designs/ironhorse-js26-map-set-gap-sequencing.md` and pushed commit `6ce1c61ab1` to `main2`.

The design:

- Recovers and cites all four engine-wide gaps and their proposal residuals.
- Specifies a serial four-increment dependency order with entry, exit, regression, and test262 gates.
- Records expected coverage deltas and blast radius.
- Notes that all four fixes already landed, so none should be queued unless a fresh pinned sweep proves regression.

Verified 47 targeted oracle-backed Ironhorse tests passed. Markdown links, style gates, `git diff --check`, and remote commit identity passed. No follow-up is currently required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ironhorse-js26-map-set-gap-sequencing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 682s

<!-- garden-usage-end -->
