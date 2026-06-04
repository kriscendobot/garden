---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
---

# Ponyfill with native fallthrough cloned from base64 skeleton, with design-after-implementation as ratification discipline

> §Designs-lane after cycle 179's chat-lane. §The fourteenth consecutive
> designs/chat alternation cycle (166-180). §Status: **Complete** —
> shipped on `llm` on 2026-04-24 (commit `ad7a177e8`) with the dev-
> dependency cycle break landing 2026-05-12 via PR #211 / commit
> `68246ad92`. §Sibling-extract-pattern to cycle 172's @endo/bytes
> and cycle 174's gateway-package.

`@endo/hex` is a 692-line design for a new leaf ponyfill package
that consolidates four independent in-tree hex implementations,
delegating to the TC39 `Uint8Array.prototype.toHex` /
`Uint8Array.fromHex` native methods when available, falling back
to portable JS otherwise.

§The-single-most-structurally-interesting-move is §design-after-
implementation-as-ratification-discipline combined with §sibling-
package-cloned-file-for-file-from-base64. §The-design-was-written-
2026-04-29 (single commit `102a94bc9` in a batch of seven
proposals) §after the initial package landed 2026-04-24 in
`ad7a177e8`. §The-design-ratifies-the-upstream-implementation
rather than driving it. §This-is-a-different-discipline from the
common §design-then-build pattern.

## §The-four-problem-statements (the cost of duplication)

The motivation enumerates four independent hex implementations:

| File                                  | Behavior on odd-length input          | Native fast path? |
|---------------------------------------|----------------------------------------|--------|
| `packages/daemon/src/hex.js`          | Silently truncates                     | Yes (TC39 detect) |
| `packages/ocapn/src/buffer-utils.js`  | Throws                                 | No     |
| `packages/relay-server/src/protocol.js` | Truncates                            | No     |
| `Buffer.from(...).toString('hex')`    | Node-only; spec behavior               | N/A (Node) |

§Three-concrete-costs explicitly named: (1) §inconsistent-
semantics (truncate vs throw); (2) §native-fast-paths-only-wired-
up-in-one-package (TC39 `Uint8Array.prototype.toHex` shortcuts
exist only in `daemon/src/hex.js`); (3) §no-canonical-home
(Buffer.from / relative `./hex.js` / inline arithmetic).

§Compare-to-cycle-172-@endo/bytes which had §sixteen-call-sites-
already-in-tree; this design has §eighteen-call-sites with the
same §extract-as-package-then-migrate-incrementally rhythm.

## §Sibling-package-cloned-file-for-file from base64

```
packages/hex/
  CHANGELOG.md
  LICENSE
  README.md
  SECURITY.md
  index.js               # Re-exports encodeHex, decodeHex
  encode.js              # Re-export of src/encode.js
  decode.js              # Re-export of src/decode.js
  src/
    common.js            # Shared alphabet constants, freeze()
    encode.js            # jsEncodeHex + encodeHex with native short-circuit
    decode.js            # jsDecodeHex + decodeHex with native short-circuit
  test/
    main.test.js
    _bench-main.js
  package.json
  tsconfig.json
  tsconfig.build.json
  typedoc.json
```

§Mirrors-packages-base64-file-for-file. §The-design-explicitly-
states-this: "Mirrors `packages/base64/` file-for-file". §`@endo/
base64` is the §canonical-leaf-package-skeleton; §every-future-
leaf-ponyfill should clone its shape.

§Three-files-omitted-from-the-clone: `atob.js`, `btoa.js`,
`shim.js`. §Why: those exist in `@endo/base64` to provide globals
the browser platform already defines for base64 (the legacy BOM
shim). §There-are-no-hex-equivalents-in-any-host-environment, so
the shim surface is absent. §A-future-shim.js-can-install-TC39-
methods if needed. §This-is-§deliberate-omission-not-oversight —
the design names what was deliberately *not* cloned and why.

## §Native-fallthrough-detection (the pattern)

```js
// src/encode.js
const ArrayFromCharCode = String.fromCharCode;
const { from: uint8ArrayFrom } = Uint8Array;

// Detected once at module load.
const nativeToHex =
  typeof (/** @type {any} */ (Uint8Array.prototype).toHex) === 'function'
    ? /** @type {(bytes: Uint8Array) => string} */ (
        /** @type {any} */ (Uint8Array.prototype).toHex
      )
    : undefined;
```

