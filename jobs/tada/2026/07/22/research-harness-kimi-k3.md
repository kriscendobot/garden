Completion report follows.

---

**Job `research-harness-kimi-k3` — researcher: can the garden harness Kimi K3?**

**What I did.** The upstream scholar ingest `scholar-fireworks-kimik3-fable` had not landed on the board, so I researched from primary sources directly (Moonshot Kimi platform docs, the Fireworks blog post, OpenRouter, MarkTechPost, Trilogy AI, HF weights-status). All external page text handled as untrusted data. I grounded the wiring plan against the live garden infra: `context/operations/local-inference-amd.md`, `skills/model-selection/SKILL.md`, `scripts/jobs/model-routing-defaults.tsv`, `scripts/jobs/handlers/cleric-codex.sh` (its `local` provider arm), and `designs/provider-model-catalog.md`.

**Findings (verdicts).**
- **Model:** Kimi K3 = 2.8T total MoE, 16/896 experts active (~50B-class active, *estimated* — no official figure), 1M context, native multimodal, KDA+AttnRes, released 2026-07-16, open weights due 2026-07-27 under Modified-MIT.
- **Local (hermit) — NOT FEASIBLE.** All 2.8T weights must be GTT-resident. A usable Q4/MXFP4 quant ≈ 1.5 TB (~12× the box's 125 GiB RAM, ~15× the ~100 GiB GTT ceiling); even a ~2-bit floor (~700–840 GB) is ~6–7× total RAM. Off by >10×; no official GGUF exists yet either. Hard no.
- **Hosted — FEASIBLE.** Moonshot serves an OpenAI-compatible `/v1`: `base_url https://api.moonshot.ai/v1`, model id `kimi-k3`, Bearer auth via `MOONSHOT_API_KEY`, 1M context, **$0.30 cached / $3.00 fresh input, $15.00 output per MTok** (~1/3 of Fable 5). OpenRouter is an alt; Fireworks hasn't published a K3 id/price yet.
- **"fable" clarification:** it is **Claude Fable 5** (a benchmark rival + routing partner), *not* a serving technique. The post's technique is predictive/oracle model routing — which the garden's bid-auction already is. Since the garden already has the `fable` tier, adding a `kimi-k3` arm realizes the post's "K3+Fable mixture" directly.

**Deliverable.** Full report with the memory math, hosted API details, a 6-step concrete wiring plan (routing row → codex-handler `moonshot` arm → tier map → worker kind/unit → rate card/catalog → `MOONSHOT_API_KEY` credential — reuses the existing codex handler, zero new handler file), UNVERIFIED flags, and a recommendation (bounded trial on low-risk/long-context classes, gated on a funded key + codex↔Moonshot chat-completions/tool-calling verification) delivered to the maintainer inbox (`20260722T071615Z-eaf442`).

**Changes / follow-ups.** No garden code changed (researcher is read-only; deliverable is the brief). Suggested follow-ups if the maintainer greenlights hosted: (1) provision a funded Moonshot key, (2) verify codex drives Moonshot's chat-completions `/v1` + K3 tool-calling (same open question as the hermit path), (3) then land the 6-step wiring as a builder/ops job.
