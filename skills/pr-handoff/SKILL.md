---
created: 2026-05-15
updated: 2026-07-05
author: boatman, gardener
---

# Skill: pr-handoff

How to ferry a completed garden-side pull request to its upstream governance repository. Covers the three procedure shapes a ferry takes (first-time, re-ferry with recompute, fast-forward append), the attribution rewrite that swaps bot authors for the named human, the trailer-strip and body-edit disciplines, and the scope boundary that separates the boatman's job from the weaver's.

Canonical for the [boatman](../../roles/boatman/AGENT.md). A liaison or steward dispatching a boatman cites this skill in the dispatch prompt; the boatman runs it. The skill assumes [pr-formation](../pr-formation/SKILL.md) for the upstream PR's title and body discipline; this skill covers the git-level mechanics around the push.

## When to use

- A dispatch prompt says "ferry #N" or "carry #N upstream". The verb names this procedure.
- A re-ferry is requested for a PR whose upstream counterpart already exists.
- A fast-forward append is requested when the source PR has gained new commits at the tip and the upstream is otherwise current.

Not for: master-merge conflict resolution (weaver), title-only updates on an existing upstream PR without a content change (out of scope; see § Scope boundary).

## Preconditions

- `gh auth status` shows `kriskowal` as the active identity on this host. Without kriskowal credentials, stop and message liaison; the bot identity must not push to a primary upstream repo. The boatman's `roles/boatman/AGENT.md` § Operating norms documents this precondition; this skill assumes it has been verified.
- The dispatch prompt carries `identity_switch_authorized: true`.
- The dispatch names the source PR (`<fork-owner>/<repo>#<n>` and source branch), the upstream repo (`<owner>/<repo>` and target branch), and the human author identity. The email is a **dispatch input**, not a fixed constant: the maintainer names it. When the dispatch leaves it unspecified, confirm rather than default. The two live values in use are `Kris Kowal <kris@agoric.com>` (the plurality on recent `endojs/endo` commits) and `Kris Kowal <kriskowal@kriskowal.com>`; both are registered on the kriskowal account so either links correctly. The code examples below use `kris@agoric.com` as the illustrative default.
- The local `origin/master` tracking ref is verified against the live remote before any shape that detaches at it (Shapes 1, 2) or at the upstream branch tip (Shape 3) recomputes. After `git fetch origin`, confirm `git rev-parse origin/master` equals `git ls-remote origin master`; if they disagree, the bare clone's `remote.origin.fetch` refspec is missing or narrow, so force the correct ref with `git fetch origin +refs/heads/master:refs/remotes/origin/master` before detaching. Otherwise the recompute lands on a stale tip.

## Three procedure shapes

The choice between shapes is driven by the relationship between source-PR state, upstream-PR state (if any), and upstream master tip. Diagnose the shape from the dispatch prompt and the current state of both PRs before starting.

### Shape 1: first-time ferry

When: no upstream PR exists yet for the source.

```sh
# 0. Identity for this worktree's commits.
git -C project config user.name 'Kris Kowal'
git -C project config user.email 'kris@agoric.com'

# 1. Detach at current upstream master.
git -C project fetch origin
git -C project checkout --detach origin/master

# 2. Cherry-pick the source PR's commits. Typically base..head from the source.
git -C project cherry-pick <source-base>..<source-head>

# 3. Attribution rewrite per commit (see § Attribution discipline below).
#    For each commit picked, the dominant pattern is:
git -C project commit --amend --reset-author --no-edit
#    Repeat per commit if multiple were picked; an interactive rebase is the
#    usual mechanism. See § Attribution discipline for the multi-author case.

# 4. Verify.
git -C project log origin/master..HEAD --pretty=fuller
git -C project log origin/master..HEAD --format='%H' | \
    xargs -I{} git -C project interpret-trailers --parse <(git -C project show -s --format=%B {})
#   No Co-authored-by, no Generated-with-Claude-Code trailers anywhere.

# 5. Push to a fresh upstream branch.
git -C project push origin HEAD:<new-branch-name>

# 6. Open the upstream PR via gh pr create with title/body per pr-formation.
gh pr create -R <upstream> --base master --head <new-branch-name> \
    --title '<conventional-commit summary>' \
    --body-file /tmp/pr-body.md \
    [--draft]
```

