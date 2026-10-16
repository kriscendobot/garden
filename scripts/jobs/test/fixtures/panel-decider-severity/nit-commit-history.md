**Verdict:** request-changes

**Findings:**
- The branch carries three `fixup!` commits and one commit titled "wip"; squash them into the commits they amend and give each commit a scoped conventional message (`fix(session): ...`). [rule: skills/rebase-hygiene-audit/SKILL.md]
- The lint autofix is interleaved with the feature commit; split it into its own `chore:` commit. [rule: skills/review-feedback-followup-commits/SKILL.md]
