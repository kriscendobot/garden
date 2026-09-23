All work complete. Inbox empty, worktree torn down.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #544 (review 4597187458 by erights, a COMMENTED review).

**What the review asked:** The review body was empty (COMMENTED state); it carried one inline comment on `designs/intra-package-plain-re-exports.md` line 187 (the *Examples in the current tree* → "Barrel reach-back" example). erights's point (treated as untrusted data): the reach-back rule is more general than `./index.js` or barrels — it applies to **every module a package's `package.json` `"exports"` map reaches**, all of which are public API surface that this refactor must **not change or deprecate**.

**What I did** (executed the design refinement directly — it was a single tightly-scoped wording reframe to a design-only doc):
- Generalized the "**Barrel reach-back**" example to "**Declared-export reach-back**" over every `"exports"`-named module (the barrel `./index.js` reframed as merely the most common such entry).
- Added explicit text that only the importer edge moves: the declared-export module reached through is public API, so it stays **unchanged and undeprecated**, and the removal pass never touches/deprecates/repoints any module the `"exports"` map names.
- Verified no other narrow barrel-only framing remained — Corollary 1, the *What the rule does not touch* section, and the `export *` open question already generalized over the full `"exports"` map; the example was the lone holdout and now matches them.

**Changed / pushed:**
- Commit `6c81706de` on branch `design/intra-package-plain-re-exports` (pushed to endojs/endo-but-for-bots; CAS push clean off `f50ec6ba7`).
- Inline thread reply: `#discussion_r3496106763`.
- Top-level summary comment: `#issuecomment-4839794986` (per the standing summary-comment norm).

**Notes/follow-ups:**
- Design-only PR (still DRAFT); no source modules move. The mechanical repoint-and-remove pass remains the explicit follow-up PR.
- PR reports `mergeable: false` against base `llm` — pre-existing, unrelated to this content change; the maintainer/weaver handles base reconciliation if/when this un-drafts.
- No garden `main2` changes were needed (external-repo review-directive job).