Default branch-naming: `kriskowal-<topic>`, or `<scope>-<topic>` mirroring the source's convention. Draft vs ready-for-review: workflow-iteration ferries open as draft; substance-bearing ferries open as ready-for-review when CI is clean and the source carries a substantive approval (especially from the original author of the substance, where applicable).

### Shape 2: re-ferry with recompute-from-master (force-push)

When: an upstream PR exists, but the source has been rebased onto a newer master or restructured (split, squashed, reordered) such that the upstream's current head is no longer an ancestor of the desired new shape.

```sh
# 0. Identity, as above.
git -C project config user.name 'Kris Kowal'
git -C project config user.email 'kris@agoric.com'

# 1. Detach at current upstream master.
git -C project fetch origin
git -C project checkout --detach origin/master

# 2. Cherry-pick the source's new shape, per-commit. Do not use --squash unless
#    the dispatch prompt asked for a squash.
git -C project cherry-pick <source-base>..<source-head>

# 3. Attribution rewrite per commit, as above.

# 4. Verify (log, interpret-trailers --parse).

# 5. Force-push with --force-with-lease against the current upstream tip.
git -C project push --force-with-lease=<upstream-branch>:<known-prior-tip> \
    origin HEAD:<upstream-branch>
```

`--force-with-lease=<upstream-branch>:<known-prior-tip>` refuses to overwrite an upstream tip that has moved since fetch; the unqualified `--force-with-lease` form also works if the local refs are fresh. Do not use plain `--force`.

**Approval-persistence note.** A force-push dismisses the upstream PR's approvals if (and only if) the upstream branch's protection rule has `dismiss_stale_reviews: true`. Without that rule, approvals persist on the record after the head moves. Document the post-push state in the result entry (`gh pr view <n> -R <upstream> --json reviewDecision,reviews`).

### Shape 3: re-ferry with cherry-pick-on-prior-tip (fast-forward append)

When: an upstream PR exists, the upstream's current head is "healthy and represents the work intended", and the source has new commits at the tip that do not conflict with the upstream's structure. Most efficient and most review-preserving shape.

```sh
# 0. Identity, as above.
git -C project config user.name 'Kris Kowal'
git -C project config user.email 'kris@agoric.com'

# 1. Detach at the upstream PR's current head, NOT at origin/master.
git -C project fetch origin
git -C project checkout --detach origin/<upstream-branch>

# 2. Cherry-pick only the new commits. The set is "what the source has gained
#    since the prior ferry", not the full base..head range.
git -C project cherry-pick <new-sha-1> <new-sha-2> ...

# 3. Attribution rewrite per commit (--reset-author --no-edit pattern).

# 4. Verify (log, interpret-trailers --parse).

# 5. PRE-FLIGHT ANCESTOR CHECK. This is the discipline that distinguishes a
#    fast-forward append from a re-ferry: the new HEAD must be a descendant of
#    the current upstream tip.
git -C project merge-base --is-ancestor origin/<upstream-branch> HEAD \
    || { echo "Not a fast-forward; abort and use shape 2"; exit 1; }

# 6. Push without --force or --force-with-lease.
git -C project push origin HEAD:<upstream-branch>
#    The remote response must read `<prior-tip>..<new-tip>` with no leading `+`
#    marker. A `+` indicates a force-push, which is wrong for this shape.

# 7. Verify approval persistence after the push.
gh pr view <n> -R <upstream> --json reviewDecision,reviews
#    APPROVED should still be present; the review record is anchored to its
#    original commit OID, which is still reachable from the new head.
```

Approval-persistence note: a fast-forward append does not dismiss approvals under any branch-protection rule, because the review record stays anchored to its original commit OID (still reachable from the new head). If `APPROVED` disappeared after the push, the push was not actually a fast-forward (the ancestor check would have caught this; investigate).

## Attribution discipline

### Single-author case (dominant)

Source commits typically carry `endolinbot <main.barn5084@fastmail.com>` (the bot) or mixed bot/human attributions. The job is to rewrite every commit's author and committer to the named human, typically `Kris Kowal <kris@agoric.com>` (see § Preconditions for how the email is chosen).

The mechanism that **works**:

