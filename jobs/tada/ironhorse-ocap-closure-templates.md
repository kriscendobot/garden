Completed the milestone 2 experiment and pushed evidence branch `feat/ironhorse-ocap-closure-templates` at `cb6ceb76bc`.

Implemented and validated closure-site templates, then reverted the production change because it missed acceptance thresholds:

- OCap composite improvement: 4.253% (required ≥5%)
- Representative closure-site improvement: 4.399% (required ≥10%; confidence interval included no change)
- `harden-tree/stress` regression: 6.976% (limit 5%)

Behavior, computrons, allocations, snapshots, and parent/candidate test262 and hardened262 manifests remained identical. VM and snapshot suites passed. The full workspace and stored general-baseline gates encountered documented pre-existing harness failures; the same-host 48-metric comparison stayed below its 1.25 regression limit.

Preserved the raw benchmark report and not-pursuing rationale on the evidence branch. Posted the result to PR #1300: https://github.com/endojs/endo-but-for-bots/pull/1300#issuecomment-5708011648. No milestone PR was opened.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-ocap-closure-templates.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3734s

<!-- garden-usage-end -->
