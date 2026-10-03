Panel round 5 on kriscendobot/minion.town PR #148 is done: `panel.sh` exited 0 with disposition **must-fix**, and the verdict is posted on the PR.

**Run:** I ran the panel in single-round mode on an isolated checkout of `build/claude-cli-provider` at head `4605078b50`. The base was the PR's `baseRefOid` `ec8db3fc87` (`main-ec8db3f`), and the diff matched GitHub's list of 61 files. I set `GARDEN_YARN=npm` and ran it detached from the session. 33 seats ran on the code panel.

**Tally:** 9 request-changes · 13 comment-only · 11 approve. Round 4 was 10 · 11 · 11.

**Why it's must-fix:**
- **Phase/evidence check is blocked.** The PR's ledger still says `non-deliverable-probe`, as it has since round 2, so this check forces must-fix every round. The fix loop can't clear it with code. The PR has to stay draft until the production canary evidence lands and the ledger becomes `deliverable`, or until the maintainer takes it out of the gauntlet.
- **PR body is too long:** 310 words against a 300-word limit, so the pruner seat was forced to review the description.

**Main findings for the fixer:**
- **Credential activation:** `credential-vault.ts` `readActive` counts a record with no `active` field as already activated. Four seats raised this; wire-watcher called it must-fix.
- **Eval tools:** `evaluate`/`eval`/`define` are still blocked only by a list of names plus a check at connect time. The confined MCP server still offers them and holds root-host authority (locksmith, breaker, wire-watcher).
- **Missing test:** the new `surfaceFault` `pruned` branch has no regression test (prover, must-fix).
- **Commit hygiene:** formatter churn is mixed into commit `729533f` and then patched by fixup commits (packager must-fix, integrator).
- Also raised: bearer tokens left in spawn settings files on persistent storage, a full `claude --version` process run on every inference, untested parts of `toMinionOutcome`, and Endo pin and binary-hash checks done once instead of per spawn.

**Posted:**
- **Review** with the header, the summary above and the 9 request-changes seats. GitHub won't let the bot request changes on its own PR, so it went in as `COMMENTED` at 20:07:12Z, the same as rounds 3 and 4. Its body states "Disposition: must-fix".
- **PR comment** with the other 24 seats: https://github.com/kriscendobot/minion.town/pull/148#issuecomment-5973007227. The full aggregate was 93KB, over GitHub's ~65KB body limit, so it had to be split.

Following the job spec, I didn't fix anything or un-draft the PR. No garden repo changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1091928 cached reads)
- Output: 6176 tokens
- Cost: $0.8785456
- Wall-clock: 509s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
