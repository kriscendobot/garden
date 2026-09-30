---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix endojs/endo-but-for-bots PR #1343 per kriskowal CHANGES_REQUESTED review

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1343
(head `issue982-build-special-names`, likely on the kriscendobot fork — check
`gh pr view 1343 --json headRepositoryOwner`; base `feat/daemon-provisioning-grants-5feadae`, draft).
Review: https://github.com/endojs/endo-but-for-bots/pull/1343#pullrequestreview-5360774903

Asks (resolve every one; reply to each inline thread with the resolving commit):
1. Review body: the VALUE side of endowments must use a pet-name or pet-name-path
   shape (not a bare string / formula id shape).
2. packages/daemon/src/provision/shapes.js:71 (comment 4140238467) — "Have we
   obviated the `introducedNames` property?" Determine; if obviated by the
   endowments mechanism, remove it (breaking is fine); answer in-thread either way.
3. packages/daemon/src/provision/shapes.js:72 (comment 4140239342) — "Can the value
   side be a pet name path?" Yes: accept a pet name path there (per ask 1).
4. packages/daemon/src/host.js:1918 (comment 4140243642) — make a BREAKING change:
   collapse special-name endowments and ordinary introduced names into one
   collectively named `endowments` option, partitioned by the `@` prefix on the key
   (keys beginning with `@` are special names, others are ordinary pet names).
   Rename `endowSpecialNames` accordingly and update the PR body, tests, types,
   and any docs/CLI that reference the old names.

Out of scope here (separately posted as job ebfb-petname-path-only): removing
bare pet-name acceptance across the whole Exo surface. Keep this PR's value side
compatible with that direction (prefer arrays of path components).

Run packages/daemon tests + lint:types + test:types before pushing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T05:14:53Z
