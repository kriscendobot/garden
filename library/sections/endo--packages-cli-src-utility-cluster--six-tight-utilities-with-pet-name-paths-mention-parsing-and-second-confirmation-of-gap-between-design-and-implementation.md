---
source: packages/cli/src/{pet-name,message-format,message-parse,number-parse,random,prompt}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/cli/src
source_path: packages/cli/src/pet-name.js, packages/cli/src/message-format.js, packages/cli/src/message-parse.js, packages/cli/src/number-parse.js, packages/cli/src/random.js, packages/cli/src/prompt.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
genre: §endo-source-comment-fragment §canonical-CLI-utility-cluster
cycle: 195
lane: chat
status: current
---

# Six tight CLI utilities (pet-name path parsing, @-mention message format and parse, parseBigint, randomHex16, readline prompt) with second confirmation of the design-vs-implementation gap

> §Chat-lane after cycle 194's designs-lane. §The-twenty-
> ninth-consecutive designs/chat alternation cycle (166-195).
> §Cycle-185-check-bundle observed the §gap-between-design-
> and-implementation when cycle 180-hex-package's audit-
> table-row-23 predicted §retained-at-boundary for `check-
> bundle/index.js` line 14, but the actual source had
> migrated to `encodeHex`. §Cycle-195 confirms the same
> pattern at a second site: `cli/src/random.js` line 9 was
> the same §retained-at-boundary prediction (cycle 180-hex
> audit-table-row-32) — and §the-actual-current-source uses
> `encodeHex(bytes)` from @endo/hex. §Twice-now: designs-
> are-guides-not-contracts.

`packages/cli/src/` contains a §six-file-utility-cluster
(138 lines total) of small focused helpers used throughout
the `endo` CLI surface. Each file is §a-single-responsibility
helper that the CLI's command modules import.

| File | Lines | Single responsibility |
|------|-------|-----------------------|
| `pet-name.js` | 41 | §dot-delimited-pet-name-path-parsing |
| `message-format.js` | 20 | §template-literal-formatter for `@petName` mentions |
| `message-parse.js` | 28 | §regex-based parser for `@petName:edgeName` |
| `number-parse.js` | 13 | §parseBigint with strict regex validation |
| `random.js` | 13 | §randomHex16 — now uses @endo/hex |
| `prompt.js` | 23 | §readline-based interactive lowercase prompt |

§The-single-most-structurally-interesting-move is §second-
confirmation-of-the-§gap-between-design-and-implementation
(at `cli/src/random.js` line 9) + §dot-delimited-pet-name-
path-parsing-with-empty-segment-rejection + §@-escape-via-
backslash-in-format-companion-with-@-mention-regex-in-parse
+ §strict-regex-bigint-parser + §example-comments-in-source-
not-tests. §Five-named-moves across the cluster.

## §The-§gap-between-design-and-implementation, confirmed twice

§Cycle-180-hex-package-design's §audit-table predicted two
§boundary-sites would be §retained-as-is (not migrated to
`encodeHex`):

| Cycle 180 audit row | File | Prediction | Actual source |
|--------------------|------|------------|---------------|
| Row 23 | `packages/check-bundle/index.js` line 14 | "Retained as-is: digest already returns hex directly" | Migrated to `encodeHex(hash.digest())` (cycle 185 finding) |
| Row 32 | `packages/cli/src/random.js` line 9 | "Retained as-is: crypto.randomBytes(n).toString('hex')" | Migrated to `encodeHex(bytes)` (this cycle) |

§Two-of-two-boundary-sites-named-in-the-audit-have-since-been-
migrated. §The-pattern-is-clear: §designs-are-guides-not-
contracts; §the-implementation-can-drift-toward-greater-
consistency over time even when the design rationalized
keeping the boundary.

§The-actual-cycle-195-`random.js`:

```js
import { encodeHex } from '@endo/hex';
import crypto from 'crypto';

export const randomHex16 = () =>
  new Promise((resolve, reject) =>
    crypto.randomBytes(16, (err, bytes) => {
      if (err) {
        reject(err);
      } else {
        resolve(encodeHex(bytes));
      }
    }),
  );
```

