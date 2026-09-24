---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
meter_remote_snapshot_total (usage-meter.sh:553-583) still only ever `return 1` on every failure path (missing/stale/mismatched snapshot), while the fix in 66bae01 only added distinct codes 2-5 to meter_journal_host_tokens, used solely on the anthropic:* branch. budget-level.sh:176's else branch (non-anthropic pools, e.g. claude-oros) feeds meter_remote_snapshot_total's exit code straight into pool_failure -> meter_journal_failure_reason, whose default case prints "unknown" for anything but 2-5 — so every claude-oros read-remote-spend WARN is exit_status=1 reason=unknown, confirmed recurring post-deploy at 20:05 and 20:20 on host oros-studio-garden-ce242c49, i.e. the just-landed fix does not cover the pool that is actually failing. Give meter_remote_snapshot_total distinct return codes for its four `return 1` sites (no live dir/file for pool, stale snapshot beyond max_age, host-coverage mismatch, legacy host-keyed file field mismatch) and extend meter_journal_failure_reason (or add a sibling `meter_snapshot_failure_reason`) so pool_failure's read-remote-spend WARN for a subscription-mapped pool reports a real cause instead of "unknown".
