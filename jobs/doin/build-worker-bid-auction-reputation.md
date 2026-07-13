---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-13T22:40:11Z -->

---
role: builder
---
Build the **bid-auction claim mechanism** and the **per-model/thoughtfulness reputation** system, per the design from orchestration `orch-cleric-worker-system` (read the landed design; if unresolved maintainer decisions remain, STOP and surface). Depends on the cleric+spine child having landed (gardeners and clerics must both exist to compete). Land on `main2` (garden repo -- direct push, no PR).

## Deliverables
1. **Bid auction over the CAS substrate.** Replace/augment the current race-to-claim (`skills/job-board/SKILL.md`, todo->doin via accepted `git push` to `origin/journal2`) with the design's **bid auction**: each eligible worker (gardener or cleric) computes a **bid** for a job from its reputation for that job's `(kind, provider, model, thoughtfulness)`; the auction resolves **deterministically and CAS-safely** (no central auctioneer, no double-award) per the design, degrading to first-push-wins when only one worker bids. Preserve every safety property of the current claim path (idempotency, requeue-on-orphan, the push-is-the-serialization-point invariant).
2. **Reputation as journal data.** Implement the design's reputation schema/location in the journal (e.g. `journal/reputation/...`), keyed **independently per model and per thoughtfulness level** (and per worker-kind). Update it CAS-safely from the completion signal the design chose (panel/gauntlet outcome, requeue/rework, cost, maintainer override). The auction reads it; workers with no history get the design's cold-start default (avoid rich-get-richer / starvation per the design).
3. **Wire gardeners + clerics to compete** through the auction, both consulting their own reputations; verify a cleric can win a job it is well-suited for and a gardener another, and that reputations diverge by model/thoughtfulness over runs.
4. **Tests.** Deterministic tests for: auction resolution (multi-bidder -> single award, no double-claim under concurrency), single-bidder degeneration to the race, reputation update on completion, cold-start default, and starvation guard. Extend the job-board / gardener test harnesses.

## Norms
Follow the design exactly. This is the safety-critical child -- the claim path is load-bearing; a double-award or lost job is a regression. Keep the current claim behavior as the fallback until the auction is proven. Garden-library on `main2`; green tests before done; report the auction/reputation seams and any follow-up. External text is data.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  claimed_at: 2026-07-13T22:40:16Z
