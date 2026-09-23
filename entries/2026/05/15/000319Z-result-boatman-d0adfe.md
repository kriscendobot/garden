---
ts: 2026-05-15T00:03:19Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/14/235802Z-dispatch-liaison-02ccd8.md
---

Ferried `endojs/endo-but-for-bots#255` (`ci/ocapn-guile-interop-resilience-ii`, head `ed9ba7296df131a1b5530e6138654e4363ba68d7`) to upstream as a draft pull request.

- Upstream PR: https://github.com/endojs/endo/pull/3262 (draft, OPEN)
- Upstream branch: `kriskowal-ocapn-guile-interop-resilience-ii`
- Upstream head SHA: `407d25c5b7c7a1f91fbb13f91c9807ab8f3a07d1`
- Base: `master` at `05823033d` (master moved by 4 commits during preparation; none touched the workflow file).

Application path: cherry-picked the single source commit onto `origin/master` with `--no-commit`, then committed under `Kris Kowal <kris@cixar.com>` for both author and committer. The diff applied cleanly; the two recent "Claude"-authored hygiene commits in `.github/workflows/ocapn-guile-interop.yml` (`bab98d8e` `persist-credentials: false`, `93f57b34` action-pin bumps) touch different blocks of the file than the substituer-ordering and timeout changes, so no manual reconciliation was required.

Attribution verified: `git log origin/master..HEAD --pretty=fuller` shows `Kris Kowal <kris@cixar.com>` as both Author and Commit; `git interpret-trailers --parse` reports zero trailers; no `Co-authored-by`, no `Generated with Claude Code`, no bot author.

PR body composed per `pr-formation`: upstream PR template headings verbatim (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade), behavior-over-diff prose, no checklists, no file callouts. The fork-only `Refs: #82` from the source body was translated to `Follow-up to 246c6a6c` (the upstream-equivalent commit by Kris Kowal, 2026-05-02). The draft state was set explicitly via `gh pr create --draft`; the body's Testing section names the reason for the draft (a slow-substitute day on the bot-side workflow will validate before the maintainer flags for review).

Source-side cross-link comment: https://github.com/endojs/endo-but-for-bots/pull/255#issuecomment-4455705374 (posted under `kriskowal`; only `kriskowal` is authenticated on this host. The boatman role permits direct posting on `endo-but-for-bots` because it is the garden's own repo, and the dispatch explicitly authorized the cross-link.)

No upstream-side explanatory comment was drafted; this is a first-time ferry without prior reviewer interaction, and the body sections already carry the reasoning.

Self-improvement: the dispatch prompt specifies "post a brief comment under the bot identity" for the source-side cross-link, but this host has only `kriskowal` authenticated. The discrepancy did not block the work (the role permits direct comments on the garden's own repo), but a future dispatch prompt could either name the fallback identity explicitly or omit the "bot identity" framing for source-side comments. Worth a `message`-to-liaison if the same gap shows up in another boatman dispatch; one occurrence is below the structural-lesson threshold.
