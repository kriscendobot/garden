---
ts: 2026-06-07T04:08:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b321bb
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4444359521
  - https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3368709228
  - https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3368718324
---

# dispatch: fixer — apply kriskowal's partial CHANGES_REQUESTED review on PR #403

Maintainer-feedback dispatch per the Monitor-surfaced
`PullRequestReviewEvent` at 2026-06-07T04:00:54Z on
`endojs/endo-but-for-bots#403`
(`feat(registry-capability): EndoRegistry capability + @registry
special name (#358 layer 1)`). Review `4444359521` is from
`kriskowal`, state `CHANGES_REQUESTED`, body: *"Partial review."*

Per the steward role's *Maintainer-feedback response* section, the
steward dispatches the response in the same parent-context tick.
Per the *Dispatch decision by PR shape* sub-section, this is a
source-touching PR (every changed path under `packages/registry-
capability/` or `tsconfig.*` or root `yarn.lock`/`.gitignore`),
so the dispatch goes to a **fixer**.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#403`, DRAFT, base `llm-c85d618`
  (frozen-base-branch snapshot), head
  `584d06da35cd9dac38ef299d6d7f7538513630c4` (`584d06da`).
- **Review**: `4444359521`, CHANGES_REQUESTED, *"Partial review."*
  marked partial; more comments may arrive on a subsequent review.
- **Inline comments** tied to this review (`pull_request_review_id
  == 4444359521`), enumerated per memory rule:
  1. `packages/registry-capability/test/store.test.js:9`
     (id `3368709228`):
     > Please use `@endo/bytes` to consolidate text encoder
     > instantiation.
  2. `packages/registry-capability/src/store.js:49`
     (id `3368718324`):
     > This is a binding to platform-specific powers which creates
     > excess coupling to a particular platform. Please note the
     > pattern for other platform-specific powers like
     > `daemon-node-powers.js` vs `daemon... [truncated]

## Task

In your `project/` worktree on the `feat/registry-capability`
branch (currently at `584d06da`):

1. **Fetch the full bodies** of both inline comments via
   `gh api repos/endojs/endo-but-for-bots/pulls/comments/3368709228`
   and `.../3368718324`. The brief above quoted only excerpts;
   the second comment is truncated. Read the full text from
   GitHub before composing your response.
2. **Address comment 3368709228** (text-encoder consolidation):
   Replace any direct `new TextEncoder()` / `new TextDecoder()`
   construction in `packages/registry-capability/test/store.test.js`
   (and adjacent files in the package if the pattern repeats)
   with the `@endo/bytes` consolidated helper. Check
   `packages/bytes/` for the canonical helper API; the maintainer's
   "consolidate" framing implies a single point of construction
   the package already exposes.
3. **Address comment 3368718324** (platform-specific powers
   coupling): Read the `daemon-node-powers.js` pattern the comment
   cites (search in `packages/daemon/src/` or wherever it lives).
   Refactor `packages/registry-capability/src/store.js:49`'s
   platform-specific binding to follow that pattern: separate the
   platform-specific binding from the capability surface, so the
   capability is platform-agnostic and the binding is the seam.
   The maintainer's exact prescription may be in the truncated
   tail; respect what the full comment says when you read it.
4. **Commit** each addressed comment with a conventional-commit
   message naming the package and the change. One commit per
   addressed concern is cleaner than bundling.
5. **Push** the new commits to `feat/registry-capability` (regular
   append push, no force needed).
6. **Reply on each inline thread** (`/pulls/comments/<id>/replies`)
   citing the addressing commit's SHA. Per the maintainer-feedback
   discipline, threads are addressed one-by-one rather than via a
   top-level summary alone.
7. **Post a top-level summary comment** on PR #403 once both
   threads are addressed, citing each commit SHA and noting the
   review was marked partial ("more comments may arrive on a
   subsequent review; this dispatch addresses the two surfaced
   so far").

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `feat/registry-capability` (regular append
  push; the PR's branch). Implicit in the fixer dispatch.
- **Reply on each inline thread** (`gh api .../comments/<id>/replies`).
  The `endo-but-for-bots` standing broad-comment authorization
  covers this.
- **Post the top-level summary comment** on PR #403. Same
  authorization.
- **Re-request review** is NOT implicit here because the
  maintainer marked the review *partial*; the maintainer will
  return to finish their review on their own cadence. Do not
  re-request.

## Out of scope

- Do NOT address comments that are NOT tied to review
  `4444359521`. If there are older inline threads pinning to
  prior code state, leave them for a separate dispatch.
- Do NOT amend the PR's overall shape (no rebase, no force-push,
  no commit rewriting).
- Do NOT mark the PR un-draft; the maintainer's *partial review*
  framing means the panel/jury workflow is the next-stage owner
  once the partial review is complete.

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming:

- The pre/post branch tip SHAs.
- The two commit SHAs (one per addressed comment).
- A brief summary of each change (file paths, lines touched, what
  pattern the platform-powers refactor adopted).
- The reply-on-thread URLs.
- The top-level summary comment URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
