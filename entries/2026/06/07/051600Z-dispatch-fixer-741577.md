---
ts: 2026-06-07T05:16:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--741577
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4444439085
  - entries/2026/06/07/042631Z-result-fixer-304a6e.md
---

# dispatch: fixer — apply kriskowal's continuation review on PR #403 (package rename + 5 inline asks)

Maintainer-feedback dispatch per the Monitor-surfaced
`PullRequestReviewEvent` at 2026-06-07T05:13:40Z on
`endojs/endo-but-for-bots#403`. Review `4444439085` is kriskowal
CHANGES_REQUESTED — the continuation of the partial review
`4444359521` that the prior fixer `b321bb` already addressed (the
maintainer reviewed the response and added these new asks).

## Review body (4444439085)

> Please rename the package `@endo/exo-npm` or similar. Registry
> is too vague, and capability goes without saying. The norm in
> `@endo` is to use `exo-` in the package name prefix to indicate
> that it imports and exports passable interfaces over a CapTP.
> Please make a note for the gardener that the style guide could
> use a hint for future designers.
>
> Please add the next implementation phase to this change.

## Five inline comments tied to this review

1. **`packages/registry-capability/src/store-web-powers.js:1`**
   (id `3368779961`):
   > The name is a subtle misnomer since this works on the web
   > and node, although those are not all possible platforms. I
   > think we should keep the name, since Node.js is emulating
   > the web, but maybe make a note in the comment that it is
   > suitable for Node.js as well.

   Action: keep the filename; add a JSDoc/comment block noting
   the Node.js-as-web-emulation suitability.

2. **`packages/registry-capability/src/store.js:1`**
   (id `3368782942`):
   > It may make sense to factor out e.g., `mem-store.js`.
   > However, a CAS is not in the scope of `@endo/exo-npm`.
   > Perhaps we should factor out `@endo/mem-cas`, with the
   > intention to eventually fill out `@endo/git-cas` or other
   > implementations of a common CAS interface. Note that the
   > daemon has an intern... [body truncated; read the full
   > comment from GitHub before acting]

   Action: factor the in-memory CAS into a new `@endo/mem-cas`
   package; design for an interface that `@endo/git-cas` (and
   others) can implement later. The renamed `@endo/exo-npm`
   then depends on `@endo/mem-cas` rather than carrying the
   store internally.

3. **`packages/registry-capability/src/interfaces.js:79`**
   (id `3368788764`):
   > "Content-Address-Store Store" is redundant. Please remind
   > the gardener that a pedantic naming reviewer should catch
   > mistakes like ATM Machine, Chai Tea, or Pita Bread.

   Action: fix the redundant naming at line 79 (drop the trailing
   "Store" word from the type/interface name).

4. **`packages/registry-capability/src/reference-backend.js:41`**
   (id `3368790256`):
   > The scope is Npm, not Js.

   Action: the package scope is the npm registry, not all of JS.
   Rename or rescope as appropriate at line 41.

