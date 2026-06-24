---
ts: 2026-06-02T23:36:24Z
kind: message
role: liaison
host: endolinbot
to: "*"
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
---

# message: #394 CHANGES_REQUESTED — Git-backed CAS architectural pivot, not autonomously dispatchable

kriskowal submitted a second CHANGES_REQUESTED review on PR #394
at 2026-06-02T23:35:32Z (review `4414303711`). One inline comment
at `packages/gateway/test/git-http-integration.test.js:446`
(comment `3345066407`) proposes a substantial architectural
pivot:

## The pivot

Replace the daemon's ad hoc CAS implementation (Node.js + Rust)
with one backed by a Git bare repository in the daemon's state
directory:

- One repository per daemon (gateway included), serving content
  on virtual hosts.
- Bearer tokens correspond to (or are identical to) refs like
  `refs/formulas/${id}`.
- Formula GC effects ref collection → ref collection effects git
  object collection (mirror Git's natural reachability semantics).
- Read/write lock discipline on the bare repository.
- Web-based daemon variant would inject a different CAS
  (browser local storage).
- Node.js CAS: initial implementation may shell out to `git`;
  second iteration borrows from @0xpatrickdev's Node.js Git
  implementation work.
- Rust CAS: bind `libgit2` (C library).
- **Use the sha256 Git variant; avoid sha1.**

Architecturally: the Gateway initializes its own Daemon with the
Git CAS, then retains the underlying CAS implementation and
vends it to the HTTP server for regulated push/pull.

## Why this isn't a fixer dispatch

This is designer-scope work that crosses multiple PRs and packages:

- Touches `packages/daemon` CAS internals.
- Touches `packages/gateway`'s daemon-injection pattern.
- Has a Rust-side counterpart (separate codebase).
- Intersects with #403's pending architectural pivot
  (`registry-capability` also called for daemon integration +
  CAS injection — kriskowal's review at `4413951956` said
  "integrate it into the daemon by injecting the CAS and
  necessary sqlite tables for persisting the registry
  metadata").

Two architectural pivots (this one + #403) both want CAS work,
both call for designer dispatch, and may benefit from a single
unified design rather than two independent ones.

## Right next move

Maintainer-engaged scoping. Options:

1. Designer dispatch on garden #3-style approach: draft a
   designs document for the Git-backed CAS, get maintainer
   review on the design, then builder dispatch.
2. Combined scoping with #403's CAS injection ask: single
   design covers both architectural pivots; addresses the
   bearer-token=ref-formula pattern and the registry metadata
   storage in one shot.

The autonomous steward defers either choice to the user.

## Companion: #394's integration test stays as-is for now

The Bearer-auth integration test at `git-http-integration.test.js`
that the prior fixer landed (commit `b22e0db66`) is still
correct for the current daemon contract. The architectural
pivot above would replace the underlying CAS, not the
HTTP-level bearer/path/ref protocol the test exercises. The
test remains useful as a regression anchor through any CAS
swap.

## Steward queue post-engagement

- **#394** new CHANGES_REQUESTED on Git-backed CAS pivot;
  awaits maintainer-engaged scoping. CI failures already noted
  as inherited from #393 base.
- **#403** registry-capability CAS-injection pivot; same scoping
  decision (potentially combined).
- All other queue items unchanged from 232446Z entry.
