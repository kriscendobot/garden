---
gate: deferred
priority: low
posted_by: producer
posted_at: 2026-09-23T14:58:52Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Hand-off: harness × inference-provider matrix, and what to probe next

Produced on the bare host (not inside the container), from a research session
that started as "wire Claude Code to Ollama with my API key" and widened into
"map every harness we could run against every provider, so we can compare and
evaluate them." Nothing here has touched the journal or any garden state —
post the pieces below from *inside* the container with the real job-board
tooling (`scripts/jobs/post-plan.sh` / `post-job.sh` / `post-orchestration.sh`),
not by writing into `journal/` directly.

## The harnesses

| Harness | CLI | Native reach | Generalized reach |
|---|---|---|---|
| **claude** (Claude Code) | `claude -p` | Anthropic Messages API | Honors `ANTHROPIC_BASE_URL`/`ANTHROPIC_AUTH_TOKEN` — can point at **any** Anthropic-Messages-compatible endpoint. **Not yet exercised anywhere in this repo.** Confirmed this session via `docs.ollama.com`: Ollama, both self-hosted and Cloud, now serves `/v1/messages` natively, so this reach is real, just unused. |
| **codex** (Codex) | `codex exec` | OpenAI API (ChatGPT-plan metered) | Already generalized via custom `model_provider` to **any OpenAI-compatible endpoint** — this is how `hermit` (local Ollama), `fireworker` (Fireworks), and `openrouter`/`openrouter-promo` (OpenRouter) all work today, sharing one handler (`cleric-codex.sh`). `codex --oss` is a native shortcut for localhost Ollama. |
| **kimi** (Kimi Code CLI) | `kimi --prompt` | Moonshot K3 only | No generalization investigated; Moonshot-specific temp-model config channel. |
| **opencode** | `opencode run` | Provider-agnostic via the Models.dev catalog (`-m provider/model`) | Natively reaches Anthropic, OpenAI, **Google Gemini**, Moonshot, and arbitrary custom OpenAI-compatible endpoints — **proposed, not built**. `designs/opencode-alternate-harness.md` (2026-07-28) already ran a rigorous 8-constraint feasibility pass and recommends **adopt narrowly: one kind per provider it fronts, sharing one handler** — the `cleric-codex.sh` pattern. No constraint was disqualifying; two need a live probe (exit-code honesty, transcript-capture plumbing). |

Reuse the opencode design's 8-constraint rubric for evaluating *any* new
harness×provider cell (including Claude×Ollama below), rather than inventing
a new one: deterministic session/resume, cost-ledger fidelity, robust binary
resolution, headless + honest exit codes, tool-permission/sandbox model,
transcript capture, model routing cleanliness, eligibility gating.

## The matrix

✅ = wired (armed or inert-by-default) · 🔬 = designed/recommended probe · ❓ = genuinely unresearched · — = no natural fit

| Provider | claude | codex | kimi | opencode |
|---|---|---|---|---|
| **anthropic** | ✅ `monk` (native, fleet default) | — | — | 🔬 `opencode-anthropic` — the opencode design's own **recommended first probe** (A/B the harness itself against native `monk` on the same model) |
| **openai** | — | ✅ `cleric` (native, ChatGPT-plan metered) | — | ❓ possible (`opencode-openai`), not probed |
| **local Ollama (on-box)** | ❓ **unresearched** — technically live (Anthropic-compat `/v1/messages`), never tried | ✅ `hermit` (OpenAI-compat `/v1`, `garden-ollama.service:11435`) | — | ❓ not discussed in the opencode design at all |
| **Ollama Cloud (ollama.com)** | ❓ **the original ask** — same mechanism as local, but paid/API-key-metered, needs its own quota/rate-card classification (can't reuse `hermit`'s "local = never quota'd" exclusion) | ❓ plausible if Cloud is OpenAI-compatible too — unconfirmed | — | ❓ unresearched |
| **moonshot** | — | — (mystic deliberately uses a dedicated harness instead) | ✅ `mystic` (native Kimi Code CLI, inert-by-default) | ❓ possible (`opencode-moonshot`), not probed |
| **fireworks** | — | ✅ `fireworker` (OpenAI-compat, inert-by-default) | — | ❓ possible, not probed |
| **openrouter** | — | ✅ `openrouter`/`openrouter-promo` (OpenAI-compat, inert-by-default) | — | ❓ possible, not probed |
| **google/gemini** | — (no Anthropic-compat path known) | — (not OpenAI-shaped without a proxy) | — | 🔬 opencode's **headline case** — the only harness reaching this provider *natively* |

