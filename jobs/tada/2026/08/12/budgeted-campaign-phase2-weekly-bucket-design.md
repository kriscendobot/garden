The design is committed and pushed to `main2` (`eebadff6f3`).

## Completion report

**Job:** designer, Phase 2 of budget-bounded campaign dispatch (recurring capacity calibration + persistent token bucket).

**What I did**
- Read the landed phase 1 document (`designs/budgeted-campaign-dispatch.md`, commit `67e6b0d88246`) in full, plus its grounding (`token-cost-ledger.md`), the `schedule` skill, the scheduler's dispatch/preflight internals, the `config/*` precedents (`fork-owners`, `sysop-issuers`), and the two style skills.

**What changed**
- New sibling document `designs/recurring-budget-calibration.md`. I chose a sibling over an in-place section and cited the reason in the doc: phase 1 is already at the screen-norm limit and already owns a differently-scoped "Phase 2: account-aware" section, so a second "Phase 2" there would collide on the name.
- A cross-link pointer added to phase 1's Phase-2 section.

**Design decisions of note (all four asks covered)**
1. **Deterministic weekly job** hosted in the scheduler's `preflight:` hook on the anchored `weekly-at-Fri-21:00-America/Los_Angeles` cadence: the calibration runs in the leader-only, no-LLM scheduler process and returns exit 2 so nothing reaches the board. I flagged the mandatory per-anchor idempotency (the preflight re-runs inside the scheduler's CAS retry loop) and made the preflight's fail-open path a safety net (a broken calibration surfaces as an investigation job). Real cost is journal config (`config/claude-subscriptions` TSV + a CAS setter), never a hardcoded `$200 x 2`.
2. **Capacity = max over trailing 4 weekly records**, per account, combined as the sum of per-account maxima (independent quotas). The maintainer's rationale (quiet weeks bias an average downward) is recorded, and I named the statistic's remaining imperfections. Derived at read time over an append-only `budget/weekly-capacity/<host>.jsonl` ledger.
3. **Persistent bucket** `budget/bucket.json` (rewrite-in-place: `capacity`, `refilled_at`, `per_account_capacity`; spend derived fresh, never stored). Draw-down is **total fleet spend since refill** (justified by units-consistency with the calibration, and it catches unenumerable descendants). Composes with phase 1 via an explicit `post-orchestration.sh --from-bucket` opt-in (not a silent default, to preserve phase 1's byte-for-byte unbudgeted behavior), with a `config/campaign-default-bucket` toggle as the path to hands-off.
4. **Unspent recovery**: confirmed sufficient with no explicit step. Within a week it stays as bucket balance; across the refill it correctly does not carry (the absolute refill mirrors the real Friday-9pm-Pacific quota reset).

Open questions (preflight-vehicle-versus-dedicated-timer, draw-down measure, window length, cold-start under 4 records, account-identity column) are left in the document, not guessed past. This was design only; no build.

**Follow-ups:** none blocking. The build slice and test list are enumerated in the document for a future builder job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/budgeted-campaign-phase2-weekly-bucket-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (1019166 cached reads)
- Output: 28801 tokens
- Cost: $2.09313
- Wall-clock: 424s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
