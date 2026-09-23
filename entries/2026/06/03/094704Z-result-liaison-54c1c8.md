---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--54c1c8
ts: 2026-06-03T09:47:04Z
ref_id: 54c1c8
---

# Cycle 149 result — unhandled-rejection-display.md (thirty-sixth-comment-style design ingest)

Cycle 149 of the librarian arc. Nominally papers-lane (cycle 148 was
comments); papers-lane has been blocked for **43+ consecutive
cycles**. Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/unhandled-rejection-display.md` — 323-line
*Complete* status design by Kris Kowal *(prompted)*. Shipped
2026-05-11 via PR #187 (`a588f0b80`); parallel non-bot landing
`74a56009a` 2026-05-12. Three-day active development (design
2026-05-10 + impl 2026-05-11-12).

## The §load-bearing-symptom

CapTP `CTP_DISCONNECT.reason` carrying an `Error` instance encoded
as `{}` on the wire because `Error`'s `name`/`message`/`stack` are
non-enumerable and invisible to `JSON.stringify`. The receiver's
`defaultOnReject` printed *CapTP <name> exception: {} ''* — making
it impossible to distinguish a `socket has been ended` race from an
`assert.fail` in a guest formula.

## Structural moves captured

- **Single most structurally interesting move**: §two-coordinated-
  changes discipline — *Either part alone is insufficient*. One
  piece of work spans two code sites (sender + receiver) that must
  agree on the `@@error` sentinel and field set.

- **§Sender-side**: narrow `messageToBytes` guard on
  `message.type === 'CTP_DISCONNECT' && message.reason instanceof
  Error` emits `{ '@@error': true, name, message, stack }`. §three-
  property-extraction matches three of cycle 87's pass-style/
  error.js four-property allowlist (cause deferred). §sentinel-not-
  duck-typing. §`@@`-prefix-convention from cycle 148's symbol.js.
  §narrow-guard-keeps-out-of-hot-path.

- **§Receiver-side** `renderRejection`: §four-case-fallback ladder
  (real Error / `@@error` sentinel / passable → `passableAsJustin` /
  non-passable → `String(reason)`). §`passableAsJustin`-not-
  `JSON.stringify` per CLAUDE.md Diagnostic Discipline.

- **§Four rejected alternatives** (the structurally interesting
  meat):
  - **Alt 1 — route through @endo/marshal**: §error-path-cannot-
    depend-on-error-path discipline. *The disconnect path runs
    precisely when the connection state is unreliable*. §extraction-
    is-intentionally-syntactic. **Cycle's most generalizable
    insight**: *diagnostic paths must not depend on the substrate
    they diagnose* (parallel to cycle 100's SES rejection-tracker).
  - **Alt 2 — JSON.stringify replacer**: §narrow-guard-not-tree-
    walk. Replacer over-applies; conflicts with marshal-side
    encoding for CTP_RETURN.exception. §two-different-error-
    encodings-must-coexist invariant.
  - **Alt 3 — receiver-only fix**: §you-can't-fix-it-on-receiver-
    because-bytes-are-lost — information-theoretic constraint that
    *forces* the two-coordinated-changes structure.
  - **Alt 4 — replace JSON with `passableAsJustin` on wire**:
    §peer-compatibility-during-rollout. Strictly-additive +
    §progressive-rollout-without-flag-day.

- **§helper-lives-next-to-encoder**: `renderRejection` exported from
  connection.js *because the two are conjugate sides of the same
  wire-shape decision*. §wire-and-display-as-conjugate-sides.

- **§three-day-active-development calibration** via `git blame` on
  `llm`: design 2026-05-10 → impl 2026-05-11-12 → PR #187 +
  parallel non-bot landing. §roadmap-calibration-via-git-blame
  discipline (same shape as cycle 95's chat-rename-dismiss-to-clear).

- **§migration-without-caller-change**: existing Error reasons get
  strictly-better diagnostic; non-Passable get slightly more
  informative. No breaking change.

- **§three-open-questions §honest-deferral**: (1) `@@error` vs
  marshal `errorIdNum`; (2) lift renderRejection to @endo/captp
  (acknowledged incomplete — captp's own `defaultOnReject` has the
  same bug); (3) plain shape vs CapData blob.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-unhandled-rejection-display`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback.md`
- **Topics**: daemon, captp, errors
- **Library totals**: 653 sections from 194 source documents
- **Lane rotation**: nominally papers-lane (43+ consecutive blocks);
  pivoted to designs-lane

Cycle 149 closes. Schedule next wake 1500s for cycle 150.
