PR #1588 CI is green on head `1649db1691`, but I pushed nothing this round. Every check is SUCCESS or SKIPPED, and none are pending or failing.

- **Inline `import()` typedefs:** the prepass flagged these in `packages/fetch/src/index.js` (lines 35–36) and `packages/http-confine/index.js` (line 7). The branch already fixes them. `70d9f028ad` and `1649db1691` converted them to top-of-file `@import` tags, and `grep "import("` finds no inline imports left in either file.
- **Comment-concision advisory:** I left the 22-line header in `packages/confined-fetch/src/index.js` as is. It records which names the module looks up and the rule that its only route to the network is the endowed base, which the code doesn't show. The prepass marked it non-blocking.
- **CI watch:** `ci-wait-merge.sh` hit the 10-minute foreground limit and was killed. I polled `gh pr checks` until nothing was left pending instead, so I never got its exit code.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 98 tokens (3122321 cached reads)
- Output: 13637 tokens
- Cost: $1.7092555999999999
- Wall-clock: 7655s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
