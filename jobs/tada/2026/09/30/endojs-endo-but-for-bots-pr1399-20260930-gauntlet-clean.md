---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage: endojs/endo-but-for-bots#1399 is red, and the failure comes from the base branch

**Result: CI RED (`ci-wait-merge.sh` rc=3).** No `clean=done` marker; the gauntlet should halt here.

**What I did**
- **No coverage pass was needed.** PR #1399 ("design(sturdyref): layer 9 — SturdyRefs in the daemon Agent API") changes only Markdown: `designs/README.md` and `designs/sturdyref-agent-api.md`. There was no code to cover and no dead code to remove, so I pushed nothing.
- **CI had never run on this PR.** The head `aeb35421` had zero Actions runs about 1.5 hours after the PR opened at 08:38Z, even though `ci.yml` runs on every `pull_request` and other PRs were getting runs. GitHub had apparently dropped the event. I closed and reopened the PR, which queued 5 workflows including CI.
- **I waited for CI with the bounded wait.** The rollup finished at 28 checks: 5 passed, 22 skipped, 1 failed (`lint`).

**Failing check: `lint`**
- The "build API docs" step fails with: `packages/captp/test/sturdyref.test.js:264:40 - error TS2339: Property 'locate' does not exist on type 'EMethods<Required<unknown>>'`.
- **This PR did not cause it.** #1399 touches no code. The error is in the frozen base `build/sturdyref-daemon-formula-8b57a39`, which is layer 8, PR #1398, based on `build/sturdyref-ocapn-enliven-267b1aa`.
- **The lower layer is red too.** #1398's previous CI run (36690025489, head `1d4d84b796`) failed lint with a related captp type error (`captp.js(199,39): TS2339 Property 'enliven' does not exist on type 'object'`), plus failures in test, cover and test-xs. A new #1398 CI run at `8b57a39` (which matches #1399's frozen base) was still in progress when I finished.

**Follow-up for the maintainer or driver**
- The fix belongs lower in the SturdyRef stack: the captp SturdyRef typing in `packages/captp/test/sturdyref.test.js` and `captp.js`, layer 8 or below. It does not belong in this design PR.
- Once the lower layers are lint-green, weave #1399 onto a new frozen base and re-run this stage. It should then pass with nothing to change.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1399-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (736557 cached reads)
- Output: 5612 tokens
- Cost: $0.6779914
- Wall-clock: 1515s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