§Six-lines + import. §Uses `encodeHex(bytes)` after `crypto
.randomBytes(16, ...)` instead of `crypto.randomBytes(16).
toString('hex')`. §The-design-predicted-this-would-be-extra-
work-without-clarity-benefit; §the-migration-happened-anyway.

§Why-twice-might-happen: §the-policy-of-routing-all-hex-
through-@endo/hex was easier to enforce uniformly than to
maintain a §two-classes-of-hex-call-site distinction. §A-
mechanical-grep-and-replace pass that the audit-table didn't
anticipate.

§Compare-to-cycle-186-break-dev-deps' §audit-as-cycle-break-
precondition (grep for unused devDeps before adding new
packages). §Cycle-186-uses-audit-to-find-things-to-remove;
§cycle-180's-audit-was-used-to-find-things-NOT-to-touch — and
the implementation §didn't-respect-the-list.

§Tier-1-borrowing: §designs-are-guides-not-contracts is
§confirmed-by-two-independent-sites (not just one). §Future-
library-memory-should-verify-against-source not just against
designs. The §verify-against-source-not-design discipline
cycle 185 named is now §confirmed-as-a-recurring-pattern.

## §pet-name.js (the §dot-delimited-path-parsing)

```js
import { q } from '@endo/errors';

export const parsePetNamePath = petNamePath => {
  assert(typeof petNamePath === 'string');

  const petNames = petNamePath.split('.');
  for (const petName of petNames) {
    if (petName === '') {
      throw new Error(
        `Pet name path ${q(petNamePath)} contains an empty segment.`,
      );
    }
  }
  return petNames;
};

export const parseOptionalPetNamePath = optionalPetNamePath => {
  assert(
    optionalPetNamePath === undefined ||
      typeof optionalPetNamePath === 'string',
  );

  return optionalPetNamePath === undefined
    ? undefined
    : parsePetNamePath(optionalPetNamePath);
};
```

§Two-functions: §parsePetNamePath (strict) + §parseOptionalPetNamePath
(undefined passthrough). §The-strict-form throws on §empty-
segment ("foo..bar" or "" or "foo." would fail).

§Why-split-on-dot: §pet-names-are-flat-strings, but the CLI's
pet-name-paths walk a §directory-like-hierarchy. §"foo.bar.baz"
addresses `bar` inside `foo`, then `baz` inside that.

§The-empty-segment-check defends against:
- `""` (empty string) — would split to `[""]` containing one
  empty segment.
- `"foo."` — would split to `["foo", ""]`.
- `"foo..bar"` — would split to `["foo", "", "bar"]`.
- `".foo"` — would split to `["", "foo"]`.

