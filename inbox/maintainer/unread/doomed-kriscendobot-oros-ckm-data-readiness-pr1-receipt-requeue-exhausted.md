from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-17T15:43:20Z
doom_base: kriscendobot-oros-ckm-data-readiness-pr1-receipt
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-17T15:43:20Z
last_seen: 2026-09-17T15:43:20Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/kriscendobot-oros-ckm-data-readiness-pr1-receipt; it stays HELD until a human promotes it
(promote-plan.sh kriscendobot-oros-ckm-data-readiness-pr1-receipt) or removes it, so nothing is lost.
Original job base: kriscendobot-oros-ckm-data-readiness-pr1-receipt

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# receipt (auto) — completion receipt for kriscendobot/oros-ckm-data-readiness PR #1 (merged)

tier: mentor
fallback-tier: minion

This OPEN-and-now-merged PR was completed by the garden. Emit its COMPLETION
RECEIPT deterministically — run the generator, which builds the per-engagement
rows + the maintainer-review heuristic, posts the PR comment (identity-pinned
gh), and archives the receipt in the journal, all idempotently:

    scripts/jobs/pr-receipt.sh kriscendobot/oros-ckm-data-readiness 1

It is fail-open and idempotent (journal archive file + comment marker guards),
so a re-run never double-posts. Report the archive path and the posted comment
URL. See designs/pr-completion-receipts.md and scripts/jobs/pr-receipt.sh.

PR: https://github.com/kriscendobot/oros-ckm-data-readiness/pull/1
