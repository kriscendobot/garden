Panel round 4 on kriscendobot/minion.town PR #145 is done. The verdict is **must-fix**, and it is posted to the PR.

- **How it ran:** I ran `panel.sh` in single-round mode, detached and with `GARDEN_YARN=npm`, against an isolated checkout of head `09743bb` on base `main-c54f507` (`c54f507`). All 33 seats returned, and the panel printed `code-panel single-round — must-fix`. Because it ran detached, I couldn't capture its exit code directly. It did reach its normal disposition line with no seat or decider errors, so I'm treating this as a real verdict, not a panel error.
- **Request-changes seats:** stylist, saboteur, breaker, wire-watcher, scribe.
  - **stylist:** the variable `zipdir` in `provision-ci-runner.sh:92` should be spelled out as `zip_directory`.
  - **saboteur, breaker, wire-watcher:** the background offline-runner cleanup can delete a runner that was just created but hasn't connected yet, a busy runner during a brief network drop, or another host's runners. It needs a minimum-age or ownership check, plus a test.
  - **saboteur:**
    - The loop never pauses when `run.sh` exits within seconds, so it keeps minting new runners without limit.
    - The bare `JSON.parse` of the secret puts its first characters into the Lambda error message.
  - **breaker, wire-watcher:** the "private repo only" check runs only at provision time. The minter should check again before `generate-jitconfig`.
  - **breaker:** the cleanup between jobs skips anything named `/tmp/systemd-private-*`. It also misses `ghrunner`'s crontab, `/run/lock`, `/dev/mqueue`, and docker swarm services and plugins.
  - **scribe:** round 3 had six must-fix seats. The latest commit addressed only stylist's and integrator's items. Nothing on the PR says what happened to the other four (locksmith, breaker, saboteur, engine-realist), so a summary comment is needed.
- **Comment-only (assessor):** `prune_offline()` treats a Lambda that threw an error as a success.
- **Where it's posted:**
  - The review is review 5399319825 on head `09743bb`. It holds the request-changes and comment-only seats. GitHub won't accept request-changes on the bot's own PR, so it is a COMMENT review that says to treat it as REQUEST CHANGES.
  - The full aggregate is 84 KB, over GitHub's limit for a review body. The 14 approve seats are in a follow-up comment, issuecomment-5966227393, following rounds 1–3.

I changed nothing in the garden repo. The next step is the fix stage, which the gauntlet driver handles.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 34 tokens (874680 cached reads)
- Output: 6594 tokens
- Cost: $1.116688
- Wall-clock: 584s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
