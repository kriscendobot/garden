---
ts: 2026-05-15T01:14:06Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/15/011141Z-dispatch-liaison-2b6168.md
---

# Result: rsvp #N added as respond-to-feedback synonym

Maintainer's framing 2026-05-15: *"A new verb for the liaison: rsvp means 'Please respond'."*

## Files revised

- `roles/liaison/AGENT.md` § Vocabulary § Compound chain idioms: appended `rsvp #N` to the existing respond-to-feedback row (alongside *carry feedback from #N* / *respond to feedback on #N* / *respond in kind on #N*). The row's disposition cell now carries the maintainer's framing and notes that bare "rsvp" without a number resolves to the most recently named PR in context. Frontmatter `updated` bumped to 2026-05-15.
- `roles/steward/AGENT.md` § Vocabulary § Compound chain idioms: mirrored the addition onto the steward's matching row, with the same framing citation. Frontmatter `updated` already 2026-05-15.

`CLAUDE.md` § Orchestrator vocabulary does not carry the respond-to-feedback row in its glossary table (it only mentions *carry feedback from #N* in prose listing what the role files cover), so no edit there.

## Commits on main

1. `e8e3f1c` — liaison vocabulary: rsvp #N as synonym for respond-to-feedback
2. `7a9c4a7` — steward vocabulary: mirror rsvp #N synonym from liaison

Pushed `7a9c4a7` to `origin/main`.

## Confirmation

The next "rsvp #N" prompt (or bare "rsvp" in a recently-named-PR context) routes through the existing respond-to-feedback disposition: liaison or steward dispatches a fixer to read PR #N's inline-review threads, address each (code change or thread reply with rationale), push, watch CI. No new skill or procedure: rsvp is purely lexical.

Self-improvement: nothing this time.