§Detection-runs-once-at-module-load. §Captured-into-module-
private-const. §A-malicious-compartment-that-tampers-with-
`Uint8Array.prototype.toHex`-after-module-init-cannot-redirect-
the-call-site. §SES-lockdown-already-freezes-the-prototype, but
the pattern matches `@endo/base64`'s defensive stance regardless
— §belt-and-suspenders-discipline.

§Compare-to-cycle-179-lp32/host-endian.js which has §module-load-
runtime-endianness-probe. §This-design-has-§module-load-runtime-
native-method-probe. §Both-are-§once-at-module-load-bound-to-
const patterns.

§Compare-to-cycle-175-harden/make-selector.js' §race-to-install-
at-well-known-slot. §That-pattern-races-to-install; §this-
pattern-detects-and-binds. §Different-disciplines-for-different-
slots.

## §Lowercase-default-with-uppercase-fallback-to-JS-path

```js
export const encodeHex =
  nativeToHex !== undefined
    ? (bytes, options) => {
        if (options?.uppercase) {
          // TC39 native only produces lowercase.  Uppercase is rare
          // enough that falling back to the JS path is acceptable.
          return jsEncodeHex(bytes, options);
        }
        return nativeToHex.call(bytes);
      }
    : jsEncodeHex;
```

§Three-case-branching: §native-available-no-uppercase (fast
path); §native-available-uppercase (fall back to JS); §native-
unavailable (always JS).

§The-comment-explains-the-discipline: "TC39 native only produces
lowercase. Uppercase is rare enough that falling back to the JS
path is acceptable." §This-is-§deliberate-asymmetry-acknowledged-
in-comment. §Compare-to-cycle-152-pass-style/symbol.js'
§three-case-decoder for symbol passability — both designs name
their case-by-case asymmetry rather than papering over it.

§Design-Decision-5 codifies this: "options.uppercase only on
encode; decodeHex accepts both. Symmetric to the native TC39
proposal: Uint8Array.prototype.toHex takes no case option (output
is lowercase); Uint8Array.fromHex accepts both cases."

§The-philosophy-named: "Our options.uppercase is an additive
extension that falls back to the JS path when set, matching the
proposal's philosophy of delegating to user code for non-default
behavior."

## §Error-rewrapping-at-the-native-boundary

```js
export const decodeHex =
  nativeFromHex !== undefined
    ? (string, name) => {
        try {
          return nativeFromHex(string);
        } catch (e) {
          // Native throws SyntaxError with no caller context.  Rewrap
          // to match the fallback's error shape.
          throw Error(
            `Invalid hex in string ${name ?? '<unknown>'}: ${/** @type {Error} */ (e).message}`,
          );
        }
      }
    : jsDecodeHex;
```

§Native-fromHex-throws-SyntaxError-with-no-caller-context.
§Fallback-jsDecodeHex-throws-Error-with-`name`-and-offset.
§The-decodeHex-wrapper-rewraps-native-errors so callers who do
`catch (e) { if (/Invalid hex/.test(e.message)) ... }` see the
same shape on both paths.

§Design-Decision-6 codifies this: "Cost: an extra try/catch and
an allocation on the error path. Benefit: a stable error
contract." §Tradeoff-named-explicitly.

§Compare-to-cycle-89-error/assert.js' §error-shape-discipline.
§This-design-applies-the-same-discipline-at-a-different-layer:
not the SES error layer, but the §native-vs-fallback-boundary.

## §The-audit-table-as-migration-driver

```
Every byte-level hex encode/decode site in the monorepo, excluding the
vendored `packages/test262-runner/test262/` fixtures (which are
externally maintained and not migration targets).
```

§Audit-section-is-23-rows-of-byte-array-sites + §9-rows-of-non-
migration-sites. §Each-row-names: file + line range + direction
(encode/decode) + case (lower/upper) + form (template) + notes.

§Compare-to-cycle-172-endo-bytes which had a 16-row audit; this
design's 23 + 9 = 32-row audit is §exhaustive-by-construction.
§Design-Decision-8 codifies this: "Audit drives scope. The audit
table is deliberately exhaustive so the migration review can be a
mechanical check against it. Non-migration sites are listed so
reviewers can confirm nothing is missed."

§This-is-§extra-audit-effort-buys-mechanical-review. §A-reviewer-
doesn't-need-to-grep-the-repo; the design has already done that.
§The-cost-is-borne-once-by-the-designer; §the-benefit-is-borne-
many-times-by-reviewers.

