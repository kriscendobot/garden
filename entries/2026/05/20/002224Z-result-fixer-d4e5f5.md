---
ts: 2026-05-20T00:22:24Z
kind: result
role: fixer
dispatch_id: d4e5f5
dispatch_root: /home/kris/dispatches/fixer--d4e5f5
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Result fixer d4e5f5 — PR #290 SmallCaps footgun (kriskowal 2026-05-20)

## Source of the ask

kriskowal on PR #290 (issue_comment 4493261993, 2026-05-20T00:07:18Z):
"I'm also concerned about smallcaps strings getting inadvertently
misinterpreted. That's a huge footgun, but patterns can usually catch
that. As long as we're using JSON, we need a rigorous treatment on
SmallCaps."

## Pathways identified

The footgun lived at one specific point in `packages/lal/agent.js`: the
`decodeSmallcapsValue` helper (lines 410-430 of the pre-fix file). It
was called from `makeExecuteTool`'s inner `executeTool` on every tool
call. The pi-ai harness delivers tool args as a plain object from
`JSON.parse`; the helper re-serialized that object as JSON, wrapped it
in `#` so the smallcaps marshal would treat it as a copyRecord, and
asked `@endo/marshal`'s smallcaps `unserialize` to walk the structure.
The walk visits every string and applies the smallcaps grammar
(documented at `packages/marshal/src/encodeToSmallcaps.js` lines 47-76):
strings starting with `!`, `#`, `$`, `%`, `&`, `+`, `-` (and reserved
`"'()*,`) get reinterpreted.

The footgun shapes I confirmed (running the pre-fix decoder against
plausible LLM-emitted JSON tool args; smoke script in
`/tmp/footgun-test.mjs`):

- `"+15551234567"` (phone number in `strings: [...]`) became
  `BigInt(15551234567)`.
- `"+5"` (typed literally) became `BigInt(5)`.
- `"#undefined"` (a literal hashtag) became JavaScript `undefined`.
- `"%percentage"` became a JavaScript Symbol.
- `"$tag-name"` triggered a remotable-decoder error (caught by the
  outer try/catch and returned raw, but the failure mode was obscure).
- `writeText({content: "+5"})` became `BigInt(5)`, which then fails
  downstream when the capability tries to do anything string-shaped
  with it.

Every tool with a string-typed arg was exposed: `send`/`reply` via
`strings: [...]`, `writeText` via `content`, `evaluate`/`define` via
`source`, `request` via `description`, `reject` via `reason`,
`lookup`/`has`/`remove`/`move`/`copy`/`makeDirectory`/`locate` via
their path args (less exposed there because pet names are
lowercase-alphanumeric, but a `["+5"]` array element would still get
mutated).

## Strategy picked

Strategy (c) from the dispatch brief: **constrain the tool-arg surface
to a non-overlapping string subspace**, expressed as per-tool
declarations of which fields are BigInt-shaped.

Concretely:

- `LalToolDef` gains an optional `bigintArgs: readonly string[]` field.
  The four mutation tools (`resolve`, `reject`, `adopt`, `dismiss`) plus
  `reply` declare `bigintArgs: ['messageNumber']`.
- `decodeSmallcapsValue` (whole-tree marshal walk) is replaced by
  `coerceBigintArgs`, which copies the args object and coerces only the
  declared bigint fields from `"+N"` / `"-N"` literals (matched by
  `/^[+-]\d+$/`) into actual BigInts. Plain numbers and existing
  BigInts pass through; anything else is returned unchanged so the
  pattern matcher rejects it with a clean diagnostic.
- The `@endo/patterns` matchers added in `fcfd88f54` stay in place and
  catch any field-shape drift (e.g., a string in a `petNamePath:
  string[]` slot).
- `@endo/marshal`'s `makeMarshal` import is dropped; `passableAsJustin`
  (used elsewhere for log rendering) stays.

### Why I rejected (a) and (b)

- **(a) Patterns-only rejection** would either drop legitimate text
  ("Call +1 555 123 4567 about the #main pipeline") or require an
  awkward escape convention the LLM is not trained to produce. The
  whole point of using JSON as the wire format is that user text
  passes through verbatim.
- **(b) Escape-at-boundary** (prefix every string with `!`) would
  succeed at preventing reinterpretation but would break the only
  documented SmallCaps surface (BigInt `messageNumber`) since `"+5"`
  would become `"!+5"` and the BigInt decoder would never see it. A
  partial form (escape strings *except* in BigInt fields) is
  isomorphic to (c) but more complex to specify and to test.

