Landed and pushed accepted migration design: `bc7f7796c2` on `main2`.

- Added `designs/anthropic-worker-kind-monk.md` and indexed it.
- Defines monk/Anthropic/Claude, cleric/OpenAI/Codex, hermit/local/Ollama, with gardener reserved generically.
- Covers compatibility reads, schema versioning, unit/count/state migration, rollback gates, no-double-running invariant, fleet rollout, and acceptance tests.

Validation: auction/reputation passed 33/33. Existing worker-spine test: 75 pass, 1 pre-existing hermit claim-history failure.

Self-improvement: nothing this time.
