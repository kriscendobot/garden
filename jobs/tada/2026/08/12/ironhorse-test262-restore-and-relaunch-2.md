Inbox empty. No garden-development changes were made (all work is journal state via sanctioned producer scripts), so there is nothing to commit to `main2`. The job is complete.

---

## Completion report

**Job:** Restore the 22 swept ironhorse children and relaunch the campaign.

**Precondition — verified live in the DEPLOYED garden root (read the files, not `main2`):**
- `scripts/jobs/orchestrate.sh` does **not** contain `requeue count rose from`; the stall test is `! has_productive_cycle_hint "$jf" && [ "$n" -gt "$limit" ]` (line 184). ✓ (`9a16e2a6ef`)
- `scripts/jobs/complete-job.sh` carries `--orchestration-failed`; `scripts/jobs/common.sh` has `tada_failed` recognizing decorated/Outcome verdict lines. ✓ (`ede7f1f467`)
- Container guard clean (inside container).

**Sweep commit used:** `c95607119cb1b8a9a48f732820ba51f96a53b1a7` (`journal2`, 2026-08-12T03:34:03Z). All 22 child bodies recovered from its parent at `jobs/plan/<child>.md`.

**Integrity (item 3) — all 22 byte-identical modulo frontmatter, verified two ways:**
1. **Lossless source recovery:** for each child, the stripped prefix + extracted body reassembles to the original file byte-for-byte, and the stripped prefix is exactly the producer's plan header (`gate`/`orchestrated_by`/`priority`/`roadmap`/`role`/`posted_by`/`posted_at`). The stripped header named the **old** base (`…-resume`); only that block was removed.
2. **Round-trip:** the body extracted back out of each freshly parked file is `cmp`-identical to my recovered body (`automatic_route_body` and the cycle-marker strip are idempotent on these bodies, which already carry `tier: mentor`/`fallback-tier: minion`/`dispatch: automatic`). **No child had an imperfect recovery** — zero diffs, zero resolutions needed.

I confirmed the header's `role: builder` was inert for execution: `job_tier` reads the first `^tier:` in the whole file (via `plan_field`), which is the body's `tier: mentor` — so dropping `role`/`priority`/`roadmap` when re-parking changes nothing about how children run. Following the spec's exact command was faithful.

**Re-parked:** all 22 (`js-07`…`js-28`) in run order under new base `ironhorse-test262-implementation-completion-resume-2`, gate `orchestrated`, `orchestrated_by` pointing at the new base.

**Campaign recorded:** `post-orchestration.sh --serial --on-child-failure halt --budget-tokens 2080000` → `jobs/orch/ironhorse-test262-implementation-completion-resume-2.md` with `order: serial`, 22 children in order, `on-child-failure: halt`, `budget_tokens: 2080000`, `state: pending`.

**Budget figure — 2,080,000 tokens — triple-verified against the records:**
- Follower-liaison message `role/liaison/20260812T164547Z-ef36a7`: "2,080,000 tokens / ~$68 notional / ~$21 real-dollar-equivalent, combined across the fleet's two Claude accounts."
- Calibration record `jobs/tada/budgeted-campaign-dispatch-design.md`: "2.08M billable tokens, approximately $68.06 notional and $20.73 real-dollar-equivalent at the current 3.28x index" + explicit instruction to launch with `--budget-tokens 2080000`.
- Matches the job spec exactly. Figure checks out; armed as-is.

**Follow-ups:** none required. This host (`endolin-garden2-5bcdff64`, the leader) runs the `garden-orchestrate` watcher, which will now promote `js-07` into `todo/` and sequence the campaign with the stall fixes live. The six `ironhorse-js-0N-…-gauntlet-panel-N` plan entries were left untouched (they belong to other orchestrations). No `main2` changes were produced (journal state only).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-restore-and-relaunch-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (1856641 cached reads)
- Output: 26268 tokens
- Cost: $2.3394655
- Wall-clock: 526s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
