---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Land directly on main2, no PR
(garden's own repo — see CLAUDE.md § Conventions).

# Heal the local-inference model pin: `qwen3:0.6b` is a phantom

**Maintainer finding (kriskowal, 2026-08-01):** `qwen3:0.6b` was never intentional and
appears nowhere by design. The garden has **only ever served `qwen3.6`**. Treat every
`qwen3:0.6b` occurrence in the tree as an error to correct, not as a tag to preserve.

Evidence from `endolin-garden2-5bcdff64`: the only model on disk is
`registry.ollama.ai/library/qwen3.6/latest` (22 GB model layer, 4 blobs, ~23 GB under
`$HOME/.ollama`). No `qwen3:0.6b` blob exists and none ever did. These are different
models, not tag variants — `qwen3:0.6b` names a 0.6-billion-parameter model.

Consequence today: `model_routing_default local` returns `qwen3:0.6b`, so the hermit
backend probe (`codex_local_endpoint_ready "$model"` via `_worker_backend_probe_dispatch`,
`common.sh` provider case `local`) checks for a model that is not served. Even with
`garden-ollama` running, the probe fails with "local inference endpoint serves no usable
model" and the backend-verified auto-tune holds the hermit pool at 0. The local lane is
therefore unusable on every host regardless of declared `hermits:`.

## Task

Replace the phantom pin with `qwen3.6` throughout, so the served model and the configured
model agree. Known occurrences at the time of writing (verify against current HEAD; this
list is a starting point, not a closed set — grep `qwen3:0\.6b` and fix every hit):

- `scripts/jobs/model-tier-inventory.tsv:21` — `local	qwen3:0.6b	myrmidon`
- `scripts/jobs/model-routing-defaults.tsv:38` — `local	qwen3:0.6b	qwen3:0.6b`
  (and the stale comment at :32 describing the qwen family default)
- `scripts/jobs/common.sh:1093` — `: "${model:=qwen3:0.6b}"` fallback in the local probe
- `scripts/jobs/common.sh:4425` — the embedded default routing row
- `scripts/jobs/common.sh:4586` — explanatory comment naming the tag
- `scripts/jobs/reputation.sh:250` — `[ -n "$model" ] || model="qwen3:0.6b"`
- `scripts/jobs/handlers/mentor-claude.sh:111` — `local) model=qwen3:0.6b ;;`
- `scripts/jobs/test/model-routing-test.sh` — :13 (header), :43-45 (classification
  assertions), :67 (`model_routing_default local` assertion)
- `scripts/jobs/test/foreman-provider-fake-curl.sh:7` — fake models payload
- `context/operations/local-inference-amd.md` — :186, :248 (`ollama pull`), :622
- `designs/hermit-failure-capability-demerit.md:10`,
  `designs/gnome-backend-verified-autotune.md:109`,
  `designs/anthropic-worker-kind-monk.md:176`

**Tier classification:** keep the local row in the tier the local lane has always
occupied (`myrmidon`) unless you can establish a better-evidenced placement. Do not leave
the row absent — `model-tier-inventory.tsv` is a closed inventory and an unlisted model
"must not be automatically dispatched", which would silently disable the lane you are
fixing. If you believe a 22 GB model does not belong in `myrmidon`, say so in your report
rather than changing it unilaterally; the weekly tier-effectiveness review can move it.

**Establish the exact tag before writing it.** On disk the manifest path is
`library/qwen3.6/latest`. Confirm what `ollama list` actually reports as the model name
on a host where the daemon is running, and use that string verbatim. Do not guess between
`qwen3.6` and `qwen3.6:latest` — an invented tag reproduces exactly the bug you are
fixing. If you cannot establish it, wire what you can and say plainly which string
remains unestablished.

The served endpoint is `GARDEN_LOCAL_OLLAMA_URL` = `http://127.0.0.1:11435/v1`
(`common.sh:165`); the garden daemon was deliberately moved off :11434 to avoid a
conflict with an `ollama`-user system unit that served an empty model list (see the note
at `scripts/jobs/handlers/codex-provider-common.sh:146`, 2026-07-28). Do not move it back.

## Verify

Hermetic tests (`scripts/jobs/test/model-routing-test.sh` and the reputation/foreman tests
that reference the tag), shell syntax on every edited script, and a read-only probe that
`model_routing_default local` and `tier_model_for_provider <tier> local` both return the
corrected tag. Do not start or enable `garden-ollama` as part of this job and do not pull
any model — this is a configuration fix only; host-local provisioning is handled
separately.

## Report

Name the landed `main2` revision and the exact deploy/activation steps. State explicitly
whether any `qwen3:0.6b` occurrence remains and why. Note in your report that both hosts
converge on this fix only at their next deliberate deploy.

<!-- garden-reaped: 0 -->
