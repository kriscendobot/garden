No code change was needed.

Artifact: inline reply [4031912235](https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4031912235) answers the sole ask by confirming that introduced names reject `@`, while special indelible names require a leading `@`, making the namespaces disjoint.

Corroboration: `pr-feedback-preflight.sh` found the same-thread reply. At PR head `bf272ccf54c0636183a283c6286470d87498ca1a`, `pet-name.js` implements exactly that partition. No tests were run because no source changed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-22928e6b.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 121s

<!-- garden-usage-end -->
