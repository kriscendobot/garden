---
title: Example Usage
source: packages/trampoline/README.md
source_repo: endojs/endo
source_commit: 4406f5dd
source_date: 2024-04-30
source_authors: [Christopher Hiller]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
---

> Abstract: Worked example showing trampoline composing a recursive coroutine without consuming the call stack. The substantial body of the README.

## Example Usage

```js
import { asyncTrampoline, syncTrampoline } from '@endo/trampoline';

/**
 * This function "reads a file synchronously" and returns "a list of its imports"
 *
 * @param {string} filepath Source file path
 * @returns {string[]} List of imports found in source
 */
const findImportsSync = filepath => {
  // read a file, parse it for imports, return a list of import specifiers
  // (synchronously)
  // ...
};

/**
 * This function "reads a file asynchronously" and returns "a list of its imports"
 *
 * @param {string} filepath Source file path
 * @returns {Promise<string[]>} List of imports found in source
 */
const findImportsAsync = async filepath => {
  // read a file, parse it for imports, return a list of import specifiers
  // (asynchronously)
  // ...
};

/**
 * Recursively crawls a dependency tree to find all dependencies
 *
 * @template {string[] | Promise<string[]>} TResult Type of result (list of imports)
 * @param {(filepath: string) => TResult} finder Function which reads a file and returns its imports
 * @param {string} filename File to start from; entry point
 * @returns {Generator<TResult, string[], string[]>} Generator yielding list of imports
 */
function* findAllImports(finder, filename) {
  // it doesn't matter if finder is sync or async!
  let specifiers = yield finder(filename);

  // pretend there's some de-duping, caching,
  // scrubbing, etc. happening here

  for (const specifier of specifiers) {
    // it's okay to be recursive
    specifiers = [...specifiers, ...(yield* findAllImports(finder, specifier))];
  }
  return specifiers;
}

// results are an array of all imports found in some.js' dependency tree
const asyncResult = await asyncTrampoline(
  findAllImports,
  findImports,
  './some.js',
);

// same thing, but synchronously
const syncResult = syncTrampoline(
  findAllImports,
  findImportsAsync,
  './some.js',
);

asyncResult === syncResult; // true
```

In the above example, **@endo/trampoline** allows us to re-use the operations in `loadRecursive()` for _both_ sync and async execution. An implementation _without_ **@endo/trampoline** would need to duplicate the operations into two (2) discrete recursive functions—a synchronous-colored function and an asynchronous-colored function. Over time, this situation commonly leads to diverging implementations. If that _doesn't_ sound like a big deal for _whatever you're trying to do here_, then you probably don't need **@endo/trampoline**.


Source: [packages/trampoline/README.md](https://github.com/endojs/endo/blob/4406f5dd/packages/trampoline/README.md) at commit `4406f5dd`.
