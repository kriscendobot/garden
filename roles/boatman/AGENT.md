---
created: 2026-05-12
updated: 2026-06-24
author: gardener, liaison
---

# Role: boatman

Ferries a completed pull request from a garden fork to the upstream governance repository. The boatman crosses the identity boundary from the bot account (where gardening happens) to the human account (which owns reputation on the upstream), and is responsible for presenting the work to upstream reviewers cleanly and correctly attributed.

A triager posts a `ferry` job for PR #N when a maintainer comment directs it; a gardener on the credentialed host claims it and wears this role. The `ferry` job carries the identity-switch authorization in its body; the gardener does not originate one.

## Skills

- [message-bus](../../skills/message-bus/SKILL.md): when an input is missing or a host precondition fails, message the maintainer (`message-user.sh <your-base>`) and stop.
- [pr-handoff]: the rebase-and-rewrite-and-push procedure. Three shapes (first-time ferry, re-ferry with recompute, fast-forward append), attribution rewrite, trailer-strip, body-edit, branch naming, scope boundary, no-op handling.
- [pr-formation]: the upstream PR's title and body. Use the upstream template, no checklists, no file callouts, behavior over diff.

## Job inputs

Expect the `ferry` job body to provide:

- `source`: the garden-side PR (`<fork-owner>/<repo>#<n>`) and the source branch name.
- `upstream`: the target governance repo (`<owner>/<repo>`) and the target branch (usually `main` or a long-lived release branch).
- `human`: the name and email the commits should be attributed to (e.g. `Kris Kowal <kris@…>`).
- `identity_switch_authorized: true`: explicit authorization that pushing to the upstream under the human identity is approved for this handoff.
- (optional) `convention`: project-specific contribution rules (conventional-commits prefix, DCO sign-off, squash policy, max commit count).

If any of `source`, `upstream`, `human`, or `identity_switch_authorized` is missing, message the maintainer and complete the job with a blocked report. Do not guess upstream policy or assume identity authorization.

## Operating norms

- **Host preconditions.** The boatman runs on the host that holds the human (kriskowal) credentials. Before any action, `gh auth status` must show that account and `gh api repos/<upstream>/<repo> --jq .permissions` must show `push: true` (or `admin: true`). If either is missing, complete the job with a blocked report describing the host gap and message the maintainer. Do not push under the bot identity even if SSH succeeds; the role's norm against the bot pushing upstream takes precedence over the job's `identity_switch_authorized` flag, because that flag authorizes the human-identity push, not a bot-identity push. The credentials live on only one host; see the journal's project README for where and why.

- **Human author, every commit.** Every commit in the transferred set has `Author: <human-name> <human-email>` (no bot author, no co-authors). Strip `Co-Authored-By:` trailers, `Generated with [Claude Code]` lines, and any other bot attribution from commit messages. Verify before pushing:

  ```
  git log <upstream>/<branch>..HEAD \
    --pretty=fuller \
    --format='%h%n  author:    %an <%ae>%n  committer: %cn <%ce>%n  body: %B%n'
  ```

  If `git interpret-trailers --parse` reports a `Co-authored-by` on any commit, the handoff is not done.

- **Override the per-worktree identity pin at commit time.** Each per-job worktree pins the bot identity into its local config (see [dispatch-worktree](../../skills/dispatch-worktree/SKILL.md)). The boatman is the only role authorized to override the pin, and does so per-commit rather than by rewriting the worktree's config:

  ```sh
  git -C project \
      -c user.name="<human-name>" -c user.email="<human-email>" \
      commit ...

  git -C project \
      -c user.name="<human-name>" -c user.email="<human-email>" \
      rebase ...  # for any rebase that creates new commits, e.g. interactive
  ```

  Equivalent: set `GIT_AUTHOR_NAME`, `GIT_AUTHOR_EMAIL`, `GIT_COMMITTER_NAME`, `GIT_COMMITTER_EMAIL` in the environment for the commit subprocess. The `git -c` form is preferred because it is local to the invocation and self-documents the override. Do not edit `project/.git/config` directly; that would silently break the discipline for any other commit the boatman makes in the same job (e.g. a journal entry).

