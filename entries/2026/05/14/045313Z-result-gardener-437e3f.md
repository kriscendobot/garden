---
ts: 2026-05-14T04:53:13Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/14/044729Z-dispatch-liaison-abf387.md
---

Encoded three recurring patterns from kriskowal's review of endojs/endo#3232.

Files edited:

- `skills/changeset-discipline/SKILL.md`: added a *What goes inside* section. Four rules: one changeset per PR per release cycle (consolidate fix-ups, do not stack); keep the body current as the PR evolves (a stale interface description is worse than none); omit implementation detail not interesting to a dependency updater; no process commentary in the published release notes. Notes-from-the-field row cites comment IDs 3239062983, 3239064618, 3239067688, 3239068864, 3239072009.
- `skills/rename-discipline/SKILL.md` (new). Default is *do not rename*; the rename earns its place in the diff only when carrying information (wrong-against-behavior name, load-bearing shadow, project naming guide, or rename-is-the-PR). Names test-local-binding renames and feature-PR "cleanup" passes as the common failure modes. The "this was better when named X" review comment is a revert, not a defense. Notes-from-the-field cites 3239081576 and 3239082370.
- `skills/regression-evidence/SKILL.md`: added an *Equivalence claims need a backing test* section. When a comment, JSDoc, or doc claims one form is "equivalent to" another, that is a load-bearing contract a future contributor will rely on; assert it with the strongest comparator available and run the same break-and-revert demonstration as for any regression test. Notes-from-the-field cites 3239085874.
- `roles/builder/AGENT.md`: `## Skills` adds the rename-discipline citation; the regression-evidence and changeset-discipline lines gain one-line annotations for the new content.
- `roles/fixer/AGENT.md`: `## Skills` adds rename-discipline (revert, not defend) and a changeset-discipline annotation (sweep the existing changeset in the fix commit, do not add a second).
- `roles/weaver/AGENT.md`: `## Skills` adds rename-discipline (conflict resolution does not invent fresh renames).
- `CLAUDE.md`: inventory adds `rename-discipline`.

Patterns encoded:

- Gratuitous rename pattern -> new `skills/rename-discipline/SKILL.md`; cited from builder, fixer, weaver.
- Changeset hygiene pattern (four sub-rules) -> extended `skills/changeset-discipline/SKILL.md`; builder and fixer carry an updated one-line annotation.
- Equivalence assertion pattern -> extended `skills/regression-evidence/SKILL.md`; builder and fixer carry an updated one-line annotation.

The kriskowal comment 3223144963 (break the chacha12 test-package cycle via a hex-test sibling) is a one-off observation, not a pattern across engagements, and was not encoded; the cycle-break is project-specific and belongs in a journal entry if it recurs.

Commit `8f3c690` landed on `main` and was pushed.

Self-improvement: nothing this time. The dispatch's three patterns were enumerated up front, each landed in a single skill, and the role citations were one-line annotations exactly as the dispatch said. No new gardener-side lesson surfaced.
