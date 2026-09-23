---
ts: 2026-06-02T23:42:03Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--4aef89
cycle: 130
---

# Cycle 130 — message-breakpoints.js (Mark Miller, endo) — comments-lane

Ingested `packages/eventual-send/src/message-breakpoints.js` (179
lines, Mark Miller-authored 2024-01-13 — the most senior @endo
file ingested in recent cycles) from `endojs/endo@b191aaf3`
(master). **Twenty-fourth comment-fragment ingest.** One
cohesion-honest section:

- **three-axis-match-grammar-with-external-internal-transpose-
  and-countdown-semantics** — the *runtime-configurable
  breakpoint tester* for E()-mediated eventual-send dispatch.
  The factory `makeMessageBreakpointTester(optionName)` reads an
  env-option-named JSON record and produces a tester with
  `getBreakpoints` / `setBreakpoints` / `shouldBreakpoint`.

## The single most structurally interesting move

The §external↔internal transpose. External JSON shape is
`{tag: {method: countdown}}` (human-organized by recipient
class); internal table is `{method: {tag: countdown}}`
(lookup-organized because shouldBreakpoint knows methodName
before recipient). The setBreakpoints procedure transposes the
index for fast lookup at shouldBreakpoint time.

## §The async-call-debugging-pain-point this file solves

In eventual-send, the actual delivery happens *later than the
call site*, often after an async hop. Breakpointing at the call
site is useless; you need to break at the *receiver's method
dispatch point*. This file lets the user say *break on the third
call to `.send` on any object tagged `'wallet'`* via a JSON env
var, with no code modification.

## §Predates the @endo/harden migration

This file uses `freeze` (not `harden`) and `Object.freeze` (not
`@endo/harden`'s default-export). Compared to cycles 108, 110,
115, 118, 123, 125 — all of which use `import harden from
'@endo/harden'` — this 2024-01-13 file *predates the migration*.
The §`__proto__: null` discipline is used instead of
prototype-stripping via harden's deep-freeze.

## Rotation note

Cycle 130 was nominally **comments-lane** (cycle 129 was
designs). Comments-lane is active. Papers-lane has been blocked
for **24+ consecutive cycles** (97/100/102/104/106/108/110/112/
113/114/116/117/118/119/120/121/122/123/124/125/126/127/128/129)
due to lack of PDF-fetching infrastructure. Pivoted away from
the @endo/patterns thread to @endo/eventual-send for variety.

## Counts

- 633 → **634** sections (+1).
- 174 → **175** source documents (+1).
- Topic pages updated: `eventual-send.md` (+1 row — fourth row
  for the eventual-send package), `errors.md` (+1 row — the
  *debugger-pause complement* to the SES error-observation
  surface).
- Keywords index extended with ~27 message-breakpoints-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 131 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 24+). The last endopi-* spinout
(`endopi-prompt-templates`, 104 lines) is available if cycle 131
pivots to designs.
