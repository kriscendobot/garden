Done. The norm is encoded and pushed to `origin/main2`.

---

**Completion report: encode-pr-summary-comment-norm**

**SHA:** `08a0e1fa` on `origin/main2` (rebased clean atop `d455c51b`; no contention).

**What I did.** Encoded the standing communication norm from maintainer feedback on PR #474: after a feedback-driven push to a PR, the doer must post a *top-level summary comment* (head SHA, what changed mapped to SHAs, what was declined and why, verification status) in addition to any inline thread replies. Inline-only replies and silent pushes are explicitly not enough.

**Where it landed.**
- **New skill** `skills/pr-completion-summary-comment/SKILL.md` — writes the rule once: the comment shape, that it is REQUIRED not optional, the authorization gating (standing on `endojs/endo-but-for-bots`; relocated to the completion report when commenting is unauthorized, never skipped), and pitfalls. References (does not duplicate) `pr-review-thread-replies` and `review-feedback-followup-commits`.
- **Roles** cite the skill: `fixer` (skills list + a strengthened definition-of-done making the summary required), `builder`, `weaver`, `shepherd`, `conductor`, `botanist`. For weaver/shepherd/conductor I also strengthened the External-repo etiquette clause so that *when commenting is authorized*, the summary is required rather than optional. The botanist's existing structured verdict comment is named as its form of the completion summary.
- **`roles/COMMON.md`** § External-repo etiquette gains a fleet-wide "Standing communication norm: the completion summary comment" paragraph, honoring the endo-but-for-bots standing comment authorization and pointing at the new skill.
- **Juror check:** the `scribe` seat (process-oriented communication/knowledge-capture closure) now reads for *completion-summary closure* — flags any maintainer directive/review that drew a responding push but no top-level summary comment (the exact #474 gap). Default disposition `summary-fix`. Updated its purpose line and added the dedicated norm.
- Added `pr-completion-summary-comment` to the CLAUDE.md skills inventory. Bumped `updated:` frontmatter to 2026-06-25 on all edited docs.

**Verification.** Style-checked: no em-dashes or Latin shorthand in the added prose (the grep hits are all pre-existing COMMON.md lines). Relative-path links verified per file depth. Built in an isolated worktree off `origin/main2`, committed explicit pathspecs, pushed `HEAD:main2`, worktree torn down.

**Follow-ups.** None required. The scribe's new check is advisory within the panel loop; if the maintainer wants silent-push detection enforced earlier (at the gardener/triager stage rather than at panel time), that would be a separate job. Inbox was empty throughout.

Self-improvement: nothing this time — the existing skills already named the top-level summary as a close-out step; the gap was that it read as optional rather than required, which this change fixes directly.
