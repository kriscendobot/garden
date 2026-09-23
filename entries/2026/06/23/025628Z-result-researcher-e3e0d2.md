---
ts: 2026-06-23T02:56:28Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/23/025628Z-result-researcher-e3e0d2.md
---

RSVP to kriskowal inline comment 3456684511 on PR #290
(`packages/lal/agent.js` line 551). Inline reply posted at
https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3456723728.

## Context at line 551

Line 551 (`const decoded = coerceBigintArgs(argsRecord, bigintArgs)`) is the
entry point of the coercion-then-fixup pipeline in `makeExecuteTool`. Pi's
`pi-agent-core` delivers tool-call arguments as a plain JS object produced by
`parseStreamingJson`, which uses JSON.parse (with partial-JSON repair as a
fallback). Because the wire format is JSON, BigInts must be reconstructed
post-hoc from SmallCaps-shaped string literals (`"+N"`), and nested objects
that some LLMs emit as JSON-encoded strings require a second parse pass
(`validateAndFixupArgs` retry loop). The maintainer's "sloppy" diagnosis names
this layering: the right type cannot land from the LLM because the wire format
cannot represent it.

## Pi tool-call parser configurability

Pi (`@earendil-works/pi-agent-core` 0.79.9, source: `earendil-works/pi`
`packages/agent/`) is not configurable on the parser dimension.
`parseStreamingJson` in `packages/ai/src/utils/json-parse.ts` calls JSON.parse
(with `partial-json` and `jsonrepair` as fallbacks). The `AgentTool` interface
accepts a TypeBox schema in `parameters` and an optional `prepareArguments`
shim, but the shim receives an already-JSON-decoded object; there is no hook
before the string-to-object step. Swapping in Justin as Pi's wire parser would
require either forking Pi or modeling tool calls as a `{ code: string }` schema
and parsing the string in `lal`'s `executeTool`.

## Justin feasibility

`@endo/marshal` exports `decodeToJustin` (Passable to Justin string) and
`passableAsJustin` (Passable to Justin string with indentation), but no
Justin-string-to-Passable parser. The package is a serializer, not a
round-trip codec at the Justin level. A Justin parser does not exist in the
workspace. To use Justin as the inbound wire format, either (a) a Justin parser
would need to land in `@endo/marshal`, or (b) `Compartment.prototype.evaluate`
on the received string provides the parse step for free, which is essentially
the JS-eval pivot.

## JS-eval pivot feasibility under SES

Straightforward. `Compartment.prototype.evaluate` is the standard SES
confinement primitive. The constructing code:

```js
const c = new Compartment({ $: harden(powers), E, harden });
const result = await c.evaluate(code);
```

gives the model a confined surface with no ambient authority beyond what is in
globals. BigInt literals (`1n`) are native JS syntax and land as actual BigInts
with no workaround. The `switch` dispatcher and the coercion-fixup pipeline
disappear entirely.

Failure modes:

- Runaway / infinite loop: `compartment.evaluate` does not respect an
  AbortSignal. A `Promise.race([c.evaluate(code), timeoutPromise])` is a soft
  mitigation (stops waiting, propagates an error to the model) but does not
  terminate the running code. A Worker with a CPU budget or `vm.Script` with a
  timeout is the stronger fix.
- Malformed code: a SyntaxError surfaces as a structured error the tool
  `execute` can return to Pi as the tool result, which the model sees and can
  retry.
- Capability leak: bounded by what is in globals. The compartment cannot reach
  `process`, the host filesystem, or any capability not explicitly introduced.

The model's structured-output mode supports `{ code: string }` via TypeBox
schema; Anthropic, OpenAI, and the Ollama / OpenAI-compatible path all handle
it. System-prompt guidance showing the `E($).method(...)` idiom replaces the
current per-tool JSON schema documentation.

## Powers as `$`

In `agent.js`, `makeExecuteTool` already receives `powers` as a parameter.
`powers` is an Endo guest capability object whose methods are the agent's
authority surface. Exposing `powers` directly as `$` (or a thin hardened wrapper
over it) in the Compartment globals is the natural binding. No reshaping is
needed; the capability is already the right shape. The Compartment would be
constructed inside `makeExecuteTool` (once) or per-call.

## Recommendation

The JS-eval pivot is the principled path. It dissolves the BigInt workaround,
the nested-JSON fixup, and the switch dispatcher in one move: the model writes
JavaScript and the capability sandbox enforces the authority boundary. A
proof-of-concept:

1. Add a single `evaluate` entry to `toolDefs` whose `parameters` is
   `{ type: 'object', properties: { code: { type: 'string' } } }`.
2. In `executeTool`, handle `name === 'evaluate'` by constructing a
   `Compartment` with `$` = `harden(powers)`, `E`, `harden` in globals and
   calling `compartment.evaluate(args.code)`.
3. Update the system prompt to show the `E($).reply(1n, ...)` idiom.
4. The existing `'evaluate'` case (which calls `E(powers).evaluate` for Endo
   formula evaluation) is a distinct capability; rename it to `'endo-evaluate'`
   to avoid collision.

A design PR capturing the Compartment construction shape, the `$` binding
contract, the rename of the existing `evaluate` tool, and the runaway-loop
mitigation strategy is the logical follow-up before a builder spike.

## Library writeback

No keyword-index hits for `Justin`, `passableAsJustin`, `decodeToJustin`,
`Compartment.evaluate`, or `pi-agent-core`. Terms are load-bearing but absent.
Adding keywords:

- `passableAsJustin` -> `vat-and-compartment` (not exact; nearest concept is
  the Compartment concept, but `passableAsJustin` is a serializer primitive not
  covered there). Queued for scholar rather than a forced fit.
- `Compartment.prototype.evaluate` -> `vat-and-compartment` (concept page
  covers Compartment as the SES realm-isolation primitive). Added shortcut below.

Open questions for scholar / librarian:
- `passableAsJustin`, `decodeToJustin`, `Justin format` have no concept page.
  They are distinct from the vat-and-compartment concept. A `justin-serialization`
  concept page would capture: Justin is a JSON-superset that encodes BigInts as
  `1n`, Symbols, and Passable tagged values; `@endo/marshal` exports the encoder
  side; no parser ships in the workspace today.
- `pi-agent-core` / `AgentTool` interface has no library entry. The term
  appears frequently in `lal/agent.js` PRs and would benefit from a
  `pi-agent-core-interface` concept page.

Self-improvement: nothing this time — the researcher role operated within its
normal parameters; no structural gap in the role or skill files was encountered.
