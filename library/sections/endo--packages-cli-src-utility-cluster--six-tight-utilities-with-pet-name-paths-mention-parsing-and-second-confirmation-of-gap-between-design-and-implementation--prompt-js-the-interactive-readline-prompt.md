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
title: §prompt.js (the §interactive-readline-prompt)
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

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
