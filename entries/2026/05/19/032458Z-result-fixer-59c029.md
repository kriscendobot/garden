---
ts: 2026-05-19T03:24:58Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--7e0c14
---

Addressed kriskowal's 2026-05-19 CHANGES_REQUESTED review on PR #288
(`feat(cbor-frame): add @endo/cbor-frame package`).
Seventeen inline comments, all dispositioned:
fifteen addressed across seven topical commits on top of `c06186c2e`,
two routed out of scope (a weaver-shaped `@endo/bytes` import rebase
and a builder-shaped `@endo/stream` PR).

Commits pushed to `feat/cbors-package`
(in chain order, oldest first):

- `e11538263` refactor(cbor-frame): return undefined for under-read head
  (comment #2 `maybeRead`-precedent fault-handling)
- `0eb7584b7` feat(cbor-frame): require tag 24 wrapping on every frame
  (comment #1 mandatory tag 24; resolves design open question #2)
- `a636ce90c` refactor(cbor-frame): rename head decoder's high/low pair
  to hi/lo (comment #3 same-length-abbreviation precedent)
- `598b54a43` test(cbor-frame): drop ASCII section banners and
  blank-line the suite (comments #6/#7/#9/#10/#11 + comments #5/#8
  TODO note about `@endo/stream` + `makePipe` + `mapReader` refactor)
- `9bf81b19d` docs(cbor-frame): document mandatory tag 24 and list
  lp32 as sibling (comments #13/#14/#17)
- `000718b5c` docs(netstring,lp32): cross-reference framing-package
  siblings (comment #15)
- `6196d0f5b` chore(cbor-frame): drop the unreleased placeholder
  CHANGELOG.md (comment #12)

Local verification: 32 tests passed (`yarn ava`); `yarn lint` clean;
`tsc` clean.
Upstream CI is in progress at end of dispatch; a Monitor is awaiting
convergence so the orchestrator can re-request kriskowal's review
after green.

Inline replies posted on each of the seventeen threads citing the
addressing SHA (or, for #4/#5, the out-of-scope routing path).
Top-level summary comment posted at
<https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4484130013>.
Standing broad-comment authorization on endojs/endo-but-for-bots
covered all comment ops; no per-action escalation needed.

Gardener-shaped notes aggregated for the steward to forward in a
follow-up `message` entry to the gardener
(landed in the active style guide and naming guide):

1. Favor `undefined` over `null` for faults
   (the `maybeRead` precedent: a missing result is the absence of a
   value, not a sentinel value).
2. Same-length abbreviation pairs like `hi`/`lo` are acceptable when
   local and the same-length property is doing legibility work
   (a transposition error is visually obvious at the call site).
3. Avoid ASCII-art section banners in test files
   (the AVA test names give enough orientation).
4. Blank lines between tests
   (one blank line between consecutive `test(...)` invocations).
5. Avoid garden procedural jargon in test prose
   (specifically: do not write "adversarial sweep" in test
   comments; that is jargon-de-jardin our reviewers do not want to
   read).
6. Future builders: omit hand-rolled `CHANGELOG.md` placeholders for
   new packages; changesets writes the file on first release
   (and the first release will be at 1.0.0 anyway).

Self-improvement: nothing this time.
The fixer skill chain ran cleanly; the per-comment disposition table
on the top-level summary made the link from comment-to-SHA easy to
audit and is worth reusing on future multi-comment reviews.
