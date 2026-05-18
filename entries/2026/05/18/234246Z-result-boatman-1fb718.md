---
ts: 2026-05-18T23:42:46Z
kind: result
role: boatman
worktree: dispatches/boatman--ferry-drop-node-20-280--20260518-233223--8c1a6e/project
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/18/233237Z-dispatch-liaison-8c1a6e.md
---

Ferried the Node-20-drop additions from `endojs/endo-but-for-bots#280` to `endojs/endo` as a stacked PR atop Turadg's open `ta/node-matrix` branch (`endojs/endo#3084`).

- Upstream PR: [endojs/endo#3268](https://github.com/endojs/endo/pull/3268)
- Head: `kriskowal-drop-node-20` at `5153162b719799aa4a939e6b85d8389304edcbc3`
- Base: `ta/node-matrix` (confirmed; not `master`)
- State: OPEN, non-draft
- Title: `chore(ci): drop Node.js 20 from the test matrix` (stacked relationship to `#3084` lives in the base ref and the body's opening paragraph; no parenthetical "on top of #3084" in the title)

New commit SHAs in order on the upstream branch:

1. `46687badc` — `chore(ci): drop Node.js 20 from the test matrix` (= source commit `2ec645b45` rewritten to Kris Kowal; body untouched)
2. `5153162b7` — `ci: preserve Node 20 SES-viable patch history` (= source commit `c040dc77e` rewritten to Kris Kowal; subject stripped of the `(per kriskowal review on #280)` bot-internal suffix; body untouched)

Source commit `d652c222` (Turadg's Node 18 drop, cherry-picked into the bot-side branch from `#3084`) was deliberately not re-applied: it is already present on the upstream base branch where it originated.

Attribution verified with `git log origin/ta/node-matrix..HEAD --pretty=fuller`: both commits show `Author: Kris Kowal <kris@cixar.com>` and `Commit: Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` on each commit body returned empty (no `Co-authored-by`, no `Generated with [Claude Code]`, no other bot trailers).

Cherry-pick required conflict resolution because the bot-side branch's commits were authored against master, and `ta/node-matrix` is 323 commits behind master at this writing (the known `ta/node-matrix` ↔ master conflict on `#3084`, declared out of scope for this dispatch). Each matrix-collision block resolved as "drop Node 20 from the post-Node-18-drop matrix": HEAD's `[20.x, 22.x]` or `[20.x]` collapses to `[22.x]`. The `ocapn-guile-interop.yml` workflow file does not exist on `ta/node-matrix` (deleted in an earlier upstream commit that is not yet on the stale branch), so commit 1's modification of that file was discarded. The `test-ocapn-python` job is already unpinned on `ta/node-matrix` (kept HEAD's unpinned form rather than re-introducing the 22.x pin commit 1 wanted). The `test-async-hooks` block was the substantive merge: HEAD's `'18'` entry survives, and commit 3's restored Node-20 historical comment block lands above the auto-merged `'22'` entry, yielding the intended commentary lineage.

PR body (per `skills/pr-formation/SKILL.md`): the endo PR template's seven section headings are used verbatim (Description, Security Considerations, Scaling Considerations, Documentation Considerations, Testing Considerations, Compatibility Considerations, Upgrade Considerations); no checklists; no file-by-file callouts; behavior over diff; the `#3084` relationship is framed as "stacked on, together they drop both Node 18 and Node 20" rather than "supersedes"; the bot-side `endojs/endo-but-for-bots#260` flake report is translated to "the Node-20 `test-xs (macos-15)` lane was filed as flaky on the bot side" (no fork-side issue number); `engines.node` is called out as out of scope.

Source-side cross-link comment: [endojs/endo-but-for-bots#280#issuecomment-4483190134](https://github.com/endojs/endo-but-for-bots/pull/280#issuecomment-4483190134) names the upstream PR URL, head SHA, the stacked-on-#3084 framing, and that Turadg's commit was not re-applied.

Steward-message: not drafted. The "stacked on `#3084` by intent; merge after `#3084`" framing is covered by the PR body's opening sentences and the PR's base ref. A separate comment from the steward would duplicate without adding for the upstream reviewer.

Self-improvement: surfaced a fourth boatman procedure shape, "stacked on an open upstream PR" (target base is a topic branch like `ta/node-matrix`, not `master`); the conflict-shape implication is that whenever the topic branch is N commits behind master, the cherry-picked commits will conflict on each line the topic branch touched, and the resolver applies the source intent to the topic-branch tree; routed as a `message`-to-`liaison` for the gardener's `entries/2026/05/15/045644Z-message-liaison-73cdf1.md` brief.
