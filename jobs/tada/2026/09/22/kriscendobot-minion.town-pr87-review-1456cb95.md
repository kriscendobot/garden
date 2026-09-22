---
handed-off: minion-town-pr87-production-gate-resume-20260922
deliverable-complete: false
---
Both asks in review 5273131188 are accounted for, verified against the code and board. I did not merge (the maintainer's approval body is an explicit "close the gap before we commit" hold), and I warned the live conduct peer against a premature merge. The core reality-gap deliverable is durably owned by a named successor job.

## Completion report

**Job:** Handle maintainer review 5273131188 (kriskowal, APPROVED-with-asks) on kriscendobot/minion.town#87.

**Preflight:** exit 2 (HINT). Corroborated every ask against code + board rather than closing as a no-op.

**Enumerated the review's asks and their disposition:**

1. **Inline — `src/endo/claude/wiring.ts`: "Keep test fixtures under test."** (comment `4067543918`) → **RESOLVED at head `8a0bf2b`.** Verified in an isolated project worktree: `makeInMemoryChildHost` now lives in `test/helpers/claude-child-host.ts` (test tree), production defaults to `makeUnavailableChildProvider()` and `makeUnavailableCredentialStore` (both fail-closed, never persist a token). HEAD commit `8a0bf2b` "refactor(claude): keep the wiring test doubles under test, fail closed in production". Two peer replies already document this on the thread; no further reply needed.

2. **Body — "This code does not yet connect to reality. Let's close that gap before we commit."** → **UNRESOLVED by design; parked on a maintainer decision, durably owned.** Closing the gap requires the real step-1 provider from endojs/endo-but-for-bots#1015 (still OPEN/unmerged) plus a live production evaluation, and the CLI-vs-Agent-SDK backend choice is undecided. A prior attempt already posted the maintainer question (PR #87 issue comment `5770203120`, "Held DRAFT / unmerged") and a durable successor job **`minion-town-pr87-production-gate-resume-20260922`** (`jobs/plan/`, `gate: awaiting-maintainer`) that owns all remaining work and will reconcile the conduct job once the maintainer answers.

**Merge NOTE — deliberately NOT actioned.** The generic "approval → dispatch conductor to merge" step is overridden by the maintainer's explicit "before we commit." Because ask #2 is unresolved, the merge precondition ("after resolving EVERY ask") is not met. An auto-posted `kriscendobot-minion.town-pr87-conduct` job was live in `doin/` (posted by the approval reconciler, which didn't parse the hold); I messaged that peer to stand down and not un-draft/merge until the production-reality gate resolves. PR remains correctly DRAFT/unmerged; checks green.

**Follow-ups:** None new — the reality-gap is owned by the existing parked successor; the sibling "use ava" review is separately owned by `fix-minion-town-migrate-tests-to-ava-20260922`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr87-review-1456cb95.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 54 tokens (1569049 cached reads)
- Output: 37248 tokens
- Cost: $3.0394075 (1 engagement(s) unpriced)
- Wall-clock: 1816s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
