---
ts: 2026-06-15T06:56:00Z
kind: result
role: fixer
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: "*"
short_id: e22b3b
prs:
  - { repo: kriscendobot/agoric-sdk, pr: 5, role: target }
refs:
  - entries/2026/06/15/064829Z-dispatch-fixer-e22b3b.md
  - entries/2026/06/15/065233Z-result-fixer-6c97c1.md
  - entries/2026/06/15/065348Z-message-fixer-ab9803.md
---

# result: fixer — kriscendobot/agoric-sdk#5 typedefs landed; CI blocker surfaced for liaison

Addressing SHA `f295e0d7`. Force-with-lease pushed onto
`mirror/12527-endo-sync-refresh` (lease anchor b0c0d727).

Two edits applied verbatim:
- `log-store.js:278`: 13-property `@typedef {object} LogStore`.
- `bijection.js:215`: 7-property `@typedef {object} Bijection`.

Inline replies + top-level summary posted on PR #5.

## CI blocker surfaced

The new strict `LogStore` typedef conflicts with TS inference
from Endo's `Guarded<>` wrapper. `Guarded<>`-returned methods
widen to a union TS can't narrow to `LogEntry`'s 5-tuple, so
the strict `peekEntry: () => LogEntry` typedef causes TS2322
/ TS2345 at `async-flow.js:196` and
`log-store.js:117/127/132/138/151/161/175/212/264`.

This is precisely the "broader call-site narrowing" the bot's
earlier review-reply (and this dispatch's brief) scoped OUT
as a separate Endo-upgrade hygiene follow-up. Replacing the
`LogStore`-side `@typedef {any}` without also addressing
those call sites breaks the previously balanced
`@ts-expect-error` suppression at b0c0d727.

CI on the new head:
- pass: lint, breakage, merge-strategy, run-scripts-tests,
  wait-integration-pre-checks, up-to-date.
- **fail**: build (node-old), test-dapp (node-new) — both
  with the same TS2322 / TS2345 cluster.

Fixer's discipline: did NOT touch call sites (respecting
"What NOT to touch") and did NOT speculate on a typedef
widening (e.g., `peekEntry: () => unknown`). Awaiting
orchestrator's call.

## Decision points for the liaison / maintainer

(a) Widen the typedef's method returns (e.g.,
    `peekEntry: () => unknown` or `LogEntry | undefined`).
    Honors the separate-followup scope. Loses some of the
    strict shape's value the bot's reply promised.
(b) Authorize the call-site `@ts-expect-error` additions in
    THIS PR after all. Goes beyond the bot's reply's scope
    but lands a complete green fix.
(c) Hybrid: widen ONLY the returns whose call sites conflict
    (`peekEntry`, `nextEntry`, `nextUnfilteredEntry`,
    `dump*`?); keep void / number / boolean returns strict.

Fixer's message-to-liaison at
`entries/2026/06/15/065348Z-message-fixer-ab9803.md`.
Dispatch root torn down.
