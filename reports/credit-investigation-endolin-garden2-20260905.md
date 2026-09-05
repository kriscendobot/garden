# Credit-expenditure investigation — endolin-garden2-5bcdff64, 2026-09-04/05

| Investigator | mentat job `mentat-endolin-garden2-credit-investigation-20260905` (claimed on endolin-garden-ece02cb4) |
| Evidence snapshot | journal2 commit `c5dd8deabc19ffd913bb3a2b56ec5612c12d26da` (2026-09-05T15:29:17Z), history deepened to 2026-08-29 |
| Window | 2026-09-04T00:00Z → 2026-09-05T15:05:51Z (last usage row before the drain), baseline 2026-08-28 → 2026-09-03 |
| Status of target | drained for maintenance at 2026-09-05T15:23:50Z; all findings from shared journal evidence only |

## Executive summary

The "egregious" day is real and has one dominant, compound explanation. On
2026-09-04 at ~04:00Z the host was switched from its (quota-exhausted)
Claude Max subscription onto a **temporary Anthropic API key**, and its budget
pool was deliberately marked `unmetered` (config commit
2026-09-04T04:15:44Z: "no weekly ceiling applies"). That disarmed the only
throttle the claim path has — `pool_admits` fails open on an unmetered pool —
so five Anthropic workers ran flat-out for ~19 hours against a large backlog of
staged gauntlet work. The per-job ledger records **$1,090.65 in that API-key
window** ($1,257.19 for the full requested window), and unlike every other day
in the ledger those dollars approximate **real credits**, not notional
subscription-equivalents. The host's previous 7-day daily range was $0–$208.

Three multipliers made the unthrottled hours expensive:

