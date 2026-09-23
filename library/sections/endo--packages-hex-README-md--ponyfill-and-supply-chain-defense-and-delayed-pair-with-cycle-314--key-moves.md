---
title: Key moves
source: endo--packages-hex-README-md
url: https://github.com/endojs/endo/blob/master/packages/hex/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/README.md
total-lines: 60
ingest-cycle: 317
ingest-date: 2026-06-11
lane: designs
section-tags:
  - the-named-ponyfill-IS-named-precise-over-polyfill
  - the-named-separate-import-per-direction-discipline
  - the-named-entrain-IS-named-load-time-cost
  - the-named-default-to-narrow-import-with-broad-import-as-escape-hatch
  - the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden
  - the-named-LICENSE-file-makes-README-License-section-optional
  - the-named-delayed-pair-shape
  - the-named-pair-shape-IS-named-cross-product-of-order-and-gap
  - eight-cycles-with-named-pivot-domain-stay
  - six-cycles-with-named-Hardened-JS-discipline
  - four-shapes-of-pair-discipline
  - the-named-shape-varies-by-package-content-extends
  - the-named-shorter-README-with-no-License-and-no-Overview-heading
  - the-named-four-section-README-shape-as-new-data-point
parent: endo--packages-hex-README-md--ponyfill-and-supply-chain-defense-and-delayed-pair-with-cycle-314
---

- **§the-named-ponyfill-IS-named-precise-over-polyfill** (line 5-6) — the README calls `@endo/hex` a **ponyfill**, not a polyfill: *"ponyfill for the TC39 `Uint8Array.prototype.toHex` and `Uint8Array.fromHex` intrinsics"*. A polyfill mutates global state (assigns to `Uint8Array.prototype.toHex` if missing); a ponyfill exports the same function without mutating globals. §the-named-ponyfill-vs-polyfill-distinction is structurally significant in a SES context: post-lockdown, global mutation is forbidden, so polyfills are infeasible. **§the-named-ponyfill-IS-named-SES-compatible**; §the-named-naming-IS-named-load-bearing-in-SES-context. The terminology is itself a security claim. First-explicit-observation.

- **§the-named-separate-import-per-direction-discipline** (line 26-30) — the canonical Usage example imports `encodeHex` from `@endo/hex/encode.js` and `decodeHex` from `@endo/hex/decode.js` *separately*; the dual import from `@endo/hex` (which re-exports both) is offered as a commented-out alternative with the framing *"Or, if you genuinely need to entrain both implementations"*. §the-named-entrain-IS-named-load-time-cost — the word "entrain" makes the load-time cost visible; §the-named-default-to-narrow-import-with-broad-import-as-escape-hatch; §the-named-genuinely-needing-both-IS-named-the-exception. First-explicit-observation. This is **§the-named-tree-shaking-aware-discipline-without-requiring-tree-shaking** — explicit per-direction imports work even on bundlers that don't tree-shake, and they signal intent clearly.

- **§the-named-LICENSE-file-makes-README-License-section-optional** (line 60 is the last) — the README *omits* a License section. The package has a `LICENSE` file at `packages/hex/LICENSE` (verified during sparse-checkout). §the-named-LICENSE-file-is-the-authoritative-source; §the-named-README-License-section-IS-named-redundant-if-LICENSE-file-exists; **§the-named-shape-varies-by-package-content** gains a new instance — hex omits both Overview heading and License section. **§the-named-four-section-README-shape-as-new-data-point** (Install + Usage + API + Hardened-JavaScript; no Overview heading, no License). Contrasts with §three-cycles-with-named-six-section-README-shape (311 nat + 313 memoize + 315 lp32). The pivot now contains both six-section and four-section README shapes; §the-named-README-shape-IS-named-tailored-to-package-depth (a smaller package gets a smaller README).

- **§the-named-delayed-pair-shape** — cycle 314 (hex source) and cycle 317 (hex README) form a *delayed* pair. The pair is in canonical source→README order (matching cycles 310-311 nat and 312-313 memoize), but with a three-cycle gap (315 lp32 README and 316 lp32 reader intervened). §the-named-orphan-singleton-was-temporary; §the-named-delayed-pair-IS-named-retroactive-completion; §the-named-pair-can-survive-gaps. This is the **third pair shape**, after adjacent-regular and adjacent-reverse. §four-shapes-of-pair-discipline becomes possible (the fourth would be README-first-source-second-with-gap; not yet observed):

| Order | Gap | Cycles |
|---|---|---|
| src→README | adjacent | 310-311 (nat), 312-313 (memoize) |
| README→src | adjacent | 315-316 (lp32) |
| src→README | delayed (3-cycle gap) | 314 + 317 (hex) |
| README→src | delayed | *not yet observed* |

