The panel ran one round on PR #173 and came back **must-fix**. I posted the verdict to the PR as a review.

- **Setup:** The PR head is `kriscendobot/minion.town:design/ocap-site-crawler-leak-rotation` at `49e9b5e`, against the base `main-50aa690`. I got an isolated checkout at `/Users/dom/garden/scratch/project-wt-kriscen-7f4fa8ae908d-b9a39f6e`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 173 origin/main-50aa690` exited 0 and reported must-fix for this design. The ownership-map pre-pass flagged cross-boundary concerns, so the panel also ran the decomplector seat. All nine seats returned ok: critic, skeptic, decomplector, ergonomist, novice, copyeditor, pedant, orthographer and thesaurus.
- **Must-fix findings (both from the skeptic):**
  - The § 8 canary triggers rotation with an unverified fetch of `/robots.txt`. Under the § 2 and § 4.2 rules that fetch is never allowed to rotate, so the canary either cannot pass or needs a test-only trigger that skips the real path.
  - Anyone holding the link can force a rotation, because the `robots.txt` and honeypot signals are easy to fake. A hostile holder could rotate a clip once a day, every day, and could trip the fleet-wide circuit breaker.
- **Should-fix findings:**
  - The 10-minute grace window delays exactly the verified-crawler rotations the design is meant to catch.
  - § 3.4's measurement gate never says what happens if 14 days produce too little evidence.
  - Degraded rotation changes only the URL; the same `back` object stays reachable.
  - The safety of degraded mode rests on a production gateway setting the design could not check.
  - Ladder and cooldown state is split between the registry and the warden.
  - Unit 1 changes caching and `robots.txt` behaviour before the gate.
- **How it was posted:** GitHub refused a request-changes review because the bot owns this PR ("Can not request changes on your own pull request"). I posted the full aggregate as a COMMENTED review instead (by kriscendobot, 2026-10-09T03:45:52Z). It opens with a "Panel review — round 1: **must-fix**" header and carries the marker `<!-- garden-panel-verdict: must-fix round=1 -->`.
- **Follow-ups:** None for this stage. The gauntlet driver should move on to the fix loop. The inbox check was still running in the background when I finished, so I did not see any messages.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (672957 cached reads)
- Output: 3857 tokens
- Cost: $0.5776114000000001
- Wall-clock: 643s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
