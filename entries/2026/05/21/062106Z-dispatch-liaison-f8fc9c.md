---
ts: 2026-05-21T06:21:06Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/061720Z-dispatch-liaison-6c7e30.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 68
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#68` ("docs(ses): document Compartment availability and OOM limits (#2742)") opens as a **non-draft** PR on `endojs/endo`. Documentation PR closing upstream issue `endojs/endo#2742`. Dispatched in parallel with #67 (`entries/2026/05/21/061720Z-dispatch-liaison-6c7e30.md`).

## Source

- Repo: `endojs/endo-but-for-bots`, PR #68 (OPEN, non-draft, MERGEABLE, **CHANGES_REQUESTED** addressed).
- Branch: `design/issue-2742-compartment-limits-doc`
- Head: `838d18ff9bae5bd6d16032efb8f0c575e079ef68`
- 5 commits:
  1. `8a1fc626 docs(ses): document Compartment availability and OOM limits (#2742)` — `Kris Kowal <kriskowal@kriskowal.com>` (2026-04-29).
  2. `59957425 docs(ses): address review on Compartment limits doc (#2742)` — `Kris Kowal <kriskowal@kriskowal.com>` (2026-05-01).
  3. `cb8d6286 docs(agents): add prose style rule banning em-dashes` — `Kris Kowal <kriskowal@kriskowal.com>` (2026-05-01). **OFF-TOPIC**: touches `AGENTS.md`, not related to the Compartment OOM issue. **Exclude from this ferry.** Endojs/endo does have an AGENTS.md, so a separate ferry of just this commit could land it upstream later if the user wants — but it's not in scope for the #2742 issue closure.
  4. `f299f8e4 docs(ses): add timing side-channels section to Compartment limits (#2742)` — **`Kriscendo Bot <noreply@anthropic.com>`** (Anthropic identity, 2026-05-08). Rewrite to `Kris Kowal <kriskowal@kriskowal.com>` during the amend.
  5. `838d18ff docs(ses): cite Agoric taxonomy paper in timing side-channels section (#68)` — `Kris Kowal <kriskowal@kriskowal.com>` (2026-05-12). Has `(#68)` bot-internal suffix to strip; `(#2742)` is correctly an upstream reference (keep that part as `endojs/endo#2742`).

The `(#2742)` references in commit subjects 1, 2, 4 refer to upstream `endojs/endo#2742` — upstream-correct, keep in the squashed commit's subject.

## Upstream (new PR)

- Repo: `endojs/endo`. Target base: `master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`).
- New branch: boatman picks (sensible default `kriskowal-compartment-oom-docs-2742`).

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-compartment-oom-68--20260521-062055--f8fc9c/`. Project worktree on `endojs/endo:origin/master` (detached at `bf951df3`).

## Boatman direction

- **Cherry-pick commits 1, 2, 4, 5** (skip 3). Squash to one.
- Detach at `origin/master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- `git cherry-pick --no-commit 8a1fc626 59957425 f299f8e4 838d18ff` to stage the combined diff (skipping commit 3).
- `git commit -m '<subject>' -m '<body>'` with the composed message.
- **Composed subject**: `docs(ses): document Compartment availability and OOM limits (#2742)` — verbatim from commit 1; `(#2742)` is the upstream issue reference, upstream-correct. The squash subsumes commits 2, 4, 5 (review feedback, timing side-channels section, Agoric taxonomy citation).
- **Composed body**: take the substantive content from the source PR body about Compartment availability + OOM limits. Include the timing-side-channels section content (from commit 4's diff) and the Agoric-taxonomy citation context (from commit 5's diff) — both are substantive additions. **Drop**:
  - Any test-plan checklists.
  - Any `endo-but-for-bots#68` references.
  - The "address review" framing from commit 2 and the `(#68)` suffix from commit 5 (both subsumed by the squash).
  - Any bot trailers (`🤖 Generated with [Claude Code]`, `Co-Authored-By: Claude` — commit 4 by Kriscendo Bot likely carries such trailers).
- **Off-topic commit handling**: commit 3 (`cb8d6286 docs(agents): add prose style rule banning em-dashes` on AGENTS.md) is **explicitly excluded**. Do not cherry-pick it. **Surface in your result entry** that this commit was skipped and remains available on the source PR for a possible separate ferry.
- **Tree-identity check**: since we're excluding a commit, the tree at HEAD will NOT match the source's head `838d18ff` (because the AGENTS.md changes from commit 3 won't be present). Instead, verify the equivalent tree: `git diff 838d18ff HEAD -- . ':!AGENTS.md'` should be empty (the only difference should be the AGENTS.md changes from commit 3). Confirm this is the case.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always. Particularly important for commit 4 by Kriscendo Bot.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows one commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
- Push the new branch via `git push origin HEAD:refs/heads/<new-branch>` (fully-qualified `refs/heads/` form for first-push).
- **Open the upstream PR as non-draft**.

### PR title and body

- **Title**: `docs(ses): document Compartment availability and OOM limits (#2742)`.
- **Body**: compose per `pr-formation` using endo's PR template section headings. Include `Fixes #2390` ... actually `Fixes #2742` (upstream issue) as a closing keyword.

- **Source-side cross-link comment** on `endojs/endo-but-for-bots#68`: post under kriskowal. Name the upstream PR URL, head SHA, that commits 1+2+4+5 were squashed to 1, that **commit 3 was excluded as off-topic** (AGENTS.md edit; not related to #2742), and that `Fixes #2742` was added.

- **Identity discipline on `endojs/endo`**: NO direct comments on the new upstream PR.

## Out of scope

- No changes to source-side PR #68.
- Commit 3 (`cb8d6286`) is explicitly excluded.
- No comments posted directly on the new upstream PR.

## Expected report

≤350 words:
- Upstream PR number, URL, head SHA, new commit SHA, non-draft.
- Squash + tree-identity verification (with the AGENTS.md exclusion note).
- Attribution verified (`kriskowal@kriskowal.com`).
- Source-side cross-link URL.
- Title chosen + body-per-`pr-formation` confirmation.
- Push-mode (first-push `refs/heads/` form).
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