- **§the-named-pair-shape-IS-named-cross-product-of-order-and-gap** — the four shapes are the cross-product of two binary parameters: (order = src→README or README→src) × (gap = adjacent or delayed). First-explicit-observation as a *parameterized* discipline. The library is exhibiting *three* of the four combinations; the fourth would arise if a README is ingested and the source arrives many cycles later (could happen if @endo/stream README ingests at cycle 318 and @endo/stream src follows at cycle 322, for instance).

- **§the-named-canonical-Uint8Array-example-shape** (line 32-33) — `encodeHex(new Uint8Array([0xb0, 0xb5, 0xc4, 0xfe])); // 'b0b5c4fe'` and `decodeHex('b0b5c4fe'); // Uint8Array(4) [0xb0, 0xb5, 0xc4, 0xfe]`. Four-byte sequence with non-trivial hex values (avoids 0x00 or 0xff, which could be mistaken for null/sentinel). §the-named-non-degenerate-example-values; §the-named-round-trip-example-via-symmetric-functions (encode then decode); §the-named-symmetric-API-symmetric-example. Contrast cycle 315's `[0x05, 0x00, 0x00, 0x00] [h, e, l, l, o]` (5-byte ASCII payload, length prefix in host byte order — a different kind of canonical example for a different kind of API).

- **§the-named-dispatches-at-module-load-time** (line 11-12) — the README explicitly says *"On engines that ship the native intrinsics, `encodeHex` and `decodeHex` dispatch to them at module load time."* This is the **README-side technique-name** for cycle 314's source-side §the-named-pre-lockdown-binding-capture. The README explains *what* the source does at the load-time decision point; the source *implements* the decision. §the-named-module-load-time-dispatch-IS-named-canonical-vocabulary; §two-cycles-with-named-module-load-time-dispatch-naming (314 source + 317 README).

- **§the-named-SES-locked-down-compartments-named-as-fallback-trigger** (line 13-15) — *"and in SES-locked-down compartments where a realm has removed the intrinsics, the package falls through to a portable pure-JavaScript implementation."* §the-named-realm-removes-intrinsics-IS-named-SES-specific-failure-mode; §the-named-fallback-IS-named-portable-pure-JavaScript; §the-named-SES-realm-IS-named-deliberate-attenuation-context. First-explicit-observation.

- **§the-named-name-parameter-as-error-attribution-discipline** (line 7-9, 48-49) — the README mentions twice that the optional `name` parameter is included in error messages for diagnostic context. **§two-mentions-of-the-named-name-parameter-discipline** in one README; §the-named-pattern-deserves-repetition; §the-named-name-parameter-IS-named-cross-package-idiom — same shape as cycle 315's lp32 Reader options and cycle 316's lp32 reader.js implementation. §three-cycles-with-named-name-parameter-IS-named-error-attribution (315 + 316 + 317).

- **§the-named-throws-on-named-error-conditions** (line 47) — *"Throws on odd-length strings and on characters outside `[0-9a-fA-F]`."* §the-named-error-conditions-enumerated-in-API-section; §the-named-throws-IS-named-noisy-failure (decode is fail-noisy on invalid input, paralleling cycle 316's §the-named-trailing-bytes-fail-noisy).

- **§the-named-lowercase-default-with-caller-uppercase-discipline** (line 40-41) — README repeats cycle 314's source-side observation: *"Encodes a `Uint8Array` as a lowercase hex string. Callers that need uppercase can call `.toUpperCase()` on the result."* §two-cycles-with-named-lowercase-default-with-caller-uppercase-discipline (314 source + 317 README); §the-named-canonical-form-on-output-caller-discretion-on-format.

- **§the-named-API-section-with-H3-subheadings-per-function** (line 36-49) — the API section has two H3 (`###`) subheadings, one per exported function, with signature lines. §the-named-API-subheading-per-export-discipline; contrasts with cycle 315's lp32 README which used H3 subheadings for `makeLp32Reader` and `makeLp32Writer`. §two-cycles-with-named-API-section-IS-named-formal-parameter-documentation (315 + 317).

- **§the-named-proposal-stage-citation-without-link** (line 5-6) — *"proposal-arraybuffer-base64, Stage 4"* — names the TC39 proposal and stage but does *not* link to the proposal URL. §the-named-cite-the-stage-and-proposal-name-as-text-not-link; §the-named-proposal-stage-IS-named-maturity-marker; §two-cycles-with-named-Stage-4-TC39-proposal-citation (314 + 317). The cycle 314 source had `https://github.com/tc39/proposal-arraybuffer-base64` as a comment URL; the README cites by name only.