1. Set local repo config first: `git -C project config user.name 'Kris Kowal' && git -C project config user.email 'kris@agoric.com'`.
2. Cherry-pick the source commit (or commits).
3. `git -C project commit --amend --reset-author --no-edit` per commit. For multi-commit cherry-picks, the practical form is an interactive rebase (`git rebase -i <base>` with each commit marked `reword` or `edit`, then `--reset-author --no-edit` on each).
4. Verify with `git -C project log <upstream-master-or-tip>..HEAD --pretty=fuller`: every commit shows the target human as both author and committer.

The mechanisms that do **not** work (avoid):

- `git cherry-pick --author='<name> <email>'`: cherry-pick does not accept `--author`; the flag is silently ignored on some git versions.
- Setting `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` env vars alone around the cherry-pick: cherry-pick preserves the original author and the env vars do not override it.

The local-config plus `--amend --reset-author --no-edit` is the canonical pattern. First documented in `journal/entries/2026/05/15/005114Z-result-boatman-eaabd7.md`; reaffirmed across every multi-commit ferry since.

### Multi-author case (salvage pattern)

When a source commit is itself a salvage of another human's original work (e.g., a commit that preserves Mark S. Miller as author after salvaging from a closed PR), do **not** use `--reset-author`. Instead:

1. Cherry-pick the source commit.
2. If a body or subject edit is needed: `git commit --amend --no-edit` (preserves the original author), or `git commit --amend --author='<original-name> <original-email>' -m '<new-message>'` if the message also needs rewriting.
3. The committer becomes the boatman's local kriskowal identity from the amend. The asymmetry (author preserved, committer is the boatman) is correct and standard.
4. Verify each commit's author individually against the dispatch prompt's per-commit author table.

The dispatch prompt for a multi-author ferry should provide a per-commit author table. If it does not, ask the liaison before guessing; do not infer authorship from commit history alone (the source may already have flattened the attribution).

## Trailer-strip discipline

Every commit body in the upstream-bound set must have:

- Zero `Co-authored-by:` trailers (any spelling, any case).
- Zero `🤖 Generated with [Claude Code]` or other generator trailers.
- Zero bot-identity references in trailer position.

The canonical check is per-commit:

```sh
for sha in $(git -C project log <base>..HEAD --format=%H); do
    echo "=== $sha ==="
    git -C project show -s --format=%B $sha | git interpret-trailers --parse
done
```

This is a **standing** discipline. Run it on every ferry, regardless of whether a liaison-side pre-inspection claimed the bodies were clean. The session's #73 ferry surfaced a case where the dispatch prompt's preliminary inspection (eyeballing the first 20 lines of each body via `gh api`) missed a `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` trailer that lived below the first paragraph. The standing `interpret-trailers --parse` caught it; without that discipline, the trailer would have shipped upstream.

Strip during the same amend that rewrites attribution. The clean rewrite uses `git commit --amend -m '<subject>' -m '<body-without-trailers>'` or an interactive rebase with `reword` on each affected commit.

## Subject and body editing

### Subject suffixes to strip

Bot-internal source-PR-number suffixes in commit subjects: `(#73)`, `(#75)`, `(#244)`, `(fix lint job on #244)`, etc. These reference fork-side PR numbers and confuse upstream readers. Strip during the attribution-rewrite amend.

### Body edits

Bot-internal references in commit bodies: `bots#57`, `endo-but-for-bots#NNN`. Drop these fragments while preserving surrounding context. Surrounding `endojs/endo#NNN` references are upstream-equivalent and stay.

Substantive cross-references should be **translated, not dropped**: a reference to "the work landed in `endo-but-for-bots#XXX`" becomes a reference to the upstream-merge SHA if the bot-side PR has been ferried and merged. Example: iteration III of an OCapN Guile interop ferry referenced iter II as bot-side `#255`; the upstream PR's body translated this to the merged commit `0ec70c6d` (the squash-merge of `#3262` on upstream master). Use `gh pr view <bot-side-N> -R <fork-repo> --json mergeCommit` to find the bot-side merge commit, then map to the upstream squash-merge SHA by reading the bot-side PR's upstream cross-link comment.

## PR-formation discipline (ferry-specific)

