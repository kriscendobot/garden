Round 5 of the panel on kriscendobot/minion.town#183 finished with a **must-fix** verdict, and I've posted it to the PR.

- **Run:** I ran `panel.sh` in single-round mode against an isolated checkout of `build/inference-phase3-secrets` at head `cab37a5`, with the frozen base `main-bc11010` (`bc110102b6f1`) as the base. All 34 seats returned and it exited 0.
- **Votes:** 11 seats approve, 22 comment only, and 1 requests changes (breaker).
- **Review:** posted as https://github.com/kriscendobot/minion.town/pull/183#pullrequestreview-5500742275. GitHub won't let the bot request changes on its own PR, so the review is a comment headed "Panel verdict — round 5: **must-fix**", the same form as rounds 2–4.

**The must-fix.** I checked it against the head and it holds. The spawn command line gets `--output-format stream-json --verbose` twice:
- This PR adds the flags to the vendored `buildArgv` (`vendor/endo-claude/src/argv.js:150-157`).
- `src/endo/claude/cli-launch.ts:174` still appends them after the harness's arguments, and its header comment still describes that.

The fix is to keep the flags in one place, correct the header, and add a test that combines `buildArgv` with the launch code and checks each flag appears exactly once.

**Since round 4:** round 4's one must-fix (renaming the new variable in the daemon integration test) is fixed. Two of round 4's should-fix items also look addressed going by the newest commits: the misplaced `InferResult` doc comment and the repeated gate test header.

**Should-fix items listed in the review:**
- A secret that was revoked but is still in the catalog reads as a fault, not as `needs-auth`.
- `bounded` gives up on a `@secrets` call after 30 s without cancelling it, which frees that user's queue while the call is still running. Round 4 raised this too.
- A refused `needs-containment` message is re-delivered on every responder restart and spends the rate limit again each time.
- `activate()` isn't tied to the token that was probed.
- No tests for the new connection handling in `cli-deployment.ts`.
- Base64 is hand-written with `Buffer` even though `@endo/base64` is already a dependency.
- The vault gets the whole root host instead of a narrowed `@secrets` view.
- The v1-to-`@secrets` migration has no rollback path, and DEPLOYMENT.md doesn't say so.

The decomplector was seated again because the panel saw a repeated must-fix on the same mechanism. It found nothing that should be removed and flagged its `@pins` trigger as a false positive.

As the job asked, I made no fixes and left the PR in draft. The next step is the gauntlet's fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (916930 cached reads)
- Output: 5892 tokens
- Cost: $0.8035220000000001
- Wall-clock: 273s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
