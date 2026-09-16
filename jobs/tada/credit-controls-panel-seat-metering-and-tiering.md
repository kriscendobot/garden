Done. Both coupled changes are implemented, tested, and landed on `main2` (commit `f0ead5146c`).

## Completion report

**Child 4 of `credit-controls-20260916` — panel-seat metering + tiering. Landed on `main2` (`f0ead5146c`).**

I first re-read the metering architecture (children 1–3 didn't move the panel surface). Key finding that shaped the fix: the *weekly quota gate* (`_meter_session_total` over all of `~/.claude/projects`) was already complete — it's the **per-job cost ledger** (`usage/<base>.jsonl`) that undercounted, and that ledger feeds per-PR cost attribution, campaign spend, reputation `agentic_dollars`, and the leader's **cross-host remote-pool fallback** (`meter_journal_host_tokens`). So the investigation's "budget controls regulating a fraction" is precise for those consumers, slightly overstated for the local weekly gate. I noted this in the design doc.

### (a) Metering — closed the nested-`claude -p` hole
- **Root cause:** each panel seat/decider/appellate is a *nested* subprocess `claude -p`; the top-level provider envelope (`monk-claude.sh`) accounts only for the top-level session, so the ledger saw ~1 of ~32 sessions (~15–21% of the host meter).
- **Fix:** `augment_usage_with_session_delta` (`usage-meter.sh`) — `monk-claude.sh` snapshots the job's session-log usage before/after the top-level call (before the completion teardown retires the transcript) and records the **complete delta** when it exceeds the envelope, preserving model/rusage and honestly dropping `total_cost_usd` (multi-model, `source:"session-augmented"`). A plain job (delta ≈ envelope) keeps its exact priced envelope.
- **Why in the handler, not the panel:** the agent runs with `GARDEN_USAGE_FILE` unset by design, so a panel-side accumulator can't reach the ledger; the handler is the parent and owns the record.
- `panel.sh` now runs every seat/decider/appellate from `cd "$wt"` so transcripts land in a job session dir (also fixes ambient-repo resolution).
- **Ledger improvement:** for gauntlet/panel jobs the ledger goes from ~1 of ~32 sessions to all of them — closing essentially the whole gap; fleet-wide recorded per-job spend should rise from ~15–21% toward parity with the host meter, and the cross-host fallback + reputation cost signals become accurate for the first time.

### (b) Tiering — off uniform Opus
`seat-model-tiers.tsv` + `seat_model_flag` (downshift-only; Anthropic-only reachable models). **Opus kept (10 seats):** adversarial (`saboteur`,`breaker`), security (`warden`,`locksmith`,`wire-watcher`), expert-distilled lenses (`integrator`,`purist`,`engine-realist`,`spec-keeper`), deepest design (`decomplector`). **Haiku (6 + appellate):** pre-pass-gated/mechanical (`orthographer`,`coverage-auditor`,`archivist`,`pruner`,`copyeditor`,`pedant`). **Sonnet (21 + decider):** the rest. Per-seat rationale in the design doc; `critic`/`typist` flagged as first to re-promote if quality slips. ≈55–60% off a code panel's per-round LLM cost.

**Files:** `designs/panel-seat-metering-and-tiering.md`, `seat-model-tiers.tsv`, `usage-meter.sh`, `monk-claude.sh`, `panel.sh`, both seat-gates, `skills/{model-selection,panel}/SKILL.md`, + 2 new tests.
**Verification:** new tests pass; existing `token-cost-ledger` (5), `gardener-worktree` (44), and the panel suite (`decider-retry`, `seat-timeout`, `per-section-provenance`, `banner-trigger`, `related-design-sensing`) all pass; shellcheck `-S error` clean.

**Follow-ups:** (1) seat sessions leak in `~/.claude/projects` after completion (pre-existing; monk-claude only retires the top-level transcript) — a minor GC gap worth a later sweep. (2) Once panels run under this, re-measure ledger-vs-host-meter coverage to confirm the modeled improvement. (3) Watch review quality on the Sonnet set (`critic`/`typist` first).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/credit-controls-panel-seat-metering-and-tiering.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (10559711 cached reads)
- Output: 77684 tokens
- Cost: $9.2322845
- Wall-clock: 1193s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
