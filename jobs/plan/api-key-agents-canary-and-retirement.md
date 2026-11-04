---
gate: awaiting-maintainer
maintainer_question: 'After phases 1-5 land behind apiKeyGuestAgents: may the bot run the production canary (phase 6) with the minion/claude-api-canary-key, and what are the answers to the parent design''s open questions (Agent SDK retention as @endo/claude vs renamed plugin; legacy migration window; bulk delegated-subtree provider attachment; garden inference sourcing; deprecation interval before deleting @endo/agent-mcp-stdio and CLI exports)? These gate migration (phase 7) and retirement steps 5-9.'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1543#pullrequestreview-5761476590
priority: normal
posted_by: endojs-endo-but-for-bots-pr1543-review-ed16aaac
posted_at: 2026-11-04T01:48:18Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: API-key agents production canary, legacy migration, and Claude-CLI retirement

Remainder of the #1543 designs (`designs/api-key-inference-providers-and-pinned-agents.md` phases 6-7; `designs/claude-bare-course-correction.md` § Independently shippable sequence steps 4-9) after orchestration `orchestrate-build-api-key-agents-20261104` lands phases 1-5. These involve a production canary with a real key, irreversible credential revocation, and deletions whose shape depends on the parent design's unanswered § Open questions, so they wait for the maintainer.
