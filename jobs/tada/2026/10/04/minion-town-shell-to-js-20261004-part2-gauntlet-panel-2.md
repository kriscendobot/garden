Panel round 2 on kriscendobot/minion.town#152 (head `f30a7ed`, base `chore/javascript-only-scripts-part-1-dcc2d64`) came back **must-fix**. The verdict is posted to the PR.

**What I did**
- Made an isolated checkout of the PR head (`kriscendobot/minion.town`, branch `chore/javascript-only-scripts-part-2a`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 152 chore/javascript-only-scripts-part-1-dcc2d64`. It exited 0 with `code-panel single-round — must-fix`, and all 33 seats returned a verdict.
- Posted the result the same way round 1 was posted:
  - **Review 5407756799.** It is a `COMMENTED` review with the heading "Panel round 2 — must-fix", tied to commit `f30a7ed`. GitHub refused `--request-changes` because the bot can't request changes on its own PR. The review holds the 9 request-changes seats: typist, stylist, prover, breaker, engine-realist, integrator, scribe, pruner and corner-prober.
  - **Issue comment 5983469929**, "Panel round 2 aggregate (part 1/1)", holds the other 24 seats (approve and comment-only).

**Main must-fix themes for the next fix round**
- **Ctrl-C still skips cleanup (`lib/common.js` `onExit`/`run`).** The parent process has no SIGINT/SIGTERM handler, so a Ctrl-C to the whole process group kills it before the `onExit` hooks run. A staged secret object in S3 can then be left behind.
- **Misplaced doc comment (`lib/common.js:52-66`).** The JSDoc written for `exitForSignal` now sits above `parseJson`.
- **Missing tests (`lib/zip.js`).** Nothing tests the locale-independent sort with mixed-case names, which the last fix commit says it fixed. `formatSize` and the empty-archive case also have no tests.
- **No fix-round summary.** Nothing was posted on the PR after the round-1 fixes landed (scribe).
- **PR description is too long.** The pruner asks for the script list and incident narrative to be cut down.

**Follow-up:** the procurer seat reported that the bare base name `chore/javascript-only-scripts-part-1-dcc2d64` doesn't resolve in the project checkout, so its build-versus-buy check was skipped. That is a small gap in that one seat and doesn't change the verdict. It is related to the panel.sh base-normalization behavior already in memory.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1100582 cached reads)
- Output: 5693 tokens
- Cost: $0.8947683999999999
- Wall-clock: 959s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
