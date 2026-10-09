**Viability report: kriscendobot/minion.town PR #174**

PR #174 ("feat(credits): meter clip publishing against an interim credit ledger (no ERTP)") is open, unmerged and still a draft. It was opened at 2026-10-09T01:18Z. Its head is `build/credit-metering-no-ertp` @ `41c9199`, and its base is the frozen `main-39867df`. I spent no clean, panel, fix, CI-wait or un-draft budget.

Deciding question: Is clip publishing on `main` still priced by the `0n` stub, with no other PR or commit adding credit metering, while the maintainer's no-ERTP metering decision and garden#58 are still open?

Evidence:
- **Base is current.** `main` is at `39867df` (merge of #169, 01:10Z), the same commit as the PR's base. A compare from `39867df` to `main` shows 0 commits ahead, so no newer base history touches this work.
- **The need is still there.** `src/endo/clip-payment.ts` on `main` still holds the "PRIMARY-PHASE STUB (per kriskowal/garden#58)" with `STUB_PUBLISH_COST = 0n`. That stub is what this PR replaces.
- **Nothing replaced it.** Among the 30 most recent PRs (any state), #174 is the only one whose title mentions credit, meter, ERTP or ledger.
- **The reason for the PR still holds.** The PR cites a maintainer decision from today's liaison muster (2026-10-09): build metering without ERTP until the v2 design. The tracking issue kriscendobot/garden#58 ("Minion Town") is still open, and this PR closes its last unchecked primary-phase box.
- **No reviews or comments yet.** Nothing in the discussion says the work is unwanted.

Both claims hold: nothing has superseded the PR, and the need behind it still holds. The gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (152092 cached reads)
- Output: 1522 tokens
- Cost: $0.35729040000000006
- Wall-clock: 80s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
