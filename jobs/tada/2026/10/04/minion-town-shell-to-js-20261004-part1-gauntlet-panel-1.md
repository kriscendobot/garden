## Panel round 1: kriscendobot/minion.town PR #151, verdict **must-fix**

The panel ran one round and returned **must-fix**. I posted the verdict as a review on the PR.

**What I did**
- **Checkout:** made an isolated project checkout of `kriscendobot/minion.town@chore/javascript-only-scripts-part-1` at head `dcc2d6425d`.
- **Panel run:** ran `GARDEN_YARN=npm GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 151 a378bb3dd5`, using the PR's `baseRefOid` (`main-a378bb3`) as the base.
  - It ran the 33-seat code panel and exited 0 with `panel #151: code-panel single-round — must-fix`.
  - The durable record is `panel-runs/kriscendobot-minion.town-151/76af02f3d4de.md`.
- **Tally:** 4 request-changes (breaker, purist, saboteur, wire-watcher), 10 comment-only, 19 approve. The deterministic pre-passes (phase/evidence, related-design) were clear, and there is no PR template.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/151#pullrequestreview-5407479565 (commit `dcc2d6425d`).
  - It is state COMMENTED because GitHub won't let the bot request changes on its own PR. The body is headed "Panel round 1 — must-fix" and carries the disposition.
  - The full aggregate was 80 KB, over GitHub's 65,536-character limit for a review. I kept every non-approve seat block and listed the 13 omitted approve seats by name, pointing to the durable record for their text.

**Must-fix for the fix round**
- `tools/claude-harness/inspect-image.js`: the credential-env check is now anchored `^NAME=`, where the old shell version matched the names anywhere. Prefixed, suffixed and `_FILE` variants now pass, which quietly weakens a security gate. Three seats found this independently.

**Should-fix items, also listed in the review header**
- In `ssmRun`, validate `SSM_POLL_TRIES` before `send-command`.
- `isShellScript` misses several shell families, and the repo walk crashes on tracked-but-missing or non-regular files.
- Several scripts changed `:-` defaults to `??`, which no longer replaces empty strings. They should use `||`.
- `vendor-endo-claude.js` calls `process.exit` inside `finally`, which leaks the temporary clone.
- Some modules exit or write to the environment as soon as they are imported.
- `JSON.parse` errors don't name the file they came from.

**One seat finding is wrong**
- I checked purist's must-fix claim that `makeSsmCommand` is an identity function, and it is false at this head. The function base64-encodes the script (`lib/common.js:70-73`), and the round-trip test passes.
- The likely cause is that the prover seat's temporary revert test was running in the same worktree while the purist seat read it. Seats sharing one worktree can see each other's scratch edits, which is worth a garden-side look. I noted the refutation in the review header.

I did not fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1328297 cached reads)
- Output: 7756 tokens
- Cost: $0.9771633999999999
- Wall-clock: 538s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