## Ranked probes

1. **`opencode-anthropic`** — zero new research needed; design and probe
   recipe are both already written (`designs/opencode-alternate-harness.md`
   § "The smallest probe").
2. **Claude × Ollama Cloud** (the original ask) — no protocol translation
   needed (confirmed this session), just env-var plumbing through a
   provider-parameterized `monk-claude.sh`. See the full brief below.
3. **`opencode-google`** — highest new-reach payoff, but scope an actual
   Gemini use-case before spending the probe.
4. Lower priority: Claude × local on-box Ollama (redundant with Cloud once
   proven); `opencode-openai`/`opencode-moonshot`/`opencode-fireworks`/
   `opencode-openrouter` (codex already reaches all of these — pure
   harness-diversity bet, lowest ROI).

Item 3 is deliberately not queued below — flag it to the maintainer, don't
probe speculatively.

## Things to post from inside the container

### 1. Fold the matrix into the reference doc

`designs/provider-model-catalog.md` is titled "Claude + Codex" but already
half-covers Kimi/local/Fireworks/OpenRouter piecemeal in its later sections —
natural home for a top-level harness × provider matrix plus an opencode row.

```sh
scripts/jobs/post-job.sh update-provider-model-catalog-matrix \
  "Add a top-level harness x provider matrix to designs/provider-model-catalog.md \
   (rows: anthropic/openai/local-ollama/ollama-cloud/moonshot/fireworks/openrouter/ \
   google-gemini; columns: claude/codex/kimi/opencode), consolidating what's already \
   scattered across the doc's later sections plus designs/opencode-alternate-harness.md. \
   See scratchpad hand-off for the drafted matrix."
```

### 2. Probe job — opencode × Anthropic

```sh
scripts/jobs/post-job.sh probe-opencode-anthropic \
  "Execute the probe specified in designs/opencode-alternate-harness.md \
   § 'The smallest probe': one opencode-anthropic kind (registry row + \
   count_key + eligibility branch), one worker enabled, one reversible \
   canary job pinned to an opencode-routed anthropic model. Verify: \
   sessionID parses and resume works via sidecar; usage/<base>.jsonl gets \
   real non-censored USD cost from summed step_finish events; the \
   reputation event lands on a DISTINCT arm from gardener/anthropic/<model>; \
   a killed run and a refused key classify as transient/environmental, not \
   a job defect. Report the gap if any of these don't hold."
```

### 3. Design job — Claude × Ollama Cloud

