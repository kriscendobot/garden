---
title: 'endo-but-for-bots designs/hex-package.md — @endo/hex ponyfill'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
source_paths:
  - designs/hex-package.md
authors:
  - Kris Kowal (prompted)
created: 2026-04-23
updated: 2026-05-18
status_at_ingest: Complete
ingested: 2026-06-03
ingested_by: scholar
topics:
  - hardened-javascript
  - tooling
sections:
  - endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation.md
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
---

# `@endo/hex` — Hex Encode/Decode Ponyfill (design)

## §Abstract

`@endo/hex` consolidates four independent in-tree hex encode/
decode implementations (`packages/daemon/src/hex.js`,
`packages/ocapn/src/buffer-utils.js`, `packages/relay-server/src/
protocol.js`, and inline `Buffer.from(...).toString('hex')` sites)
into a single Hardened-JavaScript-compatible ponyfill that
mirrors `@endo/base64` exactly. When the TC39 native methods
(`Uint8Array.prototype.toHex` / `Uint8Array.fromHex`) are
available, calls short-circuit to them; otherwise a portable
implementation runs.

The package layout is **cloned file-for-file from `packages/
base64/`**, minus the three legacy-BOM shim files (`atob.js`,
`btoa.js`, `shim.js`) that have no hex equivalent in any host
environment.

## §Status

**Complete** (shipped on `llm` 2026-04-24 via commit `ad7a177e8`;
dev-dependency cycle break shipped 2026-05-12 via PR
[#211](https://github.com/endojs/endo-but-for-bots/pull/211) /
commit `68246ad92`). The package design was written **after**
the initial implementation landed — 2026-04-29 single commit
`102a94bc9` in a batch of seven proposals — making this a
§design-after-implementation-as-ratification-discipline artifact.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/hex-package.md` | 692 | The design being ingested |
| `packages/hex/index.js` | — | Re-exports encodeHex, decodeHex |
| `packages/hex/src/encode.js` | — | jsEncodeHex + encodeHex with native short-circuit |
| `packages/hex/src/decode.js` | — | jsDecodeHex + decodeHex with native short-circuit |
| `packages/hex/src/common.js` | — | Shared alphabet constants, freeze() |
| `packages/hex-test/` | — | Synthetic test package for break-dev-dependency-cycles (PR #211) |

## §Dependencies and lineage

- §Sibling-design `base64-native-fallthrough.md` (in parallel) —
  shares runtime-detection pattern. §Lockstep-sibling-design
  discipline.
- §Largest-consumer `daemon-256-bit-identifiers` (Complete) —
  64-char lowercase hex.
- §Planned-consumers `daemon-agent-network-identity` +
  `ocapn-noise-network` — keypair bytes and Noise handshake
  values rendered as hex.
- §Sibling-extract-pattern to:
  - Cycle 172 (`endo-bytes.md`) — also a leaf ponyfill extracted
    from consumer call sites.
  - Cycle 174 (`gateway-package.md`) — subsystem-package
    extracted as a junction.
- §Canonical-skeleton-source `@endo/base64` — cloned file-for-
  file, minus three deliberate omissions.

## §Related sources in the library

- §Cycle 172 (`endo-but-for-bots--llm-designs-endo-bytes.md`) —
  §sibling-extract-pattern at leaf-utility-package scope. Both
  ingests share §extract-as-package-then-migrate-incrementally
  rhythm and §exhaustive-audit-table discipline.
- §Cycle 174 (`endo-but-for-bots--llm-designs-gateway-package.md`)
  — §sibling-extract-pattern at subsystem-package scope. Same
  §eight-Design-Decisions canonical format.
- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-worker-
  snapshot.md`) — §six-Design-Decisions sibling and §honest-
  design-evolution-record sibling. Hex-package's roadmap
  calibration paragraph is the same shape as that design's
  Revised Scope Discussion 2026-04-15.
- §Cycle 179 (`endo--packages-lp32-reader-writer-js.md`) —
  §module-load-runtime-detection pattern sibling. lp32 detects
  endianness; hex detects native method presence.
- §Cycle 175 (`endo--packages-harden-make-selector-js.md`) —
  §race-to-install-at-well-known-slot vs §detect-and-bind-once
  comparison.
- §Cycle 167 (`endo--packages-where-index-js.md`) — §don't-
  pessimize-the-boundary discipline (platform-native at edge,
  portable in middle).

## §Comment fragments worth preserving

```
// TC39 native only produces lowercase.  Uppercase is rare
// enough that falling back to the JS path is acceptable.
```

§Asymmetry-acknowledged-in-comment. §Discipline-of-explaining-
case-by-case branching in the source rather than papering over
it.

```
// Native throws SyntaxError with no caller context.  Rewrap
// to match the fallback's error shape.
```

§Stable-error-contract comment. §Names-the-cost (try/catch) and
the §benefit (stable contract) in two lines.

```
// Detected once at module load.  The proposal-arraybuffer-base64
// methods are own properties on Uint8Array / Uint8Array.prototype.
```

§Module-load-detection comment. §Tells-future-readers where to
look (TC39 spec name) and when the detection happens (once at
import).
