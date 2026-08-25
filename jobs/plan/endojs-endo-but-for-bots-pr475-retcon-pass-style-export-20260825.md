---
gate: deferred
priority: high
role: fixer
posted_by: gardener
posted_at: 2026-08-25T22:00:47Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Retcon endojs/endo-but-for-bots PR #475 after the current review-fix round. Group deletion of packages/pass-style/pass-style-of.js with removal of the corresponding packages/pass-style/package.json export and the related changeset/test262-runner adjustments in one package-scoped commit, as directed in review 5024525935 comments 3857723669 and 3857736605. Preserve the net tree and keep yarn.lock in its separate commit.
