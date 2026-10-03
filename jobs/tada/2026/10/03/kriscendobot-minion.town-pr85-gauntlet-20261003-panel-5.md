## Panel round 5 for kriscendobot/minion.town PR #85: must-fix

I ran one single-round panel on PR #85, posted the verdict as a review, and stopped there. I made no fixes, left the PR in draft and did not start a loop.

- **Panel run:** I checked out the PR head `feat/clip-upgrade-in-place` at `2c35098e9b` in an isolated worktree. The panel compared it against the PR's base commit (`main-ec8db3f`, `ec8db3fc87`) with `GARDEN_YARN=npm`. `panel.sh` exited 0 and reported `code-panel single-round — must-fix`.
- **Seat results:** 33 seats ran: 16 approve, 12 comment-only, 5 request-changes. No seat errored.
- **Review:** posted at https://github.com/kriscendobot/minion.town/pull/85#pullrequestreview-5402816681. It shows as COMMENTED because GitHub blocks request-changes on the bot's own PR, so the `disposition: must-fix` header carries the verdict. The full aggregate was 91 KB, over GitHub's 65,536-character limit, so the review includes the full text of the request-changes and comment-only seats and lists the approving seats by name only.

**Findings that block the PR:**
1. **Re-registering rolls back an upgrade (breaker, must-fix).** If the owner re-runs `register` after an upgrade, the clip goes back to its pre-upgrade content and every delegate's upgrade capability is silently revoked. A second race in `writeDirectory` lets a concurrent re-register write the old state back.
2. **Stale deployment doc (migrator, must-fix).** `DEPLOYMENT.md:399-401` still says live-path upgrade isn't available.

**Should-fix findings:**
- **Failed publish leaves a live clip (assessor, breaker).** If `publish()` throws after `evaluateRegister`, the clip is never unregistered. It stays served with no upgrade capability, and the caller is told the publish failed. Two concurrent publishes of the same clip can also overwrite each other's nonce, so one caller gets a capability that never works.
- **Grant table (breaker).** It can grow without limit. One corrupt grant file makes every later unpublish of any clip fail.
- **Revoke and use are the same string (purist).** Whoever holds the capability can also revoke it. Purist also flagged:
  - a module-scoped `powerReferences` table, so the rule that a reference never crosses to another authority isn't enforced;
  - a nonce pattern and file-write helper duplicated in two files;
  - two new result types that don't match `ClipSummary`.
- **Too much design detail (pruner).** The PR body, the tool descriptions and the module header carry design detail that belongs in the design docs.
- **Arrow glyph (typist).** `upgrade-capability.ts:73` uses `→` in prose; it should be `->`.

**Follow-up:** the next fix-loop stage owns these findings.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (988831 cached reads)
- Output: 6373 tokens
- Cost: $0.8779302000000001
- Wall-clock: 578s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
