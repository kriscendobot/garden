---
host: endolin
role: liaison
dispatch_id: 334017
date: 2026-06-02
kind: result
---

# result(librarian, cycle 116): daemon-form-request — Form message type + implementation + design decisions (2 sections)

**Cycle**: 116 (pivoted from papers-lane (ninth consecutive papers-lane block since cycle 97) to daemon-design-lane).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/daemon-form-request.md` (435 lines), last touched 2026-03-02 by Kris Kowal (prompted).

## What

Ingested the **Implemented** `daemon-form-request` design — *the* structured-question-with-named-fields message type that lets any agent send a form to any other agent. The 435-line design is *frequently named in prior cycles* (cycle 101's daemon-commands-as-messages + cycle 103's daemon-value-message + cycle 107's daemon-agent-tools all cite it as a reply-pattern donor or sibling).

### Sections drafted

1. **Form message type + implementation** (lines 1-296) — the foundational design: Problem + Type Definitions + Implementation + Interfaces + What Works Today. The §three-scenario problem framing (LLM agent config / capability requests with params / multi-field input). The §`FormField = {name, label, example?, pattern?}` ordered array vs record (separates semantic key from display text). The §`form()` fire-and-forget sending. The §`submit()` validation via `mustMatch()` (default `M.string()`) + multi-submission via `value` message replies. The §Chat UI dual support: `/form` modal builder + inline labeled-input rendering.

2. **Gaps + Design Decisions** (lines 298-435) — the rationale + remaining work: 5 named Gaps + 10 numbered Design Decisions + 3 Related Designs. The §five Gaps (no forwarding/sharing; FormulaNumber-vs-FormulaIdentifier forward-safety; limited pattern→widget vocabulary; CLI strings-only; no reusable templates). The §ten Design Decisions including *patterns are a contract, not a hint* + values support capability references + *simplified internals* with no `PROMISE`/`RESOLVER`/`RESULT` edges. The §pattern → widget mapping table (6 rows + fallback + extensible discipline).

### Library state after this cycle

- **618 sections** (was 616) / **161 sources** (was 160) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+2 rows).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~50 form-request keywords (Form message type / FormField name label example pattern / fields-as-ordered-array-vs-record / fire-and-forget form() / multi-submission via value replies / mustMatch daemon-side enforcement / patterns are a contract not a hint / pattern → widget mapping table / pet-name path selector for capability references / simplified internals no PROMISE/RESOLVER/RESULT edges / five named Gaps / ten numbered Design Decisions).

## Daemon data-entry-and-capability-flow layer

This cycle completes a *data-entry-and-capability-flow* arc in the library:

- **Cycle 103** `daemon-value-message` (Complete) — the foundational reply primitive.
- **Cycle 116** `daemon-form-request` (Implemented, this ingest) — the structured-data-entry primitive that uses value-message replies.
- **Cycle 101** `daemon-commands-as-messages` (Not Started) — names daemon-form-request as a *reply-pattern donor*.
- **Cycle 105** `daemon-capability-bank` (Not Started) — *future consumer* via capability-config-request forms.
- **Cycle 107** `daemon-agent-tools` (Not Started) — uses forms for *form-based capability provisioning*.

Together five cycles describe the *daemon's data-entry-and-capability-flow* layer.

## Notes

- The §*fields-as-ordered-array-vs-record* design choice is structurally interesting: the previous record form conflated *semantic key* with *display text*; the array form gives `name` + `label` + `example` + `pattern` as four distinct concerns. The §discipline: *separate concerns that were conflated*.
- The §*fire-and-forget + multi-submission via value replies* pattern is structurally important: `form()` doesn't allocate a promise; submissions produce `value` message replies; multi-submission allows corrections + multi-agent (when forwarding lands) + reply-chain history. The §simplified internals (Decision 10) shows the concrete consequences — *no `PROMISE`/`RESOLVER`/`RESULT` edges in the message hub*.
- The §*patterns are a contract, not a hint* discipline is the canonical statement of *server-enforced-not-client-suggested* validation. The same `@endo/patterns` language (cycles 102 + 104 + 110 + 115) drives both daemon validation and Chat UI widget selection.
- The §pattern → widget mapping table is a worked example of *extensible-by-pattern dynamic-form-rendering*. Six rows + unrecognized-pattern-fallback-to-text-input + *This mapping is extensible as new patterns are introduced*. The §pattern-introspection (e.g., `M.gte(0)` → HTML `min`) is reusable for any *constraint-derived widget config* situation.
- The §pet-name-path-selector for `M.remotable()` / `M.promise()` is the canonical *capability-reference UI*: the user picks a pet name; the daemon resolves it to a capability at submission time. The §rationale: *form values support capability references* enables use cases like *which worker should I use?*.
- The §five Gaps are *honest current-state with named limitations*. Each gap names the limitation + (where applicable) the future-direction. The §discipline preserves trust in the rest of the doc.

## Rotation discipline

Cycle 116 papers-lane block reached 11 consecutive (cycles 97 / 100 / 102 / 104 / 106 / 108 / 110 / 112 / 113-implicit / 114 / 116). The §rotation continues into design-lane and comments-lane pivots.

## Next

- Cycle 117 (chat-lane → broader endo-but-for-bots designs): remaining endopi-* (8 Proposed); daemon-capability-bus (In Progress; 526 lines, 2 sections); daemon-mount (In Progress; 718 lines, 3+ sections); daemon-checkin-checkout (Complete; 578 lines); OCapN-Noise designs.
- Cycle 118 (papers-lane): consider whether infrastructure available.
- Cycle 119 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines).

ScheduleWakeup 1500s for cycle 117.
