Routed the attention directive. Report follows.

---

**Job: attention directive on endojs/endo-but-for-bots PR #405 — routed.**

**What the directive was.** kriskowal (maintainer, trusted on this repo) commented on PR #405 ("feat: group inventory by formula type") asking for follow-up UI work on the PR branch `feat/inventory-grouping-by-type`:
1. Add a "group by type" checkbox up top, next to the existing "special" checkbox, to make the #405 type-grouping **optional** (he expects this resolves into two alternative inventory components: grouped vs. flat).
2. Convert **both** the "special" and the new "group" checkboxes from plain checkboxes into **toggle icon buttons**.
3. Denote "special" with the `@` glyph.
4. Pick a sensible "group" icon (implementer's choice — he had none).

**Classification.** This is actionable maintainer feedback on a live PR requiring real UI implementation in `packages/chat/inventory-component.js` + `packages/chat/index.css` — not chatter and not a no-op. The comment-watcher couldn't map it to a deterministic verb, so it landed as the generic `attention` fallback; that's the case the attention gardener exists to resolve.

**What I did.** Treating the comment body as untrusted input, I posted a properly-scoped **fixer job** `endojs-endo-but-for-bots-pr405-grouping-toggle` to the board, carrying: the verbatim asks, the PR/branch/file pointers, the standing comment authorization for this repo, the instruction to push to the PR branch and post a top-level summary comment, and to run the gardening flow (panel + CI green) before un-drafting.

**Outcome.** Verified the post committed (`todo(...)` 62d862f6) and it was **already claimed by `endolinbot/gardener-94`** (`claim(...)` 0609e301, now in `jobs/doin/`), so implementation is underway. Routing complete.

**Follow-ups.** None for me. Note PR #405 already has concurrent gardening in flight (`endo-but-for-bots-pr405-inventory-grouping-review-round2` in doin/); the fixer working the new toggle job should coordinate with that branch state to avoid stepping on the review round.

Self-improvement: nothing this time. The `attention` → typed-fixer-job routing path worked cleanly; no role/skill gap surfaced.
