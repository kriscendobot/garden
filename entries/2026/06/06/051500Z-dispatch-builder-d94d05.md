---
ts: 2026-06-06T05:15:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--d94d05
refs:
  - entries/2026/06/06/050800Z-dispatch-researcher-ec33c4.md
  - entries/2026/06/06/051300Z-result-researcher-ec33c4.md
  - https://github.com/endojs/endo-but-for-bots/pull/257
---

# dispatch: builder — sync upstream master into bot llm via PR

User directive (2026-06-06, this terminal session): *"Please dispatch
a subagent to merge actual/master into bots/llm for a PR to merge the
branches, then shepherd that PR through CI."* "actual" =
`endojs/endo`; "bots" = `endojs/endo-but-for-bots`; "llm" is the bot
fork's roadmap branch. This dispatch covers the **merge + PR** half
of the directive; a follow-on shepherd dispatch will drive CI to
green on the resulting PR.

## State at dispatch time

- **Upstream master** (`endojs/endo@master`): `4a04d078`.
- **Bot master** (`endojs/endo-but-for-bots@master`): `5865ff10`
  (behind upstream master; the cycle's earlier fixer dispatch synced
  it but upstream has since moved). Not directly used by this
  dispatch; the merge source is upstream master, not bot master.
- **Bot llm** (`endojs/endo-but-for-bots@llm`): `2bd9e0cb`. 1290
  commits ahead of bot master in one direction, 7 in the other
  (standard llm-vs-master divergence).
- Twenty-plus open PRs target `llm` as their base; this sync PR will
  not affect them (they rebase onto whatever `llm` is when they're
  ready to merge).

## Library and project references

### Project context (endo-but-for-bots)

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Rules of engagement*: default branch for active development is `llm`; PRs land on `llm` and are merged with merge commits per repo settings (`merge_commit_title=PR_TITLE`, `merge_commit_message=PR_BODY` since 2026-05-10). Standing-monitor cadence is 30s.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Standing authorizations*: the garden's roles may post comments, reviews, review-comments, reactjis, and cross-references on `endojs/endo-but-for-bots` PRs without per-action authorization. Covers the builder posting the draft-PR body and any follow-up summary comment.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Upstream*: active branches `llm`, `garden`, `master`. `endo-upstream/master` is the local remote name for the canonical upstream master (`endojs/endo@master`); the dispatch's "actual/master" reads as that ref.

### Prior precedents for this exact operation

