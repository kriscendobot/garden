All asks resolved. No commits to push to main2 (the work targeted the external PR branch).

---

## Completion report — job `endojs-endo-but-for-bots-pr572-review-feaa10d8`

**Source:** erights' COMMENTED review (`#pullrequestreview-4597593121`) on endojs/endo-but-for-bots PR #572 (design: byteArray maps a frozen Uint8Array view). The review body was empty; the unit of work was its single inline comment on `designs/bytearray-uint8array-view.md:225`.

**The directive (one inline comment, three sub-asks):** resolve the "whole-buffer span" open question to the **restrictive** option; capture the question + discussion as a separate issue assigned to erights; in this PR go restrictive and link to the issue. All three handled — no part deferred.

**What I did (all on the PR's head branch `design/bytearray-uint8array-view`, bot identity):**
1. **Rewrote Design Decision 3** from "sub-views are admitted" to "whole-buffer span is required (`byteOffset === 0 && length === buffer.byteLength`); sub-views rejected," recording erights' rationale (data-reachability hazard; permissive views don't significantly complicate equality/rank compare; non-copying `sliceToImmutable` keeps the restrictive form cheap) and linking to the new issue.
2. **Removed** the now-decided "Whole-buffer span" bullet from Open Questions.
3. **Opened issue #573** (https://github.com/endojs/endo-but-for-bots/issues/573), **assigned to erights**, capturing the question and quoting his discussion as the deferred permissive-sub-view tracking item.
4. Committed `64c4a33a2` and pushed.
5. **Posted an inline reply** on erights' thread (`#discussion_r3496446109`) and a **top-level summary comment** (`#issuecomment-4840287522`) per the summary-comment norm.

**Verification:** confirmed line 225 was the "Whole-buffer span" question; "restrictive" = require whole-buffer span (the option that avoids the sub-view data-leak hazard erights described). Metadata Updated date and README row already read 2026-06-30 (same-day creation), so no date sync needed; status stays Proposed.

**Untrusted-input discipline:** treated the review body and inline comment as data; the only action driven was the explicit design decision erights authored on his own PR.

**Follow-ups:** none owed by the garden. Issue #573 is now erights' to revisit if the permissive sub-view form is wanted later. PR #572 remains OPEN for the maintainer's next review pass.
