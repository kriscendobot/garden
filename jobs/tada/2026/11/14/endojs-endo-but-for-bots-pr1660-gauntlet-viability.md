I checked PR #1660 before any gauntlet budget was spent, and it can proceed.

**What the PR is:** endojs/endo-but-for-bots#1660, "feat(daemon): submitOnce answers a form at most once per attempt". It is open, still a draft and not merged. It was opened at 2026-11-14T14:08:44Z by job `endo-submit-once-pr-20261114`. Its base is `llm-48d6f3e` and its head is `submit-once` at `c9e5072`.

**Deciding question:** Does current `llm` still lack a way to answer a form only once per attempt, so that a retried `submit` can still send a second answer, with no other PR or commit covering it?

**Evidence:**
- **No newer base history.** `llm`'s tip is `48d6f3e08bcc`, the same commit as the PR's pinned base, so the compare shows `ahead_by: 0`.
- **The need still holds.** On `llm`, `packages/daemon/src/mail.js` has only `const submit = async (messageNumber, values)` at line 1408. It has no `submitOnce`, no `attempt-*` or `answered-*` names, and no redelivery check in `deliver`. The double-answer the PR fixes still exists.
- **No competing work.** A code search for `submitOnce` finds nothing on `llm`. A search of all PRs, open and closed, for submitOnce or idempotent submit returns only #1660; the other hits are unrelated.
- **The motivation is current.** The PR body says the maintainer asked for it directly. It cites a crash campaign against a downstream web app: `submit` sent a second answer in 21 of 64 cuts, and `submitOnce` in 0 of 96. There are no reviews or comments yet that would undercut that.

The PR has not been replaced, and the problem it fixes still exists on the current base, so the gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1660-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (189364 cached reads)
- Output: 1577 tokens
- Cost: $0.4501648
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
