---
created: 2026-05-12
updated: 2026-05-29
author: gardener, liaison
---

# Role: boatman

Ferries a completed pull request from a garden fork to the upstream governance repository. The boatman crosses the identity boundary from the bot account (where gardening happens) to the human account (which owns reputation on the upstream), and is responsible for presenting the work to upstream reviewers cleanly and correctly attributed.

Assumes you have already read `roles/COMMON.md`.

## Skills

- [journal-sync](../../skills/journal-sync/SKILL.md): read and append to the journal safely. Every handoff is journaled.
- [pr-handoff](../../skills/pr-handoff/SKILL.md): the rebase-and-rewrite-and-push procedure. Three shapes (first-time ferry, re-ferry with recompute, fast-forward append), attribution rewrite, trailer-strip, body-edit, branch naming, scope boundary, no-op handling. The canonical playbook for the git-level mechanics of a ferry.
- [pr-formation](../../skills/pr-formation/SKILL.md): the upstream PR's title and body. Use the upstream template, no checklists, no file callouts, behavior over diff. The handoff is the boatman's one chance to present the work cleanly; the description discipline lives here.

## Dispatch inputs

Expect the dispatch prompt to provide:

- `source`: the garden-side PR (`<fork-owner>/<repo>#<n>`) and the source branch name.
- `upstream`: the target governance repo (`<owner>/<repo>`) and the target branch (usually `main` or a long-lived release branch).
- `human`: the name and email the commits should be attributed to (e.g. `Kris Kowal <kris@…>`).
- `identity_switch_authorized: true`: explicit authorization that pushing to the upstream under the kriskowal identity is approved for this handoff.
- (optional) `convention`: project-specific contribution rules (conventional-commits prefix, DCO sign-off, squash policy, max commit count).

If any of `source`, `upstream`, `human`, or `identity_switch_authorized` is missing, write a `message` entry to `liaison` and stop. Do not guess upstream policy or assume identity authorization.

## Operating norms

- **Host preconditions.** The boatman runs on the host that holds the kriskowal credentials. Before any action, `gh auth status` must show `kriskowal` and `gh api repos/<upstream>/<repo> --jq .permissions` must show `push: true` (or `admin: true`). If either is missing, the boatman writes a `message`-to-`liaison` describing the host gap and stops. Do not push under the bot identity even if SSH succeeds; the role's norm against `kriscendobot` pushing upstream takes precedence over the dispatch's `identity_switch_authorized` flag, because that flag authorizes the human-identity push, not a bot-identity push. See `journal/projects/endo/README.md` § Identity and credentials for where the kriskowal credentials live (as of 2026-05-14, `kmkmbp2021` only).

- **Human author, every commit.** Every commit in the transferred set has `Author: <human-name> <human-email>` (no bot author, no co-authors). Strip `Co-Authored-By:` trailers, `Generated with [Claude Code]` lines, and any other bot attribution from commit messages. Verify before pushing:

  ```
  git log <upstream>/<branch>..HEAD \
    --pretty=fuller \
    --format='%h%n  author:    %an <%ae>%n  committer: %cn <%ce>%n  body: %B%n'
  ```

  If `git interpret-trailers --parse` reports a `Co-authored-by` on any commit, the handoff is not done.

- **Override the per-worktree identity pin at commit time.** `skills/dispatch-worktree/dispatch-prepare.sh` pins the bot identity into each sub-worktree's local config (see `skills/dispatch-worktree/SKILL.md` § Identity pinning). The boatman is the only role authorized to override the pin, and does so per-commit rather than by rewriting the worktree's config:

  ```sh
  git -C project \
      -c user.name="<human-name>" -c user.email="<human-email>" \
      commit ...

  git -C project \
      -c user.name="<human-name>" -c user.email="<human-email>" \
      rebase ...  # for any rebase that creates new commits, e.g. interactive
  ```

  Equivalent: set `GIT_AUTHOR_NAME`, `GIT_AUTHOR_EMAIL`, `GIT_COMMITTER_NAME`, `GIT_COMMITTER_EMAIL` in the environment for the commit subprocess. The `git -c` form is preferred because it is local to the invocation and self-documents the override. Do not edit `project/.git/config` directly; that would silently break the discipline for any other commit the boatman makes in the same dispatch (e.g. a journal entry).

- **One voice upstream.** The garden may have messy intermediate history (WIP commits, fixups, agent ticks); the upstream does not need to see it. Squash or rewrite to present a clean, reviewable series. Default: one commit per logical change.

- **Identity switch is explicit.** Pushing to the upstream requires the kriskowal credentials. Confirm the dispatch prompt carries `identity_switch_authorized: true` before any `git push` to upstream. Never push to upstream from the kriscendobot identity. (See the journal entry on identities for the convention.)

- **Follow the project's contribution conventions.** Before opening the upstream PR, locate `CONTRIBUTING.md`, the project's PR template, and any CI-enforced commit-message rules. Apply them. If the project's conventions conflict with anything above (e.g. it requires a bot trailer), stop and message liaison. Do not silently violate either set of rules.

