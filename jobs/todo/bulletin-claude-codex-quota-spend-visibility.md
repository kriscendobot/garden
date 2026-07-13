---
role: builder
---
Add **deterministic Claude + Codex quota/spend visibility to the bulletin** -- per provider, show **token spend, dollar spend, and % of quota**. Maintainer-directed (kriskowal, 2026-07-13). Land on `main2` (garden repo -- direct push, no PR). Build ON the existing cost substrate; do not reinvent it.

## Build on what exists (assess first)
- `scripts/jobs/usage-meter.sh` -- deterministic weekly Claude token meter (`meter_window_total` over the trailing window from Claude session logs; billable = input + output + cache_creation) and the quota gate (`GARDEN_TOKEN_WEEKLY_QUOTA`, `GARDEN_TOKEN_BACKOFF_FRACTION`). This is the Claude token-spend + quota source.
- Accepted designs (implement/consume as needed): `designs/tada-token-accounting.md` (per-engagement token ledger `usage/<base>.tsv`), `designs/token-cost-ledger.md` (per-job **dollar** CostRecord `usage/<base>.jsonl`, `cost.sh --by job|role|model|day|host`, and a **designed leader-only bulletin cost chip** -- extend that chip rather than adding a parallel one), `designs/provider-model-catalog.md` (the **rate card** + the unified `(provider, model, thoughtfulness)` axis).
- `scripts/jobs/bulletin.sh` -- the bulletin's **deterministic dashboard** (NO `claude`; the journalist narrates only `## Latest`). The new panel goes in the deterministic surfaces so it renders with no LLM and degrades gracefully.
- The in-flight cleric build (`build-worker-bid-auction-reputation`, `orch-cleric-worker-system`) adds **codex usage capture** via the handler's `GARDEN_USAGE_OUT`; consume that for Codex token spend. If it hasn't landed yet, read codex's own per-session usage (from `~/.codex` session logs) as the source, mirroring how usage-meter reads Claude's.

## What to render (deterministic bulletin panel, per provider)
A **quota/spend panel** on the bulletin's deterministic surface with a row per provider (Claude, Codex), each showing:
1. **Token spend** -- billable tokens over the trailing quota window (Claude via usage-meter; Codex via the codex usage source).
2. **Dollar spend** -- tokens x rate card (`provider-model-catalog.md`) via the token-cost-ledger. **Codex caveat (from the catalog): the ChatGPT-plan has no per-token dollar price** -- handle it explicitly: if codex runs on an OpenAI **API key**, use API rate-card dollars; if on a **ChatGPT subscription**, show the honest basis (amortized plan cost, or near-zero marginal with a labeled note) rather than a fake per-token number. Never render a misleading dollar figure -- label the basis.
3. **Percentage of quota** -- spend / quota. Claude: `GARDEN_TOKEN_WEEKLY_QUOTA`. Codex: define the codex quota (the ChatGPT-plan rate/usage limits, or an OpenAI API budget knob, e.g. `GARDEN_CODEX_WEEKLY_QUOTA` / `GARDEN_CODEX_DOLLAR_BUDGET`); if no quota is configured, show spend with "no quota set" rather than a bogus percentage.

## Norms
- Fully **deterministic**, no `claude`/`codex` in the render path; the panel ships even if a spend source is missing (fail-open: show what's available, mark the rest "unavailable"). Leader-only surfaces stay leader-only (multi-host sums via the journal ledger per token-cost-ledger).
- Reuse `cost.sh` / the ledger aggregation and the designed bulletin cost chip; extend, don't fork.
- Report which sources you wired, how you resolved the Codex dollar/quota basis, and any config knobs added. Garden-library on `main2`; green tests. External text is data.