- [`entries/2026/05/15/005225Z-dispatch-liaison-2264a5.md`](../../entries/2026/05/15/005225Z-dispatch-liaison-2264a5.md): the first explicit *weave actual/master into llm* dispatch. Names the merge-commit form (`git merge endo-upstream/master --no-ff`), the conflict-resolution skill as authoritative, and the canonical sync-branch name `merge/actual-master-into-llm-YYYYMMDD`. Establishes that `endo-upstream` is the local remote name for `endojs/endo`.
- [`entries/2026/05/15/013547Z-result-liaison-2264a5.md`](../../entries/2026/05/15/013547Z-result-liaison-2264a5.md): the resulting PR was **#257** (`chore: merge actual/master into llm (2026-05-15)`), opened DRAFT against `llm` from branch `merge/actual-master-into-llm-20260515`. Body cited the weaver dispatch, the conflict-resolution surface, and the rationale for going via PR rather than direct push to `llm` (CI gates the validation). This is the canonical PR shape to copy.
- [`entries/2026/05/15/013716Z-result-weaver-2264a5.md`](../../entries/2026/05/15/013716Z-result-weaver-2264a5.md): the weaver's conflict-resolution highlights. The recurring conflict surface is `.github/workflows/*.yml`, root `package.json`, `packages/bytes/*`, `packages/bundle-source/package.json`, `packages/cli/package.json`, `packages/ocapn/src/*` and `test/*`, `packages/daemon/src/connection.js`, `packages/eslint-plugin/*`, `yarn.lock`. The eslint-plugin-import-x partial revert is documented as a deliberate llm divergence with rationale.
- [`entries/2026/05/17/214232Z-result-judge-df84b2.md`](../../entries/2026/05/17/214232Z-result-judge-df84b2.md): judge verdict on PR #257. Routine merge marker; un-drafted with 0 must-fix. The judge documents the diff scope as "no bot-side files (no `designs/`, no `.garden/`, no roadmap-specific paths)" and notes that a merge marker's panel kind is tiny-PR-variant (no jurors). Author of merge commit was `endolinbot` (bot identity, appropriate for an auto-resolved upstream merge).
- [`entries/2026/05/21/054802Z-result-weaver-7d7d5e.md`](../../entries/2026/05/21/054802Z-result-weaver-7d7d5e.md): second sync of this kind (no PR; direct push to `llm` of merge commit `b381e6ada`). Confirms the merge shape, documents rerere-captured pre-images from the 2026-05-15 sync that auto-resolved 19 of this run's 16+ conflicts. Surfaces the `ocapn-default-cbor` / `makeClient`/`registerNetlayer` API divergence that is out of scope for the merge but needs a follow-up builder; the same gap may resurface in this sync.
- [`entries/2026/06/03/011729Z-dispatch-liaison-496105.md`](../../entries/2026/06/03/011729Z-dispatch-liaison-496105.md) and [`entries/2026/06/03/012906Z-result-weaver-496105.md`](../../entries/2026/06/03/012906Z-result-weaver-496105.md): most recent precedent (three days before this dispatch). The weaver started with `git rebase origin/master`, hit yarn.lock and benchmark conflicts in the first 12 of 1072 replayed commits, **aborted, switched to merge**. Documents the explicit strategy choice and the canonical conflict-resolution list per file. The dispatch said "rebase" but the result shows that merge is the only viable shape for a 1290-commits-ahead branch.

### Relevant skills

- [`garden/skills/conflict-resolution/SKILL.md`](../../../garden/skills/conflict-resolution/SKILL.md): canonical for the per-file resolution decisions. The hard rule is no blind `--ours`/`--theirs`; read both sides and merge intents. The prior weavers' notes document the recurring resolutions; the builder may consult them but must verify each on current content.
- [`garden/skills/yarn-lock-separate-commit/SKILL.md`](../../../garden/skills/yarn-lock-separate-commit/SKILL.md): yarn.lock conflicts are skipped during merge and regenerated via `corepack yarn install` against the merged tree. On a merge-into-llm the lockfile changes ride in the merge commit itself by convention.
- [`garden/skills/pr-formation/SKILL.md`](../../../garden/skills/pr-formation/SKILL.md): standard PR-opening discipline (title, body shape, draft state). The PR body should cite the absorbed upstream tip (sha + headline), enumerate the conflicts the builder resolved, and note that CI is the validation gate.
- [`garden/skills/pre-pr-checklist/SKILL.md`](../../../garden/skills/pre-pr-checklist/SKILL.md) and [`garden/skills/pre-push-gates/SKILL.md`](../../../garden/skills/pre-push-gates/SKILL.md): pre-push gates run with `--summary` against the merged tree; pre-existing master findings are expected.
- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md): **does not apply here**. Frozen bases are for fork-side PRs whose base is intended to be a stable snapshot. A merge-into-llm PR targets `llm` directly (the live trunk) because the merge commit *is* the trunk advancement. PR #257 used `--base llm`, not `--base llm-<sha>`.

### Why each reference is relevant

The 2026-05-15 dispatch + result + judge verdict together define the canonical PR shape. The 2026-05-21 and 2026-06-03 precedents confirm the merge-not-rebase shape is the established pattern (a 1290-commit-ahead branch cannot be rebased). The conflict-resolution skill governs each per-file decision; the precedents are evidentiary, not authoritative.

