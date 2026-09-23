---
ts: 2026-05-18T14:18:12Z
kind: result
role: cleaner
host: endolinbot
short_id: 8cfa50
dispatch_root: dispatches/cleaner--8cfa50
repo: endojs/endo-but-for-bots
branch: feat/cbors-package
base: llm
pr_number: 288
project: endo-but-for-bots
---

# Cleaner pass on PR #288 (@endo/cbors framing package)

Branch `feat/cbors-package` on base `llm`.
PR remains DRAFT pending the judge.

## Cleaner commits

One commit on top of the builder's `ffaac04e4`:

- `8b951d998` test(cbors): adversarial RFC 8949 conformance sweep.
  Adds five regression tests covering the dispatch's adversarial sweep
  (all non-byte-string major types, indefinite-length inside tag-24,
  overlong head encodings, 9-byte heads above 2^53-1, reader cancellation
  mid-payload). Each test is load-bearing per
  `skills/regression-evidence/SKILL.md`.

No dead-code deletions were warranted (the builder's surface is tight;
all four source files are reachable from the public API).
No `yarn.lock` churn (the new tests use only the test deps already in
`package.json`).

## Lint and tests

Before the cleaner's commit:

- `yarn lint:eslint` clean.
- `yarn lint:types` (tsc) clean.
- `prettier --check packages/cbors` clean.
- `yarn test`: 31 tests passed across noop-harden, base, and lockdown
  ses-ava configurations (3 x 31 = 93 individual passes).

After:

- `yarn lint` clean (eslint + tsc).
- `prettier --check packages/cbors` clean.
- `yarn test`: 36 tests passed across all three ses-ava configurations
  (3 x 36 = 108 individual passes).

CI on `8b951d998` converged to all-green (`SUCCESS=25`), matching the
prior head `ffaac04e4` (which was also `success=25`).
No new red, no new pre-existing red surfaced.

## Adversarial tests added

Five new tests in `packages/cbors/test/cbors.test.js`, all proven
load-bearing by temporarily breaking the corresponding implementation
branch and observing the test fail.

1. **`decodeByteStringHead rejects all non-byte-string major types`**
   exhausts the seven CBOR major types other than 2 (RFC 8949 § 3.1):
   majors 0, 1, 3, 4, 5, 6 (non-tag-24), 7.
   The existing test covered 0, 3, 4 only.
   Regression-evidence: disabling the `MAJOR_2_BASE..MAJOR_3_BASE`
   range check in `decodeByteStringHead` causes major 0 to be
   incorrectly decoded as length -64 (the failure mode under the
   broken branch).

2. **`decodeByteStringHead rejects indefinite-length byte string inside tag 24`**
   confirms the same rejection applies whether the indefinite form
   appears alone (`0x5f`) or wrapped (`0xd8 0x18 0x5f`).
   Regression-evidence: gating the indefinite check on `!tagged`
   causes the tagged-indefinite head to fall through to the reserved
   nibble error (the wrong diagnostic), and the test catches the
   message mismatch.

3. **`decodeByteStringHead accepts non-canonical (overlong) head encodings`**
   documents the decoder's intentional permissive posture per
   RFC 8949 § 4.2: encoders SHOULD emit shortest form, but readers
   MAY accept non-canonical encodings.
   The test asserts that length 5 declared via each of the four
   explicit-width forms (2-, 3-, 5-, 9-byte heads) decodes successfully
   to the same length.
   Regression-evidence: disabling the ARG_U8 branch causes the test
   to fail on the 2-byte case ("reserved additional-info 24").

4. **`decodeByteStringHead rejects 9-byte head declaring length above 2^53-1`**
   pins the JS safe-integer boundary the builder explicitly enforced.
   Two failure cases: the just-over bound (high32 = 0x200000, total =
   2^53) and the uint64 saturated maximum (all-ones bytes).
   Both rejected by the fast-path `high > 0x1fffff` check.
   A boundary sanity assertion proves the exact-at-MAX_SAFE_INTEGER
   head (high32 = 0x1fffff, low32 = 0xffffffff) decodes successfully:
   the next integer up is only reachable by incrementing high32 into
   the rejected range.
   Regression-evidence: disabling BOTH the fast-path check AND the
   post-compute `length > MAX_SAFE_PAYLOAD_LENGTH` check is required
   to make the test fail; this is intentional defense-in-depth and
   confirmed by the experiment.

