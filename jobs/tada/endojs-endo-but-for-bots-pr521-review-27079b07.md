Inbox is empty. The job is complete — this was a design-proposal request (no garden `main2` changes; the project implementation is deliberately gated on kriskowal's choice per his explicit "propose options"), so there is nothing to commit or push.

## Completion report

**Job:** Review directive on `endojs/endo-but-for-bots` PR #521 (review `4698736135` by kriskowal).

**Preflight:** `pr-feedback-preflight.sh` → exit 0 (PROCEED; no peer had resolved it).

**Enumerated the whole review unit:** review body was empty; one inline comment on `packages/marshal/src/encodePassable.js:883` (comment id `3582807958`), treated as untrusted data:
> "We need to allocate a prefix and follow-through. Please propose options and to spell the name like `'sturdyRef'`. It may be necessary to collapse the stack for holistic review."

This is a three-part **design-proposal** ask ("propose options"), so I grounded and answered it rather than guessing a wire-format choice. Posted a threaded reply as `kriscendobot`: https://github.com/endojs/endo-but-for-bots/pull/521#discussion_r3582849894

**What the proposal covers (all three asks):**
1. **`sturdyRef` spelling** — agreed and grounded: every other multi-word pass-style is camelCase (`copyRecord`, `copyArray`, `byteArray`); `'sturdyref'` is the outlier. Enumerated the bounded rename scope (5 discriminator sites in pass-style/marshal/ocapn), distinct from the broader ocapn "sturdyref" vocabulary.
2. **Prefix allocation + follow-through** — three concrete options with rank-order rationale (rank = ASCII sort of the prefix; must sort before `undefined`/`z`; avoid the `!`..`@` error-escape band): **A (recommended) `q` immediately before `remotable`**, **B `t` after `string`**, **C `w`**. Noted all are greenfield (no wire-compat migration). Described the real follow-through work (a `case 'sturdyRef'` encode arm + decode arm + `encodeSturdyRef`/`decodeSturdyRef` option hooks mirroring remotable) and flagged the one open question that must precede implementation: the locator is off-band, so the encoder must encode a host-supplied ordinal/identity, not the secret locator.
3. **Collapse the stack** — agreed; recommended folding the deferred marshal-encoding slice into this branch so `passStylePrefixes` loses its `Exclude<…, 'sturdyref'>` hole and the whole thing is holistically reviewable.

Closed by offering to land rename + prefix + encode/decode follow-through and collapse the stack in one pass once kriskowal picks an option (recommended A/`q`) and confirms the encoded-identity question.

**Changes:** none to the garden repo; no project code pushed (implementation intentionally awaits the maintainer's choice, which the reviewer requested). 

**Follow-ups:** kriskowal's option selection will return as a new review/comment on #521 (routed by the comment watcher) and can be claimed as a fixer/builder job to implement the chosen prefix + rename + codec follow-through and collapse the stack.
