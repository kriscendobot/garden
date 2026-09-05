Investigation complete — report committed to `journal2` and the link delivered to the maintainer. Completion report follows.

## Completion report — mentat-endolin-garden2-credit-investigation-20260905

**Deliverable:** standalone investigation report committed to `journal2` (commit `5d0b7974a2`):
- Stable link: https://github.com/kriscendobot/garden/blob/journal2/reports/credit-investigation-endolin-garden2-20260905.md
- Permalink: https://github.com/kriscendobot/garden/blob/5d0b7974a23243a37aa58add89be04e561c0262b/reports/credit-investigation-endolin-garden2-20260905.md

The link plus an executive summary was sent to the maintainer via `message-user.sh` (delivered as `msg-mentat-endolin-garden2-credit-investigation-20260905-90cb453a333a`).

**What I did:** worked from a fresh shallow clone of `journal2` (snapshot `c5dd8deabc`, history deepened to 2026-08-29) on this undrained host; never touched the drained target. Reproduced all liaison headline figures exactly (623 rows, $1,257.19, outcome/source/model splits, token sums, largest row). Verified ledger semantics in code (`usage-meter.sh`, `gardener.sh`, `monk-claude.sh`, `panel.sh`) and empirically: rows are per-engagement incremental (no cumulative double-count), zero duplicates, resume cost is genuine cache-read context-rebuild.

**Key findings:**
1. The burn is a ~19h window from 2026-09-04T04:00Z when the host moved onto a **temporary API key with its budget pool marked `unmetered`** (config commit 04:15:44Z) — no throttle, real credits: $1,090.65 recorded in-window vs a $0–$208 daily baseline.
2. The unthrottled hours drained a backlog dominated by **69 gauntlets mass-staged 2026-08-30 by the new hourly `design-pr-gauntlet-coverage-audit` timer** (this host was leader then): $482 recorded on this host, including stale/superseded PRs (#665/#666/#935 at iteration 5–6/6) and a re-staging behavior on archived-running gauntlets. Producer (post-build) gauntlets: $380; non-gauntlet work: $373.
3. **~80% of billable tokens are invisible to the ledger** — panel seats (28 bare `claude -p` per code round; ~504 seat engagements on this host in-window) and state-machine decision calls are never captured when the supervisor envelope wins (measured 4.19M ledger vs 19.76M meter tokens on 9-05). True API-key spend plausibly 2–5× the recorded figure; ground truth is only in the Anthropic console.
4. Requeues are mostly not waste: 71/281 were $0 churn; cost concentrates in legitimate resume-treadmill fix runs, with a specific pathology (repeated ~$1 two-turn context reloads on doomed stale-PR jobs) documented.

**Recommendations** (ranked, with evidence/tradeoffs in the report): fail-closed/explicit ceilings for API-key pools; adopt the proposed `manual-gauntlet-trigger` design; a no-LLM pre-gauntlet viability gate; close the panel-seat metering hole; tier seats off Opus; bounded resume-reload backoff. Already addressed: pool re-armed + calibrated (64M/143M), exit-0 outage routing deployed (`1c3cbbc1fa`), `session-budget-pace` and `manual-gauntlet-trigger` designs in flight.

**Follow-ups (not posted as jobs — job spec forbids launching remediation):** listed in the report; host-local evidence gaps (target session logs, fresh meter samples, Anthropic console) explicitly identified.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-endolin-garden2-credit-investigation-20260905.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (6025835 cached reads)
- Output: 53745 tokens
- Cost: $11.749504
- Wall-clock: 851s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
