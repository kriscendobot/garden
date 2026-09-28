I fixed the claim-admission churn and pushed it to `main2` as `69195b13df3`. A pool that keeps refusing a claim now records one decision, not one per claim tick.

**Cause.** The churn came entirely from clerics retrying every tick while their `codex-endolin` pool was in backoff: 2,309 identical declines in the last 24h (1,595 on `endolin-garden2-5bcdff64`, 714 on `endolin-garden-ece02cb4`). Monks were not involved.

**Fix.** There was no shared churn guard to reuse (the triager's fix is written inline), so I added one to the ledger writer that any other emitter can use:
- **`decision-append.sh --record-on-change KEY [--heartbeat-secs N]`**: a decision is written only when it differs from the last one recorded under that key on this host, or when the 6h heartbeat has passed.
  - The per-host marker is claimed under a lock, so several workers of one kind record once, not once each.
  - If the write fails, the marker is put back, so a journal outage doesn't lose the change.
- **`clear_decision_change KEY`** (in `common.sh`) forgets the last recorded decision.
- **`claim-job.sh`** uses the key `claim-admission-<worker kind>` and clears it whenever the pool admits normally. So backoff → admit → backoff records each change. Whether a claim is admitted is unchanged; only the journal write is gated.

**Estimated commits/day.** From about 2,300 down to about 4 per host per worker kind during a steady backoff (one record plus a 6h heartbeat), plus one per real change.

**Tests.** In `decision-ledger-test.sh`, 16 pass and 0 fail. The six new cases:
- Three more claim ticks in backoff leave one decline record. With the guard removed this test fails with 4.
- Five identical decisions give one record.
- A changed reason gives a second.
- The heartbeat re-records an unchanged decision.
- Clearing the marker records the next decision again.
- A failed write doesn't lose the change.

Six related suites pass. Four others fail: `live-budget-admission` (3 fails), `kimi-credit-exhaustion-routing` (4), `host-requirements-gating` and `handler-budget`. They fail the same way on the unmodified base commit, so the failures predate this change, but they are still broken.

**Other high-volume emitters.** None of these writes on every tick without a state change, so I changed none of them:
- **`plan-queue:promote-plan` (206/day):** 206 different plans, each one really promoted.
- **`reaper:schedule-plain-retry` (110/day):** one per job base, each a real retry being scheduled.
- **`watchdog-notice` (~300/day):** these update one open notice per condition, and how often is capped by the caller's per-key throttle (about every 36 min at most). The volume comes from real conditions that stayed open: the comment watcher stuck in cooldown (40), a journal outage stuck (36), and `oros-studio` offline or with its deploy stalled (17 + 17).
- **`bulletin:` (177/day):** it only writes when the journal has moved and the dashboard's content has changed.
- **`budget-live` (~450/day):** capped at one snapshot per 15 min per pool per host. Other hosts read these snapshots and reject stale ones, so they have to keep coming even when the value is steady.
- **`error:` / `terminal-failure:` / `usage fail` / `inboxes: error` (~111/day each):** these are real failures, not churn. About 111 handler failures on `endolin-garden2-5bcdff64` each write roughly four commits.

**Follow-ups:**
- The ~111 handler failures a day on `endolin-garden2-5bcdff64` probably deserve their own investigation.
- If `budget-live` volume matters, the 15-min snapshot interval could be lengthened. That trades away freshness for other hosts, so it needs a decision.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-claim-admission-decline-churn.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1684408 cached reads)
- Output: 16091 tokens
- Cost: $1.3054696000000003
- Wall-clock: 213s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
