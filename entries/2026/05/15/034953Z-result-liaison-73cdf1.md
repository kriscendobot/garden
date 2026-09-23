---
ts: 2026-05-15T03:49:53Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/034352Z-dispatch-liaison-73cdf1.md
  - entries/2026/05/15/034833Z-result-boatman-760884.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 73
    role: source
  - repo: endojs/endo
    pr: 3265
    role: target
---

First-time ferry of `endojs/endo-but-for-bots#73` opened as `endojs/endo#3265` (non-draft).

- Upstream PR: https://github.com/endojs/endo/pull/3265, `isDraft: false`, branch `kriskowal-rank-order-remotables-tied`, head `337d16a895066a66e7c92d716449273d337dceb9`.
- **Per-commit author preservation confirmed** (liaison-side verification via `gh api .../commits/...`):
  - `45d06cd16` `refactor(marshal): compareRankRemotablesTied for rank-cover ops` — author `Mark S. Miller <erights@gmail.com>` preserved (committer `Kris Kowal <kris@cixar.com>` from the amend; that asymmetry is intentional and correct). The `/ bots#57` fragment dropped from body.
  - `337d16a89` `refactor(marshal,patterns): rank-cover ops default to compareRankRemotablesTied` — author `Kris Kowal <kriskowal@kriskowal.com>` preserved (committer `Kris Kowal <kris@cixar.com>`). The `(#73)` suffix stripped from subject.
- **Important catch from the boatman**: the dispatch prompt's preliminary inspection claimed commit 2's body was clean, but `git interpret-trailers --parse` found a `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` trailer that the boatman role's standing trailer-strip discipline caught and removed. The liaison's preliminary inspection (via `gh api commits/<sha>` looking at the first 20 lines of the body) missed it because the trailer was further down. **Lesson**: trust the boatman role's `git interpret-trailers --parse` over the dispatch prompt's pre-inspection; do not claim "preliminary inspection shows clean" in future dispatches unless the liaison itself runs the same verifier the boatman uses.
- Title: kept source title `refactor(marshal): compareRankRemotablesTied for rank-cover ops` — already upstream-native.
- Body rewritten per `pr-formation`: endo template sections, behavior over diff. Substantive Refs kept (`endojs/endo#2871`, `endojs/endo#2883`, `endojs/endo#3226`); bot bookkeeping dropped (`(this fork's #57)` parentheticals, test-plan checklists, `🤖 Generated with [Claude Code]` trailer).
- Source-side cross-link on #73: [issuecomment-4456715929](https://github.com/endojs/endo-but-for-bots/pull/73#issuecomment-4456715929), posted under kriskowal.
- No steward-routed comment on the upstream side (erights's APPROVED on the source-side 5 min before this dispatch makes an explanatory comment unnecessary).

This is the first **multi-author** ferry of the session — different shape from every prior ferry, and the boatman handled the preservation cleanly (no `--reset-author`, per-commit body/subject edits with explicit author retention). Worth landing as a documented case in the eventual `skills/pr-handoff/SKILL.md`.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: two notes for the queued gardener follow-up on `skills/pr-handoff/SKILL.md`:
1. **Multi-author commits**: the salvage-and-ferry pattern (preserve original author when the source commit is itself a salvage of another human's work) is a real and distinct shape from the standard kriskowal-rewrite case. The procedure differs (no `--reset-author`; `--amend --no-edit` for body edits, or explicit `--author=` if a subject/body rewrite is needed). Worth a dedicated sub-section.
2. **Trailer-strip discipline trumps preliminary inspection**: the dispatch prompt's "preliminary inspection shows clean commit bodies" reading was wrong on this ferry — a Claude Code co-author trailer hid below the body's first paragraph. The boatman role's standing `git interpret-trailers --parse` discipline is the canonical check and should not be undermined by liaison-side pre-claims of cleanliness.
