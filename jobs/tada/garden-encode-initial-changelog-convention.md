Done. Inbox is empty and the worktree is torn down.

---

**Completion report**

Encoded kriskowal's new-package changelog/version convention (from the endojs/endo-but-for-bots#513 review directive) into the live v2 garden guidance, in both of the requested places. Committed on an isolated worktree off `origin/main2` (per the garden-infra-jobs convention, since the shared `/home/kris` tree is concurrently mutated), rebased, and pushed cleanly as `beede51e9` to `origin/main2`.

**What changed:**

1. **Builder guidance** — `skills/changeset-discipline/SKILL.md`: added a new **"New-package initial release"** section stating the fixed shape for a brand-new `@endo/*` package — empty stub `CHANGELOG.md` (the standard `# Change Log` + Conventional-Commits boilerplate, no hand-authored notes), `package.json` version `0.1.0` at creation, and a `major` changeset so the first published release is `1.0.0`; the "what this package is" prose belongs in the changeset body, not the changelog. Cites the `@endo/cancel` in-tree exemplar and the #513 provenance. Bumped `updated:` to 2026-06-26 and added a notes-from-the-field entry.

2. **Reviewer prohibition** — `roles/jurors/changeset-auditor/AGENT.md`: added a **"New-package initial-release shape"** bullet under Primary surface with three must-fix prohibitions (no hand-authored initial changelog; version must be `0.1.0`; changeset must bump `major`). Also resolved a previously-dangling citation — the seat already pointed at a `§ Bump level for new packages` section that never existed; both that reference and the "Be specific" example now point to the new `§ New-package initial release`.

**Follow-ups / notes:**
- The `@endo/cancel` exemplar lives in the endo project tree, not the garden repo, so I trusted the job spec's assertion rather than verifying it from the garden worktree.
- The `packager` seat (broader diff-hygiene/changeset-presence) was left unchanged — the `changeset-auditor` is the precise changeset-reviewing seat the directive named, and the packager already cross-cites it.
