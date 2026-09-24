**Completion report: improve-meter-journal-host-tokens-diagnostics**

The `read-remote-spend` warning now says why the read failed. I pushed the change to `main2` as commit `66bae01b5bc`. The fail-open behavior is unchanged: every failure still returns nonzero and the pool is still skipped.

**What changed**
- **`scripts/jobs/usage-meter.sh`**: `meter_journal_host_tokens` now returns a different code for each failure:
  - **2**: jq is missing or the `usage/` directory is missing.
  - **3**: the ledger is empty (probably the journal hasn't synced yet).
  - **4**: an unmetered row (or a row with bad token fields) falls inside the window.
  - **5**: the ledger is malformed and jq can't parse it. This is a new fourth case.

  I stopped using jq's `error()` and `-e` for the unmetered case. It now returns a sentinel string that the script checks, because jq exits 5 for both `error()` and a parse failure, so those two couldn't be told apart. This also shows the old code was already returning 5, not 1, for unmetered rows. So the `exit_status=1` in the 18:35/18:50 oros warnings meant jq/dir was missing or the ledger was empty — most likely journal-sync lag, which fixes itself, rather than an unmetered-row bug. I also added `meter_journal_failure_reason <code>`, which turns a code into a short reason string.
- **`scripts/jobs/budget-level.sh`**: `pool_failure` adds `reason=<...>` to the WARN line for `read-remote-spend` failures. Other log lines are unchanged.
- **`scripts/jobs/test/live-budget-admission-test.sh`**: the empty-ledger test now expects code 3. New tests cover codes 2, 4 and 5 and the reason strings.

**Verification:** `live-budget-admission-test.sh` passed 42/42 and `meter-journal-cutoff-test.sh` passed 2/2.

**Follow-ups:** none required. After this deploys, the next oros warning will say which cause it is. If it says `empty-ledger`, the fix belongs in journal sync, not the meter.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-meter-journal-host-tokens-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (435579 cached reads)
- Output: 5667 tokens
- Cost: $0.6547118000000002
- Wall-clock: 61s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