Strategy (c) is the most rigorous because it makes the wire-format
contract bidirectional and exhaustive: JSON in, JSON out, with one
named exception that is enumerated per-tool and enforced by the
pattern matcher. It also makes the primer's `smallcaps.md` claim
("the harness handles regular strings...without any prefix from you",
rewritten in `a0ee8b5e` two commits ago) true rather than aspirational.

## Tests

New file: `packages/lal/test/smallcaps-footgun.test.js`. Eleven tests,
all passing. Each constructs a `PiAgent` the same way `spawnWorkerLoop`
does (same `convertToLlm` filter, same tool surface from `toolDefs` +
`toAgentTool` + `makeExecuteTool`), supplies a scripted `streamFn` (no
provider call), and asserts at the powers boundary or at a dispatched
spy.

Coverage:

- `send` with `"+15551234567"`, `"+5"`, `"#undefined"`, `"%percentage"`
  in `strings: [...]` — each arrives at the mock powers as the literal
  string (typeof === 'string').
- `send` with a realistic chat message intermixing `+1`, `#main`,
  `+5`, `%percent`, `$variable` — survives intact.
- `writeText` with `content: "+5"` — arrives at the capability's
  `writeText(fileName, content)` as the literal string.
- `evaluate` with `source: "+5 + 1"` (whose first char is `+`) —
  survives as a string.
- `lookup` with `petNameOrPath: "+5"` — passes through (would have
  become BigInt, then failed the matcher's string check).
- `dismiss` with `messageNumber: "+5"` — STILL coerces to `BigInt(5)`
  at the powers boundary (the one documented surface).
- `reply` with `messageNumber: "+3"` and `strings: ["Thanks for the +5
  update on #main!"]` — coerces only the number, leaves the chat text
  alone.

Regression evidence: I temporarily restored the pre-fix decoder and
re-ran the test file; 6 of the 11 new tests fail with the pre-fix
code. After restoring the new `coerceBigintArgs`, all 11 pass plus the
existing `pi-agent-tools.test.js` JSON-string-retry test continues to
pass (the retry runs after BigInt coercion; non-bigint string args are
untouched so JSON-encoded `fromPath`/`toPath` strings still reach the
matcher's fallback path).

## Commits

`b813721ab fix(lal): scope SmallCaps decode to per-tool bigintArgs (per kriskowal #290)`

Pushed to `feat/lal-pi-harness` (origin endojs/endo-but-for-bots).

## Local validation

- `yarn test` in `packages/lal`: 17 passed, 1 skipped (was 6/1; this
  commit adds 11 new tests).
- `yarn lint:eslint` in `packages/lal`: 0 errors, 31 warnings (the +6
  warnings over baseline are pre-existing `any` type warnings on the
  new test file, matching the pattern in `pi-agent-tools.test.js`).
- `yarn lint:prettier` repo-wide: clean.
- `yarn lint:types` for lal: clean for lal sources (the pre-existing
  third-party type errors are unchanged).

## CI

Pushed at 2026-05-20T00:22 UTC. CI is queued; the steward's CI watch
will pick up the result.

## External-repo etiquette

This dispatch carried no per-action authorization for posting
top-level summaries, inline replies, or re-requesting review. The
push is implicit in the fixer dispatch shape; the comment work is
deferred to a separate authorization if the next maintainer round
wants it.

## Follow-ups for the next round

- **Spec note**: a short paragraph in `packages/lal/primer/smallcaps.md`
  or `LAL-ARCHITECTURE.md` explaining the JSON-vs-SmallCaps boundary
  (the only smallcaps interpretation is BigInt coercion on declared
  bigint fields; everything else is bytes-for-bytes) would help future
  LLM prompt-engineers reason about the surface. Out of scope for this
  commit; lives more naturally in a docs PR after the harness settles.
- **Secondary surfaces**: the same JSON-tool-args pathway exists in any
  sibling package that builds a tool surface from pi-ai output. As of
  this commit only `packages/lal` constructs a pi-agent-core harness;
  `packages/fae` and `packages/jaine` consume lal's `providers/`
  re-exports but do not construct their own PiAgent. When they (or any
  future caller) do, the same per-tool-bigint-fields discipline
  applies; worth a sweep at that point.
- **`bigintArgs` derivation from patterns**: the current declaration
  is a free-form string array per tool. A future refactor could walk
  the `params` matcher tree to find `MessageNumberShape` references
  and derive the bigint-field list automatically, keeping the two
  sources of truth in lockstep. Not done here because the explicit
  declaration matches `packages/genie/src/tools/common.js`'s discipline
  and is easier to audit by eye.

## Self-improvement

Self-improvement: nothing this time. The fixer role, the
review-feedback-followup-commits skill, and the regression-evidence
skill all fit the work cleanly; no recurring snag worth a structural
change.
