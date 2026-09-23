PR #990 is confirmed: draft, base `llm-a54c3ad`, head `bot/slots-ocapn-deliver-convention`. All acceptance criteria are met. My builder deliverable is complete.

## Completion report

**Job:** Migrate `@endo/slots` deliver bodies to the OCapN calling convention (builder). Draft PR opened: **endojs/endo-but-for-bots#990**.

### What I did
Refactored `@endo/slots` so `deliver` carries **one flat passable argument vector** in its body, matching the OCapN Body Content Format and mirroring `@endo/ocapn`'s client. Based the work on `llm-a54c3ad` (where the slots package lives, PR #124's now-merged base) so the PR diff is exactly this delta.

### Changes (`packages/slots`)
- **`src/selector.js` (new):** `makeSelector` / `getSelectorName`, mirroring `packages/ocapn/src/selector.js` — coerce a string method name to its passable-symbol selector on send, validate-and-decode it on receipt (rejects non-symbol / non-passable / `@@`-reserved).
- **`src/codec.js`:** `encodeDeliver`/`decodeDeliver` now emit/consume a flat argument vector body (`harden([...args])`) instead of `[method, args]`. Descriptor threading, reply, and resolve paths unchanged.
- **`src/client.js`:** send-side handlers — `applyMethod` prepends `makeSelector(method)`; `applyFunction` sends args unchanged; symbol methods rejected. Receive-side `invokeDeliver` mirrors OCapN: `typeof target === 'function'` → `applyFunction` with the whole vector; object → decode leading selector → `applyMethod`. Removed the `__call__` sentinel. `__get__` retained as a private string-method convention.
- **`index.js`:** export the selector helpers.
- **`README.md`:** new "Calling convention" section citing the OCapN Body Content Format and documenting the `__get__` decision (stays private, not a distinct OCapN op — rationale included).
- **Tests:** codec tests pin the flat vector + leading passable-selector encoding (and a selector-free function vector); e2e adds `E(function)(value)` and both send-only variants; client tests add malformed/non-selector object-call rejection and symbol-method rejection.
- **`.changeset/slots-ocapn-deliver-convention.md`:** breaking changeset (`minor`, per the pre-1.0 `@endo/slots` convention), explicitly marked BREAKING.

### Verification
- `@endo/slots` JS: **82 tests pass** under both `lockdown` and `endo` configs; `tsc` clean; `eslint` 0 errors (only pre-existing warnings); pre-push deterministic probes clean.
- Rust: `cargo test -p slots` — **43 pass**, including `deliver_body_passes_through_unchanged`, confirming the supervisor treats the body as opaque so no Rust change was needed.

### Acceptance criteria — all met
Flat-argument + passable-selector codec tests ✅; e2e for method/function/send-only/malformed/symbol-rejection ✅; no `__call__`/`[method, args]` remaining ✅; README cites OCapN Body Content Format ✅; breaking changeset ✅; JS + Rust tests run ✅; `__get__` decision documented ✅.

### Follow-ups / notes
- **Base choice:** opened against `llm-a54c3ad` directly (already a frozen `llm-<sha>` snapshot where slots lives). If the maintainer prefers a fresh snapshot layer or a different target once `llm-a54c3ad` lands to `llm`, a `rebase #990` re-points it.
- The draft PR now enters the gauntlet (panel → fix-loop → un-draft) under the gardening state machine; the builder stage (implement + open draft) is complete.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-slots-ocapn-deliver-convention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 168 tokens (11239890 cached reads)
- Output: 68952 tokens
- Cost: $9.112486000000002
- Wall-clock: 983s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
