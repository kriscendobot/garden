Implemented M3 `endoclaw-network-fetch` and pushed commits through `e4221057fa`.

- Added origin allowlists, request/response bounds, rate/concurrency limits, deadlines, cancellation, revocation, durable policy control, and TOFU prompting.
- Added the passable Timer capability and removed ambient timer/AbortController requirements from confined fetch.
- Added 92 focused tests, including daemon-endowment-only Compartment execution; package lint, type checks, docs, formatting, and package uniformity pass locally.
- Opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1588
- Updated design, changeset, READMEs, generated TypeScript references, lockfile, and garden library keywords.
- Final CI was queued/running after bounded monitoring; initial CI findings were fixed. `makeHttpTool` remains a separate integration follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endoclaw-network-fetch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 188 tokens (14577827 cached reads)
- Output: 79616 tokens
- Cost: $6.215117399999997 (1 engagement(s) unpriced)
- Wall-clock: 5188s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