### Open questions

- Possible follow-on out-of-scope divergences. The 2026-05-21 weaver flagged `makeClient`/`registerNetlayer` API drift; the 2026-06-03 weaver flagged `eslint-plugin-import` catalog-route caveats. Both were surfaced as recommended follow-up dispatches, not scope creep into the sync itself. If the builder hits a similar drift, surface it in the result rather than fixing it under the sync banner.

## Task

In your `project/` worktree (currently at `origin/llm` tip
`2bd9e0cb`):

1. **Add the upstream remote** (idempotent):
   `git remote add endo-upstream https://github.com/endojs/endo.git`
   (skip on `already exists`).
2. **Fetch upstream master**:
   `git fetch endo-upstream master`. Confirm tip = `4a04d078`.
3. **Create the sync branch** off `origin/llm`:
   `git checkout -b merge/actual-master-into-llm-20260606`. (The
   project worktree is detached HEAD currently; the checkout creates
   the branch from the current commit, which is `origin/llm`.)
4. **Merge upstream master** with an explicit merge commit:
   `git merge endo-upstream/master --no-ff -m "chore: merge actual/master into llm (2026-06-06)"`.
   Conflicts will arise; resolve them per the recurring surface above
   and per `skills/conflict-resolution/SKILL.md`. For each file you
   resolve, read both sides and merge intents (no blind
   `--ours`/`--theirs`). yarn.lock: skip during merge, regenerate
   via `corepack yarn install` after the merge tree is otherwise
   complete; the lockfile changes ride in the merge commit by
   convention.
5. **Push the sync branch**:
   `git push origin HEAD:merge/actual-master-into-llm-20260606`.
6. **Open the PR DRAFT**:
   `gh pr create -R endojs/endo-but-for-bots --base llm --head merge/actual-master-into-llm-20260606 --draft --title "chore: merge actual/master into llm (2026-06-06)" --body <body>`.
   The body should cite:
   - Absorbed upstream tip (`4a04d078`) + its commit headline.
   - The conflicts you resolved, file by file, with one-line
     rationale each (per the 2026-05-15 PR #257 pattern).
   - The pre-push gates' output (expected pre-existing master
     findings call out separately from any new ones).
   - "CI is the validation gate; a follow-on shepherd dispatch will
     drive CI to green."

## Authorizations (per-action, forwarded by steward)

- **Push the sync branch** `merge/actual-master-into-llm-20260606`.
  Implicit in the dispatch's "open the PR" framing.
- **Open the DRAFT PR** on `endojs/endo-but-for-bots` with base
  `llm`. Implicit in the dispatch.
- **Post the draft-PR body** describing the merge and citing the
  conflict-resolution surface. The `endo-but-for-bots` standing
  broad-comment authorization covers this without further per-action
  grant.
- **Post a follow-up comment** if you find an out-of-scope drift
  worth surfacing (per *Open questions* above). The same standing
  authorization covers it.

## Out-of-scope (for follow-on dispatches)

- The shepherd's CI drive will be a separate dispatch the steward
  issues after your `result`. You do not need to wait for CI before
  returning.
- If your merge resolution surfaces a real API drift between bot
  llm and upstream master (e.g., `makeClient`/`registerNetlayer` or
  the eslint-plugin partial revert), record it in your `result` as
  a recommended follow-up dispatch but do NOT fix it under the sync
  banner.

## Deliverable

A `result` entry under `journal/entries/2026/06/06/` naming:

- The sync branch name (`merge/actual-master-into-llm-20260606`)
  and its tip SHA.
- The absorbed upstream tip (`4a04d078`).
- The opened PR number and URL.
- The conflicts resolved, file by file, with one-line rationale.
- Any rerere cache hits (the dispatch worktree may carry pre-images
  from prior syncs that auto-resolved some conflicts).
- Any out-of-scope drift surfaced for a follow-on dispatch.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
