---
ts: 2026-05-15T01:11:41Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener adds "rsvp" verb to the liaison vocabulary

Dispatch root: `dispatches/gardener--2b6168/`. Garden-meta only.

## Maintainer directive

2026-05-15: *"A new verb for the liaison: rsvp means 'Please respond'."*

## Semantics

"rsvp #N" / "rsvp" is a one-word synonym for the existing "respond to feedback on #N" / "carry feedback from #N" / "respond in kind on #N" cluster in the compound-chain-idioms category. Same disposition: dispatch a fixer to read the inline-review threads on PR #N, address each (code change or thread reply with rationale), push, watch CI.

Used as:
- "rsvp #247" → dispatch fixer to respond to inline feedback on #247.
- "rsvp on the agoric PR" → dispatch fixer to respond on the named PR.
- "please rsvp" (in the context of a recently-named PR) → dispatch fixer on that PR.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/liaison/AGENT.md` § Vocabulary, `roles/steward/AGENT.md` § Vocabulary, `CLAUDE.md` § Orchestrator vocabulary.

2. **Update `roles/liaison/AGENT.md` § Vocabulary** — add "rsvp" as a recognized synonym in the existing compound-chain-idioms row for respond-to-feedback. Don't author a new row; the existing row already covers the disposition.

   Existing row (from gardener `319706` earlier today):
   > **carry feedback from #N** / **respond to feedback on #N** / **respond in kind on #N** — fixer applies inline-review feedback on the bot-side mirror.

   Updated row should read (gardener's call on exact wording):
   > **carry feedback from #N** / **respond to feedback on #N** / **respond in kind on #N** / **rsvp #N** — fixer applies inline-review feedback on the bot-side mirror.

3. **Mirror onto `roles/steward/AGENT.md` § Vocabulary** if it carries the same row.

4. **Update `CLAUDE.md` § Orchestrator vocabulary** if it carries the respond-to-feedback glossary entry (likely not; the glossary table is the smaller subset).

5. **Cite the maintainer's framing** in a notes-from-the-field row (or fold into the existing one from `319706`).

## Out of scope

- No new skill (the procedure is the existing respond-to-feedback fixer shape).
- No new role.
- No edit to other vocabulary entries.

## Commits

- One commit per substantively-revised file (likely just `roles/liaison/AGENT.md` and possibly `roles/steward/AGENT.md`).

Push at end. Journal result entry.

## Report

≤ 150 words: files updated, one-line confirmation the next "rsvp #N" prompt routes to a fixer, one-line `Self-improvement: ...`.