§The-audit-distinguishes-three-classes-of-site:
1. **§Byte-array-migration-targets** (23 rows) — encode/decode
   Uint8Array ↔ string.
2. **§Boundary-sites** (5 rows) — Node `crypto.createHash().digest('hex')`
   and `crypto.randomBytes(n).toString('hex')` — kept at the Node
   powers boundary, not migrated.
3. **§Non-byte-array-sites** (9 rows) — `BigInt.toString(16)`,
   IPv6 group parsing, Unicode code-point formatting — out of
   scope.

§This-three-way-classification-is-explicit-and-defended in Design
Decision 4 ("Node boundaries keep their direct hex usage").

## §Phase-rhythm: §five-phases-mostly-S

| Phase | Scope | Size |
|-------|-------|------|
| 1 — Create `@endo/hex` | Add packages/hex/ as cloned base64. No consumers yet. | S (< 500 LOC) |
| 2 — Migrate daemon | Replace daemon/src/hex.js with re-export from @endo/hex; transitional alias. | S (1 day) |
| 3 — Migrate relay-server | Delete relay-server/src/protocol.js's toHex/fromHex. | S (< 1 hour) |
| 4 — Migrate OCapN | Migrate client/util.js + buffer-utils.js + test files. | S (half day) |
| 5 — Document and release | CHANGELOG, designs/README, npm publish. | S |

§All-five-phases-are-S. §Compare-to-cycle-174-gateway-package
which had four §strategic-phases + 11+ §tactical-PRs. §Hex-
package-is-a-§one-tier-flat-rhythm — leaf package with simple
migration steps.

§Phase-2-uses-the-§transitional-alias-pattern:

```js
// packages/daemon/src/hex.js (transitional)
export { encodeHex as toHex, decodeHex as fromHex } from '@endo/hex';
```

§The-name-mismatch (`toHex` vs `encodeHex`) is handled by re-
export alias. §All-daemon-call-sites continue to import from
`./hex.js`. §No-call-site-rewriting-in-Phase-2. §A-follow-up-
commit-deletes-the-transitional-file. §This-is-§two-step-
migration-with-zero-flaky-window.

## §Eight-Design-Decisions (the structured rationale)

| # | Decision | Reason |
|---|----------|--------|
| 1 | New package, not addition to @endo/base64 | Two RFCs (RFC 4648 § 4 vs § 8); TC39 split; bundler cost scoping |
| 2 | encodeHex/decodeHex naming, not toHex/fromHex | Matches @endo/base64 canonical model; re-export alias migrates call sites |
| 3 | No shim.js | No legacy global like atob/btoa for hex; future shim deferred |
| 4 | Node boundaries keep direct hex usage | digest('hex') returns hex directly; no clarity benefit forcing through @endo/hex |
| 5 | options.uppercase only on encode; decodeHex accepts both | Symmetric to TC39 proposal; additive extension delegates to fallback |
| 6 | Error rewrapping at native boundary | Stable error contract; try/catch cost paid only on error path |
| 7 | Detection one-shot at module load | Standard Hardened-JS pattern; belt-and-suspenders with SES lockdown |
| 8 | Audit drives scope | Exhaustive audit table lets review be mechanical |

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §six-Design-
Decisions and cycle 174 gateway-package's §eight-Design-
Decisions. §The-§eight-Design-Decisions count is shared. §Each-
decision-numbered-with-a-bold-statement-then-rationale — the
§canonical-Design-Decisions-format across endo-but-for-bots
designs.

## §Design-after-implementation-as-ratification

§The-roadmap-calibration paragraph is rare in this corpus:

> Active development: 2026-04-24 → 2026-05-14 (21 days, calendar).
> Design phase: 2026-04-29 (single commit `102a94bc9`, batch of
> seven proposals; the design was written **after** the initial
> package landed 2026-04-24 in `ad7a177e8`, ratifying the upstream
> implementation).

