Fixed the Node 24 `ClientDestroyedError` crash in `@endo/floot` tests.

- Root cause: the routing test unintentionally opened an ambient hosted-provider fetch client, which AVA destroyed after SES lockdown.
- Made the test fully offline with an explicit unsupported provider and a regression assertion that no fetch occurs.
- Commit: `e8294ede88ecfdde246386d42c8071e606da828a`
- Draft PR: https://github.com/endojs/endo-but-for-bots/pull/1567
- Validation: 852 floot tests passed locally on Node 24; pre-push gates passed; GitHub CI is fully green on Node 22/24 across Ubuntu/macOS, coverage, lint, and zizmor.
- Follow-up: maintainer review and merge.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-floot-client-destroyed-error-node24.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3089s

<!-- garden-usage-end -->
