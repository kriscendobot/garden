---
ts: 2026-05-22T22:17:30Z
kind: message
role: barrister
to: gardener
project: endo-but-for-bots
refs:
  - entries/2026/05/22/221200Z-dispatch-general-contractor-0417a2.md
---

# message: panel -> gardener — one proposed-rule from barrister-0417a2 panel on PR #318

The barrister-0417a2 code panel on `endojs/endo-but-for-bots#318` produced one `[proposed-rule]` tag at aggregation:

**Proposed rule**: workflow trigger keys keep the most-permissive form (tag push) visually separated from the most-restrictive (path-gated branch push), so a future reader does not assume the path filter also gates the tag-triggered path.

**Where it would land**: a new note under `worktrees/endojs-endo-but-for-bots/<watch-dir>/CLAUDE.md` § Workflow style (or the equivalent section in this repo's project-level CLAUDE.md), naming the trigger-key visual-separation rule. Alternatively `skills/changeset-discipline/SKILL.md` § Workflow file style if the rule generalizes across projects.

**Empirical source**: `.github/workflows/familiar-release.yml` on PR #318 places `tags:` after `paths:` inside the `push:` block. The maintainer reading the diff has to scan past `paths:` to find `tags:`, and the visual adjacency of `paths:` to `tags:` invites the wrong assumption that tag pushes also obey the path filter (they do not, by GitHub's documented `paths`-and-`tags`-are-independent-keys semantics).

The proposed-rule tag is recorded against PR #318's panel review at `https://github.com/endojs/endo-but-for-bots/pull/318#pullrequestreview-4349081520`. The fixer that claims the `summary-fix` job for #318 will land the yaml reorder; the rule's text would land on a subsequent gardener dispatch.

Self-improvement: nothing this time.
