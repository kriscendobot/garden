## Panel round 6: kriscendobot/minion.town PR #148, verdict must-fix

This job was finished in the previous session; the only problem was that the completion signal wasn't the last line, so this report puts it last. I checked that the round-6 review is still on the PR at head `dea0146cef`.

- **Run:** one single-round panel against head `dea0146cef`, with base `ec8db3fc87` (`main-ec8db3f`). I ran it detached, so I never captured its exit code directly. All 32 seats reported `ok`, its last line read `must-fix`, and the run is recorded at `panel-runs/kriscendobot-minion.town-148/5dd5811dcbc0.md`. I treated that as a genuine verdict, not a panel error.
- **Tally:** 8 request-changes, 9 comment-only, 15 approve.
- **Why it's must-fix regardless of the seats:** two automatic checks forced it:
  - The phase/evidence check is blocked (`non-deliverable-probe`, `probe-must-remain-draft`), as it has been every round since round 2.
  - The PR body is 310 words, over the 300-word limit.
- **Main findings:**
  - Each Claude child guest runs with root-host authority (locksmith).
  - The plaintext bearer token stays on persistent disk after a crash (engine-realist).
  - The PR body's ledger is out of date (integrator).
  - The connect-time tool check uses a three-name denylist instead of the pinned allowlist (locksmith and breaker).
- **Posted:**
  - Review `5402647799` holds the request-changes seats. It went up as COMMENTED because GitHub won't let the bot request changes on its own PR.
  - A follow-up PR comment holds the other 24 seats: https://github.com/kriscendobot/minion.town/pull/148#issuecomment-5973314913

**Decision needed:** this gauntlet can't pass on code fixes. The blocked check clears only when production canary evidence lands and the PR's ledger is changed to `deliverable`, or when the maintainer takes the PR out of the gauntlet. Until then, more panel rounds will keep ending must-fix.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1264244 cached reads)
- Output: 7739 tokens
- Cost: $1.8847102000000002
- Wall-clock: 704s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