The general PR-body discipline lives in [pr-formation](../pr-formation/SKILL.md). The boatman applies that skill and adds these ferry-specific rules to the PR body:

- **Drop fork-only references.** Any `Refs: #N` where `#N` is fork-side, the `(this fork's #N)` parentheticals, the `(re-opened from #N under the bot)` framing, etc. Strip without replacement.
- **Drop bot bookkeeping.** Maintainer-directive quotes (`Per the maintainer's 2026-05-14 directive: ...`), test-plan checklists (`[x] yarn test ...`, `[ ] CI green ...`), the `🤖 Generated with [Claude Code]` line, the `Co-Authored-By:` trailer if it appears in the body proper (not just commit messages).
- **Translate, do not drop, substantive cross-references.** A fork-side reference whose upstream-equivalent exists should be translated; only references with no upstream equivalent are dropped.
- **Iteration-history framing.** When ferrying a follow-up to a previously-merged ferry (iteration III after iteration II merged), reference prior iterations by upstream merge SHAs (e.g., `246c6a6c`, `0ec70c6d`) rather than bot-side PR numbers.

The boatman's roles/AGENT.md captures the parallel "frame for the upstream audience" rule for title and body voice; this skill captures the specific edits the ferry's content drives.

## Identity discipline

- The push to upstream happens under kriskowal credentials, gated by `identity_switch_authorized: true` in the dispatch prompt. Verify `gh auth status` shows kriskowal as active before pushing. If it does not, stop and message liaison; the host is wrong.
- Comments on **primary upstream repos** (`endojs/endo`, `agoric/agoric-sdk`) under the kriskowal identity are **forbidden** by the standing identity-discipline rule (`roles/boatman/AGENT.md` § Operating norms). The boatman routes any upstream explanatory comment through a `message`-to-`steward` journal entry; the steward, running under `kriscendobot`, posts on its next cycle.
- Comments on the **garden's own repo** (`endojs/endo-but-for-bots`) can be posted directly by the boatman under whichever identity is authenticated on the host. The standing repo authorization permits both kriskowal and kriscendobot. The dispatch prompt should say "post under whichever identity is authenticated" rather than presuming the bot host's setup; on `kmkmbp2021` only kriskowal is authenticated, and earlier dispatch prompts that said "under the bot identity" produced surfaced misframings.

## Branch naming

- **First-time ferry.** Boatman picks. Sensible defaults: `kriskowal-<topic>` or `<scope>-<topic>` mirroring the source's convention.
- **Re-ferry.** Push to the **same upstream branch** as the prior ferry. The upstream branch name may differ from the source-side branch name due to historical renames (e.g., `kriskowal-random-chacha20` on upstream vs `kriskowal-random-chacha12` on source for the same PR). Preserve the upstream's historical name; do not rename to match the source.

## Scope boundary

The boatman's responsibility ends at "the upstream head matches the source's content". Two adjacent concerns are explicitly **out of scope**:

1. **Master-merge conflict resolution.** A `MERGEABLE: CONFLICTING` status on the upstream PR after a ferry is the weaver's job. The boatman surfaces the status in its result entry but does not attempt to rebase the upstream branch onto current master.
2. **Title and description updates on the upstream PR.** Default is "leave the existing title and body unchanged". The boatman edits title or body only when:
   - The user explicitly asks for it in the dispatch prompt ("update the title and description").
   - The source's restructure has changed the PR's shape such that the existing title is materially misleading (e.g., the work shifted from "migrate to" to "alias"; the title rewrite was substantive and reviewer-facing).
   - First-time ferry, where there is no existing upstream title or body to preserve.

When in doubt, leave the upstream PR's title and body alone and surface the question in the result entry.

## No-op handling

