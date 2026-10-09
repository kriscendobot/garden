PR #174 failed panel round 3 with a **must-fix** verdict: 5 of 32 seats requested changes.

**What I did**
- Made an isolated checkout of `kriscendobot/minion.town@build/credit-metering-no-ertp` (head `f7dfa80`) and ran `panel.sh` in single-round mode against base `main-39867df`. It exited 0 with disposition `must-fix`.
- The panel also seated the decomplector. Two things triggered that: a new-mechanism probe fired, and the same mechanism drew must-fix more than once, which forced the decomplector's "is this mechanism needed?" question.
- **Tally:**
  - Request-changes (5): archivist, breaker, engine-realist, pruner, stylist.
  - Comment-only: 20.
  - Approve: 7.
- **Posted the verdict on the PR as two comment reviews:**
  - The full per-seat aggregate (`round-1.md`, about 88KB).
  - A short header in the same "Panel verdict — round 3: **must-fix**" shape as the round-2 review, so the next-stage heuristic recognizes it.
- GitHub refused a request-changes review because the bot authored this PR, so both went in as comments.

**Follow-ups**
- The next stage is the gauntlet's fix-loop. Assessor, which only commented, flagged two should-fix edge cases:
  - A concurrent replay can publish for free if the first publish fails and is refunded.
  - A failed `appendFile` can leave a torn line in the middle of the ledger log.
- The heuristic needs to treat a commented review with the must-fix header as a must-fix verdict, because request-changes can't be posted on the bot's own PRs.
- I couldn't confirm a journal `panel-runs` record for head `f7dfa80`; neither of the two records I checked names it. The aggregate itself was in a temporary run directory, which won't outlast this job, but it is posted on the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (403599 cached reads)
- Output: 2736 tokens
- Cost: $0.5078478000000001
- Wall-clock: 224s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
