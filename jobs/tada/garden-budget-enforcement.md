Inbox empty; the design is landed on `origin/main2` at `87ccd70ab6`. The job is complete.

## Completion report — `garden-budget-enforcement`

**Landed on `main2` (`87ccd70ab6`):** `designs/live-budget-admission.md` plus a `designs/README.md` index row for it (and, discovered missing during the work, rows for the two prior lineage designs `budgeted-campaign-dispatch.md` and `recurring-budget-calibration.md`). Direct-to-main2 landing, matching the five prior budget jobs — judged garden-meta, not project work.

### What the design says
It is the capstone of the budget-study lineage: generalize phase-1's opt-in per-campaign `--budget-tokens` gate to a standing **per-account admission gate on every dispatch**, and make the 2026-08-15 manual garden1/garden2 worker leveling automatic.

- **Coverage reframe (the crux the prompt asked about).** `cost-by-pr.sh`'s **28.8%** is a *retrospective PR-attribution* number over the per-job `usage/<base>.jsonl` ledger — it is **not** the denominator for live enforcement, and closing it is *not* a precondition. `usage-meter.sh` already reads Claude Code's session logs (`~/.claude/projects/**/*.jsonl`), capturing ~100% of a host's Claude spend including the off-spine standing services the ledger can't see. So near-100% live coverage is already available.
- **Multiple pools:** pool = `(provider[, account])`; Anthropic = two independent per-account weekly token quotas (the two hosts), metered APIs = real-dollar pools, local = unmetered. Verified per-host = per-account is *correct* for our one-subscription-per-host topology (the meter's multi-host-undercount TODO is the opposite case).
- **The mechanism mostly already exists.** The meter's `off/unknown/ok/backoff` verdict is already consulted by the foreman (`foreman.sh:213`) and the gardener handler (`mentor-claude.sh:245`); it's just **OFF** (quota unset) and not at every surface. The design generalizes it to one shared `pool_admits <pool>` predicate called at the three admission surfaces that lack it — plan→todo promotion, direct `post-job.sh`, and the **universal claim gate** (`post-job.sh` is bypassed by `gauntlet.sh`/`auction.sh`, so claim is the load-bearing point).
- **Boundary:** park-not-refuse via the *existing* `--budget-hold` + `budget-refresh.sh` auto-return; never revoke `doin/` work; warn always. Distinguishes the per-account weekly quota from the reaper's already-built *reactive* per-job role budget (`applied_token_budget`/`reaper.sh:831-840`).
- **Automatic leveling:** a leader-only, no-LLM `budget-level.sh` driving `set-workers`/the sysop op from each pool's live remaining headroom — bidirectional (throttle the over-spender AND spin up an idle host with headroom).
- **Omega composition (asked explicitly):** the budget predicate sits **alongside and ahead of** the omega-ranked promoter (omega orders *what*; budget admits *whether*), replacing nothing; independently stageable.
- **pr992 grounding:** shows how a budget-aware gauntlet halts on spend, not an arbitrary `max_iterations=6`.

### Grounding question posted
Per the endorsed pattern, posted one maintainer-inbox note surfacing the single maintainer-only blocker to going live: the **per-account weekly token cap** (not machine-readable — supply from Claude Code `/usage`, or greenlight building phase-2's `weekly-capacity-calibration.sh` to measure it). Until then all gates stay `off`/transparent.

### Method note
Grounded against the cited evidence (`garden-budget-{triple,ratecard,omega}.md`, `budgeted-campaign-dispatch.md`, `recurring-budget-calibration.md`, `omega-task-rank-and-foreman-retirement.md`) and a direct read of the live scripts (`usage-meter.sh`, `claim-job.sh`, `foreman.sh`, `set-workers.sh`, `post-plan.sh`, `budget-refresh.sh`) plus a subagent map of exact function/line references. Confirmed phase-1 pieces (`campaign-spend.sh`, `usage-meter.sh`) exist on disk while phase-2's bucket does not — the design states that dependency explicitly.

### Follow-ups (none blocking)
- No build queued — design-only per the deliverable.
- Turning the meter live needs the maintainer's cap number (message posted).
- Open policy questions (account asymmetry via `hasExtraUsageEnabled`, 0.85-vs-1.0 gate fraction for directed work, leveling shape) are in the doc's §10.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-budget-enforcement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4672982 cached reads)
- Output: 49691 tokens
- Cost: $6.319030999999999
- Wall-clock: 761s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
