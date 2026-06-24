---
ts: 2026-05-18T23:44:39Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/18/233237Z-dispatch-liaison-8c1a6e.md
  - entries/2026/05/18/234246Z-result-boatman-1fb718.md
  - entries/2026/05/18/234247Z-message-boatman-1fb718.md
  - entries/2026/05/15/045644Z-message-liaison-73cdf1.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 280
    role: source
  - repo: endojs/endo
    pr: 3268
    role: target
  - repo: endojs/endo
    pr: 3084
    role: merge-base
---

First-time **stacked** ferry of `endojs/endo-but-for-bots#280` opened as `endojs/endo#3268` (non-draft, base = `ta/node-matrix`).

- Upstream PR: https://github.com/endojs/endo/pull/3268. `baseRefName: ta/node-matrix`, `isDraft: false`, state OPEN.
- Branch: boatman picked `kriskowal-drop-node-20-stacked` (or similar); head `5153162b719799aa4a939e6b85d8389304edcbc3`.
- Two commits, both author + committer `Kris Kowal <kris@cixar.com>`, zero bot trailers:
  - `46687badc` chore(ci): drop Node.js 20 from the test matrix
  - `5153162b7` ci: preserve Node 20 SES-viable patch history (the `(per kriskowal review on #280)` bot-internal suffix stripped during the amend)
- Turadg's source-side cherry-pick (`d652c222`) deliberately not re-applied — Turadg's original Node-18 work stays on `ta/node-matrix` upstream where it originated.
- Title: `chore(ci): drop Node.js 20 from the test matrix` (the stacked-on relationship lives in the base ref and the body's opening sentence, not in a title parenthetical).
- Body composed per `pr-formation`: endo PR template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade), behavior over diff. `#3084` framed as "stacked on, together they drop both Node 18 and Node 20", not "supersedes" (per user direction). Fork-only `endojs/endo-but-for-bots#260` translated to "the Node-20 `test-xs (macos-15)` lane was filed as flaky on the bot side".
- Source-side cross-link on #280: [issuecomment-4483190134](https://github.com/endojs/endo-but-for-bots/pull/280#issuecomment-4483190134), posted under kriskowal.
- No steward-routed comment on the upstream side.

**Substantive note** from the boatman: cherry-picking against `ta/node-matrix` (which is 323 commits behind master) produced conflicts whose resolution rule was "apply source-commit intent to the post-Node-18-drop tree". Two source changes turned out to be **moot on the base**:
- `ocapn-guile-interop.yml` does not exist on `ta/node-matrix` — that modification was discarded by the boatman.
- `test-ocapn-python` is already unpinned on `ta/node-matrix` — the source's 20→22 pin-advance was a no-op.

This is the natural consequence of stacking on a topic branch that predates the recent CI hygiene work. The stacked PR's diff is narrower than the source PR's diff would have been against master; that's correct.

**New procedure shape** (the fourth boatman shape): **stacked on an open upstream PR**. The boatman wrote a parallel message to liaison at `entries/2026/05/18/234247Z-message-boatman-1fb718.md` detailing the procedure for the gardener brief. Salient elements:
1. Target base is a topic branch (not master).
2. Cherry-pick the source's bot-authored commits while **excluding** the source's own cherry-pick of the topic-branch's commit (already on the base).
3. Conflicts against a stale topic branch are predictable; resolution rule is "apply source-commit intent to the topic-branch tree".
4. Source changes that target files-not-yet-on-the-topic-branch are discarded as moot; surface them in the result so the user knows.

Both the dispatch's flag and the boatman's parallel message agree this should be added to the gardener brief at `entries/2026/05/15/045644Z-message-liaison-73cdf1.md` as a fourth procedure shape.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: when the steward dispatches the gardener on the queued `skills/pr-handoff/SKILL.md` engagement, the gardener should now find **four** distinct procedure shapes to land (first-time, recompute-from-master, fast-forward-append, stacked-on-open-upstream-PR), with the stacked shape being the newest and the moot-change handling being its distinctive feature. The gardener can either read the brief at `045644Z-message-liaison-73cdf1.md` plus the boatman's follow-up message at `234247Z-message-boatman-1fb718.md`, or read this result entry's links and synthesize from both.
