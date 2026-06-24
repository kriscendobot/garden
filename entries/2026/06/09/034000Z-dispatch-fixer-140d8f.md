---
ts: 2026-06-09T03:40:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--140d8f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: upstream-source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo-but-for-bots/issues/75#issuecomment-4655836014
  - https://github.com/endojs/endo/pull/3232#pullrequestreview-4445424009
---

# dispatch: fixer — carry endo#3232 final review into single append commit on #75 (kriskowal directive)

User directive (kriskowal at 2026-06-09T03:38:11Z on PR #75,
issue comment `4655836014`):

> Per accept all feedback in this final review
> https://github.com/endojs/endo/pull/3232#pullrequestreview-4445424009
> and append a single commit with your changes, then shepherd.

This dispatch handles the **carry + append** step. A follow-on
shepherd dispatch handles CI convergence once the commit is pushed.

## State at dispatch time

- **Mirror PR** `endojs/endo-but-for-bots#75`
  ("feat(random,chacha12): factor @endo/random from @endo/chacha12
  [resync to actual/kriskowal-random-chacha20]"), OPEN (not DRAFT),
  base `master`, head `kriskowal-random-chacha12` at
  `1da07c3587d5384551a60546a8c78fb34b1dae7c` (`1da07c358`).
  `reviewDecision: CHANGES_REQUESTED`, `mergeStateStatus: UNSTABLE`.
- **Upstream review** `endojs/endo#3232 #pullrequestreview-4445424009`,
  state APPROVED, by **gibson042**, submitted 2026-06-09T02:31:42Z,
  body: *"LGTM after addressing (or explicitly choosing not to address)
  some final comments and suggestions."*
- **Seven inline suggestions** tied to that review
  (`pull_request_review_id == 4445424009`), enumerated per memory
  rule *Fetch ALL inline comments tied to a review*:
  1. `.changeset/endo-chacha12.md:23` (id `3369687293`) — suggestion
     reframing the keystream methods' description (clarify
     snapshot/clone/next as `pure-rand` v8 `RandomGenerator`
     conformance).
  2. `packages/chacha12-fast-check-test/test/_random-type.js:8`
     (id `3369692155`) — *"Neither `packages/random-fast-check/` nor
     `designs/random-pure-rand-v8-interface.md` seem to exist."*
     (substance ask: investigate, remove stale references or create
     the missing artifacts.)
  3. `packages/chacha12-fast-check-test/test/_random-type.js:33`
     (id `3369696203`) — consistency suggestion: rewrite the comment
     to *"structurally compatible with `pure-rand@8`'s
     `RandomGenerator` (and therefore with `fast-check@4`'s
     `randomType` parameter)."*
  4. `packages/chacha12-fast-check-test/test/_random-type.js:40`
     (id `3369697997`) — *"I don't see an `@endo/random-fast-check`."*
     (substance ask similar to #2.)
  5. `packages/chacha12-fast-check-test/test/fast-check.test.js:61`
     (id `3377415818`) — suggestion: tighten assertion to
     `t.true(runA.length > 1);`.
  6. `packages/chacha12-fast-check-test/test/fast-check.test.js:91`
     (id `3377468377`) — multi-line suggestion restructuring
     `findCounterexample` to use a `distinctResults` set and assert
     both true/false branches are produced.
  7. `packages/chacha12/src/chacha12.js:16` (id `3377480793`) —
     suggestion rewording the comment header to match the
     `pure-rand@8`/`fast-check@4` framing.

**Fetch each comment's full body** with
`gh api repos/endojs/endo/pulls/comments/<id>` before applying;
the excerpts above are truncated and the longer multi-line
suggestion blocks (5, 6) need to be applied verbatim.

## Task

In your `project/` worktree on the `kriskowal-random-chacha12`
branch (currently at `1da07c358`):

1. **Read each of the seven upstream inline comments in full** via the
   `gh api` endpoint cited above.
2. **Apply each suggestion** to the corresponding file. The
   `suggestion` blocks (comments 1, 3, 5, 6, 7) drop in directly.
   For substance asks (comments 2 and 4) — *"Neither
   `packages/random-fast-check/` nor `designs/random-pure-rand-v8-interface.md`
   seem to exist."* and *"I don't see an `@endo/random-fast-check`."* —
   first investigate: run `find packages -type d -name 'random-fast-check'`
   and `ls designs/ | grep -i pure-rand` in `project/`, and check
   whether the referenced packages were renamed or never created.
   Then either remove the stale references (preferred if they were
   never created) or replace them with the correct names if they
   were renamed.
3. **Sweep mirror PR #75's own inline threads** for any
   currently-unresolved asks not yet addressed. Per memory rule
   *Sweep mirror PR's inline comments before upstream-feedback-carry
   dispatch*: enumerate via `gh api
   repos/endojs/endo-but-for-bots/pulls/75/comments`, filter for
   unresolved threads (use the GraphQL `isResolved` field via
   `gh api graphql` if needed), and fold any unaddressed asks into
   the same append commit. The maintainer's directive is "append a
   single commit" — that covers upstream + mirror sweep in one
   commit. If the mirror sweep finds nothing unresolved, note the
   negative result in the result entry.
4. **Verify locally** that the changes are coherent: at minimum,
   `corepack yarn build` and `corepack yarn lint` should pass
   without new errors. Skip the full test suite — shepherd handles
   CI convergence.
5. **Append as a single commit** with a conventional-commit message:
   `fix(random,chacha12): address gibson042 final review on endo#3232`
   (extend with mirror-sweep scope if applicable). Per the
   maintainer's "append a single commit" framing, one commit covers
   all seven asks plus the mirror sweep — do NOT split.
6. **Push** to `kriskowal-random-chacha12` (regular append push).
7. **Reply on each upstream inline thread** at
   `gh api repos/endojs/endo/pulls/comments/<id>/replies` citing the
   addressing commit's SHA on the mirror. Threads on the upstream
   PR get short acknowledgments noting the mirror commit; the
   upstream ferry happens later (separate boatman dispatch).
8. **Post a top-level summary comment** on PR #75 listing each
   addressed thread (upstream comment id + brief one-line summary)
   and the appending commit SHA. Note any mirror-sweep findings.
9. **Reply to the kriskowal directive comment** (issue comment
   `4655836014`) confirming completion and naming the commit SHA;
   include "shepherd dispatch follows" so the maintainer knows the
   CI step is queued.

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `kriskowal-random-chacha12` (append push).
  Implicit in the fixer dispatch.
- **Reply on upstream endo#3232 inline threads**: the
  `endo-but-for-bots` standing broad-comment authorization does
  NOT extend to `endo` upstream. Inline replies on **endojs/endo**
  threads are NOT authorized for this fixer — only post the mirror
  PR's top-level summary and the response to kriskowal's directive
  on #75 itself. If you find an upstream thread that needs a reply,
  note it in the result entry for a future boatman/upstream-reply
  dispatch.
- **Top-level summary comment** on PR #75. Standing authorization.
- **Reply to issue comment `4655836014`** on PR #75. Same.

## Out of scope

- Do NOT re-request review. The directive's chain ends with
  shepherd; review re-request happens later.
- Do NOT split the commit. The maintainer's "append a single commit"
  framing is explicit.
- Do NOT rebase or amend prior commits. Append only.
- Do NOT touch the upstream endo#3232 PR or push to endojs/endo.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs.
- The single commit SHA.
- File-by-file list of changes, mapped to upstream comment ids.
- Mirror-sweep findings (resolved/unresolved counts; any unaddressed
  asks folded in).
- Result of local `yarn build` + `yarn lint`.
- The top-level summary comment URL on PR #75.
- The reply URL to issue comment `4655836014`.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the shepherd next and tears down your
dispatch root on return.
