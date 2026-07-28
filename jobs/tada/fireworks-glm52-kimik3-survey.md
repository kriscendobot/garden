# Fireworks GLM 5.2 and Kimi K3 survey

Observed 2026-07-28. This is a research/proposal report only: no routing was
changed and no worker was enabled.

## Current Fireworks wire ids

| Garden selector | Exact suffix sent after `fireworks/` | Serving path and source |
| --- | --- | --- |
| `fireworks/accounts/fireworks/models/glm-5p2` | `accounts/fireworks/models/glm-5p2` | GLM 5.2 Serverless standard. The [Fireworks GLM 5.2 model library](https://fireworks.ai/models/fireworks/glm-5p2) lists this model path and Serverless support. |
| `fireworks/accounts/fireworks/routers/glm-5p2-fast` | `accounts/fireworks/routers/glm-5p2-fast` | GLM 5.2 Fast shared Serverless router. The [Fireworks Fast announcement](https://fireworks.ai/blog/glm-5p2-fast) gives this exact ID. |
| `fireworks/accounts/fireworks/models/kimi-k3` | `accounts/fireworks/models/kimi-k3` | Kimi K3 Serverless standard. The [Fireworks Kimi K3 model library](https://fireworks.ai/models/fireworks/kimi-k3) lists this model path and Serverless support. |

These are public model-library/provider observations, not an authenticated
`/models` listing. Recheck them immediately before posting a production
canary; the Fireworks namespace intentionally has no garden catalog default.

## Availability and tool surface

* GLM 5.2 standard is Serverless and on-demand; its model-library card states a
  1,040k-token context and Function Calling support. GLM 5.2 Fast is shared
  Serverless (not dedicated-only), preserves the full 1M context, and Fireworks
  documents the same structured-output/function-call contract as Standard:
  JSON-schema and BNF grammar structured output plus tool calling. The Fast
  router is an optional second GLM canary, not the initial route.
* Kimi K3 is Serverless and on-demand, not dedicated-only; its card states a
  1,040k-token context, Function Calling support, and image input. The generic
  [Fireworks tool-calling documentation](https://docs.fireworks.ai/guides/function-calling)
  documents JSON-schema tool parameters and `response_format` JSON-schema use,
  but the K3 card does not make a model-specific structured-output claim.
  Treat K3 structured output as a canary-time check rather than an established
  compatibility guarantee.

## K3 is two independent backends

Keep Moonshot Kimi Code and Fireworks K3 distinct:

* Existing Mystic: `model: kimi-k3`, `worker_kind: mystic`, `provider: moonshot`,
  official Kimi Code handler `scripts/jobs/handlers/mystic-kimi.sh`.
* Proposed Fireworker: `model: fireworks/accounts/fireworks/models/kimi-k3`,
  `worker_kind: fireworker`, `provider: fireworks`, Codex-compatible Fireworks
  handler.

Prefer Mystic for the presently established Kimi Code continuation path and its
private per-job Kimi session state. Use Fireworker K3 only as an independent
serving-path trial/bakeoff, especially for the Codex tool harness and Fireworks
availability/latency behavior. Neither becomes a default. Keep reputation arms
separate by `(kind, provider, model)`; do not pool `mystic/moonshot/kimi-k3` with
`fireworker/fireworks/accounts/fireworks/models/kimi-k3`.

## GLM 5.2 fit

The evidence supports a bounded trial for explicit, tool-using coding and
long-context repository analysis jobs: Fireworks documents Serverless function
calling and a 1,040k context, and documents Fast's structured-output/tool-call
behavior. It does not establish garden-specific reliability, tool-call validity,
or code-change quality. Start with isolated, reversible gardener/fixer-style
canaries; do not add GLM 5.2 as a designer/builder default before those results.

## Build proposal for the next child

1. Leave `scripts/jobs/model-routing-defaults.tsv` unchanged: its existing
   `fireworks\tfireworks/*` row already routes only explicitly prefixed selectors
   to Fireworker, with no fleet default. Leave `scripts/jobs/claim-job.sh`
   unchanged: Fireworker already requires `fireworks/<nonempty-wire-id>`. Do not
   add a provider catalog, an alias such as `glm-5p2`, or an unprefixed K3 route.
2. Update `context/operations/fireworks.md` with a short dated example-selector
   table containing the three selectors above, their source URLs, and the rule to
   recheck public availability before a canary. Keep the no-catalog-default
   language. Add explicit K3 dual-backend/reputation guidance, cross-linking
   `context/operations/kimi-k3.md`.
3. Extend `scripts/jobs/test/worker-spine-kinds-test.sh` with eligibility cases
   for `fireworks/accounts/fireworks/models/glm-5p2`,
   `fireworks/accounts/fireworks/routers/glm-5p2-fast`, and
   `fireworks/accounts/fireworks/models/kimi-k3`; each must be claimed by
   Fireworker and rejected by the non-Fireworker kinds. This proves the route
   remains explicit without hard-coding provider availability into routing code.
4. On a key-bearing container, make a status-only authenticated `/models` probe.
   Do not save or report its body. Only after a 2xx result, run exactly one
   Fireworker. Post sequential, isolated-worktree, no-external-action canaries:
   (a) GLM standard, `model: fireworks/accounts/fireworks/models/glm-5p2`, asks
   for a harmless create/read/remove tool action; (b) optional GLM Fast repeat,
   `model: fireworks/accounts/fireworks/routers/glm-5p2-fast`; (c) K3,
   `model: fireworks/accounts/fireworks/models/kimi-k3`, with the same tool
   action plus a JSON-schema/structured-output check. Each report must record a
   normal completion, `worker_kind: fireworker`, provider `fireworks`, the exact
   selector, and whether the tool (and, for K3, schema output) actually worked.
   Inspect its distinct reputation arm, then return Fireworker to zero after each
   bounded trial unless the maintainer authorizes expansion.

## Key-bearing host check

The current host's handoff and process environment reported Fireworks-key
**presence** using presence-only checks; no secret, header, or response body was
printed. This contradicts the job's earlier snapshot that this host lacked the
key. The leader marker resolves to `endolin-garden2-5bcdff64`, but that host was
not reachable by name or noninteractive SSH from this container, and no local
container runtime is available. Its key presence could therefore not be
established here. The next child must repeat the same presence-only check on the
leader (or use this current key-bearing host if policy permits) before running a
canary.
