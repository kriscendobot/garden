---
handed-off: validate-minion-town-prod-probe-dispatch-backstop
deliverable-complete: false
---
Implemented and pushed draft PR https://github.com/kriscendobot/minion.town/pull/184 at `935b6d6`.

- Added a five-minute systemd backstop that dispatches a strict probe after 3.5 hours without a run.
- Added an independent repository-scoped Actions credential path; the runner host never receives the token.
- Preserved ordinary manual-dispatch, `--strict`, and failure-issue semantics.
- Documented deployment and the required four-hour staleness alarm.
- Verified pre-push gates, typecheck, 21/21 backstop tests, load-bearing threshold behavior, and the GitHub `test` check.
- Production validation remains pending because the required least-privilege PAT has not been provisioned. Parked successor `validate-minion-town-prod-probe-dispatch-backstop` owns credential-gated deployment and forced-dispatch validation.
- Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-prod-probe-dispatch-backstop.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 992s

<!-- garden-usage-end -->
