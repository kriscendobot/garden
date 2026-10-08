**Panel round 2 for kriscendobot/minion.town PR #169 came back must-fix.**

**What I did**
- Made an isolated checkout of the PR head (`kriscendobot/fix/deploy-secret-preflight` at `ff76caa`) and ran `panel.sh` once in single-round mode, with `GARDEN_YARN=npm`. I used the PR's actual base commit `d750b09` (`main-d750b09`) as the base ref. All 34 seats returned: 3 request changes, 12 comment only, 19 approve.
- `panel.sh` exited 0 with disposition `must-fix`.
- Posted the verdict as a review on #169 at head `ff76caa` (review 5451742506). GitHub rejected a request-changes review because the bot owns the PR, so it was posted as a comment review, like the earlier rounds.

**Glitch:** my first background launch of `panel.sh` didn't actually stop when I killed it, so the panel ran twice. Both runs wrote to the same run folder and appended to one aggregate file. Both reached `must-fix`. The review uses only the second run's half, which matches the per-seat files on disk. The duplicate also left a second record of the run in the journal (`panel-runs/kriscendobot-minion.town-169/75954db5be14.md`, written at 05:07:26 and 05:07:57).

**The blocking item:** a check that triggers when several rounds keep flagging the same mechanism fired here. The last two rounds both raised must-fix items on the `GUEST_RECOVERY_KEY` handling. The decomplector says to keep the pre-deploy check but stop copying systemd's `EnvironmentFile=` parsing rules by hand at `deploy-app.sh:164-165`; three commits have patched that copy so far. Instead, let systemd read the file itself, for example with `systemd-run --wait --pipe -p EnvironmentFile=/etc/minion-mcp/account.env sh -c '[ "${#GUEST_RECOVERY_KEY}" -ge 32 ]'`. Most of the parsing rules and most of the test table could then go.

**Non-blocking items in the review:**
- The writer's key check can be simplified once the pre-deploy check asks systemd.
- The commit history still adds and then removes a deploy-side writer and its permission grant; regroup it into about three commits.
- `DEPLOYMENT.md:956-958` contradicts the new requirement that `account.env` exists.
- `DEPLOYMENT.md:1156-1169` should be trimmed.
- Leftover `…` and `⇒` characters on lines the PR rewrites.

The pruner seat's output is partly garbled and generic, and the review says so; only its `DEPLOYMENT.md` items are grounded.

**Follow-ups:** the next stage is the fixer, working from the review. The duplicated journal record of the run may be worth tidying.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-20261008-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1316370 cached reads)
- Output: 7863 tokens
- Cost: $0.922982
- Wall-clock: 262s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
