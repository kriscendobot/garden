## Completion report: harness-provider-matrix-handoff-20260901

There was nothing left to post. All three jobs the hand-off asked for were posted on 2026-09-01 and have finished (reports in `journal/jobs/tada/2026/09/01/`), so I didn't post duplicates:

1. **`update-provider-model-catalog-matrix`:** done. The harness × provider matrix is now in `designs/provider-model-catalog.md` § "Harness x provider matrix" (commits `334a7cc2d6` and `29dc503493`).
2. **`probe-opencode-anthropic`:** the code landed (`77b82f7f2d`), but the live test was never run. That covers the registry row, handler, session resume, cost accounting, failure classification and a hermetic test. The host has neither the opencode binary nor an `ANTHROPIC_API_KEY`, so no worker was enabled and no paid canary job ran. Real cost and reputation records are still unconfirmed. The steps to turn it on are in `context/operations/opencode-anthropic.md`.
3. **`design-claude-ollama-cloud-worker-kind`:** the `friar` kind (provider `ollama-cloud`) landed (`ceeb7306a0`) as a design plus a working implementation, with zero workers. It stays off until someone:
   - supplies `OLLAMA_CLOUD_API_KEY` through the seed-api-key-handoff path,
   - rebuilds the image,
   - sets `friars: N` on a host.

**What I did:** I sent the maintainer one message (delivered to `inbox/maintainer`) with:
- a summary of where the three jobs stand;
- the decision the hand-off reserved for the maintainer: whether to probe `opencode-google` (Gemini, the third-ranked probe). It stays unqueued until there's a concrete Gemini use case;
- a note that the reaper had given up on this hand-off job after repeated failed requeues. A stale parked copy is still at `jobs/plan/harness-provider-matrix-handoff-20260901`; it should be removed, not promoted again.

**Changes:** no commits and no garden files changed.

**Follow-ups, all needing the maintainer:**
- Decide whether to probe Gemini through opencode.
- Supply the Ollama Cloud key and choose how many friar workers to run.
- Install opencode and an Anthropic key if they want the live opencode canary run.
- Remove the stale plan entry.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/harness-provider-matrix-handoff-20260901.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 14 tokens (354927 cached reads)
- Output: 3574 tokens
- Cost: $0.5331294
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
