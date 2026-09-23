---
ts: 2026-05-15T03:43:52Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/033302Z-result-liaison-2757e1.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 73
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#73` ("refactor(marshal): compareRankRemotablesTied for rank-cover ops") opens as a new **non-draft** PR on `endojs/endo`. The source is APPROVED by erights (Mark S. Miller, the original author of the underlying commit) at 2026-05-15T03:38:39Z — five minutes before the user's ferry ask. Approval from the original author of the substance is the strongest readiness signal; non-draft is the right shape (in contrast to the workflow-iteration ferries earlier this session, which opened as drafts to let CI settle).

This is a **multi-author** ferry — different from every other ferry this session. The PR salvages the rank-comparison refactor from the original `endojs/endo#2871` (erights), separating it from the codec-admission core which has its own home in `endojs/endo#3226` / fork's `#57`. The two commits are:

1. `c0740c16 refactor(marshal): compareRankRemotablesTied for rank-cover ops` — author `Mark S. Miller <erights@gmail.com>` (original, 2026-04-30). Preserve attribution; do **not** rewrite to Kris Kowal.
2. `6d52eef1 refactor(marshal,patterns): rank-cover ops default to compareRankRemotablesTied (#73)` — author `Kris Kowal <kriskowal@kriskowal.com>` (follow-up, 2026-05-01). Preserve attribution; do **not** rewrite (the email differs from the boatman default `kris@cixar.com` but it is a valid human identity the user has used historically, not a bot identity).

Strip the `(#73)` bot-internal source-PR-number suffix from commit 2's subject during a no-author-change amend. Commit 1's body contains a bot-internal `/ bots#57` reference; rewrite to drop just that fragment (the surrounding `endojs/endo#2871` / `endojs/endo#3226` references are upstream-equivalent and stay).

**Source**: `endojs/endo-but-for-bots#73`, branch `kriskowal-rank-order-remotables-tied`, head `6d52eef18a7bd739ffbc3eb658357929b8d3a8a8`. State OPEN, non-draft, MERGEABLE, APPROVED by erights. CI: 26 SUCCESS / 0 FAILURE. Base on `master` at `c513f1ab` (older than the recent `c2fc02eb8` baseline; the boatman will compute the diff against current upstream master).

**Upstream**: new branch on `endojs/endo`. Boatman picks (sensible default: `kriskowal-rank-order-remotables-tied` mirrors the source). Target base: `master` (currently `0ec70c6dd`-ish; the boatman fetches).

**Human(s)**: Mark S. Miller `<erights@gmail.com>` (commit 1, preserved) and Kris Kowal `<kriskowal@kriskowal.com>` (commit 2, preserved). **identity_switch_authorized: true** for pushing under the kriskowal GitHub credentials.

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-rank-order-tied-73--20260515-034342--73cdf1/`. Project worktree on `endojs/endo:master`.

**Boatman direction**:

- Cherry-pick **both** commits (`c0740c16` then `6d52eef1`) onto current `origin/master`. Preserve as two commits.
- **Do not** rewrite either commit's author. Cherry-pick + `git commit --amend --no-edit` (no `--reset-author`) for any subject/body edits needed.
- **Commit 1 body edit**: drop the `/ bots#57` fragment from the first paragraph, leaving the surrounding `endojs/endo#3226` reference intact. Use `git commit --amend -m '<rewritten body>'` or an interactive rewrite; preserve all other content verbatim. **Author stays as Mark S. Miller**.
- **Commit 2 subject edit**: strip the `(#73)` bot-internal source-PR-number suffix. The new subject is `refactor(marshal,patterns): rank-cover ops default to compareRankRemotablesTied`. Body untouched. **Author stays as Kris Kowal `<kriskowal@kriskowal.com>`**.
- **Strip bot trailers** from both commit bodies. Inspect for `🤖 Generated with [Claude Code]`, `Co-authored-by`, etc. — preliminary inspection shows the commit bodies are clean (the bot trailer is only on the PR body), but verify with `git interpret-trailers --parse` per commit before pushing.
- **Identity-switch push**: `git push origin HEAD:<new-branch>` under kriskowal credentials. Verify with `gh auth status`. The push happens under kriskowal even though the commits are authored by mixed identities — that's the boatman's standing pattern.
- **Open the upstream PR (non-draft)** via `gh pr create -R endojs/endo --base master --head <new-branch> --title <new> --body <new>`. Compose per `pr-formation`:
  - Title: keep source title `refactor(marshal): compareRankRemotablesTied for rank-cover ops` — already upstream-native.
  - Body: endo PR template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Behavior over diff. **Substantive Refs to keep**: `endojs/endo#2871` (original PR being salvaged), `endojs/endo#2883` (tracking issue), `endojs/endo#3226` (companion codec-admission PR). **Bot bookkeeping to drop**: the `(this fork's #57)` parenthetical references, the test-plan checklists, the `🤖 Generated with [Claude Code]` trailer. The "salvaged from #2871" framing is substantive and stays.
- Source-side cross-link comment on `endo-but-for-bots#73`: post under kriskowal (only authenticated identity on this host). Name the upstream PR URL, head SHA, and that both commits' authors are preserved.
- Identity discipline: no direct comments on the new upstream PR. If an explanatory comment is warranted (e.g., to thank erights for the approval and to flag that the upstream PR carries the original two-commit attribution), route via `message`-to-`steward`.

**Expected report** (≤350 words): upstream PR number + URL + head SHA, two new commit SHAs in order with their preserved authors confirmed, attribution verified (commit 1 erights, commit 2 kriskowal@kriskowal.com), source-side cross-link URL, title chosen + body-per-`pr-formation` confirmation, steward-message path if any, one-line `Self-improvement: ...`. If blocked (cherry-pick conflict, attribution-rewrite confusion, etc.), `message`-to-liaison and stop.
