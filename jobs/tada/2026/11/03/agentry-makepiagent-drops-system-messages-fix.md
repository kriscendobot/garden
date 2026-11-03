---
handed-off: agentry-makepiagent-drops-system-messages-fix-open-pr
deliverable-complete: false
---
**The fix is pushed, but the draft PR isn't open yet.** This host's token can't create PRs on endojs (`createPullRequest` 403), so I posted `agentry-makepiagent-drops-system-messages-fix-open-pr`, pinned to `endolin-garden-ece02cb4`. That job has the full PR body and keeps this job's base, so it reuses the same PR marker. It only opens the PR; naming the PR URL in its report should stage the gauntlet.

- **Head:** `fix/agentry-pi-agent-system-messages` at `d080647e4bc3`
- **Base:** frozen `llm-48d6f3e`, which currently matches `llm`

## Cause
- **Confirmed:** with the real `openai-completions` adapter against a local fake endpoint, the first message sent was the user's and the system prompt was missing.
- **Which Pi bump:** the break came earlier than the job assumed, in Pi 0.86.0 rather than 0.87. That release stopped passing `systemPrompt` and `tools` on the request context, and upstream's default filter started keeping `system` at the same time. It reached this repo with the `^0.85.1` to `^0.86.1` bump in `5c8309652` (2026-09-27), so anything on `llm` since then is affected.

## Changes
- **Fix:** `packages/agentry/src/harness/pi-agent.js` no longer has its own filter and uses pi-agent-core's default, so the two can't drift apart again. A custom `convertToLlm` still takes priority, and the docs now say it must keep `system` messages.
- **Other callers:** `defineAgent` and Lal's `spawnWorkerLoop` pick up the fix, and code mode doesn't set `convertToLlm`. No production code passes a custom one.
- **Lal cleanup:** I updated the copies of the old filter in `pi-agent-tools.test.js` and `smallcaps-footgun.test.js`, plus a stale comment in `packages/lal/agent.js`.
- **Regression tests:** the new `packages/agentry/test/harness-pi-agent.test.js` has 5 tests, and 4 fail without the fix. The fifth checks that a custom `convertToLlm` is honored. They cover:
  - the context a scripted stream receives, including seeded messages and `defineAgent`;
  - the request bodies the real adapter sends across a full tool call round trip.
- **Changeset:** added a patch changeset for `@endo/agentry`.

## Verification
- **New tests:** all 5 pass.
- **`packages/lal`:** 197 passed, 1 skipped. This ran just before a comment reflow in `agent.js` and test-only type-import edits in agentry, and I didn't rerun it afterwards.
- **`packages/agentry` full suite:** still red.
  - **`eval/conflict-rebase`:** one test fails (`git rebase integration`), and it fails the same way without the fix.
  - **Timeout:** the same run timed out with one test still pending in that file, which finished when run alone with a longer timeout. Everything else that ran passed.
- **Static checks:** `tsc` passes in both packages. ESLint and Prettier ran on changed files only, and pre-push probes pass with one non-blocking comment advisory; I kept that comment because it explains the Pi behaviour.
- **Not yet run:** CI hasn't run and will be the first full-repo lint, since there's no PR yet. No live provider was called.

## Follow-ups
- **Possible delay:** the endolin job can sit unclaimed if that host is over its token cap, and this fix stays out of `llm` until it runs.
- **Bug-report memory:** it now says 0.86 and points at this branch. Delete it once the branch merges.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/agentry-makepiagent-drops-system-messages-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (2081056 cached reads)
- Output: 25459 tokens
- Cost: $1.8767352000000002
- Wall-clock: 1796s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
