Inbox empty. Work complete.

## Completion report

**Job:** Extend `job_eligible_for_kind()` so a job whose `role:` requires the Claude-agent posture is claimable only by an anthropic (`gardener`/`monk`) kind, closing the hermit-claims-`role: gardener` hot loop.

**Root cause confirmed:** An unpinned, tier-less `role: gardener` job (the `automatic_route_body` default) fell through `job_eligible_for_kind()`'s unclassified-tier early-return as "claimable by any provider." Nothing fenced non-anthropic kinds off a role their codex/local handlers can't honor — the sole role-aware carve-out was mystic's `builder|designer` fence.

**Changes:**
- `scripts/jobs/common.sh` — new `role_requires_anthropic_posture(role)` predicate (rc 0 for `gardener`), placed beside the `role_default_*` policy family with a rationale block explaining why it's a curated deny-list rather than the pure complement of the codex `role_default_model` vocabulary (fixer/shepherd/botanist/prosecutor are ordinary PR-mechanical work a codex handler runs fine on the fleet default; fencing them would strand the automatic fleet during the codex-primary posture).
- `scripts/jobs/claim-job.sh` — `job_eligible_for_kind()` consults the predicate **first**, before tier resolution, returning ineligible when `KIND_PROVIDER != anthropic`. Placement is deliberate so it also catches the unpinned/tier-less case that the old early-return missed. This fences hermit/cleric/fireworker/mystic all at once (the mystic carve-out analogue the spec named).
- `scripts/jobs/test/worker-spine-kinds-test.sh` — 7 new full-spine ELIGIBILITY cases: `role: gardener` left in todo for hermit/cleric/mystic/fireworker, claimed by monk/gardener; `role: fixer` still claimed by cleric (regression guard that mechanical roles stay codex-claimable).

**Verification:** `worker-spine-kinds-test.sh` 181/0, `gardener-claude-tier-serving-test.sh` 13/0. Predicate unit-probed: only `gardener` returns anthropic-only; empty/fixer/designer/builder/shepherd/botanist stay any-kind.

**Committed & pushed** to `main2` (`f645584305..7b57fce400`).

**Follow-ups (none blocking):** The deny-list is anchored on `gardener` only — if a future automatic producer posts another genuinely Claude-agentic role as a claimable board job (the other meta roles — foreman/watchman/liaison/orchestrator/triager — are daemon/singleton postures, not board-claimable, so they need no entry today), add it to the single `case` in `role_requires_anthropic_posture()`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-hermit-claims-gardener-role-jobs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 57 tokens (2247445 cached reads)
- Output: 27047 tokens
- Cost: $2.6354764999999998
- Wall-clock: 498s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
