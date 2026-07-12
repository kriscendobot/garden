---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr678-review-d461c045
verdict: not-a-miss
category: new-direction
pr: 678
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/678#pullrequestreview-4680247381
identity: endojs/endo-but-for-bots#678:review:4680247381:retro
---

# Dismissal: "rename search-powers.js" is naming direction on a fresh module

kriskowal's CHANGES_REQUESTED review on #678 (review `4680247381`) carried an
**empty body** and a **single inline comment** anchored on
`packages/platform/src/fs-node/`: a request to rename `search-powers.js`
(verbatim untrusted text at `comment_url`). The primary loop
(`endojs-endo-but-for-bots-pr678-review-d461c045`) confirmed the effect — the
`fs-node/` directory now holds `search.js` with no `search-powers.js`, i.e. the
maintainer wanted the `-powers` qualifier dropped from a module the PR's
`fs`→`fs-node` reorganization freshly created.

## Grounds (not-a-miss — naming taste on a freshly-authored file)

This is a preference call on the name of a **new** module, made mid-reorg, and no
standing garden rule bound on the axis that produced it:

- **It is not the abbreviation pattern.** The only encoded naming check is the
  `avoid-name-abbreviations` cluster (closed; a tier-1 spell-out-identifiers gate
  plus builder/fixer/stylist directives). That fires on *shortened* identifiers
  (`dir`, `Arg`, `subDir`). `search-powers.js` is the opposite — a fully-spelled,
  *longer* name — so that gate correctly abstains and did not miss.
- **No module-name convention prohibits a `-powers` qualifier.** `search-powers.js`
  is a defensible, idiomatic Endo name (a module exporting the search *powers*
  object that bundles ambient authority). `rename-discipline` governs keeping
  *gratuitous* renames out of a diff and warns against export-stutter renames of
  *existing* base files; it says nothing about which name a newly-created module
  should carry. Nothing in the ergonomist seat, the stylist seat, or any skill
  encodes "drop qualifier suffixes like `-powers` from filenames."
- **The choice between `search-powers.js` and `search.js` is the maintainer's
  architectural taste** for how the new `fs-node` powers layout names its modules
  — a requirement first stated in this review comment. A panel could not have
  anticipated the specific preference; both names are reasonable. New direction.

Recorded as a durable dismissal so this rename comment is never re-litigated. It
mints no cluster and is unrelated to the `catch-all-error-swallow` cluster that
#678's other review (`4680172450`, primary base
`endojs-endo-but-for-bots-pr678-review-4d666bb1`) contributed a correctness miss
to.