§Design-phase-after-implementation-phase. §The-package-shipped-
first, then the design was written. §Three-bursts-of-
implementation: Burst 1 (initial add 2026-04-24); Burst 2
(compartment-mapper/bundle-source routed through 2026-04-25);
Burst 3 (PR #211 dev-cycle break 2026-05-11 → 2026-05-14).

§This-is-§ratification-by-design — the artifact predates its
specification. §Compare-to-the-typical-design-then-implement
rhythm of cycle 178 daemon-xs-worker-snapshot (design written
2026-04-15, implementation phased after) or cycle 174 gateway-
package (design 2026-05-22 still §Proposed).

§Why-do-this? §The-implementation-was-simple-enough that the
design wasn't load-bearing for the build; §the-design-is-load-
bearing-for-the-record. §Future-developers-reading-only-the-
design will reconstruct intent the same as if it had been
written first.

§Compare-to-the-honesty-of cycle 178's "Revised Scope
Discussion 2026-04-15" subsection (§honest-design-evolution-
record). §This-design's-honest-confession is in its roadmap
calibration: "the design was written **after** the initial
package landed."

## §Four-Dependencies (compact dependency table)

| Design | Relationship |
|---|---|
| `base64-native-fallthrough.md` (sibling, in parallel) | Shares the runtime-detection pattern. |
| `daemon-256-bit-identifiers` (Complete) | Identifiers are 64-char lowercase hex; largest single consumer |
| `daemon-agent-network-identity` (Planned) | Agent keypair bytes over wire as hex |
| `ocapn-noise-network` (Planned) | 32-byte public keys + 16-byte nonces rendered as hex |

§Sibling-design `base64-native-fallthrough.md` is the §parallel-
sibling sharing the detection pattern. §If-one-design-diverges,
the other should be updated for consistency. §This-is-§lockstep-
sibling-design-discipline.

§Compare-to-cycle-174-gateway-package's §eighteen-dependencies.
§This-design has §four. §Hex-is-a-leaf; §gateway-is-a-junction.
§Dependency-count-correlates-with-design-position-in-the-stack.

## §Known-Gaps (the discipline of naming the un-shipped)

```
- [ ] Native TC39 Uint8Array.prototype.toHex does not accept an
      options bag.  If the proposal adds { uppercase } before Stage 4,
      revisit the encode fast path to avoid the fallback on uppercase.
- [ ] packages/compartment-mapper/demo/policy/app.js migration is
      deferred because the demo is CommonJS and requires a richer
      interop story.
- [ ] No benchmark numbers are included here.
- [ ] @endo/hex does not yet have a ./lite export for environments
      that want to avoid the native-detection branch.
- [ ] Uint8Array.prototype.setFromHex (writes into existing buffer)
      is not mirrored.
```

§Five-known-gaps-as-checkbox-list. §Compare-to-cycle-174-gateway-
package's §seven-open-questions. §The-gap-list-is-honest-about-
what-was-deferred. §§Add-if-a-consumer-asks pattern repeats —
features deferred until someone has a concrete need.

§§Add-if-a-consumer-asks is the §YAGNI-with-extension-point
discipline. §The-design-leaves-room for §setFromHex (in-place
write into existing buffer) and §`./lite` export (no native-
detection branch) without committing to them. §This-is-§deliberate-
under-specification.

## §Audit-extends-beyond-source: §test-files-included

Five test files appear in the audit table:

- `daemon/test/hex.test.js`
- `ocapn/test/buffer-utils.test.js`
- `ocapn/test/codecs/_codecs_util.js`
- `ocapn/test/codecs/passable-fuzz.test.js`
- `compartment-mapper/demo/policy/app.js`

§Test-scaffolding-uses-`Buffer.from(...).toString('hex')` for
hex formatting of fuzz diagnostics and codec snapshots. §These-
are-migration-targets-too: removing `Buffer` from test
scaffolding lets tests run on XS and browser realms.

§This-is-the-§portability-by-removing-Node-specific-imports
discipline. §Cycle-179-lp32 had the same flavor: same-host stdio
IPC means no Node-specific `Buffer` is needed; @endo/hex
similarly lets test code drop its `Buffer` dependency.

## §Boundary-sites-explicitly-named-and-defended

Five sites are not migration targets despite using hex:

- `daemon/src/daemon-node-powers.js` line 309 — `digester.digest('hex')`
- `daemon/src/daemon-node-powers.js` line 319 — `randomHex256` via Node `crypto.randomBytes(n).toString('hex')`
- `check-bundle/index.js` line 14 — `hash.digest().toString('hex')`
- `compartment-mapper/src/node-powers.js` lines 162-168 — `hash.digest().toString('hex')`
- `cli/src/random.js` line 9 — `bytes.toString('hex')`

§Design-Decision-4-defends-this: "Forcing them through @endo/hex
would add a Uint8Array allocation without clarity benefit." §The-
policy-named: inside SES-locked compartments and platform-
agnostic code, use @endo/hex; at the Node powers boundary, use
whatever the `crypto` API gives you.

