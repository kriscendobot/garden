All landed on `main2`. The job is complete.

## Completion report

**Job:** `design-openrouter-provider` — harness and configure OpenRouter as a new garden provider.

**Outcome:** Shipped both the design doc **and** the full disabled-by-default wiring in one commit (`9790c4f4db`, pushed to `main2`). The mechanism turned out to be pure reuse of the existing Codex custom OpenAI-compatible path (no new handler file), so per job option 2 I did the wiring; the one genuinely-unresolved question (the stealth/promotional lane) is deferred as a maintainer open question rather than guessed.

**What I produced**
- **`designs/openrouter-provider.md`** — reasons through: the mechanism (same generalization as `fireworker`, confirmed against `opencode-alternate-harness.md` option C, no new harness); the wiring checklist keyed to the Fireworks commit `2c21ea3f2c`; and **the crux** — closed-inventory vs. rotating stealth models. **Recommendation: admit stable NAMED `:free` models via ordinary reviewed rows; EXCLUDE cloaked/stealth ids** (they fail closed like any unreviewed selector) until they de-cloak under a real name. The promotional-lane option (a second `openrouter-promo` kind with re-review cadence + rip-cord) is fully designed but left as an Open Question because it weakens the inventory invariant and is inseparable from the unresolved terms question. Terms/data-retention (free tier commonly requires logging/training-on-inputs; stealth operators undisclosed by definition) is surfaced as an explicit Open Question, not a settled premise.
- **The wiring** (21 files, same shape as Fireworks + evolution): `openrouter` kind in `common.sh`/`claim-job.sh`/`reputation.sh`/`comment-provenance.sh`; two reviewed named-free inventory+routing rows (DeepSeek V3 free→minion, Llama 3.3 70B free→myrmidon, different tiers so both independently selectable); handler generalized so Fireworks+OpenRouter share one `$custom_openai_compat` path (`fireworks_*` kept as wrappers); `set-openrouters.sh`; `OPENROUTER_API_KEY` tmpfs handoff (`garden` + `seed-api-key-handoff.sh`); auto-rendered `garden-openrouter@` unit; `context/operations/openrouter.md` bounded-probe activation doc (kimi-k3 shape); `model-selection`/`provider-model-catalog`/`starting`/README updates.

**Verification:** Fixed three real eligibility bugs found while testing (unrecognized `openrouter` provider constraint; unpinned minion/myrmidon leak; unclassified-pin fallback leak) so **no automatic/unpinned/stealth/foreign job can reach the lane** — only a reviewed `openrouter/<id>` pin or a `provider: openrouter` canary. New `openrouter-harness-test.sh` (16/16) plus green runs of `worker-spine-kinds-test` (217/0), `fireworker-harness` (15/0, no regression), `api-key-handoff`, `worker-health-gate`, `scaler-desired-count`, `model-routing`. shellcheck clean on new files.

**Posture:** Pool at zero, explicit-model-only, no spend. Key provisioning + first canary stay a separate maintainer-directed step (I supplied/requested no key and armed nothing).

**Follow-ups / flags:**
1. The design carries a non-empty `## Open questions` section. The job directive explicitly said "commit directly to `main2`, no PR," which I honored — but CLAUDE.md's standing carve-out normally gives an open-questions design a review PR. If the maintainer wants inline review of the terms/stealth-lane questions, a review PR can still be opened (frozen-base-branch snapshot).
2. The two seed model ids were **transcribed, not live-verified** (no key in the worktree). The activation doc requires confirming each via the status-only probe (200 vs 404) before enabling; a rotated-away `:free` id gets removed, not dispatched.
3. Latent (pre-existing, out of scope): the `fireworker` lane has the same unpinned-tier leak I closed for openrouter — worth a maintainer note since both pools are at zero today.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-openrouter-provider.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 246 tokens (23654240 cached reads)
- Output: 97094 tokens
- Cost: $16.62393599999999
- Wall-clock: 1530s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