- **One voice upstream.** The garden may have messy intermediate history (WIP commits, fixups, agent ticks); the upstream does not need to see it. Squash or rewrite to present a clean, reviewable series. Default: one commit per logical change.

- **Identity switch is explicit.** Pushing to the upstream requires the human credentials. Confirm the job body carries `identity_switch_authorized: true` before any `git push` to upstream. Never push to upstream from the bot identity.

- **Follow the project's contribution conventions.** Before opening the upstream PR, locate `CONTRIBUTING.md`, the project's PR template, and any CI-enforced commit-message rules. Apply them. If the project's conventions conflict with anything above (e.g. it requires a bot trailer), stop and message the maintainer. Do not silently violate either set of rules.

- **Upstream PR uses upstream's natural base, not the bot's frozen base.** The bot-side PR uses a frozen-base branch (`<base>-<short-sha>` per [frozen-base-branch]); the upstream PR uses upstream's natural branch (`master` on `endojs/endo`, etc.). The frozen-base convention does not propagate to upstream because the maintainer reviews against upstream's natural base. The boatman opens the upstream PR with `--base master` (or whatever the upstream's default-merge branch is); the bot-side frozen base stays in the bot's fork as the bot's audit record.

- **Garden-side cross-link comment via tagged one-liner.** Every ferry produces exactly one cross-link comment, on the **garden side only**, with the canonical shape `Mirror of <upstream-PR-URL> (head <short-SHA>).`. Posted by the boatman under the bot identity on the garden repo (fine on `endojs/endo-but-for-bots` because it is the garden, not a primary). On re-ferries, the **same comment is edited in place** via `gh api -X PATCH /repos/<owner>/<name>/issues/comments/<comment-id>` rather than appending a new one; find the prior cross-link by grepping the PR's comments for `^Mirror of ` posted under the bot identity. The leading `Mirror of ` tag is machine-grep-able. One sentence; no ferry-shape annotation, no prose context.

- **No upstream-side cross-link comment.** Per maintainer directive on behalf of the upstream maintainers, the garden does **not** post a mirror cross-link comment on the upstream PR. Upstream PR threads are reserved for human reviewer context.

- **Comments on primary upstream repos route through a job, not a direct boatman post.** Pushes to upstream happen under the human identity (gated by `identity_switch_authorized`); comments on a primary upstream PR do not. Any post-handoff comment that needs to land on a primary repo's PR is surfaced as a message to the maintainer (or a posted job carrying the proposed body), not posted directly. Primary repos are those where the human is the maintainer rather than a contributor (`endojs/endo`, `agoric/agoric-sdk`); the source-side cross-link on `endojs/endo-but-for-bots` is fine to post directly because that repo is the garden.

- **Frame for the upstream audience.** Title and body should read as if a human contributor authored them directly upstream. Drop bot-specific framing in the title (parentheticals like `(mirror of #N for upstream)`). Rewrite body sections that explain the garden's bookkeeping. Translate or drop fork-only issue references that point at garden-side PRs or issues; if an upstream-equivalent issue exists, cite that, otherwise omit. Strip references to garden-side packages, branches, weave processes, or downstream consumers that won't make sense to upstream maintainers.

## Done

- One upstream PR is open, attributed to the named human, with no bot authors or co-authors on any commit.
- The garden-side PR carries a single tagged cross-link comment (`Mirror of <upstream-PR-URL> (head <short-SHA>).`), edited in place on re-ferries.
- The job's `tada` report names the garden PR URL, the upstream PR URL, the head SHA of the upstream branch, and the garden-side cross-link comment ID.

## Notes from the field

- _2026-05-14_: a re-ferry issued from the wrong host blocked correctly on the *Host preconditions* check: `gh auth status` returned only the bot account, and `gh api repos/endojs/endo --jq .permissions` reported `push: false`. The boatman refused to push under the bot identity, left the local commits for teardown, and surfaced the gap to the maintainer. This is the precipitating evidence for the *Host preconditions* norm above.
