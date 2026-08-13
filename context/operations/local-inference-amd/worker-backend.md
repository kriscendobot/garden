# Wiring a local-inference worker backend (the `hermit` kind)

How the garden fleet reaches the local endpoint as a **third worker backend**:
the `hermit` worker kind (LANDED 2026-07-14) — a `provider: local` codex-cleric
that reuses the entire cleric handler for zero new handler code — the tier map
that resolves served tags (`20b → gpt-oss:20b`), the claim-eligibility that keeps
local and paid jobs from crossing, and the alternative of a dedicated local
handler. Read this to add or understand the local worker wiring. Getting the
endpoint it targets up is [serving-endpoint.md](serving-endpoint.md); pricing the
worker's bids is [cost-model.md](cost-model.md); what ships in the image to make
it self-standing is [durability.md](durability.md).

The parked design **`cleric-worker-bid-auction-reputation`**
([designs/cleric-worker-bid-auction-reputation.md](../../../designs/cleric-worker-bid-auction-reputation.md),
gated by orchestration `orch-cleric-worker-system`) factors the gardener loop
into a **worker spine** with a **worker-kind registry** (§2.1 there). Adding a
backend is deliberately cheap: *one handler script implementing the contract,
one registry row, one rate-card block, one tier map, and a `hosts/<host>` count
line* (§2.2, "Adding a third backend"). Local inference is exactly that third
backend. Two ways to build it:

## Option 1 (recommended first step) — a codex-cleric pointed at the local endpoint

**`codex` can target any OpenAI-compatible `base_url`** via a custom
`model_provider`. The cleric handler already drives `codex exec` (design §1.1);
point it at the local Ollama `/v1` instead of OpenAI by adding a provider block
to `~/.codex/config.toml` and selecting it with `-c model_provider=…`:

```toml
# ~/.codex/config.toml
[model_providers.local]
name = "local-ollama"
base_url = "http://127.0.0.1:11435/v1"
env_key = "OLLAMA_API_KEY"   # any non-empty value; Ollama ignores it
```

```sh
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  -c model_provider=local -m gpt-oss:20b "…the job prompt…"
```

(Exact `config.toml`/flag surface to be re-verified against the installed codex
CLI when built — the catalog warns the CLI surface is server-resolved and
living. **UNVERIFIED** against a specific codex version here.)

This reuses the **entire cleric handler** (`handlers/cleric-codex.sh`) — session
resume, worktree lifecycle, completion-marker contract, and the `--json` usage
adapter — for **zero new handler code**. It is the fastest path to a working
local worker and the right first move.

- Registry-wise, the cleanest expression is a **new kind** (say `hermit`) whose
  registry row reuses the codex handler but sets `provider: local` (so its
  reputation and rate-card rows are distinct from the paid-OpenAI `cleric`),
  plus a `hosts/<host>` line `hermits: N`. The provider field is exactly why the
  design keeps `worker_kind` and `provider` distinct (§4.2): "a future kind
  could drive either provider" — a codex-harness kind driving a *local* provider
  is that case.

**LANDED (2026-07-14): the `hermit` kind is wired.** Concretely:
- `common.sh` worker-kind registry gains a `hermit` row: handler
  `handlers/cleric-codex.sh` (reused verbatim), `provider: local`, unit
  `garden-hermit@`, count_key/state_ns `hermits`. `worker_kinds` enumerates it, so
  the scaler, `install-units.sh scale hermit N`, and the systemd template render it
  with **no per-kind source** (the same factoring the cleric proved).
- `resolve_model_tier local <tier>` maps the served Ollama tags (`20b →
  gpt-oss:20b`, `120b → gpt-oss:120b`, colon-tags pass through); the `openai` map
  now explicitly rejects `gpt-oss*` so a local tag can't be mis-claimed as a paid
  model. `claim-job.sh`'s backend-fit filter routes a `gpt-oss:*`-pinned job to a
  hermit only, and keeps a hermit off claude-/codex-pinned jobs.
- `cleric-codex.sh` is now provider-parameterized: for `provider=local` it skips the
  ChatGPT `codex login` check (does a `/v1/models` reachability probe instead),
  defaults to `gpt-oss:20b`, and adds `-c model_provider=local` plus an **inline**
  `-c model_providers.local.{name,base_url,env_key}` block (endpoint from
  `GARDEN_LOCAL_OLLAMA_URL`, default `http://127.0.0.1:11435/v1`) — so no
  `~/.codex/config.toml` is required and the wiring is reset-proof. **Zero new
  handler file.**
- Declare a host's count with `scripts/jobs/set-hermits.sh <N> [host]` (the
  `set-clerics.sh` analogue). Recommended initial sizing on a host that serves local
  inference: a small pool (e.g. 2) to accrue reputation data.
- **UNVERIFIED against a live codex on a GPU host:** the exact `-c model_provider`
  key names / string-quoting were transcribed from this guide, not re-run (codex was
  not on PATH in the build worktree). Re-verify on the live CLI before the first real
  hermit job. `codex --oss` is a native alternative shortcut for a localhost Ollama.

## Option 2 — a dedicated local handler

Write `handlers/hermit-local.sh` that calls the local `/v1` directly (via a
thin OpenAI client or `curl`) instead of going through codex. Worth it only if
codex's agentic loop proves a poor fit for a small local model, or to drop the
codex dependency. It implements the same handler contract:
`handler <base> <jobfile> <report-out>`, writes the completion sentinel iff the
run genuinely finished, and fills `GARDEN_USAGE_OUT` with normalized usage
`{provider, model, thoughtfulness, input_tokens, output_tokens, …}` — which for
local inference comes straight from the `/v1` response's `usage` block.

**Recommendation:** ship **Option 1** first (a `provider: local` codex-cleric —
no new handler), measure it under the auction, and only write a dedicated
handler if the reuse proves inadequate.

## Model/tier and eligibility

- Add an `openai`-shaped (OpenAI-compatible) tier map entry resolving the local
  model ids (`gpt-oss:20b`, `gpt-oss:120b`, …) — these are the served model tags,
  not paid slugs.
- The interim claim-eligibility predicate (design §1.3) must treat local model
  tags as **local-only** so a paid-cleric never claims a job pinned to a local
  model and vice-versa; under the auction this becomes a priced bid rather than
  a hard filter.
