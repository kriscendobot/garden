---
created: 2026-09-01
author: gardener
---

# Bounded Ollama Cloud (friar) worker activation

`friar` is a provider-constrained, explicit-model-only pool that runs **Claude Code**
(`claude`) against **Ollama Cloud** — ollama.com's **Anthropic-compatible** endpoint.
Its provider is **`ollama-cloud`**: a paid, metered, external surface, distinct from
`anthropic` (the flat Claude Max subscription the gardeners/monk draw) and from local
(`hermit`). Because Ollama Cloud speaks the Anthropic wire protocol, the friar reuses
the same `claude` agent binary as the gardener; only the base URL and credential
differ. The unit is `garden-friar@`, its per-host count key and state namespace are
`friars`, and its label is `garden-friar`. The pool starts at **zero** and refuses
unconstrained work. Design: [`designs/claude-ollama-cloud-worker-kind.md`](../../designs/claude-ollama-cloud-worker-kind.md).

## The credential (host env var → tmpfs handoff)

The friar authenticates with **`OLLAMA_CLOUD_API_KEY`**. Export it as a host
environment variable at container creation; the `garden` launcher forwards it (via a
`-e` into `docker run`, exactly like `FIREWORKS_API_KEY`/`OPENROUTER_API_KEY`) into the
container, where `seed-api-key-handoff.sh` lands it on the tmpfs systemd handoff for the
worker to read. The key value **never enters the image, the repo, a unit, the journal, a
worktree, a report, or a diagnostic** — only the tmpfs handoff.

**An image rebuild is required before the new variable is recognized.**
`seed-api-key-handoff.sh` is a build input baked into the image, so a container built
before this arm existed will not seed `OLLAMA_CLOUD_API_KEY`. Rebuild the image first,
then recreate the container with the key supplied only in the creation command (avoid
shell tracing, `docker inspect`, verbose curl, or anything that prints environments):

```sh
./garden build
./garden reset
OLLAMA_CLOUD_API_KEY='replace-with-secret' ./garden create
```

Key provisioning and the first canary are a **separate, maintainer-directed step**
(same as fireworks/openrouter/kimi-k3) — this activation page arms nothing on its own.

## Registered routes

The closed inventory (`scripts/jobs/model-tier-inventory.tsv`) registers reviewed
Ollama Cloud routes. New selectors fail closed until an inventory, routing-default,
resolver, and test update lands; do not use a wildcard route.

| Garden id (inventory) | Wire id sent to Ollama Cloud | Tier | Provenance |
| --- | --- | --- | --- |
| `qwen3.5:cloud` | `qwen3.5:cloud` | `minion` | First onboarded Ollama Cloud model (provisional); verified against ollama.com's cloud model list |

The friar is **explicit-model-only**: no automatic or unpinned board job can reach it
(`claim-job.sh` fences it to a `provider: ollama-cloud` canary or an explicit
`model: qwen3.5:cloud` pin), exactly as with the mystic/fireworker/openrouter arms.

## Canary

Once the key is provisioned and the pool is armed, enable one worker only. There is
**no `set-friars.sh` wrapper**; use the generic `set-workers.sh`:

```sh
scripts/jobs/set-workers.sh friar 1
```

Post one harmless, isolated-worktree canary with an Ollama Cloud constraint and no
external action, either a `provider: ollama-cloud` canary or a concrete
`model: qwen3.5:cloud` pin. Put the harmless task (a file create → readback → remove)
in `canary.md`, then post it with:

```sh
scripts/jobs/post-job.sh --provider-canary ollama-cloud minion ollama-cloud-qwen-canary canary.md
```

Confirm the `jobs/tada/` report contains `worker_kind: friar`, provider `ollama-cloud`,
tier `minion`, and the resolved model `qwen3.5:cloud`, with **tool-verified** evidence
the model did the work (a file create → readback → remove, reported with its tool
output) rather than merely returning plausible text. Output with no tool result behind
it is a failed canary. Then return the pool to zero unless the maintainer authorizes a
larger trial:

```sh
scripts/jobs/set-workers.sh friar 0
```

## A paid, metered arm

Unlike the flat-subscription gardener/monk lane, `ollama-cloud` bills **real dollars
per call** — it is a metered pool like Moonshot/Fireworks/OpenAI. Its spend is priced
from the rate-card row for the provider, and it is subject to the same quota-throttle,
**manually-funded** classification as the other metered arms: the account must carry a
funded balance before it can serve, and admission/leveling treat it as a real-dollar
pool (`designs/live-budget-admission.md` § Metered API pools). Weigh that before
authorizing a trial larger than a canary.

## Declaring zero is not the same as declaring nothing

As with the fireworker/openrouter: an absent `friars:` line means "this host does not
declare this kind" and the scaler leaves the pool alone; an explicit `friars: 0`
records that the kind was considered and is deliberately off.
