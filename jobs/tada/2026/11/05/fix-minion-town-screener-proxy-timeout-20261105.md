Implemented and pushed:

- `024425a0ee0`: moved screening from `garden-proxy` into a dedicated leader-only timer with a 30-minute bound; rc-124/137 overruns now log, notify the maintainer, and recover cleanly.
- `dd3e6bc6edf`: fixed the secrets compatibility lookup that blocked candidate deployment tests in narrow fixtures.
- Added unit, timeout/recovery, enablement, and leader-gating regression coverage.

Verification:

- Screening suite: 38 passed.
- Unit isolation/timeout test: passed.
- Leader gating: 55 passed.
- Service enablement: 41 passed.
- Signal classifier: 17 passed.
- Deployment candidate gate passed.
- Leader deployed at `dd3e6bc6edf`.
- Live screening tick completed successfully and attested PRs 237, 246, 250, and 252; all four conduct jobs reached `doin`.

The leader lag was caused by the rolling deploy waiting on the stuck `oros-studio-garden-ce242c49` canary; the existing `oros-health-checkup-20261105-103515` job tracks that follow-up.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-screener-proxy-timeout-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1422s

<!-- garden-usage-end -->
