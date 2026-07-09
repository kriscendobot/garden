---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-mount-ext-rebuild-orch-127
priority: normal
posted_by: producer
posted_at: 2026-07-09T18:51:34Z
---

---
role: fixer
---

# Close PR #127 (final step of the reconstruction)

Repo: endojs/endo-but-for-bots. Precondition: the four reconstruction PRs
(`feat/mount-revocation`, `feat/mount-glob`, `feat/mount-grep`,
`feat/mount-json`) are all OPEN — verify with `gh pr list` before acting; if
any is missing, report the gap instead of closing.

Post a closing comment on https://github.com/endojs/endo-but-for-bots/pull/127
cross-linking the four replacement PRs and design PR #648
(`designs/mount-extensions-reconstruction.md`), then close #127 (do not
delete its branch). Authorization: the maintainer's 2026-07-09 review on #127
("Create fresh PRs and close this") is the lifecycle directive; per the
project's standing authorizations it is self-authorizing.
