Panel round 3 on kriscendobot/minion.town#179 is finished and returned **must-fix**; I posted the verdict on the PR.

**What I did:**
- **Checkout:** made an isolated checkout of `kriscendobot/minion.town@gutter-clip-labels` at head `9ebace1`.
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 179 c7bdf2018897…`. The PR's base is `main-c7bdf20`, so I passed its commit hash instead of the branch name. It exited 0 with the disposition `must-fix`.
- **Restart:** my first launch could have been cut off by the 10-minute background limit, so I killed it a few seconds in and reran it detached, waiting for it in the foreground. Only the second run produced the result.
- **Seats:** 34 seats ran: 10 approve, 22 comment-only and 2 request-changes (stylist and breaker).
- **Posting:** the full seat detail went up as two PR comments (6112766678 and 6112766875). The summary went up as a COMMENTED review (5484605776, carrying the `garden-panel … round=3 disposition=must-fix` marker), the same shape as rounds 1 and 2.

**Still open for the fix stage:**
1. **Abbreviated names:** `conn` and `sockPath` in the rewritten code in `site-registry.ts` should be `connection` and `socketPath` (stylist).
2. **Fake subdivision flags:** the name sanitizer still accepts any short run of tag characters between U+1F3F4 and U+E007F. About seven fake "flags" can carry roughly 49 invisible characters in one name. Only the three real sequences (`gbeng`, `gbsct`, `gbwls`) should be allowed, in both copies of the sanitizer.
3. **Stuck lookup slots:** daemon reads that never finish hold their slots forever, and the daemon connection is cached with no timeout. Four such reads turn every clip name into "Clip N" until the process restarts.
4. **Slow title regex:** `extractHtmlTitle` can backtrack on a crafted page, about 37M synchronous steps per page.
5. **Shell can fail to load:** the top-level lookbehind regex in `shell.js` is a parse error on older Safari, which takes down the whole shell, not just the names.
6. **Weak parity test:** the server/shell test only compares the regex source. A property test should check both implementations give the same output and that sanitizing twice changes nothing.

There are also several should-fix items (a changeset, the design doc, test gaps, a British spelling), listed in the review.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1399676 cached reads)
- Output: 7527 tokens
- Cost: $1.0657712
- Wall-clock: 261s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
