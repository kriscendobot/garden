---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Add a top-level harness x provider matrix to designs/provider-model-catalog.md
(rows: anthropic/openai/local-ollama/ollama-cloud/moonshot/fireworks/openrouter/
google-gemini; columns: claude/codex/kimi/opencode), consolidating what's already
scattered across the doc's later sections plus designs/opencode-alternate-harness.md.

Source: `hand-off.md`, a research hand-off written on the bare host this session
(not inside the container, so it never touched the journal) mapping every
harness the fleet could run against every inference provider. Read it in full
before starting — it has the drafted matrix, the per-cell sourcing, and the
reasoning behind each ✅/🔬/❓/— marking. If it's since been cleaned up from the
garden root, its content is reproduced in this job's sibling postings
(`probe-opencode-anthropic`) and the liaison's own summary of it survives in
this session's transcript; ask the liaison if you can't locate it.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-01T21:06:31Z
