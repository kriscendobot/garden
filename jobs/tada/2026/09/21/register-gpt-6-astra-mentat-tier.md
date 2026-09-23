Inbox empty. Work is complete and pushed.

## Completion report

Registered **GPT-6 Astra** (`gpt-6-astra`) as an OpenAI **mentat**-tier model, claimable by codex/cleric workers — the first non-Anthropic mentat row. Committed to `main2` as `5fdb7e9158`.

**What changed:**
- `scripts/jobs/model-tier-inventory.tsv`: added `openai␉gpt-6-astra␉mentat` (3-column, tab-separated matching the adjacent `anthropic␉claude-fable-5␉mentat` row). No 4th `pull_bytes` field — per the file's own header that column is only for locally-provisioned Ollama models; GPT-6 Astra is a hosted API model, so it stays blank like every other non-local row.
- `scripts/jobs/model-routing-defaults.tsv`: added `gpt-6-astra` to the `openai` pattern set, so a `gpt-6-astra` pin binds to openai (per SKILL's "Adding a model" requirement) rather than resolving unpinned.
- `skills/model-selection/SKILL.md`: rewrote the mentat row to name both providers and explain multi-provider claimability, mirroring the mentor row's prose.
- `designs/provider-model-catalog.md`: updated the dispatch-vocabulary summary and added a GPT-6 Astra subsection under §2 Codex (1.05M context, 128K output, cutoff 2026-04-30, $10/$50 per M in/out; provenance = OpenAI dev docs, flagged **[unverified]** against the account-scoped `codex debug models` catalog).

**The manual-only invariant gap — found and fixed:** the *manual-dispatch* refusal (`claim-job.sh` line 122; `monk-claude.sh`) was already provider-agnostic (keyed on the tier string). But `claim-job.sh` carried a **separate** hardcoded gate — `[ "$tier" != mentat ] || [ "$KIND_PROVIDER" = anthropic ]` — that made mentat anthropic-only even for a manual dispatch, which would have blocked a cleric from ever claiming the new row. I dropped it. Provider fit for mentat is now decided provider-agnostically by the existing backend-fit filter (`tier_model_for_provider`), which admits only a provider that has a model at the tier — so providers without a mentat row (moonshot/fireworks/local) still fail closed with no hardcoded allowlist. I also added the handler-side manual-mentat gate to `cleric-codex.sh`, mirroring `monk-claude.sh`, so the codex providers carry the same defense-in-depth and claim/serve stay in agreement.

**End-to-end verification** (drove `job_eligible_for_kind` directly, not just a config read): a manual `tier: mentat` `role: fixer` job is claimable by a **cleric (openai)** ✅ and a **monk (anthropic)** ✅; refused for mystic/fireworker/hermit (no mentat model) ✅; refused for **all** providers when `dispatch: automatic` ✅; the cleric handler resolves mentat → `gpt-6-astra` (what `codex -m` receives) while the anthropic path still resolves → `claude-fable-5` ✅. `post-manual-job.sh` stamps `tier: mentat` + `dispatch: manual` with no provider pin, so the manual path routes to whichever mentat-capable worker is live. Both guard suites pass (tier-vocabulary-routing 44 checks, gardener-claude-tier-serving 13 checks).

**Pricing / rate card:** no change needed. `rate-card-defaults.md` keys openai by `model: *` (a provisional fleet-default row), not per-model, so `gpt-6-astra` already resolves through the wildcard. The published API pricing isn't directly usable as a dollars-per-second rate on the ChatGPT-plan-metered cleric path, so I did not invent a per-model row.

**Follow-up (non-blocking):** confirm the ChatGPT-plan `codex` catalog exposes `gpt-6-astra` as a selectable `-m` slug on a cleric host (`codex debug models`) before relying on it in practice — flagged unverified in the catalog doc.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/register-gpt-6-astra-mentat-tier.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4292706 cached reads)
- Output: 30065 tokens
- Cost: $4.301453999999999
- Wall-clock: 459s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
