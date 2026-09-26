Updated the bot-authored PR #600 comment in place at `#issuecomment-5123851722`.

Final footnote:
`<sub><!--garden-provenance-->model <code>gpt-5.6-terra</code> · harness <code>codex</code> · garden <a href="https://github.com/kriskowal/garden/commit/7d041aa1f89c4f1af92057b50a1f3579a6d43047"><code>7d041aa1</code></a></sub>`

Evidence used:
- `/.garden-state/foreman/journal/reputation/events/endojs-endo-but-for-bots-pr600-shepherd.md` records `provider: openai` and `model: gpt-5.6-terra`.
- `/.garden-state/foreman/journal/jobs/doin/endojs-endo-but-for-bots-pr600-shepherd.md` records `worker_kind: cleric`.
- `scripts/jobs/comment-provenance.sh` maps `cleric` to the `codex` harness.

Re-read the live comment after the PATCH and confirmed the footnote now matches the above.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr600-footnote-model-harness.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 240s

<!-- garden-usage-end -->
