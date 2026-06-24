---
ts: 2026-05-19T23:37:51Z
kind: result
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/225725Z-dispatch-steward-84ed30.md
---

# Steward wrap-up: 5-builder parallel dispatch (4 PRs opened + 1 no-op)

| Bucket | Dispatch | Outcome | PR |
|---|---|---|---|
| A — status PR for 11 designs | builder `ec855a` | OPENED | [#302](https://github.com/endojs/endo-but-for-bots/pull/302) |
| B1 — chat-edit-message-ui | builder `f4075c` | OPENED (stacked on #125) | [#305](https://github.com/endojs/endo-but-for-bots/pull/305) |
| B2 — filesystem-watchers | builder `c597b8` | **NO-OP** | [#277](https://github.com/endojs/endo-but-for-bots/pull/277) already exists |
| B3 — daemon-capability-persona | builder `e50dd8` | OPENED | [#306](https://github.com/endojs/endo-but-for-bots/pull/306) |
| C — kriskowal-error-trace + gamut | builder `a8e4d9` | OPENED DRAFT | [#301](https://github.com/endojs/endo-but-for-bots/pull/301) |

**Notable findings**:

- **B2 was a duplicate** — `packages/daemon/src/mount.js` already
  has `followNameChanges` via the open PR #277 (`feat/endo-mount-follow-name-changes`,
  950 LOC, +8 mount tests + 335-LOC `watch-directory.test.js`).
  The design's `followLocatorNameChanges` parity ask was scoped out
  by the design itself (mounts have no formula identifiers). Builder
  correctly stopped at pre-flight check; recommend routing #277
  through the gamut instead of dispatching a fresh builder. **No
  fresh PR opened**.

- **Bucket A's three "believe merged" misses** (per the builder's
  per-design table on #302):
  - `chat-pending-commands`: PR [#133](https://github.com/endojs/endo-but-for-bots/pull/133)
    OPEN; code not on `llm`. Status set to **In Progress**, not Complete.
  - `daemon-message-streaming`: PR [#287](https://github.com/endojs/endo-but-for-bots/pull/287)
    OPEN; Phase 1 on feature branch only. Status **In Progress**.
  - `daemon-retention-paths`: PR [#284](https://github.com/endojs/endo-but-for-bots/pull/284)
    OPEN; `listRetentionPaths` still private to GC on `llm`. Status **In Progress**.
  These three may warrant gamut runs on the open PRs to drive them
  to merge.

- **`daemon-mount` partial**: 4 of 6 phases on `llm` (Phases 1, 2,
  3, 5 via direct commit `e22f71327` and #135/#127/#277). Phases 4
  and 6 still open across the three open PRs. Builder marked Status
  **In Progress** rather than Complete; user's "probably complete"
  hint was overstated.

**Bucket C (kriskowal-error-trace) caveat**: branch's merge-base is
~435 commits behind current `origin/llm`. PR #301 opens with the
focused 36-file diff (GitHub uses merge-base). A future weaver
dispatch may want to rebase. Drafted as-is per dispatch guidance.

**Standing PR-creation-flow scan** will pick up the 3 new DRAFT PRs
(#301, #305, #306) on next cycle for cleaner → judge → fixer-loop →
un-draft. PR #302 is non-draft (chore docs PR) and goes straight to
review.

Self-improvement: the B2 no-op is the second time a builder dispatch
hit a pre-existing PR for the same design (first was the prior
contractor's design-to-PR pipeline catching duplicates). Worth
landing a hint in the gardener queue: "before opening a fresh
implementation builder, the dispatcher should grep open PRs for the
design slug first; the builder's own pre-flight check is the second
line of defense." Already routed via this entry's body; explicit
gardener message not needed.
