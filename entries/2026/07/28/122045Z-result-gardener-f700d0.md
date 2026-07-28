---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-28T12:21:05Z
---
---
ts: 2026-07-28T00:00:00Z
kind: result
role: assessor
repo: endojs/endo-but-for-bots
project: endo
---

Jury seat `assessor` on PR #755 (`@endo/cbor` phase 1), diff base `origin/llm-4f09410`.

### assessor (correctness logic and control flow)

**Verdict:** request-changes

**Findings:**

- **must-fix** `packages/cbor/index.js:614-628`, `:705-711`, `:688-694`, `:723-730` -- the four
  simple-value readers discriminate on `head.value` alone, so a float64 head whose 64-bit pattern
  happens to be 20, 21, 22, or 23 is accepted as `false`, `true`, `null`, or `undefined`. Root cause:
  `readHeadInternal` (`:425`) returns `{ major, value, start }` and drops the additional-information
  nibble, which for major 7 is a TYPE SELECTOR (its own comment at `:439` says so) rather than an
  integer argument. Executed against the built package under `lockdown()`:
  `readBoolean(fb0000000000000014) -> false` (index 9), `readBoolean(fb0000000000000015) -> true`,
  `readNull(fb0000000000000016)` returns normally, `readOptionalNull(fb0000000000000016) -> true`,
  `readOptionalUndefined(fb0000000000000017) -> true`. Each of those byte strings is a legitimate
  float64 (`readFloat64` decodes `fb0000000000000016` as `1.1e-322`), so two byte-different encodings
  decode to the same value, and one of them decodes to two different values depending on which reader
  is called. That directly falsifies the invariant published on `makeCborReader` at `:403-407` ("no
  two byte-different encodings of a value both decode") on the happy path, no attack needed. Fix:
  carry `info` out of `readHeadInternal` and require `info < 24` at all four sites.
  [rule: designs/cbor-codec.md § Canonicality posture -- readers are strict, no lenient mode]

- **must-fix** `packages/cbor/index.js:624` -- the error-message discriminator in `readBoolean` uses
  `head.value < 24n` for the same reason, so the float64 cases above that do not hit the accept path
  are still misreported as "simple value N". The existing test (`test/cbor.test.js:517-522`) only
  exercises `fb3ff0000000000000`, whose pattern is above 24, so the discriminator's defect is
  unpinned. Same one-line fix as above; add a vector with a sub-24 bit pattern.
  [proposed-rule: when a reader's error message names which construct arrived, the test that pins it
  must include the case where the naive discriminator gives the wrong name]

- **should-fix** `packages/cbor/index.js:491-516` -- `readHead` and `peekHead` return `{ major, value }`,
  which leaves every consumer with exactly the ambiguity above; `test/cbor.test.js:189-193` already
  builds a dispatching decoder on the probes and would inherit it. Expose the nibble (or a width /
  `isFloat64` flag) on the returned head so a caller can discriminate without re-reading bytes.
  [rule: designs/cbor-codec.md § Canonicality posture]

- **should-fix** `packages/cbor/index.js:257-263` -- `writeInt` on a value below `-2**64` fails inside
  `assertHeadArgument` reporting the transformed `-1n - value`, not the caller's argument, so the
  diagnostic names a number the caller never passed. Guard the range in `writeInt` and name the input,
  pointing at `writeBignum` as the JSDoc already does.
  [proposed-rule: an assertion reached through a value transformation reports the caller's input, not
  the transformed value]

**Notes (out of scope but worth flagging):**

- `packages/cbor/index.js:578-582` -- the bare `catch` maps every throw out of `bytesToText` to
  "Invalid UTF-8 text string", including a throw that is not a decode failure. Narrow or accept.
  [rule: roles/jurors/assessor/AGENT.md § Primary surface -- error paths]
- Verification: the defect above was reproduced by direct execution under `ses` `lockdown()`. The
  package's own AVA suite was **not** run (`ses-ava` is blocked by this sandbox's permission policy),
  so I did not confirm the current suite is otherwise green.

Self-improvement: nothing this time.