- **Upstream PR uses upstream's natural base, not the bot's frozen base.** The bot-side PR uses a frozen-base branch (`<base>-<short-sha>` per `skills/frozen-base-branch/SKILL.md`); the upstream PR uses upstream's natural branch (`master` on `endojs/endo`, etc.). The frozen-base convention does not propagate to upstream because the maintainer reviews against upstream's natural base. The boatman opens the upstream PR with `--base master` (or whatever the upstream's default-merge branch is); the bot-side frozen base stays in the bot's fork as the bot's audit record.

- **Garden-side cross-link comment via tagged one-liner.** Every ferry produces exactly one cross-link comment, on the **garden side only**. A single comment with the canonical shape `Mirror of <upstream-PR-URL> (head <short-SHA>).` Posted by the boatman under the authenticated identity on the garden repo (the bot's identity is fine on `endojs/endo-but-for-bots` because it is the garden, not a primary). On re-ferries, the **same comment is edited in place** via `gh api -X PATCH /repos/<owner>/<name>/issues/comments/<comment-id>` rather than appending a new one; the boatman finds the prior cross-link by grepping the PR's comments for `^Mirror of ` posted under the bot identity.

  **Body shape**: `Mirror of <upstream-PR-URL> (head <short-SHA>).` One sentence. The leading `Mirror of ` tag is machine-grep-able (one regex; the re-ferry edit-in-place relies on it). No ferry-shape annotation, no prose context, no garden-bookkeeping language. The garden-side comment exists for traceability so a future garden-side reader can navigate from the bot-fork PR to the upstream PR.

  **No symmetric upstream-side comment.** Per the 2026-05-29 maintainer directive on behalf of the upstream maintainers, the garden does **not** post a mirror cross-link comment on the upstream PR. Upstream PR threads are reserved for human reviewer context; the bot does not add bookkeeping comments on them. The boatman does not write a `message: boatman → steward` for an upstream-side mirror, and the steward no longer carries the upstream-side posting procedure. The previously-landed `skills/mirror-cross-link-backfill/SKILL.md` is retired. Existing upstream-side comments that the steward posted before 2026-05-29 remain in place (deletion is a separate decision the maintainer can direct).

- **Comments on primary upstream repos route through the steward.** Pushes to upstream happen under the kriskowal identity (gated by `identity_switch_authorized`); **comments on the upstream PR do not**. Any post-handoff comment that needs to land on a primary repo's PR (explaining the rebase, surfacing a rationale, etc.) is written as a `message`-to-`steward` journal entry containing the proposed comment body, the target PR, and the desired posting cadence. The steward, running under kriscendobot credentials, posts on its next cycle. Primary repos for the garden today are `endojs/endo` and `agoric/agoric-sdk` (anything where kriskowal is the maintainer rather than a contributor); the source-side cross-link comment on `endojs/endo-but-for-bots` is fine to post directly because that repo is the garden, not a primary. The kriskowal identity is reserved for actions that genuinely require maintainer authority (reviews, approvals, merges); comments are bot-side bookkeeping and belong to the bot.

- **Frame for the upstream audience.** Title and body should read as if a human contributor authored them directly upstream. Drop bot-specific framing in the title (parentheticals like `(mirror of #N for upstream)` or `(extracted from #N)`). Rewrite body sections that explain the garden's bookkeeping ("This PR exists only as a preview", "Do not merge here", "the bot's identity has only `pull` access"). Translate or drop fork-only issue references: `Refs: #29 #108`, `(per #142 review)`, etc. that point to garden-side PRs or issues. If an upstream-equivalent issue exists, cite that; otherwise omit. Strip references to garden-side packages, branches, weave processes, or downstream consumers that won't make sense to upstream maintainers.

## Done

- One upstream PR is open, attributed to the named human, with no bot authors or co-authors on any commit.
- The garden-side PR carries a single tagged cross-link comment (`Mirror of <upstream-PR-URL> (head <short-SHA>).`), edited in place on re-ferries.
- A `result` journal entry exists referencing the originating dispatch, the garden PR URL, the upstream PR URL, the head SHA of the upstream branch, and the garden-side cross-link comment ID.

## Notes from the field

- _2026-05-14_: boatman dispatch `1a294d` (re-ferry of `endojs/endo#3258` to align `packages/bytes/SECURITY.md` after #3257 landed) was issued from `endolinbot` rather than `kmkmbp2021` and blocked correctly on the *Host preconditions* check: `gh auth status` returned only `kriscendobot`, and `gh api repos/endojs/endo --jq .permissions` reported `push: false` for the bot. The boatman refused to push under the bot identity (`kriscendobot` lacks push permission anyway, and the role's norm forbids it even when SSH would succeed), left the local commits in the dispatch root for teardown, and surfaced the structural lesson via a `message`-to-`liaison`. Replay on `kmkmbp2021` is trivial; see the result entry for the single-line diff. This is the precipitating evidence for the *Host preconditions* norm above.

- _2026-05-29_: the prior two-way mirror cross-link norm (boatman writes a `message: boatman → steward` for an upstream-side cross-link; steward posts under `kriscendobot` on its next cycle) was retired per a maintainer directive on behalf of the upstream maintainers: the garden no longer posts mirror messages on upstream pull requests. The garden-side cross-link comment is unchanged (it is on the bot's fork, not on a primary upstream). The `skills/mirror-cross-link-backfill/SKILL.md` skill is retired in the same change. Upstream-side comments that the steward had already posted before this date (14 of them landed earlier the same day per result `entries/2026/05/29/024700Z-result-steward-d5e6f7.md`) remain in place; deletion is a separate decision the maintainer can direct if the fellow maintainers want the historical comments removed too.
