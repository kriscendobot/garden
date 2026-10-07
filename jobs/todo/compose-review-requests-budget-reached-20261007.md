---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
dispatch: automatic
---
**Role: fixer.** Compose maintainer **review requests** for PRs whose gauntlet reached its review budget: 6 panel/fix rounds, CI green, but the subjective review didn't converge. Maintainer approved (liaison muster, 2026-10-07).

For each item, read the gauntlet's final panel report and its fix rounds (journal `panel-runs/`, the gauntlet record, and the stage reports in `jobs/tada/`). Then send ONE maintainer message with `scripts/jobs/send-msg.sh maintainer`, keyed `review-request-<owner>-<repo>-pr<N>`. It contains: the PR URL, its arc, what the PR does in two lines, current CI, the **unresolved findings from the last panel round** (seat, finding, why it didn't converge), and what a reviewer should look at first. Do not request review on GitHub and do not approve anything.

1. https://github.com/endojs/endo-but-for-bots/pull/1398 (layer 8 SturdyRef; gauntlet `endojs-endo-but-for-bots-pr1398-gauntlet`)
2. https://github.com/endojs/endo-but-for-bots/pull/1426 (Familiar security-warning render; gauntlet `build-familiar-localhttp-protocol-gauntlet`)
3. **One message for the stack**: https://github.com/kriscendobot/minion.town/pull/151 → /152 → /154 (JavaScript-only deploy migration; gauntlets `minion-town-shell-to-js-20261004-part{1,2,3}-gauntlet`). Review in order from #151.

After each message is sent, archive the matching `*-review-budget-reached.md` notice(s) with `scripts/jobs/maintainer-archive.sh`.