§This-is-§don't-pessimize-the-boundary discipline. §Compare-to-
cycle-167-where/index.js' §platform-fallback-chain that
deliberately uses platform-native conventions at the boundary
rather than forcing portability.

## §SES-and-hardening-considerations (the SES paragraph)

```
- Every named export has a companion harden() call.
  Module-level constants (hexAlphabetLower, hexAlphabetUpper) are
  hardened at declaration.
- The native method is looked up once at module load and bound
  into a local const.  A malicious compartment that tampers with
  Uint8Array.prototype.toHex after module initialization cannot
  redirect our call site.  (SES lockdown already freezes the
  prototype, but the pattern matches @endo/base64's defensive
  stance regardless.)
- Input validation happens in the JS path unconditionally.
- No module-scope mutable state; detection is pure and
  deterministic.
```

§Four-SES-bullets: §every-export-hardened + §native-bound-at-
module-load + §input-validation-in-JS-path-unconditionally +
§no-module-scope-mutable-state.

§The-third-bullet-is-the-most-interesting: input validation runs
on the JS path *unconditionally*. §When-we-delegate-to-the-
native-path, we rewrap native errors. §The-validation-cost-is-
paid-twice-in-the-error-path (once in native, once in rewrap),
but §never-twice-on-the-happy-path. §This-is-§belt-and-
suspenders-for-input-but-not-for-output.

## §Cohesion notes

- §Sibling-extract-pattern to cycle 172 @endo/bytes (also a leaf
  ponyfill extracted from consumer call sites) and cycle 174
  gateway-package (subsystem-package extracted as a junction).
- §Canonical-leaf-package-skeleton: `packages/base64/` is the
  template; future leaf ponyfills should clone its shape.
  §Three-files-omitted (atob.js / btoa.js / shim.js) are
  §deliberate-omission-not-oversight.
- §Design-after-implementation-as-ratification-discipline: the
  artifact predates its specification. §Honest-roadmap-
  calibration in the Status section names this.
- §Module-load-runtime-detection bound to module-private const
  — same shape as cycle 179 lp32 host-endian probe + cycle 175
  harden/make-selector.js' race-to-install.
- §Error-rewrapping-at-native-boundary for §stable-error-
  contract — explicit Design Decision 6 with named cost/benefit.
- §Eight-Design-Decisions canonical format matches cycle 174
  gateway-package's eight + cycle 178 daemon-xs-worker-
  snapshot's six.
- §Audit-drives-scope: 32 rows total (23 byte-array + 5
  boundary + 9 non-byte-array) lets migration review be
  mechanical. §Test-files-included in the audit lets §portability-
  by-removing-Node-specific-imports proceed.
- §Five-phases-mostly-S: leaf package with simple migration
  rhythm. §Transitional-alias-pattern in Phase 2 eliminates the
  flaky-window between package-landed and call-sites-migrated.
- §Boundary-sites-explicitly-named-and-defended: §don't-
  pessimize-the-boundary; use the platform's hex directly
  where it already produces hex.
- §Status-Complete with shipped commits cited (ad7a177e8 +
  68246ad92) — §design-ratifies-implementation-then-cites-it.

## §Tier-1 borrowing

- §sibling-package-cloned-file-for-file (canonical-leaf-package
  pattern from @endo/base64)
- §design-after-implementation-as-ratification-discipline
- §native-fallthrough-detection-bound-once-at-module-load
- §error-rewrapping-at-native-boundary-for-stable-error-contract
- §audit-drives-scope (exhaustive table for mechanical review)
- §three-way-classification-of-sites (migration / boundary /
  non-byte-array)
- §transitional-alias-pattern (re-export alias eliminates flaky
  window between package-landed and call-sites-migrated)
- §don't-pessimize-the-boundary (platform-native at the edge,
  portable in the middle)
- §belt-and-suspenders-for-input-but-not-for-output (input
  validation unconditional even when delegating output)
- §deliberate-omission-not-oversight (atob.js / btoa.js /
  shim.js named as not-cloned and why)

## §Synthesis-target

The §slot-machine-library may need its own leaf packages
(framing, hashing, signing) extracted from initial monolith.
§Hex-package-discipline-applies: clone the canonical skeleton,
detect-and-bind-once, rewrap-errors-for-stable-contract,
exhaustive-audit-for-mechanical-review, transitional-alias-for-
zero-flaky-window.
