---
ts: 2026-06-06T05:13:00Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/researcher--ec33c4
to: steward
refs:
  - entries/2026/06/06/050800Z-dispatch-researcher-ec33c4.md
  - entries/2026/05/15/005225Z-dispatch-liaison-2264a5.md
  - entries/2026/05/15/013547Z-result-liaison-2264a5.md
  - entries/2026/05/15/013716Z-result-weaver-2264a5.md
  - entries/2026/05/17/214232Z-result-judge-df84b2.md
  - entries/2026/05/21/054802Z-result-weaver-7d7d5e.md
  - entries/2026/06/03/011729Z-dispatch-liaison-496105.md
  - entries/2026/06/03/012906Z-result-weaver-496105.md
---

# result: researcher — references for sync-actual-master-into-llm builder dispatch

The downstream builder will produce a draft PR on `endojs/endo-but-for-bots` whose base is `llm` and whose head is a sync branch that merges `endojs/endo@master` into `llm`. The project has three prior precedents for exactly this operation (2026-05-15 → PR #257; 2026-05-21 → direct push; 2026-06-03 → direct push). All three converged on the same merge-not-rebase shape because `llm` is 1290 commits ahead of master and a rebase would replay the full bot-side history; the merge-commit shape preserves it and matches the long-lived feature trunk pattern. The refinement below cites those precedents, the project README anchors, the canonical conflict files the prior weavers documented, and the relevant skills.

```markdown
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
- [`entries/2026/05/21/054802Z-result-weaver-7d7d5e.md`](../../entries/2026/05/21/054802Z-result-weaver-7d7d5e.md): second sync of this kind (no PR; direct push to `llm` of merge commit `b381e6ada`). Confirms the merge shape, documents rerere-captured pre-images from the 2026-05-15 sync that auto-resolved 19 of this run's 16+ conflicts (the dispatch worktree's rerere cache may already carry those resolutions). Surfaces the `ocapn-default-cbor` / `makeClient`/`registerNetlayer` API divergence that is out of scope for the merge but needs a follow-up builder; the same gap may resurface in this sync.
- [`entries/2026/06/03/011729Z-dispatch-liaison-496105.md`](../../entries/2026/06/03/011729Z-dispatch-liaison-496105.md) and [`entries/2026/06/03/012906Z-result-weaver-496105.md`](../../entries/2026/06/03/012906Z-result-weaver-496105.md): most recent precedent (three days before this dispatch). The weaver started with `git rebase origin/master`, hit yarn.lock and benchmark conflicts in the first 12 of 1072 replayed commits, **aborted, switched to merge**. Documents the explicit strategy choice and the canonical conflict-resolution list per file. The dispatch said "rebase" but the result shows that merge is the only viable shape for a 1290-commits-ahead branch. The builder should expect the same strategy switch (the dispatch text says "merge ... via a fork-side PR", which is already the merge framing — no rebase attempt needed).

### Relevant skills

- [`garden/skills/conflict-resolution/SKILL.md`](../../../garden/skills/conflict-resolution/SKILL.md): canonical for the per-file resolution decisions. The hard rule is no blind `--ours`/`--theirs`; read both sides and merge intents. The prior weavers' notes document the recurring resolutions; the builder may consult them but must verify each on current content.
- [`garden/skills/yarn-lock-separate-commit/SKILL.md`](../../../garden/skills/yarn-lock-separate-commit/SKILL.md): yarn.lock conflicts are skipped during merge/rebase and regenerated via `corepack yarn install` against the merged tree. Separate `chore: Update yarn.lock` commit is the convention; on a merge-into-llm the lockfile changes ride in the merge commit itself by convention. The 2026-06-03 weaver regenerated in <1s.
- [`garden/skills/pr-formation/SKILL.md`](../../../garden/skills/pr-formation/SKILL.md): standard PR-opening discipline (title, body shape, draft state). The PR body should cite the absorbed upstream tip (sha + headline), enumerate the conflicts the builder resolved, and note that CI is the validation gate.
- [`garden/skills/pre-pr-checklist/SKILL.md`](../../../garden/skills/pre-pr-checklist/SKILL.md) and [`garden/skills/pre-push-gates/SKILL.md`](../../../garden/skills/pre-push-gates/SKILL.md): pre-push gates run with `--summary` against the merged tree; pre-existing master findings are expected.
- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md): **does not apply here**. Frozen bases are for fork-side PRs whose base is intended to be a stable snapshot. A merge-into-llm PR targets `llm` directly (the live trunk) because the merge commit *is* the trunk advancement. PR #257 used `--base llm`, not `--base llm-<sha>`. The builder follows the same pattern.

### Why each reference is relevant

- The project README anchors define the rules of engagement (llm is the trunk, comments are pre-authorized) and the remote-name convention (`endo-upstream` for upstream).
- The 2026-05-15 dispatch + result + judge verdict together define the canonical PR shape: sync-branch named `merge/actual-master-into-llm-YYYYMMDD`, DRAFT, base `llm`, body cites weaver/builder dispatch and conflict-resolution surface, judge un-drafts as a tiny-PR merge-marker on a clean run.
- The 2026-05-21 and 2026-06-03 precedents confirm the merge-not-rebase shape is the established pattern. They also document the rerere cache the dispatch worktree may already carry from prior syncs (`b381e6ada`'s pre-images on workflow files, ocapn tests, eslint-plugin, yarn.lock).
- The conflict-resolution skill governs each per-file decision; the precedents are evidentiary, not authoritative.

### Open questions (for the builder to resolve in the dispatch)

- **Recurring cadence vs single-shot.** The history shows three syncs over three weeks (2026-05-15, 2026-05-21, 2026-06-03), driven by maintainer requests when an upstream landing matters to the bot estate. No automated cadence; treat as single-shot but the fourth in a recurring pattern. Branch-name suffix `-20260606` keeps the sequence visible.
- **PR shape: PR or direct push?** The 2026-05-15 sync went via PR #257 (so CI could validate without the weaver's local yarn install reaching all the way); the 2026-05-21 and 2026-06-03 syncs went **direct push to `llm`** after local validation. The dispatch explicitly says "produce a PR on the bot fork whose base is `llm`" and "Open the PR DRAFT; CI will be driven by a follow-on shepherd dispatch" — this returns to the PR shape of #257. Builder copies the #257 pattern.
- **Possible follow-on out-of-scope divergences.** The 2026-05-21 weaver flagged `makeClient`/`registerNetlayer` API drift; the 2026-06-03 weaver flagged `eslint-plugin-import` catalog-route caveats. Both were surfaced as recommended follow-up dispatches, not scope creep into the sync itself. If the builder hits a similar drift, surface it in the result rather than fixing it under the sync banner.

### Library writeback

No keyword shortcuts added, no concept pages drafted, no distractions pruned. The library's keyword index covers chat-design terms heavily; the `journal/projects/endo-but-for-bots/` topic-file inventory remains minimal (one investigation, one followups directory). The recurring `actual/master -> llm` sync is a candidate for a topic file (`journal/projects/endo-but-for-bots/master-into-llm-sync.md`) that would consolidate the four precedents above; queued for the scholar / librarian rather than written here since this is a researcher dispatch, not a library-build dispatch.
```

## Library writeback

No mutations to `journal/library/` this engagement. The four precedent entries on the `actual/master into llm` sync are not currently indexed in `journal/library/keywords.md`; they are recovered via grep across `journal/entries/` and `journal/projects/endo-but-for-bots/`. The topic-file gap noted in *Open questions* above is the same gap — a `journal/projects/endo-but-for-bots/master-into-llm-sync.md` topic page consolidating the four precedents would make the next researcher's lookup an O(1) read.

## Open questions

- The `journal/projects/endo-but-for-bots/` directory has no topic file for the recurring `actual/master into llm` sync. Four precedents exist (2026-05-15 PR #257, 2026-05-21 direct push `b381e6ada`, 2026-06-03 direct push `720a39600`, and this 2026-06-06 dispatch in flight). Queueing for the librarian or scholar.
- The `journal/library/keywords.md` index has no entries for the project-specific terms `actual/master`, `bot-master`, `llm branch`, `roadmap branch`, `frozen-base-branch`, or `sync PR`. The library's current coverage is dominated by chat-design terminology from the llm-side designs.

Self-improvement: nothing this time. The role's "researcher reads the proposed prompt, walks library and project material, returns a `## Library and project references` section" played as written. The library-writeback step was a no-op only because the relevant project material is concentrated in journal entries (which the skill explicitly does not mutate) rather than in the keyword-indexable library; the *Open questions* section captures the topic-file gap for the librarian.
