Chapter 8 was already finished by the earlier attempt. That attempt wrote and pushed it to `journal2` at 03:52Z (commit `f3b69c27bda`, `projects/garden-book/ch8-cybernetics-budgeting.md`, about 4,900 words), then got reaped before it could send its completion signal. I checked the pushed file on `journal2` and did not redo it.

**What the chapter covers:** it has a section for each of the seven topics the job asked for, plus a closing operator quick-reference table:
- **8.1 Why "cybernetics":** budget treated as a set of feedback loops rather than one cap.
- **8.2 Subscription accounting:** pools, host-to-pool mapping, the meter, and why a pool that is not both metered and calibrated refuses claims.
- **8.3 Worker-count leveling and derotation:** the leveler, `worker-derotate.sh`, and the sysop's host operations.
- **8.4 The foreman as pacing actuator:** why the active target is 10, and how the brake, drain and target differ.
- **8.5 Per-job budgets:** `handler-timeout:` and its cap tied to claim TTL, `token-budget:`, and how the model tier affects cost.
- **8.6 Per-orchestration budgets:** `--budget-tokens`, stopping cleanly when it runs out, and resuming the parked remainder.
- **8.7 The accountant role:** described as work in progress.

**Checks I made today:**
- **The accountant section is still accurate.** `design-accountant-role-budget-apportionment` is still in `jobs/todo/`, no accountant design is in `designs/`, and there is no `roles/accountant/`. The chapter says exactly that and does not invent any conclusions for it.
- **The commands it cites exist.** All ten scripts named in the quick-reference table and body (`worker-derotate.sh`, `set-token-backoff-fraction.sh`, `append-quota-checkpoint.sh`, `budget-refresh.sh`, `progress.sh`, `drain-fleet.sh`, `brake-foreman.sh`, `set-budget-pool.sh`, `send-host-op.sh`, `usage-meter.sh`) are in `scripts/jobs/` on `main2`.

**Follow-up:** once the accountant design lands, section 8.7 should be rewritten to describe what was actually decided.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-ch8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 56 tokens (1951669 cached reads)
- Output: 22150 tokens
- Cost: $1.9923578000000004
- Wall-clock: 227s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
