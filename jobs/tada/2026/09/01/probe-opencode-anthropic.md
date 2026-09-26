Implemented and pushed commit `77b82f7f2d` to `main2`.

- Added the `opencode-anthropic` registry row, count key, systemd/scaler integration, explicit namespaced eligibility, handler, sidecar resume, private XDG state, transcript export/spooling, summed `step_finish` USD accounting, and environmental failure classification.
- Added a reversible canary recipe and a 9/9 passing hermetic harness test.
- Live OpenCode 1.18.25 confirmed parseable `sessionID`, same-ID `--session` resume, rc 143 when killed, and handler normalization of a refused key to rc 75.
- Gap: this host has neither an installed OpenCode binary nor `ANTHROPIC_API_KEY`. Therefore no worker was enabled, no paid canary ran, and real non-censored USD/reputation journal records remain unverified. The operations guide records the exact activation procedure.
- Other targeted tests passed. The broader auction test retains a wallclock-reducer churn failure outside this probe.
- Self-improvement: added `context/operations/opencode-anthropic.md` documenting current OpenCode storage, routing, activation, and observed gaps.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/probe-opencode-anthropic.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 904s

<!-- garden-usage-end -->
