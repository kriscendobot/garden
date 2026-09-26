Inbox is empty. The job is complete.

## Completion report

**Task:** Produce a models reference documenting all models available on both Claude and Codex, to ground the bid-auction/reputation design and the model-selection policy.

**What I did:**
- Investigated the **live Codex CLI** (codex-cli 0.144.3, logged in via ChatGPT). Found no `config.toml` and no static preset list; the binary's raw strings were noisy (many internal/unreleased families). The authoritative source turned out to be **`codex debug models`** — the CLI's own JSON catalog. Transcribed the four selectable models rather than inventing any ids.
- Grounded the **Claude** side against the bundled `claude-api` skill's `shared/models.md` catalog + `scripts/jobs/common.sh` tier bindings + this host's session context (not from memory).
- Wrote **`designs/provider-model-catalog.md`** — a table per provider (concrete id, context/output, thoughtfulness levels, cost, intended use) plus the load-bearing **unified `(provider, model, thoughtfulness)` axis** mapping Claude's `low/medium/high/xhigh/max` onto Codex's `low/medium/high/xhigh/max/ultra`.
- **Cross-linked** it from `skills/model-selection/SKILL.md` and (reciprocally) `designs/gardener-bid-accept-market.md` §2.2.

**Key findings captured:**
- **Claude:** Fable 5 `claude-fable-5`, Opus 4.8 `claude-opus-4-8` (+ `[1m]` variant), Opus 4.7, Sonnet 5 `claude-sonnet-5`, Sonnet 4.6, Haiku 4.5. Effort `low/medium/high/xhigh/max`, per-model support noted (Haiku 4.5 rejects effort entirely; Fable 5 thinking always-on). Rate-card $/MTok included.
- **Codex (codex-cli 0.144.3, live):** `gpt-5.6-terra` (default), `gpt-5.6-luna`, `gpt-5.5`, `gpt-5.4-mini` — all 272K context, text+image, default effort `medium`. Effort set via `-c model_reasoning_effort=`; per-model supported levels transcribed; `ultra` (terra-only, "max reasoning + auto delegation") and hidden `codex-auto-review` noted.

**Follow-ups flagged (not acted on — out of scope for a reference doc):**
1. `sonnet` tier in `common.sh` still binds `claude-sonnet-4-6`, not Sonnet 5.
2. Codex's ChatGPT-plan CLI exposes **no per-token dollar price** — the reputation ledger's dollar dimension needs an API-priced Codex source before Codex arms can be cost-compared against Claude arms.
3. No Codex tier map exists yet (role→model policy is Claude-only).

Committed and pushed to `main2` (`87de685685`), first-attempt CAS success. Inbox drained (empty).
