---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. PR #97 (docs(claude-agents): reconcile design to root-only endowment amendment, branch design/claude-agents-root-endowment) now shows mergeable: CONFLICTING against main.

Cause: PR #87 (feat(claude): wire the Claude-agents capability behind ENDO_CLAUDE_ENABLED) just merged (commit 287af35, merge of 330fec4 + 8a0bf2b) and its own last-mile commit 330fec4 already applied a similar root-only-endowment rewrite to designs/claude-agents-capability.md — the same section PR #97 independently rewrote on its own branch three weeks ago. The two edits collide textually.

PR #97 is NOT simply superseded: diffing origin/design/claude-agents-root-endowment against origin/main on designs/claude-agents-capability.md shows #97 still carries real unlanded design content absent from what #87 merged — the delegate()/DelegatedClaudeAgents peer-delegation mechanism, the RootClaudeAccount/RootClaudeAgents privileged-naming convention, and a "§ Delegation to connected guests" section. Rebase PR #97 onto the new main tip (287af35), resolve the conflict by keeping #87's now-landed baseline prose and re-applying #97's genuinely additional delegation-mechanism content on top, then push. Do not close the PR; the content is real and still wanted.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T03:38:49Z