1. **A backlog of 69 auto-staged gauntlets.** On 2026-08-30 06:39–07:40Z the
   then-new hourly `design-pr-gauntlet-coverage-audit` timer, running on this
   host (which held the `leader` marker at the time), staged gauntlets for 69
   previously-ungauntleted bot-authored design PRs — most of them months-old
   endo-but-for-bots backlog (#138, #231…#300…#665, #666, #718, #735, #935…),
   several known-superseded. Stages from those gauntlets account for **$482**
   of the window's recorded spend on this host alone (234 engagements, 25 PRs),
   with fix rounds churning to `max_iterations: 6` on PRs that cannot merge.
2. **Everything rode Opus.** $1,153.42 of $1,257.19 is tagged
   `claude-opus-4-8` (567 of 623 rows; the `minion`-tier fleet default). The
   only non-Opus spend was the maintainer-requested mentat security review
   ($25.90 on claude-fable-5).
3. **Most of the burn is invisible to the ledger.** Panel juror seats (~28
   bare `claude -p` subprocesses per code-panel round; 29 panel runs ≈ 504
   seat engagements recorded by this host in the window) and the gauntlet
   state machine's decision calls are **never captured in the per-job dollar
   ledger** when the supervising engagement's envelope wins. Calibrating
   against the host's own meter on 2026-09-05 (03:00→12:45Z): ledger 4.19M
   billable tokens vs meter 19.76M — **~21% coverage**. Actual API-key credit
   consumption on 2026-09-04 was therefore plausibly a small multiple of the
   recorded $1,091; the exact figure exists only in the Anthropic console for
   that key.

The accounting itself is sound where it has coverage: rows are per-engagement
**incremental** (verified empirically — no cumulative double-count), there are
zero duplicate rows, and requeue rows are genuinely distinct engagements.

## 1. Verification of the liaison's preliminary numbers

All headline figures reproduce **exactly** against the fresh snapshot
(`usage/*.jsonl`, filter `host=="endolin-garden2-5bcdff64" and ts>="2026-09-04"`):

| Metric | Liaison | This investigation |
|---|---|---|
| Engagement rows | 623 | 623 (max ts 2026-09-05T15:05:51Z) |
| tada / requeue / fail | 306 / 281 / 36 | 306 / 281 / 36 |
| source result / none | 576 / 47 | 576 / 47 |
| Σ total_cost_usd | $1,257.19327815 | $1,257.19327815 |
| tada / requeue / fail cost | 635.66 / 584.00 / 37.54 | 635.66 / 584.00 / 37.54 |
| claude-opus-4-8 cost | $1,153.4235795 | $1,153.4235795 |
| in+out+cache-creation tokens | 63,281,721 | 63,281,721 |
| cache-read tokens | 1,231,100,469 | 1,231,100,469 |
| OpenAI unmetered rows | 7 | 7 (all $0, no token fields) |
| Largest row | pr892-gauntlet-fix-1, 552 turns, 82.4M cache-read, $44.157 | confirmed (tada, 2026-09-04T08:12:58Z, elapsed 2584s) |
| pr665-gauntlet-fix-1 rows | 10 | 10 (9 requeue + 1 fail) |

## 2. Ledger semantics — what a row means (verified in code and data)

- **One row per engagement** (one claim cycle = one handler run).
  `usage_ledger_stage_row` (scripts/jobs/usage-meter.sh) appends on every
  outcome; `usage_capture_result` stores the `claude -p --output-format json`
  result envelope of **that invocation only**. A requeued job's next claim is
  a separate `--resume` invocation with its own envelope.
- **Incremental, not cumulative.** Verified empirically:
  pr665-gauntlet-fix-1's ten costs run 2.38, 1.14, 1.34, 1.13, 0.84, 0.87,
  7.48, 1.33, 1.36, 0 — non-monotone, so envelopes are per-invocation. Summing
  rows is valid; there is no resume double-count. (Caveat: `num_turns` may be
  session-cumulative on resume — the 552-turn row is consistent with a resumed
  session — but tokens/cost are per-invocation.)
- **Deduplication:** zero duplicate (ts,base) pairs in the 623 rows.
- **Resume effects are real cost, correctly attributed:** each `--resume`
  re-reads the whole session transcript as cache-read tokens. The $44.16
  pr892 row is 82.4M cache-read vs only 190K cache-creation + 72K output —
  i.e. ~150K tokens of context re-read per turn across 552 turns. Long
  sessions make every additional turn more expensive.
- **Missing coverage (the big one):** the envelope captures only the
  *supervising* session. Panel seats (`panel.sh` line ~362: bare
  `claude -p` per juror seat, 28 seats/code round) and `garden-pr.sh`
  decision calls are subprocesses whose usage lands in **no per-job row**.
  The fallback session-log delta (`meter_job_session_usage`) would catch them,
  but it only runs when the envelope is absent — 576/623 rows are
  `source: result`, so it almost never ran. The 193 `gauntlet-panel` rows
  average **$0.88** — impossibly low for 28-seat Opus panels; that is the
  supervisor's cost only.
  - **Calibration:** for 2026-09-05T03:00→12:45Z the ledger shows 4,189,427
    billable tokens for this host while the maintainer-verified meter
    checkpoint (`budget/manual-checkpoints/endolin-garden2-5bcdff64.jsonl`,
    12:47Z row, pairing_confidence high) shows 19,759,739 → **ledger covers
    ~21%**. By 15:15Z: 4.80M vs 32.29M → ~15%.
- **Other unmetered rows:** 47 `source: none` rows (35 tada, 12 requeue,
  ~24,441s of wall clock — cleric/codex evals, review jobs, some panel/design
  rows) carry no usage at all; the 7 OpenAI rows carry no cost.

## 3. Timeline and causes

**Baseline.** Target host daily recorded cost 2026-08-28→09-03:
$0, $0, $116, $0, $113, $208, $60 (the zeros are outage/quota-starved days;
the fleet-wide max day in that period was $485). 2026-09-04: **$1,092** —
5.3× the host's best prior day; fleet-wide 09-04 was $1,378, the largest day
in the deepened history.

**Quota context.** Both Max accounts had been at/near their weekly caps since
~2026-09-01 (journal reset-events; confirmed reset boundary Friday 8pm Pacific
= 2026-09-05T03:00Z). On 2026-09-03T06:56Z the maintainer recorded garden2
"over quota waiting for reset".

**The ignition (2026-09-04 ~04:00Z).** Rather than wait ~23h for the reset,
the host was put on a **temporary API key**. `config/budget-pools` commit
2026-09-04T04:15:44Z ("library-edit: liaison wrote config/budget-pools on
endolin-garden2-5bcdff64") set `ceiling_kind: unmetered`, documenting: *"no
weekly ceiling applies … meter_quota_status returns `unknown` … pool_admits
fails open and claim-job.sh keeps admitting."* Exactly one row precedes 04:00Z
that day ($1.38). Burn then ran **~$150/hour recorded for 7 straight hours**
(04–11h: $994, 404 rows), paused ~11:30–21:00Z, resumed 21–23h ($64), and
died into zero-cost churn at 23h — consistent with the key lapsing; by
2026-09-05T03:43Z the maintainer confirmed "the temporary API key lapsed and
this host is back on a subscription". Recorded cost inside the API-key window
(04:00Z→24:00Z): **$1,090.65** (496 rows, 58.4M billable + 1.08B cache-read
tokens). Post-restoration 09-05 spend ($164.72) is subscription-notional
again, now throttled by the first real calibration for this pool (64M/wk,
set 2026-09-05T11:45Z).

**What the unthrottled hours were spent on** (recorded dollars, this host,
full window):

| Bucket | Cost | Detail |
|---|---|---|
| Gauntlet stages of **audit-staged** gauntlets | $482 | 234 rows, 25 PRs — from the 2026-08-30 mass staging of 69 (below) |
| Gauntlet stages of **producer** gauntlets (post-build auto-gauntlet) | $380 | 196 rows, 25 PRs — the sanctioned build→gauntlet chain |
| Gauntlet stages, other creators (gardener/builder/comment-watcher) | $22 | |
| Non-gauntlet jobs | $373 | builds $77 (top: build-minion-town-clip-shell-framework $61.30), mentat security review $25.90, garden-pty-lane-context-introspection $25.26, 10 design jobs $25, misc PR/review/conduct jobs |

By stage across all gauntlets: fix **$688** (216 rows, 97 fix jobs, 40 PRs),
panel $170 (supervisors only — see § 2), clean/undraft $24.

**The 69-gauntlet mass staging (2026-08-30 06:39–07:40Z).** Every one of the
69 `jobs/gauntlet/*` records created in that hour carries
`created_by: design-pr-gauntlet-coverage-audit`. The audit is a deterministic
hourly leader-gated timer (`garden-design-pr-gauntlet-audit`, built by job
`design-pr-gauntlet-coverage-audit`, main2 `e08fcc809a`) that stages a
gauntlet for every open bot-authored design-only PR with no gauntlet coverage.
Its build report explicitly limited *manual* staging to minion.town ("rather
than mass-staging every watched repo from a single gardener job") — but once
deployed, the timer's first leader ticks did exactly the mass staging, on this
host (the `leader` file named endolin-garden2-5bcdff64 on 08-30; leadership
has since moved). The staged set includes PRs the journal already knew to be
superseded or unmergeable (#300, #536, #718 per memory/tada records; #665,
#666, #935 now sit at iteration 5–6 of 6). The audit also **re-stages**: on
2026-09-05T12:37–38Z it re-created gauntlet records for pr665/666/935/1151/
1156/1157/1158 whose prior records had been archived mid-run (17 of 18
archived gauntlets are archived in `state: running`), so stale-PR gauntlets
re-enter the active set without any human deciding they are worth more spend.

**Fix-loop / treadmill anatomy (why requeues cost money without being
"waste").** Of 281 requeue rows: 71 were $0 (provider-outage or claim churn —
cheap), 72 more under $1. The requeue cost concentrates in 36 engagements
≥$5 — almost all genuine long fix runs (50–150 turns, 700–2,400s) that hit
the handler wall or exited before the completion sentinel and correctly
resumed next claim (the sanctioned resume treadmill; 11 rows ≥2,000s elapsed
cost $81). The pathological variant is visible on pr665-gauntlet-fix-1: ten
claims in 4.2h including six ~2-turn, 20–30s engagements at ~$0.85–1.36 each
— each resume paid 140K–900K cache-read tokens to reload a long session, did
nearly nothing, and exited — then the job failed anyway (the PR is one of the
mass-staged stale set). That is ~$6 of pure context-reload on a job that
should never have been staged.

## 4. Notional vs actual

- **2026-09-04 04:00Z→~23:00Z:** API key ⇒ `total_cost_usd` ≈ real credits at
  API list price. Recorded $1,090.65; true key consumption higher by the
  unrecorded panel-seat/decision-call spend (ledger coverage measured at
  15–21% of billable tokens on the adjacent day with the same workload mix —
  the dollar multiplier is uncertain because seat sessions have a different
  cache profile, but "2–5× recorded" is the honest band). Only the Anthropic
  console for that key can give the exact number.
- **Everything else in the window (and the whole baseline):** Max
  subscription ⇒ dollars are **notional API-equivalents** (prior analysis:
  ~$400/mo flat across two Max accounts; the notional ledger historically
  overstates cash ~8.7×). The real cost there is weekly-quota consumption
  (opportunity cost: starving other work), not cash.

## 5. What already addresses this (deployed or in flight)

- **Pool re-armed + first real calibration.** garden2 restored to
  `weekly-tokens` (2026-09-05T03:45Z) and calibrated to 64M/wk from a paired
  dashboard/meter sample (11:45Z). garden1 calibrated to 143M/wk with
  provenance (2026-09-04T22:10Z). The unthrottled state no longer exists.
- **`fix(gardener): route exit-0 provider outages off the unavailable worker
  route` (1c3cbbc1fa, deployed — the target's checkout is exactly this
  commit).** Reduces the zero-cost outage-churn engagements (71 rows here).
- **`designs/manual-gauntlet-trigger.md` (Proposed, 2026-09-05, branch
  `main2-2256256`).** Directly targets root cause #1: builds/designs stop at
  a draft PR; `run the gauntlet #N` becomes the sole ordinary trigger;
  automatic staging (including the coverage audit's) is replaced by a
  non-mutating readiness audit. Adopting it removes the mass-staging class.
- **`designs/session-budget-pace.md` (designed, unimplemented)** — the
  session-quota pace constraint that would have smoothed the burst profile.
- **Foreman brake** — can quiet the autonomous pump without draining, useful
  during any future key-arming.
- **`reports/panel-seat-tiering/evidence.md`** — the evidence base for moving
  panel seats off Opus already exists; no tiering decision has landed yet.

## 6. Recommendations (ranked)

1. **Never run an unmetered pool with live workers.** When an API key
   replaces a subscription, set an explicit credit ceiling (dollars/day or
   tokens/window) instead of `unmetered`; make `pool_admits` fail **closed**
   for api-key pools with unknown status, or drop worker counts at arming
   time. Evidence: the single `unmetered` day cost more real money than a
   typical month of both subscriptions. Tradeoff: an over-tight ceiling idles
   paid capacity — but the failure mode is bounded, unlike this one.
2. **Adopt the manual-gauntlet-trigger design (or at minimum cap/gate the
   coverage audit).** Require maintainer promotion for gauntlets on PRs older
   than N days, cap stagings per tick, and stop re-staging archived-running
   gauntlets without a human ack. Evidence: $482 recorded (plus hidden seat
   multiples, plus garden1's share) went to auto-staged backlog gauntlets, on
   PRs including known-superseded ones now churning at iteration 6/6.
   Tradeoff: the audit exists to close a real review-coverage hole (the
   minion.town#47 incident); the design's draft-state sensor keeps that
   guarantee without buying review for every stale artifact.
3. **Add a cheap pre-gauntlet viability gate.** Before clean/panel, a no-LLM
   check: PR mergeable, CI attachable, not superseded (the journal already
   holds supersession facts for #300/#536/#718/#814/#1075). Evidence: the
   pr665 pattern — 10 engagements, $17.87 recorded, ended in fail — repeats
   across the stale set. Tradeoff: a conflicting PR is sometimes exactly what
   a fix round should rescue; gate on "conflicting AND stale AND unclaimed by
   any arc", not conflict alone.
4. **Close the ledger's 80% coverage hole.** Meter panel seats and
   state-machine decision calls: run seats through an envelope-capturing
   wrapper (per-seat `usage-append`), or always compute the session-log delta
   and record `max(envelope, delta)`/both fields. Until then every
   cost-attribution and calibration exercise (including this one) understates
   panel-heavy work ~5×. Evidence: 4.19M ledger vs 19.76M meter tokens,
   same host, same window, high-confidence pairing.
5. **Tier panel seats and routine fix rounds off Opus.** 28 Opus seats per
   code round is the single largest hidden multiplier; sonnet-5 (`myrmidon`)
   exists in the inventory and the seat-tiering evidence file is already
   written. Tradeoff: review quality — mitigate by keeping a minority of
   seats (breaker/saboteur/assessor) on Opus.
6. **Bound resume-treadmill reloads.** Two cheap mechanics: (a) exponential
   claim backoff for a base whose last engagement was <5 turns and
   non-productive (six ~$1 no-op reloads on pr665 in 4h); (b) for sessions
   past ~100 turns, have the handler summarize-and-restart instead of
   `--resume` (the pr892 row paid ~150K cache-read tokens per turn; a fresh
   session with a summary would have cost a fraction). Tradeoff: (b) loses
   in-context reasoning state; apply only above a turn threshold.
7. **Do not "fix" requeues wholesale.** 71/281 requeues were free, the
   productive-cycle hint already protects long jobs, and the outage-routing
   fix is deployed. The waste is specific (stale-PR treadmills, reload-heavy
   resumes), not the requeue mechanism itself.

## 7. Limitations — host-local evidence not accessed (target drained)

- `~/.claude` session logs on the target (would give exact per-seat token
  accounting and close the 80% gap for 09-04 specifically).
- Fresh `budget/live` meter samples for 09-04 (the journal copy is the stale
  2026-09-04T04:01:07Z sample, taken minutes into the burn).
- The preliminary local report `.garden-state/reports/credit-investigation-20260905.md`
  (its material findings were quoted in the job spec and all reproduced here).
- Target systemd journals (worker claim logs, provider-cooldown timings).
- The Anthropic console for the temporary API key — the only ground truth for
  actual credits billed on 2026-09-04 (maintainer-side).
- Which principal armed the key itself (the journal records the liaison
  writing the pool config on the maintainer's report; the key material and
  its arming are host-local/operator acts outside the journal).

## Appendix — reproducible queries

Snapshot: `git clone --depth 1 -b journal2 git@github.com:kriscendobot/garden.git snap && cd snap && git fetch --shallow-since=2026-08-29 origin journal2`. All queries run in `snap/`.

```sh
# Headline reproduction
cat usage/*.jsonl | jq -s 'map(select(.host=="endolin-garden2-5bcdff64" and .ts>="2026-09-04"))
  | {rows:length, cost:(map(.total_cost_usd//0)|add),
     by_outcome:(group_by(.outcome)|map({(.[0].outcome):length})|add)}'

# Daily baseline by host
cat usage/*.jsonl | jq -s 'map(select(.ts>="2026-08-28")) | group_by(.host+.ts[0:10])
  | map({h:(.[0].host+" "+.[0].ts[0:10]), cost:(map(.total_cost_usd//0)|add)})'

# The 69-gauntlet mass staging
git log --since=2026-08-30T06:00 --until=2026-08-30T08:00 --diff-filter=A \
  --format='%cI %s' -- 'jobs/gauntlet/*.md'
git show <add-commit>:jobs/gauntlet/endojs-endo-but-for-bots-pr300-gauntlet.md | head -20  # created_by

# Unmetered-pool arming
git log --format='%cI %s' --since=2026-09-03 -- config/budget-pools
git log -p --since=2026-09-04T04:00 --until=2026-09-04T05:00 -- config/budget-pools

# Ledger-vs-meter coverage calibration
jq -s '[.[]|select(.host=="endolin-garden2-5bcdff64" and .ts>="2026-09-05T03:00" and .ts<="2026-09-05T12:45")]
  | map((.input_tokens//0)+(.output_tokens//0)+(.cache_creation_tokens//0))|add' usage/*.jsonl
tail -3 budget/manual-checkpoints/endolin-garden2-5bcdff64.jsonl   # meter_spend_tokens 19,759,739

# Panel-seat fan-out (bare, unmetered claude -p per seat)
grep -n 'claude -p' ../scripts/jobs/gardening/panel.sh   # on a main2 checkout
git log --since=2026-09-04 --until=2026-09-05T15:29 --diff-filter=A --name-only -- 'panel-runs/*'

# Treadmill anatomy
jq -c '.' usage/endojs-endo-but-for-bots-pr665-gauntlet-fix-1.jsonl
jq -c '.' usage/endojs-endo-but-for-bots-pr892-gauntlet-fix-1.jsonl
```