When the dispatch asks to ferry a PR but the source and upstream are at the same head (`gh compare` reports `ahead: 0, behind: 0, files_changed: 0`), the dispatcher writes a `tick` entry rather than spinning up a boatman. The source-side auto-sync pattern (the bot rebases its source PR onto the boatman's rewritten history, bringing the two heads into byte-for-byte agreement) is common enough that this case appears regularly.

If the boatman is dispatched and discovers the no-op state during its own pre-flight inspection (e.g., the dispatch prompt was issued before the auto-sync converged), the boatman writes a `result` entry naming the no-op state and exits without pushing. Do not invent a no-op commit to "register" the ferry.

## Verification checklist

Run these in order before announcing the ferry done. The checklist is the executable form of "the upstream head matches the source's content with clean attribution".

1. **Identity.** `gh auth status` shows kriskowal active.
2. **Authorization.** Dispatch prompt carries `identity_switch_authorized: true`.
3. **Attribution.** `git log <upstream-tip-or-master>..HEAD --pretty=fuller` shows the named human as author and committer on every commit (except deliberate multi-author preserved cases).
4. **Trailers.** Per-commit `interpret-trailers --parse` is empty for every commit (no `Co-authored-by`, no `Generated-with-...`).
5. **Body.** No fork-side references remain, no bot bookkeeping remains. Cross-references are translated to upstream-equivalent SHAs or dropped.
6. **Shape-specific.**
   - Shape 1 (first-time): `gh pr create` succeeded; PR URL recorded.
   - Shape 2 (recompute): force-push landed; approval state recorded in result entry.
   - Shape 3 (fast-forward): `merge-base --is-ancestor` succeeded pre-push; remote response showed `<old>..<new>` with no `+`; `APPROVED` review state still present post-push.
7. **CI status.** `gh pr checks <n> -R <upstream>` recorded in the result entry (pending / passing / failing). The boatman does not wait for CI to finish before reporting; the shepherd handles CI-driven follow-up.
8. **Garden-side cross-link comment.** The garden-side PR carries exactly one tagged cross-link comment in the canonical shape `Mirror of <upstream-PR-URL> (head <short-SHA>).` The boatman posts (or PATCHes the existing one on a re-ferry) under the authenticated identity on the garden repo. Find the existing one via `gh api repos/<owner>/<name>/issues/<N>/comments --jq '.[] | select(.user.login == "kriscendobot" and (.body | startswith("Mirror of ")))'`; if found, edit in place (`gh api -X PATCH /repos/.../issues/comments/<id> -f body=...`); else create.

   The `Mirror of ` tag is the load-bearing prefix; the re-ferry edit-in-place greps on it.

   **No symmetric upstream-side comment.** Per the 2026-05-29 maintainer directive on behalf of the upstream maintainers, the garden does not post mirror cross-link comments on upstream PRs. The prior two-way procedure (boatman writes `message: boatman → steward`; steward posts under `kriscendobot` on next cycle) is retired, as is the back-fill skill that supported it. See `roles/boatman/AGENT.md` § Operating norms (Garden-side cross-link comment via tagged one-liner) for the canonical statement.

## Notes from the field

- _2026-05-15_: skill landed after nine ferries in 2026-05-14 evening through 2026-05-15 04:50Z exercised all three shapes and both attribution cases. Distilled from `journal/entries/2026/05/15/045644Z-message-liaison-73cdf1.md` and the per-ferry result entries it references. The fast-forward-append shape was independently proposed by the boatman in `journal/entries/2026/05/15/025038Z-message-boatman-8b5ee5.md`; the skill is consistent with that proposal and adds the other two shapes plus the multi-author case.
- _2026-05-15_: the precipitating bug for the trailer-strip discipline being standing-rather-than-conditional was the #73 ferry, where the dispatch prompt's "preliminary inspection shows clean commit bodies" framing was wrong because the inspector eyeballed only the first 20 lines of each body. The boatman's standing `interpret-trailers --parse` caught a `Co-Authored-By: Claude` trailer further down. Standing discipline means "every ferry, every commit, always", not "when the prompt suggests it might be needed".
- _2026-06-02_: the precipitating case for the verify-tracking-ref precondition was the #387 re-ferry (endo-but-for-bots#387 -> endo#3294). `worktrees/endojs-endo.git`'s `origin/master` sat stale at `c49fb048b` across four ferries because the bare clone's `remote.origin.fetch` was empty, so plain `git fetch origin` only advanced FETCH_HEAD. `git ls-remote` showed the live tip was `3c5753b67`; forcing `git fetch origin +refs/heads/master:refs/remotes/origin/master` corrected the ref and the recompute landed on current master. The root cause is fixed at bare-clone creation in `../../WORKTREES.md` § Adding a fork worktree; this precondition is the defense in depth for clones made before that step existed.
