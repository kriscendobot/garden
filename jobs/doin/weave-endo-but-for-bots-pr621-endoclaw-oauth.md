# Weave endojs/endo-but-for-bots #621 — refine endoclaw-oauth design — back onto fresh `llm`

PR: https://github.com/endojs/endo-but-for-bots/pull/621 (OPEN, not draft).

State (2026-07-13): all 5 CI checks GREEN, but `mergeable: CONFLICTING` — the head
has drifted behind `llm` and now conflicts (the PR touches `designs/*.md`; expect a
documentation-level conflict, not code). It is the deepest node of the
`@endo/exo-google-sheets` dependency tree (design PR #612, merged) and everything
downstream — the OAuth exo, `@endo/google-sheets`, `@endo/exo-google-sheets` — is
blocked on it landing.

Task: **weave / rebase #621 onto current `origin/llm`, resolve the conflict(s),
preserve the net design intent (the head already addresses kriskowal's 2026-07-10
review incl. the 16:42 caretaker-attenuation directive — do NOT drop those
revisions), push the resolved head, and confirm CI returns green.** Do NOT re-open
design questions or alter substance; this is a conflict-resolution/refresh pass so
the PR is mergeable the moment the maintainer re-reviews.

Note: a stale `CHANGES_REQUESTED` from kriskowal (2026-07-10 15:59) still stands but
the head (last commit 2026-07-10 16:56) post-dates his final comment — that is a
re-review gap for the maintainer, NOT something to address by changing the design.
External-repo etiquette: this is the endojs/endo-but-for-bots fork the garden already
works; standard fork push, no upstream-branch pushes.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  claimed_at: 2026-07-13T19:07:44Z
