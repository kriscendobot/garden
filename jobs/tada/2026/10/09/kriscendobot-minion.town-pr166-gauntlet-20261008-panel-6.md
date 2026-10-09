Round 6 of the panel on kriscendobot/minion.town PR #166 came back **must-fix**. The verdict is posted to the PR as review 5469512817 against head `4353d0b`, base `main-50aa690`. It went up as a comment-review, because GitHub won't let the bot request changes on its own PR; rounds 2–5 were posted the same way.

**What I did**
- Got an isolated project checkout of `kriscendobot/minion.town@feat/prod-objectives-probe` at `4353d0b`. The first two attempts failed on a fetch error and the third succeeded.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 166 main-50aa690`. It exited 0 with disposition `must-fix`. All 34 seats returned: 4 request-changes (decomplector, locksmith, pruner, wire-watcher), 21 comment-only and 9 approve.
- Rounds 4 (`525596d7`) and 5 (`9572abfd`) both raised must-fix findings on the same mechanism, `Headers.get` header interpretation. That triggered the panel's repeated-mechanism check, so the decomplector was asked whether that code is needed at all.

**Must-fix findings**
1. **decomplector:** remove the hand-written header evaluator in `deploy/probe/prod-objectives.mjs` (`parseCsp`, `TIGHTENING_DIRECTIVES`, `NARROW_SOURCES`, `CASE_INSENSITIVE_HEADERS`, `cacheDirectives`, …). Instead, compare each header exactly against what the gateway declares (`ISOLATION_HEADERS`, `IMMUTABLE_CACHE`, the etag). This is the third round patching that evaluator.
2. **wire-watcher:** `parseCsp` treats a non-breaking space (U+00A0) as whitespace, but a browser splits only on ASCII whitespace. So the probe can report `default-src 'self'` as present while a browser ignores it. Fixing finding 1 makes this moot.

**Should-fix findings**
- **locksmith:** the probe's full-authority client secret sits in repo-wide Actions secrets with no environment gate, so a workflow pushed to any branch can read it. Move it into an Environment that only the default branch can use.
- **pruner:** trim repeated documentation.
- **saboteur:** the evidence in the PR body was gathered at `525596d`; re-run it at the current head.

**The review itself**
The panel's full output is 96 KB, over GitHub's ~65 KB limit for a review body. I posted a 63.8 KB version, ordered as a summary header (must-fix, then should-fix), then per-seat reports with request-changes seats first. To fit, it leaves out 15 lower-priority seat reports (7 comment-only, 8 approve) and lists them by name.

The inbox drain found nothing: the inbox journal clone timed out, so the drain was skipped. I made no fixes and did not un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (823908 cached reads)
- Output: 6701 tokens
- Cost: $0.7672416000000001
- Wall-clock: 757s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
