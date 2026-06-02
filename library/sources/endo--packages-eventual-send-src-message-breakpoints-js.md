---
source: packages/eventual-send/src/message-breakpoints.js
source_repo: endojs/endo
source_branch: master
source_commit: b191aaf3d8b9015801d3f6793f0dd21995aba48e
source_date: 2024-01-13
source_authors: [Mark S. Miller]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-fourth comment-fragment ingest. 179-line Mark Miller-
  authored file (2024-01-13 — the most senior @endo file ingested
  in recent cycles). Factory `makeMessageBreakpointTester` reads
  an env-option-named JSON record and produces a tester with
  `getBreakpoints` / `setBreakpoints` / `shouldBreakpoint`
  methods for *runtime-configurable breakpointing on E()-mediated
  eventual-send dispatch*.

  §Three-axis match grammar: MatchStringTag (recipient class) ×
  MatchMethodName × MatchCountdown. Each axis admits `'*'`
  wildcard. Countdown semantics: `'*'` always breakpoint; `0`
  always breakpoint (countdown-exhausted state); positive integer
  decrements by one each match until zero.

  Single most structurally interesting move: the §external↔
  internal transpose. External JSON shape is
  `{tag: {method: countdown}}` (human-organized by recipient
  class); internal table is `{method: {tag: countdown}}`
  (lookup-organized by method-first because shouldBreakpoint
  knows methodName before recipient). The transpose builds the
  internal table fresh on each setBreakpoints call.

  §simplifyTag idiom strips a leading `'Alleged: '` or
  `'DebugName: '` prefix; *if there are multiple such prefixes,
  only the outer one is removed* — the §one-level-strip
  discipline. §setBreakpoints validation *enforces canonical
  simple tags*: *Just use simple tag X rather than Y* — pushes
  prefix-stripping responsibility to configuration time, not
  per-call match time.

  §shouldBreakpoint flow: (1) no methodName → no breakpoint
  (TODO: enable function breakpointing); (2) method-or-wildcard
  fallback; (3) tag-or-wildcard fallback; (4) `'*'` or `0`
  shortcut to always breakpoint; (5) §in-place-decrement on the
  internal table — `classBPs[tag] = count - 1`.

  §getBreakpoints-returns-original-not-mutated invariant: external
  `breakpoints` variable is NOT mutated by shouldBreakpoint; only
  the internal table's countdowns decrement. `getBreakpoints()`
  returns the user-configured JSON; *re-installing the same JSON
  resets the countdowns* via the §default-argument-to-stored-
  breakpoints idiom (`setBreakpoints()` with no argument).

  §env-option-yields-undefined-when-unset discipline: factory
  returns `undefined` rather than a no-op tester. §Caller can
  check `if (tester)` and skip the shouldBreakpoint call entirely
  — the §zero-cost-when-unset property. §getEnvironmentOption
  with caller-supplied optionName lets multiple parallel
  breakpoint testers exist for different concerns (E() vs
  HandledPromise applyMethod, etc).

  §`__proto__: null` discipline on both the outer and inner
  internal-table records — prevents accidental prototype-key
  lookup hazards. §freeze on the three exported methods + the
  returned tester object — callers cannot replace methods.
  Two §`@ts-expect-error confused by __proto__` comments
  acknowledge TypeScript's lack of native support for the
  prototype-null pattern. No `harden` (predates the @endo/harden
  migration visible in cycles 108 + 110 + 115 + 118 + 123 + 125).

  §async-call-debugging-pain-point this file solves: in
  eventual-send, the actual delivery happens *later than the
  call site*, often after an async hop. Breakpointing at the call
  site is useless; you need to break at the *receiver's method
  dispatch point*. This file lets the user say *break on the
  third call to `.send` on any object tagged `'wallet'`* via a
  JSON env var, with no code modification.

  Cycle 130 was nominally comments-lane (cycle 129 was designs).
  Comments-lane is active. Papers-lane has been blocked for 24+
  consecutive cycles. Pivoted away from the @endo/patterns thread
  to @endo/eventual-send for variety.
---

> Abstract: `packages/eventual-send/src/message-breakpoints.js`
> (179 lines, Mark Miller, 2024-01-13) is the *runtime-
> configurable breakpoint tester* for E()-mediated eventual-send
> dispatch. The factory `makeMessageBreakpointTester(optionName)`
> reads an env-option-named JSON record and produces a tester
> with `getBreakpoints` / `setBreakpoints` / `shouldBreakpoint`.
>
> The §three-axis match grammar: MatchStringTag (recipient class)
> × MatchMethodName × MatchCountdown. Each axis admits `'*'`
> wildcard. Countdown: `'*'` always; `0` always; positive integer
> decrements until zero.
>
> **The single most structurally interesting move**: the
> §external↔internal transpose. External JSON is `{tag: {method:
> countdown}}` (human-organized); internal table is `{method:
> {tag: countdown}}` (lookup-organized because shouldBreakpoint
> knows methodName before recipient). The setBreakpoints
> procedure transposes the index for fast lookup.
>
> §simplifyTag strips `'Alleged: '` or `'DebugName: '` prefix
> (only one level); the §validation enforces canonical simple
> tags at configuration time. §shouldBreakpoint uses
> method-or-wildcard + tag-or-wildcard fallbacks, with `'*'` and
> `0` as always-breakpoint shortcuts. §In-place-decrement on the
> internal table; *external `breakpoints` variable is not
> mutated*.
>
> §env-option-yields-undefined-when-unset: factory returns
> `undefined` rather than a no-op tester — caller can skip the
> shouldBreakpoint call entirely (the §zero-cost-when-unset
> property). §`__proto__: null` on internal records prevents
> prototype-pollution lookup. §freeze on exports prevents method
> replacement. No `harden` (predates the @endo/harden migration).
>
> §The async-call-debugging-pain-point this file solves: in
> eventual-send, the actual delivery happens *later than the
> call site*, often after an async hop. This file lets the user
> say *break on the third call to `.send` on any object tagged
> `'wallet'`* via a JSON env var, with no code modification.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics](../sections/endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics.md) | eventual-send, errors | current |

Tight 179-line single-section file. The whole content hangs off
*one mechanism* (the factory + its three-method tester); the
three-axis match grammar + external/internal transpose + countdown
semantics + env-option-driven instantiation are all aspects of
that single mechanism. One cohesion-honest section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@b191aaf3` (`master`) via
  the local bare-clone.
- Last touched 2024-01-13 by Mark Miller in commit `b191aaf3` —
  the most senior @endo file ingested in recent cycles (predates
  the @endo/harden migration visible in cycles 108 + 110 + 115 +
  118 + 123 + 125).
- Verified file existence and structure via the local bare-clone:
  179 lines + 1 exported factory + 1 private `simplifyTag` helper
  + 1 private `isJSONRecord` predicate + 3 JSDoc typedefs +
  1 tester-object typedef.
- **Twenty-fourth comment-fragment ingest.** Pairs structurally
  with cycle 66's `handled-promise.js` §handler-protocol (the
  HandledPromise handler that calls into this file's tester
  before dispatching).
- Cycle 130 was nominally **comments-lane** (cycle 129 was
  designs). Comments-lane is active. Papers-lane has been
  blocked for **24+ consecutive cycles** due to lack of
  PDF-fetching infrastructure. Pivoted away from the
  @endo/patterns thread to @endo/eventual-send for variety.
- One cohesion-honest section.
