PR #250 CI is green at head `e3c78e91`.

- Diagnosed a GitHub-hosted Actions billing refusal; no source defect.
- Switched `kriscendobot/minion.town` CI to the online `ci.minion.town` runner.
- Verified `changes` and `test` passed: https://github.com/kriscendobot/minion.town/actions/runs/41982294057
- Recovered the other billing-blocked run, which also passed fully.
- Scheduled a hosted-runner probe/switch-back for 2026-12-01T00:30:00Z and notified the maintainer.
- No repository files or PR commits changed.
- Follow-up: `minion-town-ci-runner-to-hosted-202611` will test the hosted runner after the monthly reset.
- Self-improvement: nothing this time.
- next: none
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1482s

<!-- garden-usage-end -->
