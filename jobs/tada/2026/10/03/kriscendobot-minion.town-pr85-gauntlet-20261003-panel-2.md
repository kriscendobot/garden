I ran round 2 of the review panel on kriscendobot/minion.town PR #85 and it came back **must-fix**.

**The run.** `panel.sh` ran in single-round mode against an isolated checkout of the PR head (`a9d7b3e`). I compared it against the PR's frozen base commit `ec8db3fc87` (`main-ec8db3f`); the 18 changed files match GitHub's file list exactly. It used the code panel of 33 seats and exited 0. The seats split 15 approve, 12 comment-only and 6 request-changes (typist, saboteur, breaker, purist, spec-keeper, wire-watcher).

**The review.** It is posted on #85 as a COMMENTED review, not request-changes. GitHub refuses a request-changes review on the bot's own PR, which matches round 1. The body carries `disposition: must-fix` and the marker `garden-panel-verdict … round=2 disposition=must-fix`. The 16 seat verdicts that didn't fit under GitHub's size limit are in a PR comment (#issuecomment-5972790477).

**The 3 must-fix findings:**
1. **typist:** The doc comment on `GuestSiteAuthority.resolvePowerReference` (`publish.ts:175`) says it returns the power itself. The daemon authority now returns an opaque `{ clipPowerName }` placeholder instead, so the comment is wrong for that path.
2. **saboteur:** In `makeFsUpgradeCapabilityTable().get` (`upgrade-capability.ts:796` and `:801`), two bare `catch {}` blocks turn read errors and corrupt files into "not a valid upgrade capability", with nothing logged.
3. **fast-checker:** The grant validator's rejection of malformed input has only hand-picked tests and needs a property test.

**Should-fix issues several seats raised:**
- A content-only capability doesn't actually stop a delegate from rebinding the clip's powers, because of the known gap where any guest can reach the clip's directory (residual R3). The `attenuateUpgrade` tool text claims it does.
- An upgrade that changes both content and powers can half-apply: powers are rebound before the content write, which can still fail.
- Upgrade grants pile up and are never cleaned up, whether a publish fails, the clip is unpublished, or `attenuateUpgrade` is called repeatedly.
- Grants aren't frozen at runtime.
- A `@self` id with no `:` silently produces a malformed id.
- The payer is charged before an upgrade naming a power they don't hold is rejected.

As instructed, this stage didn't fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (856010 cached reads)
- Output: 6678 tokens
- Cost: $0.82653
- Wall-clock: 512s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
