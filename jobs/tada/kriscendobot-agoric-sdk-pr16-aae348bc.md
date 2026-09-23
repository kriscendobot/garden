Done. Let me write the completion report.

## Completion report

**Job:** attention directive on kriscendobot/agoric-sdk PR #16 (self-improvement note from maintainer dckc, comment `4965987380`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved this).

**What the directive was:** dckc noted "for self-improvement" that he hoisted documentation from an internal `//` comment up to the API JSDoc "where it belongs." The maintainer had already made the code fix on the PR; the job was to route the lesson into durable garden guidance, not to edit the PR.

**Routing decision:** This is a *doc-placement* review norm. The canonical owner is the **archivist** juror, whose primary surface is already "is new behavior documented in the JSDoc of new exports, and do existing comments/JSDoc still describe the code." The lesson is a distinct, actionable placement finding it did not yet carry. Per the self-improvement threshold, one vivid, maintainer-sourced observation is enough to add an operating-norm bullet to an existing role.

**What changed:**
- `roles/jurors/archivist/AGENT.md` — added a should-fix operating-norm bullet: *API documentation belongs in the export's JSDoc, not buried in an internal `//` comment.* It flags internal comments that document a public export's contract (behavior, caveats, param/return meaning) and recommends hoisting them into the JSDoc, while explicitly excepting genuine implementation notes / local invariants / TODOs. Provenance cites dckc's comment. Bumped the `updated:` frontmatter to 2026-07-14.
- Committed with explicit pathspec, rebased and pushed to `main2` (CAS push succeeded first attempt).
- Posted a `+1` reactji on the source comment (permitted-experimentation fork; endorses the path and signals the note was absorbed).

**Follow-ups (not done, optional):** The lesson could also be added author-side to the `builder`/`fixer` roles so the pattern is prevented at generation, not just caught at review. I held to the single most-relevant home (the review seat) to avoid role bloat on one observation; a second engagement's evidence would justify widening. Note this norm is judgment-only — unlike `no-comment-banners` it can't be a deterministic pre-push gate (you can't grep for "this comment should be JSDoc").

Self-improvement: `roles/jurors/archivist/AGENT.md`; encoded dckc's JSDoc-over-internal-comment note as an archivist should-fix norm. My own run had no separate gotcha — nothing else this time.
