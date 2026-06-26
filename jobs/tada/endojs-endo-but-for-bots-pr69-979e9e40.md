Inbox is empty; scratch clone removed. Work complete.

---

**Completion report — endojs-endo-but-for-bots-pr69-979e9e40**

**Directive:** erights left a `COMMENTED` review on PR #69 ("fix(pass-style): treat document.all-like values as objects") with two inline comments, both asking the same thing: clarify that `document.all` is not only the only *known* JS value with the `[[IsHTMLDDA]]` internal slot, but the only value the **current TC39 spec permits** to have it.

**What I did** (folded both comments into one fix, per the "fetch all comments tied to a review" discipline):
- Edited `.changeset/pass-style-document-all.md` — added a sentence stating `document.all` is the only known JS value with the slot and the only value the current TC39 spec (Annex B `[[IsHTMLDDA]]`) permits to have it.
- Edited the regression-test comment in `packages/pass-style/test/passStyleOf.test.js` (the second anchor) with the same clarification, reflowed to keep the comment block's line width.
- Committed `990f470d` and pushed to `design/issue-3156-pass-style-document-all`.

**Verification:** change is comment/changeset prose only — no logic touched. `npx prettier --check` passes on both files.

**Communication** (repo standing authorization covers commenting on endojs/endo-but-for-bots):
- Inline reply on the changeset thread (`#discussion_r3478870642`).
- Inline reply on the test thread (`#discussion_r3478870687`).
- Top-level summary comment citing head SHA and what changed (`#issuecomment-4805976299`).

**Follow-ups:** none required. CI re-runs automatically on the push; PR was already non-draft and mergeable. No further dispatch needed unless erights requests more.

**Self-improvement:** nothing this time.