§The-§q(petNamePath) wraps the original input for diagnostic
purposes (cycle 87-ses-error/assert.js' §`q`-template-tag).

§The-§undefined-passthrough variant lets callers chain
optional inputs without an `if (x !== undefined)` per call
site. §Compare-to-cycle-167-where/index.js' §POSIX-vs-macOS-
vs-Windows path-resolution: cycle 195-pet-name.js handles
the simpler case (no platform variation) but with the same
§empty-segment-defense rigor.

§Tier-1-borrowing: §parseOptional-variant-pattern for any
§strict-parser whose inputs might be optional in caller code.
§Two-functions-with-the-undefined-passthrough as wrapper.

## §message-format.js + message-parse.js (the @-mention pair)

§message-format.js (20 lines):

```js
export const formatMessage = (strings, edgeNames) => {
  let message = '';
  let index = 0;
  for (
    index = 0;
    index < Math.min(strings.length, edgeNames.length);
    index += 1
  ) {
    message += strings[index].replace(/@/g, '\\@');
    message += `@${edgeNames[index]}`;
  }
  if (strings.length > edgeNames.length) {
    message += strings[index].replace(/@/g, '\\@');
  }
  return JSON.stringify(message);
};
```

§message-parse.js (28 lines):

```js
const pattern = /@([a-z][a-z0-9-]{0,127})(?::([a-z][a-z0-9-]{0,127}))?/g;

export const parseMessage = message => {
  const strings = [];
  const petNames = [];
  const edgeNames = [];
  let start = 0;
  message.replace(pattern, (match, edgeName, petName, stop) => {
    strings.push(message.slice(start, stop));
    start = stop + match.length;

    edgeNames.push(edgeName);
    petNames.push(petName ?? edgeName);
    return '';
  });
  strings.push(message.slice(start));
  return {
    strings,
    petNames,
    edgeNames,
  };
};

// console.log(parseMessage('before @pet-name:edge-name and @other-pet-name to the end'));
// ...
```

§A-format/parse-pair. §The-§@-mention-protocol: `@petName`
mentions a pet by name; `@petName:edgeName` mentions a pet
with a §named-edge (used for capability-passing in CLI
commands).

§Format-and-parse-are-asymmetric:

- **§format** takes `(strings, edgeNames)` — the §tagged-
  template-literal-shape with edge-names interpolated between
  template strings.
- **§parse** returns `{strings, petNames, edgeNames}` — the
  §three-array-decomposition where `petNames` defaults to
  `edgeNames` when no `:edgeName` suffix is present.

§The-§@-escape-via-backslash discipline: `strings[index]
.replace(/@/g, '\\@')` escapes any literal `@` in the user-
supplied string portion. §Symmetric-to-the-§regex-match-
pattern (which won't match `\\@` since the regex starts with
`@` not `\\@`).

§The-§regex-pattern: `/@([a-z][a-z0-9-]{0,127})(?::([a-z][a-z0-9-]{0,127}))?/g`.

§Five-properties:

1. §Lowercase-letter-prefix (`[a-z]`) — pet names start with
   a lowercase letter.
2. §128-char-max (`{0,127}` after the prefix = 128 total).
3. §Allowed-charset (`[a-z0-9-]`) — lowercase + digits +
   hyphen.
4. §Optional-edge-name-via-colon (`(?::([a-z][a-z0-9-]{0,127}))?`).
5. §Global-flag (`/g`) — multiple mentions per message.

§The-128-char-limit is consistent with cycle 49-daemon-
locator-terminology and other Endo identifier conventions.

§Compare-to-cycle-189-marshal-justin's §SGML-comment-
injection-defense (the `<!` and `->` cases in badPair-
detector). §Both-are-§escape-injection-defense at different
scales; cycle 189 protects against HTML-comment formation in
minified JS; cycle 195 protects against literal-`@` being
misread as a mention.

§The-§example-comments-in-source (lines 24-28 of message-
parse.js):

```js
// console.log(parseMessage('before @pet-name:edge-name and @other-pet-name to the end'));
// console.log(parseMessage('@pet-name'));
// console.log(parseMessage('@pet-name:edge-name'));
// console.log(parseMessage('@pet-name:edge-name trailer'));
// console.log(parseMessage('header @pet-name:edge-name trailer'));
```

§Five-commented-out-console.log-examples as §inline-tests-
that-don't-run. §A-§quick-sanity-check disguised as a
comment block. §Tier-1-borrowing: §example-comments-in-source-
not-tests for §quick-mental-verification of a parser.

§Compare-to-cycle-191-zip's §`@see` URLs to Ralph-Brown-
Interrupt-List. §Both-are-§auxiliary-information-in-comments;
cycle 191 cites external docs; cycle 195 inlines examples.

## §number-parse.js (the §strict-bigint-regex)

```js
export const parseBigint = (input = '') => {
  const trimmed = input.trim();
  if (!/^(0|[1-9][0-9]*)$/.test(trimmed)) {
    throw new Error(`Invalid number: ${input}`);
  }
  return BigInt(trimmed);
};
```

§Thirteen-lines. §The-§strict-regex `/^(0|[1-9][0-9]*)$/`
matches:

- `0` (just zero).
- `[1-9][0-9]*` (non-zero positive integer, no leading zeros).

§Rejects: §negative-numbers (no `-` allowed); §decimal-points;
§hex-prefix `0x`; §scientific-notation; §leading-zero-with-
followup (`007`); §empty-string.

§Why-strict: `BigInt('123')` succeeds; `BigInt('-123')` also
succeeds (negative bigint). §The-regex-narrows-to-non-negative-
integer-with-no-leading-zeros — the §canonical-shape for
non-negative-bigint-input.

§The-`input = ''` default makes §undefined-input behave like
empty-string. §Combined-with-the-empty-string-rejection, this
yields §a-clean-throw-on-undefined.

§Compare-to-cycle-191-zip's §assertNatNumber (also `Number
.isSafeInteger + non-negative` check). §Both-are-§validate-
the-canonical-integer-shape patterns; cycle 191 validates
JS-number; cycle 195 parses-from-string-then-validates.

§Tier-1-borrowing: §parseBigint-with-strict-regex for any
§CLI-argument that must be a §non-negative-integer (no
leading zeros, no decimals, no signs).

## §random.js (the §confirmed-design-implementation-gap)

```js
import { encodeHex } from '@endo/hex';
import crypto from 'crypto';

export const randomHex16 = () =>
  new Promise((resolve, reject) =>
    crypto.randomBytes(16, (err, bytes) => {
      if (err) {
        reject(err);
      } else {
        resolve(encodeHex(bytes));
      }
    }),
  );
```

§Thirteen-lines. §Generates-a-32-character-hex-string-from-
16-random-bytes.

§The-§Node-callback-style of `crypto.randomBytes(n, callback)`
wrapped in a `Promise` constructor. §Could-have-used `crypto
.promises.randomBytes` but uses the §legacy-callback-form.

§Why-`encodeHex(bytes)`-and-not-`bytes.toString('hex')`:
§the-policy-routing-all-hex-through-@endo/hex (per cycle 180
design). §The-design-predicted-this-would-NOT-be-done at
boundary sites; §the-implementation-did-it-anyway. §Confirmed-
twice (this cycle + cycle 185).

§Tier-1-borrowing: §promise-wrap-Node-callback-API for a
§cleaner-async-surface. §The-`new Promise(...)` constructor
form is fine for §single-shot-async-operations like
randomBytes.

§The-`16-bytes = 128-bits = 32-hex-chars` is enough for §a-
session-token or §a-nonce. §Less-than-cycle-49-daemon-locator-
terminology's §256-bit-identifier-width (which uses 32 bytes).

## §prompt.js (the §interactive-readline-prompt)

```js
import { stdin, stdout } from 'process';
import readline from 'readline';

export async function prompt(question) {
  const rl = readline.createInterface({
    input: stdin,
    output: stdout,
  });

  return new Promise(resolve => {
    rl.question(`${question}\n`, answer => {
      rl.close();
      resolve(answer.trim().toLowerCase());
    });
  });
}
```

§Twenty-three-lines (with JSDoc). §Three-step-flow: create
readline-interface + ask-question + resolve-with-trimmed-
lowercase-answer.

§The-§trim-and-toLowerCase post-processing is for §case-
insensitive-CLI-confirmation prompts. §A-user-types-"Y" or
"y" or "yes" or "Yes"; the consumer sees `"y"` or `"yes"`.

§The-`rl.close()` inside the callback is §single-shot-cleanup:
this `prompt` function is for §one-question-then-close. §Not-
for-a-multi-question-interactive-session.

§Compare-to-cycle-187-shim's §three-purpose-prepare-module
which integrates lockdown + env + AVA. §Both-are-§one-call-
multiple-effects helpers; cycle 187's is module-wide, cycle
195's is per-call.

§Compare-to-cycle-185-check-bundle's §await-null-at-function-
start (§async-rejection-discipline). §Cycle-195-prompt also
uses `new Promise` constructor — but doesn't need `await null`
because the only throws happen inside the readline callback
which is already in microtask context.

§Tier-1-borrowing: §async-readline-prompt with §trim-and-
toLowerCase-discipline for any §case-insensitive-CLI-
confirmation surface.

## §The-§six-file-cluster-cohesion (one-purpose-per-file)

§Six-files-each-with-one-purpose. §No-file-imports-another
in the cluster. §Each-file-is-imported-individually by the
CLI's command modules (under `commands/`).

§Compare-to-cycle-187-shim-cluster which §three-package-spans
(eventual-send + promise-kit + ses-ava) with §nine-files.
§Cycle-195-is-§one-package-six-files. §Different-scope; same
§single-responsibility-per-file discipline.

§Compare-to-cycle-191-zip-src-cluster which had §eight-files
(of 11) with §interlocking-dependencies (BufferReader
imported by reader, etc.). §Cycle-195-cli-utility-cluster
has §no-internal-dependencies — flat utility helpers.

§Tier-1-borrowing: §one-purpose-per-file-with-no-internal-
dependencies for §CLI-utility-clusters where the helpers
are §independently-importable.

## §The-§absence-of-tests (in this cluster)

§None-of-these-six-files have adjacent test files in this
ingest. §The-CLI-utilities-are-tested-via-the-CLI-itself
(integration tests of the `endo` commands).

§Compare-to-cycle-185-check-bundle which has its own test
file. §Cycle-195-cli-utilities are §implicitly-tested-by-
the-CLI-commands that use them.

§The-§example-comments-in-source (message-parse.js) might
be the §closest-thing-to-a-test these utilities ship. §A-
contributor-would-uncomment-and-run-Node to verify behavior
during development.

## §Cohesion notes

- §Six-tight-utilities, each §one-purpose-per-file with §no-
  internal-dependencies.
- §Second-confirmation-of-the-§gap-between-design-and-
  implementation: cycle 180-hex-package's audit-table-row-32
  predicted §retained-at-boundary for `cli/src/random.js` line
  9; actual source uses `encodeHex(bytes)`. §Two-of-two-audit-
  boundary-sites have-since-been-migrated.
- §Pet-name-path-parsing with §empty-segment-rejection and
  §parseOptional-variant-pattern.
- §@-mention-format/parse-pair: §@-escape-via-backslash in
  format; §regex-with-128-char-max + §optional-edge-name in
  parse.
- §Five-properties-of-the-regex (lowercase prefix + 128 char
  max + allowed charset + optional edge + global flag).
- §Example-comments-in-source-not-tests (five console.log
  examples commented out in message-parse.js).
- §parseBigint with §strict-regex `/^(0|[1-9][0-9]*)$/` for
  non-negative integer with no leading zeros.
- §randomHex16 with §Node-callback-promise-wrap + §confirmed-
  use-of-@endo/hex despite cycle-180-design-prediction-of-
  boundary-retention.
- §Async-readline-prompt with §trim-and-toLowerCase-discipline.
- §Implicitly-tested-by-the-CLI-itself (no per-file unit
  tests in this cluster).

## §Tier-1 borrowing

- §designs-are-guides-not-contracts (§confirmed-twice now;
  verify-against-source not just against design)
- §parseOptional-variant-pattern (undefined-passthrough
  wrapper around a strict parser)
- §empty-segment-rejection in dot-delimited path-parsing
- §@-escape-via-backslash + §@-mention-regex-with-128-char-
  max (matched format/parse pair)
- §example-comments-in-source-not-tests (commented-out
  console.log examples for quick mental verification)
- §strict-regex-bigint-parser for non-negative integer input
- §promise-wrap-Node-callback-API for cleaner async surface
- §async-readline-prompt-with-trim-and-toLowerCase
- §one-purpose-per-file-with-no-internal-dependencies for
  CLI utility clusters

## §Synthesis-target

The §slot-machine-library's CLI (if any) can §borrow-this-
six-file-cluster-shape directly: §dot-delimited-pet-name-
path-parsing + §@-mention-format/parse-pair + §parseBigint +
§randomHex16 + §async-prompt. §Each-helper-is-thirteen-to-
forty-lines.

§The-§designs-are-guides-not-contracts meta-finding is now
§confirmed-twice. §Library-memory-protocol-recommendation:
when consulting an older audit-table for the current state
of a codebase, §verify-against-source not §verify-against-
design. §A-greppable-check (`grep -F 'encodeHex' src/`) is
cheaper than reading the audit and may catch §migrations-
the-audit-didn't-anticipate.
