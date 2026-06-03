---
source: designs/unhandled-rejection-display.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 04b3022bde245745b3dfcef1cf299592f9b511d6
source_date: 2026-05-18
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-sixth-comment-style design ingest (cycle 149). 323-
  line *Complete* status design shipped 2026-05-11 via PR
  #187 (commit `a588f0b80` on `llm`; parallel non-bot landing
  `74a56009a` 2026-05-12). Source issue #171; repro test PR
  #174. Three-day active development (design + 2 days
  implementation).

  §Load-bearing-symptom-and-diagnosis: CapTP
  `CTP_DISCONNECT.reason` carrying an `Error` instance
  encodes as `{}` because `Error`'s `name`/`message`/`stack`
  are non-enumerable and invisible to `JSON.stringify`. The
  receiver's `defaultOnReject` printed *CapTP <name>
  exception: {} ''* — empty braces and empty string. Triage
  cannot distinguish a `socket has been ended` race from an
  `assert.fail` in a guest formula.

  Single most structurally interesting move: §two-coordinated-
  changes discipline. *Either part on its own is
  insufficient: a sender that preserves Error structure does
  no good if the receiver's display still falls through to a
  formatter that drops it; a smarter receiver display has
  nothing to display if the wire stripped the structure*.
  §coordinated-changes-as-design-shape — one piece of work
  spans two code sites that must agree.

  §Sender-side: `messageToBytes` in `packages/daemon/src/
  connection.js` gets a narrow guard on `message.type ===
  'CTP_DISCONNECT' && message.reason instanceof Error`;
  extracts the three diagnostic-bearing fields (name +
  message + stack); emits `{ '@@error': true, name, message,
  stack }`. §three-property-extraction matches three of
  cycle 87's pass-style/error.js four-property allowlist
  (cause deferred). §sentinel-not-duck-typing discipline:
  `'@@error': true` is preferable to duck-typing on
  `'message' in reason && 'stack' in reason` because nothing
  prevents an application from sending a plain object with
  those field names. §`@@`-prefix-convention propagates
  cycle 148's symbol.js Hilbert-Hotel discipline. §narrow-
  guard-keeps-out-of-hot-path — disconnect is cold path; call/
  return/resolve are hot path and already go through marshal.

  §Receiver-side `renderRejection`: §four-case-fallback
  ladder — (1) real Error → `name: message\nstack`; (2)
  `'@@error': true` sentinel → reconstruct; (3) passable per
  `isPassable` from @endo/marshal → `passableAsJustin`; (4)
  non-passable → `(non-passable <type>) String(reason)`.
  §`passableAsJustin`-not-`JSON.stringify` (project standard
  per CLAUDE.md's Diagnostic Discipline rule). §use-marshal-
  for-display-not-wire — marshal-for-display is one-way
  read-only that doesn't depend on table state; marshal-for-
  wire is the rejected Alternative 1.

  §Four rejected alternatives (the structurally interesting
  meat of the design):

  **Alt 1 — route through @endo/marshal (rejected)**:
  §error-path-cannot-depend-on-error-path discipline — *the
  disconnect path runs precisely when the connection state is
  unreliable. The marshal tables may have been GC'd, the
  c-list may be partially torn down, or the disconnect may be
  happening because marshal itself failed*. §extraction-is-
  intentionally-syntactic — no method dispatch, no proxy
  traps, no table lookups, no exo invocation; cannot fail.
  Cycle's most generalizable insight: **diagnostic paths must
  not depend on the substrate they diagnose**. Parallel to
  cycle 100's SES rejection-tracker.

  **Alt 2 — `JSON.stringify` replacer (rejected)**: §narrow-
  guard-not-tree-walk discipline. Replacer runs at every key;
  would over-apply and conflict with marshal-side encoding
  for CTP_RETURN.exception. §two-different-error-encodings-
  must-coexist invariant.

  **Alt 3 — receiver-only fix (rejected)**: §you-can't-fix-
  it-on-receiver-because-bytes-are-lost — the fundamental
  information-theoretic constraint that *forces* the two-
  coordinated-changes structure. No amount of receiver
  cleverness can recover what `JSON.stringify` discarded.

  **Alt 4 — replace JSON with `passableAsJustin` on the wire
  (rejected)**: §peer-compatibility-during-rollout. Justin is
  a language; would need parser on receiver; wire-incompatible
  with non-upgraded peers. The chosen design is strictly
  additive — §progressive-rollout-without-flag-day.

  §helper-lives-next-to-encoder discipline: `renderRejection`
  exported from connection.js *because the two are conjugate
  sides of the same wire-shape decision*. §wire-and-display-
  as-conjugate-sides. §future-portability gesture to
  @endo/captp (Open question #2 — `defaultOnReject` there has
  the same bug for any captp consumer not providing custom
  onReject).

  §three-day-active-development calibration via `git blame`
  on `llm`: design 2026-05-10 → implementation 2026-05-11-12
  → PR #187 squash-merge 2026-05-11 + parallel non-bot
  `74a56009a` 2026-05-12. §roadmap-calibration-via-git-blame
  discipline (same shape as cycle 95's chat-rename-dismiss-
  to-clear 65-day window).

  §migration-without-caller-change: existing Error reasons
  get strictly-better diagnostic; non-Passable reasons get
  slightly more informative diagnostic; no breaking change.
  §strictly-additive-on-receiver-side discipline.

  §three-open-questions §honest-deferral: (1) `@@error` vs
  marshal `errorIdNum` (answered by §two-encodings-coexist);
  (2) lift `renderRejection` to @endo/captp (acknowledged
  incomplete fix); (3) plain shape vs CapData blob
  (recommendation: plain for now).

  Cycle 149 was nominally papers-lane (cycle 148 was
  comments). Papers-lane blocked 43+ consecutive cycles.
  Cycle 149 pivoted to designs-lane.
---

> Abstract: `unhandled-rejection-display.md` (323 lines,
> *Complete*; shipped 2026-05-11 via PR #187) is a tight,
> load-bearing CapTP diagnostic-path design.
>
> §Load-bearing-symptom: CapTP `CTP_DISCONNECT.reason`
> carrying an `Error` encodes as `{}` because `Error`'s name/
> message/stack are non-enumerable and invisible to
> `JSON.stringify`. Triage cannot distinguish race from
> assert.fail.
>
> **Single most structurally interesting move**: §two-
> coordinated-changes discipline. *Either part on its own is
> insufficient*. One piece of work spans two code sites
> (sender + receiver) that must agree.
>
> §Sender-side: narrow `messageToBytes` guard emits
> `{ '@@error': true, name, message, stack }`. §sentinel-not-
> duck-typing; §`@@`-prefix from cycle 148.
>
> §Receiver-side `renderRejection`: §four-case-fallback (real
> Error / `@@error` sentinel / passable→Justin / non-passable
> →String). §`passableAsJustin`-not-`JSON.stringify`.
>
> §Four rejected alternatives. **Most generalizable insight**:
> §error-path-cannot-depend-on-error-path —
> diagnostic paths must not depend on the substrate they
> diagnose. §extraction-is-intentionally-syntactic (no
> marshal, no exo machinery; cannot fail mid-disconnect).
>
> §you-can't-fix-it-on-receiver-because-bytes-are-lost is the
> information-theoretic constraint forcing the two-coordinated
> structure.
>
> §three-day-active-development calibration via git-blame.
> §migration-without-caller-change.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback](../sections/endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback.md) | daemon, captp, errors | current |

Tight 323-line *Complete* design. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@
  04b3022bd` (branch `origin/llm`) via the local bare-clone.
- Created 2026-05-10 / updated 2026-05-18 / status
  *Complete*. Author Kris Kowal *(prompted)*.
- Shipped 2026-05-11 via PR
  [#187](https://github.com/endojs/endo-but-for-bots/pull/187)
  commit `a588f0b80`; parallel non-bot landing `74a56009a`
  2026-05-12. Source issue #171; repro test PR #174.
- Last touch commit `04b3022bd` 2026-05-20 (`docs(designs):
  unhandled-rejection-display roadmap calibration (3-day
  active span)`).
- **Thirty-sixth-comment-style design ingest.**
- Cycle 149 was nominally **papers-lane** (cycle 148 was
  comments). Papers-lane has been blocked for **43+
  consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 149 pivoted to designs-lane.
- One cohesion-honest section.