5. **`reader cancellation mid-payload closes the underlying input`**
   confirms the async iteration protocol propagates cleanly: a caller
   that breaks from `for await (const frame of reader)` causes
   `reader.return()` to fire, which (because the generator uses
   `for await` on its upstream `input`) propagates to the upstream
   iterator's `return` method.
   The test wraps the input in a tracked iterator whose `return`
   sets a flag; after `break` on the first frame, the flag is true.
   Regression-evidence: this test is intrinsically load-bearing.
   Removing the `for await` cancellation propagation (e.g., by
   catching upstream cleanup) would leave the flag false.

## RFC 8949 conformance findings

- **Major-type discrimination is tight.**
  The reader only accepts initial bytes in `[0x40, 0x60)` (major 2) and
  the specific tag-24 wrapper `0xd8 0x18`.
  All other initial bytes throw with a major-number diagnostic.
  Confirmed across all seven non-byte-string major types.
- **Indefinite-length forms are rejected uniformly.**
  Whether the `0x5f` appears alone or inside a tag-24 wrapper, the
  decoder throws with an "indefinite" diagnostic.
  This is the right posture for a framing primitive: indefinite-length
  byte strings would require a `0xFF` "break" sentinel that this
  reader does not model.
- **Overlong head encodings are accepted.**
  The reader is permissive in the direction RFC 8949 § 4.2 explicitly
  allows (readers MAY accept non-canonical encodings).
  The writer always emits shortest form, so on-the-wire output is
  canonical, but the reader interoperates with strictly-conforming
  peers that happen to emit over-wide heads.
  This is a defensible choice; the test now documents it so a future
  refactor that tightens the reader does not silently break interop.
- **2^53-1 ceiling is enforced with defense-in-depth.**
  Two checks fire in `decodeByteStringHead`: a fast-path
  `high > 0x1fffff` reject before the multiplication, and a strict
  `length > MAX_SAFE_PAYLOAD_LENGTH` reject after.
  Both are required to fail for the 2^53 case to slip through, which
  is good (the regression test exercises both).
  The boundary at exactly 2^53 - 1 successfully decodes; no real-world
  consumer would allocate that buffer, but the head-level invariant
  holds.
- **Reader cancellation propagates cleanly.**
  Breaking from a `for await` consumer triggers the async iterator
  return cascade through to the upstream byte source.
  The underlying transport's `return` (e.g., closing a socket pipe)
  fires as expected.

No conformance gaps were found that required code changes; the
implementation's posture matches RFC 8949 and the design's explicit
deferrals.

## Drift items

- **`types.d.ts` not shipped.**
  The dispatch description (and the design's Status section at
  `designs/cbors.md` line 27) says `types.d.ts` was shipped, but
  the package does not contain one.
  All types are inline JSDoc annotations on the source files, and
  `tsc --build tsconfig.build.json` produces a `tsconfig.tsbuildinfo`
  consistent with type-only inference.
  `yarn lint:types` (the bare `tsc` invocation) passes clean.
  This is a documentation drift, not a functional gap; the design
  should either (a) drop the `types.d.ts` claim from Status to match
  the as-built layout, or (b) a follow-up adds the file.
  Not blocking for the judge.
- **Codec scope is tight.**
  No accidental codec features beyond byte-string head encoding:
  grepping the src tree for major-type references shows only
  diagnostic mentions of other majors (in error messages) and the
  `MAJOR_2_BASE`/`MAJOR_3_BASE` discriminator constants.
- **Daemon wiring is absent (correctly).**
  `git diff llm..HEAD -- packages/daemon/` is empty.
  The deferred Phase 2 (wiring `@endo/cbors` into `envelope.js` /
  `bus-xs-core.js`) has not crept in.
- **Builder's `chore: Update yarn.lock` commit is the only lockfile
  touch.**
  The cleaner added no test dependencies, so no follow-on lockfile
  commit is needed.
- **Hex-test reformat caught and reverted.**
  Running `prettier --write packages/cbors/test/cbors.test.js`
  reformatted exactly the targeted file, but a separate uncommitted
  change had appeared in `packages/hex-test/package.json` (the
  warning the prior cleaner's note flagged about `yarn format`'s
  blast radius).
  The unrelated change was reverted (`git checkout`) before
  committing.
  No noise in the cleaner's commit.

## Self-improvement

Nothing this time.
The cleaner pass found the expected adversarial holes, regression
evidence was straightforward, and the existing role/skill files
already covered every step.
One observation worth recording in this entry rather than amending
the role: the `yarn format` blast radius is real on this repo (the
prior cleaner's note is correct).
Targeted `prettier --write <single file>` invocations are the
narrower hammer; using `yarn format` even with a path argument
expands prettier's view to the workspace pretty-format set.
That observation is already captured in the prior cleaner's note;
no new lesson.
