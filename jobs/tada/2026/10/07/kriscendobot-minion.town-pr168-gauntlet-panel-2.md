I ran panel round 2 on kriscendobot/minion.town PR #168 ("design: clarify, list, and remove a guest's OAuth bonds"), and the verdict is **must-fix**. The panel exited normally and all 9 seats returned results.

- **What was reviewed:** I made an isolated checkout of the PR head `792bb4b` (branch `design/guest-oauth-bonds`, which includes the round-1 fixes). I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `d750b09` (`main-d750b09`), using the PR's own base commit.
- **Seat verdicts:**
  - Request-changes: critic, skeptic, ergonomist, pedant.
  - Comment-only: decomplector, novice.
  - Approve: copyeditor, orthographer, thesaurus.
- **Must-fix findings:**
  - **Skeptic:** anyone holding the bearer alone can remove every bond, including the last one. That turns a leaked bearer into a guest nobody can recover.
  - **Skeptic:** the migration assumes every legacy row has a `guest_formula_fingerprint`, which the design never verifies. It needs a fallback for rows that lack one.
  - **Ergonomist:** the same object is called a bond, a recovery sign-in, a provider and a recovery identity across routes, IDs and copy.
  - **Ergonomist:** the dialog for removing the last bond doesn't offer "Copy this guest's URL" before the destructive button.
- **Main should-fix findings:**
  - The design depends on #114, #129 and #133, none of which are merged, and names no fallbacks.
  - The 10-per-hour rate limit is inherited from #114 rather than set here.
  - It doesn't say what happens to the never-rotated `fingerprintKey` when a guest is rotated or revoked.
  - It's unclear whether removal is a hard delete or a change to the `status` field.
  - The recovery GET also writes bookkeeping, and the design should say that write is best-effort.
  - The 409 "Open that guest" flow quietly replaces the guest stored in the browser.
  - Error responses use different shapes across the three routes.
  - The tests don't cover concurrent add/remove or the sign-out redirect's `rd` allowlist.
- **Posted review:** https://github.com/kriscendobot/minion.town/pull/168#pullrequestreview-5449493878, on commit `792bb4b`, with the marker `<!-- garden-panel: kriscendobot-minion.town-pr168-gauntlet round=2 disposition=must-fix -->`. GitHub won't let the bot request changes on its own PR, so the review posted as COMMENTED, the same as round 1.

I didn't fix anything or un-draft the PR; the next fix-loop stage owns the findings. I made no garden repo changes and no commits.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (581431 cached reads)
- Output: 3659 tokens
- Cost: $0.6452742
- Wall-clock: 155s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