```sh
scripts/jobs/post-job.sh design-claude-ollama-cloud-worker-kind \
  "$(cat <<'EOF'
Add a new Anthropic-taxonomy worker kind that runs Claude Code against Ollama
Cloud (ollama.com), authenticated with a maintainer-supplied Ollama API key,
alongside the existing monk (real Anthropic API), cleric (OpenAI/Codex), and
hermit (local Ollama/Codex) kinds. Follow the established "adding a third
backend" recipe (common.sh:513-515, context/operations/local-inference-amd/
worker-backend.md). Concretely:

- Handler: extend handlers/monk-claude.sh to be provider-parameterized
  (mirroring cleric-codex.sh's existing provider=local branch): when the new
  provider is active, export ANTHROPIC_BASE_URL=https://ollama.com,
  ANTHROPIC_AUTH_TOKEN=$<new-secret-var>, ANTHROPIC_API_KEY= (cleared) before
  the existing claude -p invocation. No other line of that handler should
  need to change.
- Registry: new worker_kind_field() row -- handler handlers/monk-claude.sh
  (reused), agent_bin: claude, a new, distinct provider (not anthropic, not
  local -- see quota-throttle note below), a new unit/count_key/state_ns/
  label. Suggested kind name: friar (the exact placeholder name common.sh:513
  already uses as its example of "a third backend on a future CLI").
  Not load-bearing -- confirm no collision, can pick differently.
- Model/tier map: new rows in model-tier-inventory.tsv and
  model-routing-defaults.tsv for whichever Ollama Cloud model tag(s) are
  onboarded first, at a tier matched to measured capability -- mirroring the
  existing "local qwen3.6 minion" row. Verify current Ollama Cloud
  catalog/pricing at design time, not from this brief.
- Secrets: add the new API-key env var to the allowlist in
  scripts/systemd/seed-api-key-handoff.sh (currently ANTHROPIC_API_KEY
  MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY only), same
  base64url-charset validation. Pick a name that can't collide with the
  pre-existing, non-secret, ignored-by-Ollama OLLAMA_API_KEY convention
  already used by hermit/codex's local config -- e.g. OLLAMA_CLOUD_API_KEY.
- Rate card / quota: this is a paid, metered, external surface, unlike
  hermit's free local compute -- needs its own reputation/rate-card.md
  provider row (not pooled with anthropic or local), and must NOT inherit
  the local-provider quota-throttle exclusion in designs/quota-throttle.md
  ("Ollama (hermit, provider: local) -- explicit non-goal"), which is
  explicitly premised on local compute never emitting a cap signature.
  Ollama Cloud will emit real rate-limit/quota errors against the
  maintainer's key, so the new provider needs its own throttle
  classification, sized like mystic (moonshot) or fireworker's
  "manually-funded arm routed to a human," not like hermit.
- Verification / risk to smoke-test before trusting the fleet on it: Ollama
  Cloud's /v1/messages wants Authorization: Bearer (ANTHROPIC_AUTH_TOKEN),
  not x-api-key -- confirm this works end to end, not just locally. Confirm
  Claude Code doesn't hard-fail when it hits an unsupported endpoint
  (count-tokens is the known risk -- see live Ollama GitHub issue). Confirm
  usage/cost accounting (usage_capture_result in monk-claude.sh) degrades
  sensibly given Ollama's token counts are approximate and prompt caching
  isn't supported.

Open questions for the design doc's own "Open questions" section: final
kind/provider names; which Cloud model(s) to onboard first and at what tier;
initial pool sizing (friars: N) and which host(s) run it; whether this needs
maintainer attestation to arm (like the local-model sysop op) given it's a
new paid external surface.
EOF
)"
```

**Before posting #3**, obtain an Ollama Cloud API key from ollama.com's
account settings — never type it into a chat session or commit it to the
repo. Once the design lands and picks a secret-var name, the key goes
through the same handoff path `ANTHROPIC_API_KEY` already uses (exported
before container start, bridged by `scripts/systemd/seed-api-key-handoff.sh`
into the lingering systemd user manager). Worth a manual `ollama launch
claude` smoke test locally first (Ollama's own quick-start) to validate the
key and Cloud access before wiring it into the fleet.

## Sources consulted this session

- `designs/anthropic-worker-kind-monk.md` — monk/cleric/hermit taxonomy
- `designs/opencode-alternate-harness.md` — the 8-constraint harness rubric, opencode feasibility
- `designs/provider-model-catalog.md` — existing Claude+Codex(+local/Kimi/Fireworks/OpenRouter) catalog
- `designs/quota-throttle.md` — why `hermit`'s local-only quota exclusion can't extend to a paid Cloud arm
- `context/operations/local-inference-amd/{worker-backend,cost-model,serving-endpoint}.md`
- `scripts/jobs/common.sh` (`worker_kind_field`, `worker_kinds`, `resolve_model_tier`, `role_default_model`)
- `scripts/jobs/handlers/monk-claude.sh`, `scripts/systemd/seed-api-key-handoff.sh`
- `docs.ollama.com/api/anthropic-compatibility`, `docs.ollama.com/integrations/claude-code` (web, 2026-09-01)
