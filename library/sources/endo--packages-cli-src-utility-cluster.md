---
title: '@endo/cli: src/ utility cluster (pet-name + message-format + message-parse + number-parse + random + prompt)'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/cli/src
source_paths:
  - packages/cli/src/pet-name.js
  - packages/cli/src/message-format.js
  - packages/cli/src/message-parse.js
  - packages/cli/src/number-parse.js
  - packages/cli/src/random.js
  - packages/cli/src/prompt.js
authors:
  - Kris Kowal (prompted)
ingested: 2026-06-05
ingested_by: scholar
topics:
  - tooling
  - daemon
sections:
  - endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation.md
genre: §endo-source-comment-fragment §canonical-CLI-utility-cluster
cycle: 195
lane: chat
---

# @endo/cli: src/ utility cluster (six tight helpers)

## §Abstract

Six tight CLI utility files (138 lines total) under
`packages/cli/src/`. Each file is a §single-responsibility
helper with §no-internal-dependencies in the cluster. Used
throughout the `endo` CLI's command modules.

| File | Lines | Purpose |
|------|-------|---------|
| `pet-name.js` | 41 | §dot-delimited-pet-name-path-parsing |
| `message-format.js` | 20 | §template-literal-formatter for `@petName` mentions |
| `message-parse.js` | 28 | §regex-based parser for `@petName:edgeName` |
| `number-parse.js` | 13 | §parseBigint with strict regex validation |
| `random.js` | 13 | §randomHex16 — uses @endo/hex |
| `prompt.js` | 23 | §readline-based interactive lowercase prompt |

§The-headline-finding: §second-confirmation-of-the-§gap-
between-design-and-implementation. §Cycle-180-hex-package's
§audit-table-row-32 predicted `cli/src/random.js` line 9
would be §retained-at-boundary (keep `crypto.randomBytes(n)
.toString('hex')`); §actual-source uses `encodeHex(bytes)`
from @endo/hex. §Cycle-185-check-bundle found-the-same-
pattern at row-23. §Two-of-two-audit-boundary-sites have
since been migrated.

§Other-disciplines:

- §parseOptional-variant-pattern (undefined passthrough
  wrapper around a strict parser).
- §empty-segment-rejection in dot-delimited path parsing.
- §@-escape-via-backslash + §@-mention-regex-with-128-char-
  max (matched format/parse pair).
- §example-comments-in-source-not-tests (five console.log
  examples commented out in message-parse.js).
- §strict-regex-bigint-parser `/^(0|[1-9][0-9]*)$/`
  (rejects leading zeros, signs, decimals).
- §promise-wrap-Node-callback-API for cleaner async surface.
- §async-readline-prompt-with-trim-and-toLowerCase
  discipline for case-insensitive confirmation.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `packages/cli/src/pet-name.js` | 41 | parsePetNamePath + parseOptionalPetNamePath |
| `packages/cli/src/message-format.js` | 20 | formatMessage |
| `packages/cli/src/message-parse.js` | 28 | parseMessage |
| `packages/cli/src/number-parse.js` | 13 | parseBigint |
| `packages/cli/src/random.js` | 13 | randomHex16 |
| `packages/cli/src/prompt.js` | 23 | prompt |

## §Provenance and dependencies

- §Imports `@endo/errors` (`q` template tag) from pet-name.js.
- §Imports `@endo/hex` (`encodeHex`) from random.js — the
  §migration-that-cycle-180-design-predicted-wouldn't-happen.
- §Imports Node-builtin `crypto`, `process`, `readline` from
  random.js + prompt.js.
- §No-internal-dependencies within the cluster (no file
  imports another).
- §Consumers: `packages/cli/src/commands/*.js` — the CLI's
  command modules (not in this ingest).

## §Related sources in the library

- §Cycle 180 (`endo-but-for-bots--llm-designs-hex-package.md`)
  — §audit-table predicted §retained-at-boundary for
  `cli/src/random.js` line 9 (row 32). §Cycle-195 confirms-
  this-prediction-was-overturned by implementation.
- §Cycle 185 (`endo--packages-check-bundle-js.md`) — first
  observation of the §gap-between-design-and-implementation
  at `check-bundle/index.js`. §Cycle-195 makes-it-twice.
- §Cycle 49 (daemon-locator-terminology) — §256-bit-identifier-
  width sibling; cycle 195's `randomHex16` is the §128-bit
  variant.
- §Cycle 87 (SES error/assert) — `q` template tag substrate.
- §Cycle 167 (`endo--packages-where-index-js.md`) — §per-
  platform-naming-conventions; cycle 195-pet-name has no
  platform variation but shares the §empty-segment-defense
  rigor.
- §Cycle 189 (`endo--packages-marshal-src-marshal-justin-
  and-marshal-stringify-js.md`) — §SGML-comment-injection-
  defense sibling at a different scale; cycle 195-message-
  format/parse has §@-escape-via-backslash for literal-@
  protection.
- §Cycle 191 (`endo--packages-zip-src-cluster.md`) —
  §assertNatNumber sibling for integer-validation discipline.
- §Cycle 185's §await-null-at-function-start vs cycle 195-
  prompt's `new Promise` constructor without `await null` —
  cycle 195-prompt doesn't need it because the only throws
  happen inside the readline callback which is already in
  microtask context.

## §Comment fragments worth preserving

```js
// console.log(parseMessage('before @pet-name:edge-name and @other-pet-name to the end'));
// console.log(parseMessage('@pet-name'));
// console.log(parseMessage('@pet-name:edge-name'));
// console.log(parseMessage('@pet-name:edge-name trailer'));
// console.log(parseMessage('header @pet-name:edge-name trailer'));
```

§Five-commented-out-console.log-examples in message-parse.js.
§Quick-mental-verification disguised as a comment block.

```js
import { encodeHex } from '@endo/hex';
import crypto from 'crypto';
// ...
resolve(encodeHex(bytes));
```

§The-implementation-that-overturned-the-cycle-180-design-
prediction. §Cycle-180-audit-row-32 said this site would
§use-`crypto.randomBytes(n).toString('hex')`-directly. §It-
doesn't.

```js
const pattern = /@([a-z][a-z0-9-]{0,127})(?::([a-z][a-z0-9-]{0,127}))?/g;
```

§The-canonical-mention-regex. §128-char-max + §lowercase-
prefix + §allowed-charset (letters + digits + hyphen).
§Optional-edge-name via `:edgeName` suffix.

```js
assert(typeof petNamePath === 'string');
```

§Type-assertion-first discipline. §Compare-to-cycle-181-base64's
§three-class-validation (JSON-parse + type-object + not-
array). §Type-first is the §cheapest-defense.
