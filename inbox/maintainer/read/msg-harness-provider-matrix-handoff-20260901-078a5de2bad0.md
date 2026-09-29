from_host: endolin-garden-ece02cb4
from: gardener:harness-provider-matrix-handoff-20260901
reply_to: harness-provider-matrix-handoff-20260901
msg_key: msg-harness-provider-matrix-handoff-20260901-078a5de2bad0
notice_count: 1
first_seen: 2026-09-29T16:26:36Z
last_seen: 2026-09-29T16:26:38Z
sent_at: 2026-09-29T16:26:38Z
---
harness-provider-matrix-handoff-20260901: all three posts it asked for already exist and finished on 2026-09-01 (jobs/tada/2026/09/01/):
- update-provider-model-catalog-matrix: the matrix is in designs/provider-model-catalog.md § "Harness x provider matrix".
- probe-opencode-anthropic: the kind landed in 77b82f7f2d. The live canary is NOT verified: this host has no opencode binary and no ANTHROPIC_API_KEY. The activation steps are in context/operations/opencode-anthropic.md.
- design-claude-ollama-cloud-worker-kind: the `friar` kind (provider ollama-cloud) landed in ceeb7306a0 with no workers. To turn it on, export OLLAMA_CLOUD_API_KEY (from your ollama.com account, via the seed-api-key-handoff path), rebuild the image, and declare `friars: N` on a host.

Needs your call: opencode-google (Gemini, the third-ranked probe) was left unqueued on purpose until there's a concrete Gemini use case. Tell me one if you want it probed. Otherwise there's nothing to do.

Note: the reaper had doomed this hand-off job for requeue exhaustion, and a stale parked copy is still at jobs/plan/harness-provider-matrix-handoff-20260901. You can remove it; please don't promote it again.
