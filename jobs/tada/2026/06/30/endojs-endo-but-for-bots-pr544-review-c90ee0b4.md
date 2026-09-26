Inbox empty, worktree cleaned up. Work complete.

---

**Completion report — job `endojs-endo-but-for-bots-pr544-review-c90ee0b4`**

**Review handled:** erights' COMMENTED review (#pullrequestreview-4597095247) on endojs/endo-but-for-bots PR #544 (draft design "intra-package plain re-exports rule"). The review body was empty; it carried one inline comment (id 3496014677) on `designs/intra-package-plain-re-exports.md:61`, in the *What the rule does not touch* section. That was the entire unit of work — no other inline comments tied to the review.

**The ask (single directive):** the public API surface is more general than barrels / `src/index.js` — it is every export listed in the package's `package.json` `"exports"` section, and the internal re-exports backing those declared exports must not be deprecated or removed, because there is nowhere else another package could import them from.

**What I did** (wore the designer hat directly, since this was one contained design-doc edit on a repo with standing comment authorization):
- Rewrote *What the rule does not touch* so the protected surface is the whole `"exports"` map (with `"."` → `src/index.js` as just the most common instance, not the definition), and stated explicitly that a declared-export module stays even when it is itself a plain re-export, and that the deprecate-then-remove staging never removes a re-export backing a declared export.
- Threaded the same declared-export gate through corollary 1 (reach-back), corollary 2 (`@endo/far`-analog re-bundler), the `evasive-transform/src/visitor.js` example, and the `export *` open question, so the removal pass cannot touch the public surface anywhere.
- Bumped the metadata `Updated` to 2026-06-30.

**Changes pushed:** commit `d87ab191b` on `design/intra-package-plain-re-exports` (+46/−24, documentation-only; no source modules move). Identity kriscendobot.

**Communication:** posted an inline thread reply (discussion_r3496033841) on erights' comment and a top-level summary comment (issuecomment-4839691043) naming the head SHA, the mapped changes, nothing declined, and the verification status. PR stays draft pending maintainer review of the rule.

**Follow-ups:** none. Inbox empty; project worktree removed.

**Self-improvement:** nothing this time — clean design-review-followup against an already-well-documented flow.
