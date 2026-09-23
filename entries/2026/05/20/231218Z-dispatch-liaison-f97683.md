---
ts: 2026-05-20T23:12:18Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/214742Z-result-liaison-410186.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 329
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#329` ("docs: introduce spackle, the polyfill+ponyfill race pattern") opens as a **non-draft** PR on `endojs/endo`. Documentation port — adds `docs/spackle.md` (a new article) plus a `typedoc.json` projectDocuments entry.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #329.
- Branch: `docs/spackle`
- Base: `llm` at `37dce60e`
- Head: `a9624e71c75dd2267a35417ef54fbfaa6fc93c8c`
- State: OPEN, non-draft, MERGEABLE, **CHANGES_REQUESTED** addressed by commits 2 and 3. CI: 20 SUCCESS / 5 unknown.
- Three commits, all `endolinbot <main.barn5084@fastmail.com>`:
  1. `398eb22c docs: introduce spackle, the polyfill+ponyfill race pattern` (original, 2026-05-20T21:36Z)
  2. `edb1b06f docs(spackle): address kriskowal review on #329` (bot-side review feedback)
  3. `a9624e71 docs(spackle): apply maintainer suggestion on Conclusion section` (more review feedback)

The source body claims "direct port of the article authored on the endo side at `kriscendobot/endo@8848cb052:docs/spackle.md`; the bytes are verbatim". That commit exists on `kriscendobot/endo` as an orphan (not on any branch), so the bot's personal fork is not a viable ferry target. Ferry to `endojs/endo` directly.

## Upstream (NEW PR)

- Repo: `endojs/endo`. Target base: `master` (`bf951df346cfcf605a6709e6a5479f2fdd526113` after fresh fetch; advanced one commit beyond `ec3dcbc0` from earlier this session).
- New branch: boatman picks (sensible default `kriskowal-spackle-docs`).
- Two files: `docs/spackle.md` (new) and `typedoc.json` (one-line insertion of `"docs/spackle.md"` in `projectDocuments`).

## Human

`Kris Kowal <kriskowal@kriskowal.com>` (current default). **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-spackle-329--20260520-231206--f97683/`. Project worktree on `endojs/endo:master` (detached at `bf951df3`).

## Boatman direction

- **Squash to 1 commit**. The 3 source commits represent an original + 2 review-feedback rounds; the review cycle is bot-internal (kriskowal reviewing the bot's PR before ferry). Upstream reviewers should see the final shape as a single commit. Use the squash sub-procedure surfaced on the #3268 squash (`entries/2026/05/18/235615Z-result-liaison-a71656.md`):
  - Detach at `origin/master` (`bf951df3`).
  - `git cherry-pick --no-commit 398eb22c..a9624e71` to stage the combined diff.
  - `git commit -m '<subject>' -m '<body>'` with the composed message.
- **Subject**: `docs: introduce spackle, the polyfill+ponyfill race pattern` (verbatim from commit 1 — already upstream-native).
- **Body**: compose per `pr-formation`'s commit-message discipline. Take the substantive content from the source PR body (the spackle pattern definition, the polyfill+ponyfill+race-discipline framing, the eval-twins-problem motivation, the rule of three, `@endo/harden` as canonical instance, the typedoc companion change). **Drop**:
  - The bot-internal `kriscendobot/endo@8848cb052` reference (orphan commit; not upstream-visible).
  - The `endojs/endo-but-for-bots#329` self-reference.
  - The "bytes are verbatim" framing (bot-bookkeeping).
  - Any `(#329)` source-PR-number suffix and any bot trailers.
- **Tree-identity check** (per the squash sub-procedure): `git diff a9624e71 HEAD -- .` should be empty after the squash + amend. Verify.
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- `git commit --amend --reset-author --no-edit` to set author + committer to the new default.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always.
- Verify with `git log origin/master..HEAD --pretty=fuller`: one commit, `Kris Kowal <kriskowal@kriskowal.com>`.
- Push to a fresh upstream branch.
- **Open the upstream PR as non-draft** via `gh pr create -R endojs/endo --base master --head <new-branch> --title <new> --body <new>`.

### PR title and body

- **Title**: `docs: introduce spackle, the polyfill+ponyfill race pattern` (source's title is already upstream-native).
- **Body**: compose per `pr-formation` using the endo PR template's section headings verbatim (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Read `.github/PULL_REQUEST_TEMPLATE.md` in the project worktree to confirm the headings.
  - **Description**: the spackle pattern in behavior-and-intent prose. Cite `@endo/harden` as the canonical instance. Note the eval-twins motivation and the rule-of-three deciding criterion.
  - **Documentation**: confirm the typedoc.json projectDocuments addition wires the article into the rendered docs.
  - **Security / Scaling / Testing / Compatibility / Upgrade**: docs change; mostly N/A.
  - No `#329` / `endo-but-for-bots#329` references. No "bytes are verbatim" framing. No checklists. No file-by-file callouts beyond `docs/spackle.md`.

- **Source-side cross-link comment** on `endojs/endo-but-for-bots#329`: post under kriskowal. Name the upstream PR URL, head SHA, and confirm the 3-commit squash to 1.
- **Identity discipline on `endojs/endo`**: NO direct comments on the new upstream PR.

## Out of scope

- No changes to source-side PR #329.
- No comments posted directly on the new upstream PR.
- The orphan `kriscendobot/endo@8848cb052` commit is left as-is (not a branch; not in scope).

## Expected report

≤300 words:
- Upstream PR number + URL + head SHA + new commit SHA, non-draft confirmed.
- Squash + tree-identity verification.
- Attribution verified (`kriskowal@kriskowal.com`).
- Source-side cross-link URL.
- New title + body-per-`pr-formation` confirmation.
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