5. **`packages/registry-capability/src/reference-backend.js:1`**
   (id `3368791874`):
   > This needs to be factored in a way where the implementation
   > receives tables (backed by sqlite) for caching npm registry
   > information. I'm expecting to map package name to version to
   > content, and to be sorted by version (dewey-decimal, so
   > potentially with three separate columns for major, minor,
   > and p... [body truncated; read full from GitHub before
   > acting]

   Action: rework the reference backend to accept sqlite-backed
   tables (caller-provided) for package metadata, with dewey-
   decimal version sorting. This is the largest substance change
   in this review.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#403`, DRAFT, base `llm-c85d618`
  (frozen-base-branch), head `b7e7bd93` (from prior fixer
  `b321bb`). Full SHA: `b7e7bd932...`.
- Review `4444439085` CHANGES_REQUESTED submitted
  2026-06-07T05:13:40Z (about 3 min before this dispatch).
- Note PR title carries `(#358 layer 1)` framing; the
  maintainer's "add next implementation phase" hint suggests
  layer 2 should be folded into this PR rather than a follow-up.

## Task

In your `project/` worktree on `feat/registry-capability`
(currently at `b7e7bd93`):

1. **Fetch and reset to current tip**:
   `git fetch origin && git reset --hard origin/feat/registry-capability`.
2. **Read full inline comment bodies** for items 2 and 5 (the
   ones truncated above) via
   `gh api repos/.../pulls/comments/3368782942` and
   `.../comments/3368791874`. The truncated tails carry concrete
   guidance you need.
3. **Package rename** (item from review body):
   - Move `packages/registry-capability/` → `packages/exo-npm/`.
   - Update `package.json`'s `name` from
     `@endo/registry-capability` → `@endo/exo-npm`.
   - Sweep all references across the workspace (`grep -rIn
     '@endo/registry-capability\\|registry-capability' --include='*.json'
     --include='*.js' --include='*.ts' --include='*.md'`).
   - Update `yarn.lock` via `corepack yarn install`.
4. **Address the 5 inline asks** in order (or interleaved
   sensibly with the rename); separate commit per concern is
   cleaner than bundling:
   - `docs(exo-npm): note Node.js-as-web-emulation suitability
     in store-web-powers` (inline 1).
   - **Factor out `@endo/mem-cas`** as a new package: create
     `packages/mem-cas/` with the in-memory CAS implementation,
     design the interface for later `@endo/git-cas`. Update
     `exo-npm` to depend on `mem-cas` (inline 2). This may be a
     2-3 commit sub-sequence depending on how clean the
     extraction is.
   - `fix(exo-npm): drop redundant "Store" from
     ContentAddressStoreStore naming` (inline 3).
   - `fix(exo-npm): rescope reference-backend to npm scope`
     (inline 4) — rename or annotate per the inline guidance.
   - `feat(exo-npm): sqlite-backed reference-backend tables for
     npm metadata caching` (inline 5) — implement caller-provided
     sqlite tables with dewey-decimal version sorting. **This is
     the largest substance change; if it grows beyond fixer
     scope (e.g., requires designing a new interface from
     scratch, requires deep test coverage), surface the over-
     scope to liaison via `message: fixer → liaison` and stop at
     a partial fix rather than overrun.**
5. **"Add next implementation phase to this change"** (review
   body): read `journal/projects/endo-but-for-bots/` or
   `designs/` for `#358` references to understand what "layer
   2" / "next phase" means. If the scope is clear and surgical,
   fold it in. If the scope is large (new interfaces, new design
   doc), surface to liaison and stop.
6. **Reply on each inline thread** citing the addressing
   commit(s). Reply on the review's top-level (a top-level
   comment on the PR) summarizing the rename + 5 inline + next-
   phase coverage.
7. **Push** all commits to `feat/registry-capability` (regular
   append).

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `feat/registry-capability` (regular append).
- **Reply on each inline thread** and post the top-level
  summary comment (`endo-but-for-bots` standing broad-comment
  authorization).
- **Open a new package** (`packages/exo-npm/`, `packages/mem-cas/`):
  implicit in the rename + factor-out asks. The new package
  files land in the same PR.
- **NOT re-request review**: the maintainer's review pattern on
  #403 is multi-stage (partial → continuation); they will return
  on their own cadence.

## Out of scope

- Do NOT amend or rewrite prior commits on the branch; this is
  an additive fix.
- Do NOT touch packages outside `registry-capability`/`exo-npm`/
  the new `mem-cas` (except for cross-reference updates from the
  rename).
- Do NOT drive CI to green; a follow-on shepherd will handle CI
  if needed.

## Steward-side parallel

A separate `message: steward → gardener` entry in the same cycle
forwards the two meta-evolution asks from this review body:

- "Make a note for the gardener that the style guide could use a
  hint for future designers" (re: `exo-` package-name prefix
  norm).
- "Remind the gardener that a pedantic naming reviewer should
  catch mistakes like ATM Machine, Chai Tea, or Pita Bread" (re:
  redundant-word naming).

You do NOT need to forward these; the steward handles the
gardener routing in parallel.

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming:

- Pre/post branch tip SHAs.
- Per-commit SHAs and one-line descriptions.
- Whether the "next implementation phase" was folded in or
  surfaced as out-of-scope.
- The new package directories created (`exo-npm`, `mem-cas`).
- Cross-reference rename sweep diff line counts.
- Reply-on-thread URLs (5 inline + top-level).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
