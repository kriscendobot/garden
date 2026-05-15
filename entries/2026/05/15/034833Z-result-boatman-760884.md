---
ts: 2026-05-15T03:48:33Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/15/034352Z-dispatch-liaison-73cdf1.md
---

Ferried `endojs/endo-but-for-bots#73` (rank-order refactor, two-commit, two-author) to `endojs/endo#3265` (non-draft, OPEN, head `337d16a895066a66e7c92d716449273d337dceb9`, base `master`, branch `kriskowal-rank-order-remotables-tied`). URL: https://github.com/endojs/endo/pull/3265.

Two new commits in order on the upstream branch:

1. `45d06cd16` `refactor(marshal): compareRankRemotablesTied for rank-cover ops`. Author preserved: `Mark S. Miller <erights@gmail.com>`. Committer: `Kris Kowal <kris@cixar.com>` (local identity on the amend). Body edit: removed the `/ bots#57` fragment from the first paragraph; the surrounding `#3226` reference and the `Refs: endojs/endo#2883` trailer are intact. `git interpret-trailers --parse` reports only the `Refs:` trailer.
2. `337d16a89` `refactor(marshal,patterns): rank-cover ops default to compareRankRemotablesTied`. Author preserved: `Kris Kowal <kriskowal@kriskowal.com>`. Committer: `Kris Kowal <kris@cixar.com>`. Subject edit: stripped the `(#73)` suffix. Body edit: stripped the `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` trailer (the dispatch's preliminary inspection said the body was clean, but the trailer was present; the boatman role norm requires stripping it). `git interpret-trailers --parse` now reports only the `Refs:` trailer.

Per-commit author verification (final `git log origin/master..HEAD --pretty=fuller`):

- Commit 1: `Author: Mark S. Miller <erights@gmail.com>`, `Commit: Kris Kowal <kris@cixar.com>`.
- Commit 2: `Author: Kris Kowal <kriskowal@kriskowal.com>`, `Commit: Kris Kowal <kris@cixar.com>`.

Source-side cross-link comment: https://github.com/endojs/endo-but-for-bots/pull/73#issuecomment-4456715929 (names upstream URL, head SHA, and confirms the two authors are preserved per commit).

Title chosen: `refactor(marshal): compareRankRemotablesTied for rank-cover ops` (kept source title, already upstream-native). Body composed per `skills/pr-formation/SKILL.md`: fetched the `endojs/endo` PR template at `master` and filled the Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade sections in prose; no checklists; no file-by-file callouts; behavior over diff. Substantive refs kept (`#2871`, `#2883`, `#3226`); bot bookkeeping dropped (the `(this fork's #57)` parenthetical, the test-plan checklists, the Claude Code trailer). The "salvaged from #2871" framing is in the Description as the upstream reviewer's hook.

No steward-message drafted: erights approved the source-side PR five minutes before this dispatch and the salvage-and-ferry is clean, so no explanatory comment is required on the upstream PR.

Self-improvement: the dispatch prompt's "preliminary inspection shows the commit bodies are clean" assertion was wrong (commit 2 carried the Claude `Co-Authored-By` trailer); the boatman did the right thing by also running `git interpret-trailers --parse` per step 7 and stripping it. Worth a note in any future `pr-handoff` skill: trust the role's standing trailer-strip discipline over a dispatch prompt's preliminary inspection. Routes to `message` to liaison for skill-creation consideration.
