from_host: endolin-garden-ece02cb4
from: gardener:claude-on-minion-town-completion-press-20260926-233541
reply_to: claude-on-minion-town-completion-press-20260926-233541
msg_key: msg-claude-on-minion-town-completion-press-20260926-233541-65068d693596
notice_count: 1
first_seen: 2026-09-26T23:40:22Z
last_seen: 2026-09-26T23:40:23Z
sent_at: 2026-09-26T23:40:23Z
---
Claude-on-minion.town arc completion press (2026-09-26T23:36Z): the foreman revived stale arc jobs, and most of them had nothing left to do.

Between 18:14Z and 23:37Z the foreman's leaf-first plan promoter took 23 doom-parked arc jobs out of `jobs/plan/`. All of them were `gate: deferred`, so the path was sanctioned and nothing went missing. But 17 of the 21 arc jobs that completed in the window ran against work that had already shipped, and each report says so:
- `build-minion-town-claude-agents-capability`: https://github.com/kriscendobot/minion.town/pull/87 merged 09-03, so no artifact was needed.
- 6 jobs on https://github.com/endojs/endo-but-for-bots/pull/1304 and 7 on https://github.com/endojs/endo-but-for-bots/pull/1305: both PRs merged 09-18/19.
- The https://github.com/endojs/endo-but-for-bots/pull/1305 retcon failed to set up its worktree because the head branch had been deleted after merge.
- The workers on pr1304-panel-6 and pr1305-retcon both flagged that the promoter does not check whether the PR is open or the gauntlet has finished before it promotes a PR-scoped stage.

In flight right now:
- `endojs-endo-but-for-bots-pr1306-conduct` and `-pr1306-conduct-20260919` are both in doin on garden2, conducting a PR that merged on 09-19.
- `pr1305-conduct-20260919` sits in todo under the resume orchestration.
- These should resolve as no-ops, but they spend tokens.

Still parked (doomed, deferred), and likely to be revived the same way: `split-pr1125-1304-gauntlet-shepherd`, `pr1306-review-3ed76637`, `minion.town-pr99-receipt`, `pr1125-aff3b059-retro`. `pr1015-refresh-for-review-20260919` is go-ahead, so it is protected.

Suggestion, your call: withdraw those stale PR-scoped plan jobs. Separately, consider a merged-PR check in the promoter. I have not touched the board.

Real progress: the https://github.com/kriscendobot/minion.town/pull/118 shepherd fixed the red B2 restart test (326b199), and CI is green. The PR needs dckc to re-approve the rebased head before a conductor can merge it.

No new dooms, no policy-refusals, no requeue loops, and no job went absent.
