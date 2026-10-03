The round-1 panel on kriscendobot/minion.town PR #85 returned **must-fix**, and I posted that verdict on the PR. `panel.sh` exited 0, so this is a real verdict, not a sensor failure.

- **Run:** I ran the code panel once (`GARDEN_PANEL_SINGLE_ROUND=1`) in an isolated checkout of head `a41d7047ec`. I passed the PR's `baseRefOid` (`ec8db3fc87`, frozen base `main-ec8db3f`) as the base, set `GARDEN_YARN=npm`, and ran it detached so a reap couldn't kill it. It took about 7 minutes.
- **Seats:** of 33 seats, 13 requested changes, 10 approved, 8 were comment-only and 2 gave no verdict label.
- **Must-fix findings (9):**
  - **stylist:** the identifier `dir` is an abbreviation (`upgrade-capability.ts:149`).
  - **prover:** the `assertUpgradable` tests can never fail, because they call a method that no longer exists through optional chaining. One test's title also contradicts its body.
  - **curator** and **integrator:** the PR ships in-place upgrade, which a landed design and kriskowal's open CHANGES_REQUESTED review mark as superseded.
  - **migrator:** the capability table starts empty on deploy, so clips that are already published can no longer be upgraded.
  - **locksmith:** if an upgrade races an unpublish, the clip comes back online.
  - **breaker** and **wire-watcher:** on the live daemon path, a powers rewrite may not be gated by the capability at all.
  - **integrator:** design docs (`clip-ocap-synthesis.md`, `clip-formula-id-origin-and-content-gc.md`) are left stale.
- **How it was posted:**
  - **Review:** GitHub won't let the bot request changes on its own PR, so the review posted as COMMENTED (review id 5402341871). It carries the `disposition: must-fix` header, the must-fix list and a `garden-panel-verdict` marker.
  - **Overflow comment:** the full aggregate was 86KB, over GitHub's 65,536-character review limit. The review holds the summary plus all 13 request-changes seats in full; the other 15 seats are in a follow-up comment: https://github.com/kriscendobot/minion.town/pull/85#issuecomment-5972574294
- **Cosmetic flaw:** a cleanup step in my posting script stripped some `**` bold markers from three bullets in the integrator seat's block. The text is complete, but the bold formatting there is off.
- **Run directory:** the seat verdicts are in `/home/kris/garden2/scratch/garden-panel-pr85-20261003/`.

**Follow-ups:**
- The fix stage should start with the integrator and curator finding: maintainer direction says this PR's in-place-upgrade premise is superseded, and that may be a close-or-redesign question for the maintainer rather than something a fixer can resolve.
- Garden-dev: `panel.sh` has no step that splits an aggregate over GitHub's 65,536-character review limit; the gardener has to split it by hand.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1137907 cached reads)
- Output: 8215 tokens
- Cost: $0.9122174000000001
- Wall-clock: 535s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
