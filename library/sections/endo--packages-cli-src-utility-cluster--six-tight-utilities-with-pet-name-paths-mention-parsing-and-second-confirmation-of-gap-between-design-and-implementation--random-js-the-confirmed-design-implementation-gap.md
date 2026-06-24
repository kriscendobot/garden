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
title: §random.js (the §confirmed-design-implementation-gap)
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

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
