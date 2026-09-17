from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-17T16:23:40Z
doom_base: improve-receipt-watcher-direct-dispatch
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-17T16:23:40Z
last_seen: 2026-09-17T16:23:40Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-receipt-watcher-direct-dispatch; it stays HELD until a human promotes it
(promote-plan.sh improve-receipt-watcher-direct-dispatch) or removes it, so nothing is lost.
Original job base: improve-receipt-watcher-direct-dispatch

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh
`receipt-watcher.sh` currently posts each completion-receipt job (`<slug>-pr<N>-receipt`) as an LLM-dispatched job (`tier: mentor`, `fallback-tier: minion`) whose body just instructs an agent to run `scripts/jobs/pr-receipt.sh <repo> <pr>` — a script explicitly documented as deterministic, plain-code, "NO `claude -p`". Observed failure: `kriscendobot-oros-ckm-data-readiness-pr1-receipt` burned a kimi-k3 attempt then an opus fallback, both exiting rc=1 in a constant ~3s with no output, tripped the gardener's elapsed-constancy overrun-suspect detector, and was doomed `requeue-exhausted` (see `journal/inbox/maintainer/unread/doomed-kriscendobot-oros-ckm-data-readiness-pr1-receipt-requeue-exhausted.md` and `journal/usage/kriscendobot-oros-ckm-data-readiness-pr1-receipt.jsonl`). Since the underlying operation needs no judgment, `receipt-watcher.sh` (already deterministic, no-LLM, same process that already computes `repo`/`num`) should invoke `pr-receipt.sh` directly in-process — mirroring how `ci-watcher.sh`/`comment-watcher.sh`/`dependabot-watcher.sh` call deterministic generators straight, rather than round-tripping through `post-job.sh` into an LLM-tier claim. Keep the job-board post only as a fallback path if the direct call fails (so a genuine `pr-receipt.sh` bug still surfaces to the maintainer inbox instead of retrying silently forever), but the common case should never touch an LLM dispatch at all.
