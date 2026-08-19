---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design a new worker kind: "muse" (Meta Muse Code)

Repository: this repo (garden). Garden-infra design — the deliverable is
`designs/muse-worker-kind.md`, landed directly on `main2` (no PR; CLAUDE.md
§ Conventions — the garden does not open PRs against itself).

## Source

https://developer.meta.com/ai/products/muse-code/ — read it yourself, don't
rely on the summary below alone. What's confirmed so far:

- **CLI + hosted service**: `curl -fsSL https://dev.meta.ai/install.sh | bash`
  installs an agentic coding CLI.
- **Model & API**: backed by **Muse Spark**, reachable via the Meta Model API
  with **OpenAI SDK compatibility**.
- **What it does**: "An agent for your most complex coding workstreams... it
  coordinates multiple AI agents on coding tasks — workers in parallel with
  background reviewers." This is a fuller agentic-orchestration product, not
  a bare chat-completions model — closer in shape to Claude Code itself than
  to a plain API backend.
- **Access**: via `https://dev.meta.ai/`, API login required, **currently
  beta**.
- **Pricing** (Muse Spark 1.2, metered per token, not flat-rate):
  Contributor: $0.10/Mtok in, $0.002/Mtok cached, $0.20/Mtok out. Standard:
  $1.25/Mtok in, $0.15/Mtok cached, $4.25/Mtok out. 1M context window.

## Read first (precedent — follow the established shape, don't reinvent it)

- [`designs/anthropic-worker-kind-monk.md`](../designs/anthropic-worker-kind-monk.md)
  — the most recent worker-kind introduction/rename, and the freshest
  precedent for the registry/handler/systemd/model-routing shape a new kind
  needs. This week's `gardener`→`monk` release is the live example of what
  "done" looks like for a kind's registration surface.
- [`designs/gnome-backend-verified-autotune.md`](../designs/gnome-backend-verified-autotune.md)
  — the provisioning-gate pattern every non-Anthropic kind already follows:
  `set-workers.sh` refuses a kind's count > 0 until that kind's backend probe
  (credentials *and* software) passes on the declaring host. Muse should
  follow this exactly, the same way cleric/mystic/fireworker/hermit do
  (`worker_backend_probe`, `GARDEN_FORCE_DECLARE=1` staging).
- [`designs/cleric-worker-bid-auction-reputation.md`](../designs/cleric-worker-bid-auction-reputation.md)
  and [`designs/hermit-failure-capability-demerit.md`](../designs/hermit-failure-capability-demerit.md)
  — reputation/reliability precedent for a newly-introduced kind; read for
  the shape, not necessarily to replicate every mechanic.
- `skills/model-selection/SKILL.md` and `scripts/jobs/common.sh`'s
  `role_default_model` / `resolve_model_tier` / `worker_kinds` /
  `worker_kind_field` — the actual registry a new kind must extend.

## What the design needs to decide and specify

- **Integration shape: CLI or raw API?** Every existing kind's handler shells
  out to that provider's own agentic CLI (`claude -p`, `codex exec`, etc.) —
  not a bare API client. Muse ships **both** a CLI and an OpenAI-compatible
  API. Investigate which fits the fleet's handler pattern better: the native
  `muse` CLI (mirrors the existing pattern most closely, but is a new,
  beta, third-party binary to sandbox/audit) versus a lightweight
  OpenAI-SDK-compatible API call (less surface, but diverges from how every
  other kind is driven, and doesn't get you Muse's own worker/reviewer
  orchestration — which may not even be desirable to give up).
- **Nested orchestration tension — name it explicitly, don't paper over it.**
  Muse's headline feature is that it *itself* coordinates multiple agents
  (parallel workers + background reviewers) on one task. The garden already
  has its own orchestration model (the job board, the gardening state
  machine, panel review). Using Muse naively could mean an agent-orchestrator
  running *inside* a job a gardener claimed, which the garden-fleet has no
  visibility into (cost, timing, sub-task state) and which may double up on
  work the garden's own panel/fix-loop already does. Decide (or flag as an
  explicit open question) whether "muse" should be constrained to
  single-agent mode for garden jobs, or whether its multi-agent mode is
  usable/desirable within a garden job's bounds.
- **Cost exposure is real and metered, unlike the Claude Max flat-rate
  accounts the fleet mostly runs on.** The design must address budget
  guardrails explicitly — tie into the just-landed live-budget-admission /
  token-bucket admission mechanics (`designs/live-budget-admission.md`,
  `designs/budgeted-campaign-dispatch.md`) rather than adding an
  unmetered-cost worker class that bypasses them. State what tier(s) muse
  maps to and whether it should default to any automatic routing at all
  (compare to how `skills/model-selection/SKILL.md` currently keeps some
  tiers manual-only/opt-in).
- **Credential/access gate.** Beta + `dev.meta.ai` API login means this is a
  maintainer-provisioned credential, exactly like `MOONSHOT_API_KEY`
  (mystic) or `FIREWORKS_API_KEY` (fireworker) — name the exact env var /
  config the backend probe checks, following that established pattern. Note
  explicitly that **beta access itself may need a waitlist/approval step
  outside the garden's control** — this is a real precondition the design
  should surface, not assume away.
- **Registry surface**: `worker_kinds`, `worker_kind_field` entries
  (provider, count_key, tier defaults), a new `handlers/muse-*.sh`, a
  `garden-muse@.service` systemd template + scaler wiring, `set-workers.sh
  muse N` support, and the per-role default-model table entries
  (`role_default_model` in `common.sh`) — mirror monk's shape exactly for
  each of these unless there's a concrete reason to diverge.

## Deliverable

A design document per the usual shape (problem statement, scope, design,
alternatives considered, open questions, phased implementation). Given the
real unknowns here (beta access, ToS, per-token cost, the nested-orchestration
question), lean toward naming things as explicit open questions for the
maintainer rather than guessing — this is exactly the kind of prompt where
premature certainty costs more than an honest question. Do not proceed to
a build job from this one; that follows once the design is reviewed.

<!-- garden-reaped: 1 -->
