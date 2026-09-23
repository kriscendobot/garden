Reply posted (comment id 3513868282), inbox is empty. The work is complete.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #591 (review 4614733828 by @erights).

**Preflight:** `pr-feedback-preflight.sh` exited 0 (PROCEED) — no peer had resolved this feedback.

**Scope enumerated:**
- Review body: empty (COMMENTED state, no top-level ask).
- Inline comments tied to the review: exactly one — `packages/far/README.md:14`, @erights asking "Why these leading `>` markdown blockquotes?"

**Resolution:** The `@endo/far` deprecation notice (added by this PR's parent commit) had its entire body wrapped in a markdown blockquote (`>`). A blockquote implies a quotation, but this text is the README's own primary content, so the markers were inappropriate. Treated the reviewer's rhetorical question as a directive to unwrap it.

**Change:** Removed the leading `>` blockquote markers from the deprecation notice in `packages/far/README.md`, leaving the identical prose, code fence, and `[543]` link reference as normal markdown. No content changed — formatting only (12 insertions, 12 deletions).

**Commit & push:** `397ee471e docs(far): unwrap the deprecation notice out of a blockquote`, pushed to PR head branch `refactor/inter-package-far-remove` (44590be94..397ee471e) with a rebase-CAS push loop (clean on first push).

**Thread reply:** Posted a reply to the inline comment (id 3513868282) citing the fixing commit and explaining the rationale.

**Prompt-injection discipline:** The review body and inline comment were treated strictly as data. The comment contained an `@kriscendobot` mention — ignored as untrusted content, not acted on as an instruction.

**Follow-ups:** None. The PR remains an intentional DRAFT (deferred per its own commit message until confidence that no outstanding importers depend on the removed re-exports); that is unrelated to this review and out of scope.
