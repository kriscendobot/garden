---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 305
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-20T00:34:00Z
last_appended_at: 2026-05-20T00:34:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#305

Created from the code-panel verdict (17 seats, in-band fallback) on the chat-edit-message-ui PR (`feat/chat-edit-message-ui`, stacked on PR #125 `feat/edit-message`). The PR delivers the three coordinated entry points (focus-mode `e`, hover pencil, `/edit-message` slash) from `designs/chat-edit-message-ui.md`. Three deferrals warrant revisit when the PR (or its upstream mirror) merges.

## Items

- [ ] **Slash-command surface unification (design open question 1)**.
  **Source juror(s)**: integrator, curator, archivist.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR that adds a dispatch shim on `/edit` picking the `edit-message` entry when the first argument parses as a `BigInt`-coercible number and falling back to the existing blob `edit` entry otherwise. The maintainer resolved open question 1 as "overload `/edit` on referent type"; this PR ships `/edit-message` and the `editmsg` alias as the interim form. Retire the `editmsg` alias once the overload lands.

- [ ] **Revision-history panel (design open question 2 and § Surfacing edit history)**.
  **Source juror(s)**: archivist, integrator.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR for the click-to-open revision panel that calls `messageHistory(number)` and renders the revision array oldest-first with the current revision marked. Only the inline `edited <timestamp>` caption ships in this PR; the rich panel is the deferred surface. The design's middle-ground option (always show "edited" but only expose the revision panel for messages that were ever settled and then re-edited) is a candidate framing for the follow-up.

- [ ] **Chip locator restoration (Design Decision 4)**.
  **Source juror(s)**: locksmith, integrator.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR that reconstructs the embedded-token chip from `names` plus the resolved locator on edit-form preload, rather than using the edge name as the placeholder. The current preload uses `@<edgeName>` markers so the user can re-pick references; the design's contract is that the chip carries the underlying locator (which the inventory's pet name is orthogonal to). Add one test that pins round-trip preservation of the chip's identity across an edit.
