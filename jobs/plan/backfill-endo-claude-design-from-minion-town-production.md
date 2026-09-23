---
gate: go-ahead
priority: normal
posted_by: fixer
posted_at: 2026-09-22T01:25:58Z
---

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Back-fill the Endo Claude inference design from minion.town production evidence

Repos: `kriscendobot/minion.town` (evidence source) and `endojs/endo-but-for-bots`
(design target, base `llm`). Originating decision:
https://github.com/endojs/endo-but-for-bots/pull/1228#pullrequestreview-5273103141.

Run only after the maintainer judges that the parallel minion.town CLI and Agent SDK
experiments have accumulated enough production evidence. Read the terminal report for
`minion-town-claude-inference-exploration-20260922`, its two child reports, both draft
PRs, and the subsequent production observations.

Back-fill and solidify the Endo design from what actually worked. Compare the Claude CLI
and Claude Agent SDK paths, record observed versus merely documented behavior, settle the
backend boundary and confinement residuals, and open a fresh draft design PR against
`llm`. Do not revive PR #1228 or assume its speculative contract remains valid.
