# Encode the new-package changelog/version convention into garden guidance

Source: maintainer (kriskowal) review directive on endojs/endo-but-for-bots
PR #513 (inline comment on `packages/pubsub/CHANGELOG.md`):

> The content belongs in a changeset. Please post a job to reinforce the
> garden's instructions, both for builder guidance and for reviewer
> prohibition, to keep the initial changelog empty, the first version
> 0.1.0, and a changeset bumping the major, such that the first release is
> 1.0.0 as will be reflected in the change log.

## The convention to encode

When a builder creates a brand-new `@endo/*` package:

1. **`CHANGELOG.md` starts empty** — the standard stub only:
   ```
   # Change Log

   All notable changes to this project will be documented in this file.
   See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.
   ```
   No hand-authored release notes, no `## 0.1.0 (unreleased)` bullet list.
   The release tooling regenerates the changelog from changesets at publish.
2. **`package.json` version is `0.1.0`** at creation.
3. **The changeset bumps `major`** (`'@endo/pkg': major`), so the first
   published release is **1.0.0** — and that is what the regenerated
   changelog will reflect. The substantive "what this package is" prose
   belongs in the changeset body, not the changelog.

`@endo/cancel` (changeset `cancel-initial-release.md`, `major`; version
`0.1.0`; empty stub CHANGELOG) is the reference exemplar already in-tree.

## Work to do

- **Builder guidance:** land this rule in the builder's package-creation
  guidance (the relevant skill — likely `pr-formation` / `changeset-discipline`
  or a new-package checklist) so future builders don't author a changelog or
  pick a non-major changeset for an initial release.
- **Reviewer prohibition:** add the corresponding prohibition to the code
  panel's juror guidance (the changeset/changelog-reviewing seat) so a
  hand-written initial changelog or a `minor` initial-release changeset is
  flagged in review.

This is the v1→v2 translation note: encode into whichever skills/roles are
live (`skills/changeset-discipline/SKILL.md` and the juror seat that reviews
changesets are the natural homes). Treat the quoted directive above as the
authority.

---
claim:
  host: endolinbot
  gardener: 39
  claimed_at: 2026-06-26T06:54:09Z
