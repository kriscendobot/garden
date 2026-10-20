I ran the read-only style pre-pass on PR #1512 at its pinned base and head. It failed, so I did not dispatch any jurors, run `panel.sh` or post a PR review. Nothing was fixed or un-drafted.

- **Pinned pair:** base `92b91a7e93c936b30567924c480641da19f44f78`, head `75a361e7ed03bec9c19b65dbfff64cba2049a180`. The head is `endojs/endo-but-for-bots:design/ocapn-noise-session-reconnect-protocol`, and the PR is still an open draft.
- **Checkout:** I made an isolated checkout at `/Users/dom/garden/scratch/project-wt-endojs--8aed1c9d1bf3-22a7527b`, detached at the head commit. `git rev-parse HEAD` matched the head ID.
- **Pre-pass:** `scripts/jobs/gardening/pre-push-gates.sh --no-auto-fix --probes-only --base-ref 92b91a7e93c936b30567924c480641da19f44f78 <worktree>` exited 1. One probe failed: `designs/ocapn-noise-session-reconnect-protocol.md` line 228 uses the `↔` arrow (U+2194) where the probe wants `<->`. The probe reports it as auto-fixable with `--fix`.

The exact combined output is below, for fix-1:

<!-- gauntlet-style-prepass-output-begin -->
probe typist-friendly-code-points fail (exit 1)
  fail: designs/ocapn-noise-session-reconnect-protocol.md:228 U+2194 LEFT RIGHT ARROW: type `<->` (auto-fixable: run with --fix)
result: 1 failing stage(s); address and re-run.
<!-- gauntlet-style-prepass-output-end -->

**Follow-up:** fix-1 should replace that character with `<->` (or run the probe with `--fix`). Panel round 1 can run after that.

<!-- gauntlet-stage-result: panel=prepass-failed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1512-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (154063 cached reads)
- Output: 1700 tokens
- Cost: $0.35124459999999996
- Wall-clock: 144s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
