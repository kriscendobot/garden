---
posted_at: 2026-11-18T00:18:10Z
role: builder
arc: endo-ocapn-background
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: wire @endo/skills into Lal (endopi-skills-markdown-format, delta 5)

Repo: https://github.com/endojs/endo-but-for-bots. Design: https://github.com/endojs/endo-but-for-bots/pull/1672 (`designs/endopi-skills-markdown-format.md` on head `design/endopi-skills-markdown-format`). Library PR: https://github.com/endojs/endo-but-for-bots/pull/1643 (head `endopi-skills-markdown-format`).

Predecessor job `build-endopi-skills-markdown-format` implemented deltas 1-4 and 6 on #1643: `endo-skills-setup`, `@endo/skills/mount.js` (`loadAgentSkills(powers)`, pet-name locations), `formatSkillsForPrompt(skills, { readHint })`, and stricter validation. What is left is **delta 5, wiring Lal (`packages/lal`)**. Push it to the #1643 head branch (preferred: one PR), or open a stacked draft PR on top of it.

- Load skills once each time the agent starts (incarnation) through `loadAgentSkills(powers)`, and append `formatSkillsForPrompt(skills, { readHint })` to the system prompt. Lal's `readHint` tells the model to use `readText(<location minus SKILL.md>, "SKILL.md")` and to resolve relative references against the skill's directory path.
- Follow `agent-skills` with `followNameChanges`. When an entry is added or removed, reload; the new list applies at the **next** round's prompt, never the current round's.
- Cap the list at 200 skills in precedence order, and log a warning for the rest. Diagnostics go to Lal's log, never to the model.
- In the inbox loop, run `/skill:<name> [args]` through `expandSkillCommand`, rereading the current body. An unknown name replies to the sender with an error and runs no model round. A `disable-model-invocation` skill still expands by command. The transcript records the expanded text as an ordinary user message.
- Tests: the design's § Test plan Lal rows, plus a mount source checked against a scratch daemon if that is feasible.

Report a gap rather than weaken a property the design requires. Successful completion stages the gauntlet for #1643.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-18T00:29:21Z
