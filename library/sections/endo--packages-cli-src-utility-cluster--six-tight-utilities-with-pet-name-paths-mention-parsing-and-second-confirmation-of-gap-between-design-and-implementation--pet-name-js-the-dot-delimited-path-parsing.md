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
title: §pet-name.js (the §dot-delimited-path-parsing)
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

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
