---
title: Body
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "23-122 (safeV8CallSiteMethodNames + filename censors + filterFileName)"
topics: [hardened-javascript, errors, capability-security]
status: current
notes: |
  The opening section of `packages/ses/src/error/tame-v8-error-constructor.js`
  is SES's defensive response to the V8 stack-trace API's *too-much-
  information* problem. The V8 CallSite methods (documented at
  v8.dev/docs/stack-trace-api) expose useful frame information but
  also a few that leak too much (`getThis`, `getFunction`). The file
  defines an explicit *permit list* of 16 names that user-prepareFns
  may invoke; everything else is suppressed at the safeV8CallSiteFacet
  level. Separately, five filename-censor regexes drop infrastructure
  frames from *concise* stack traces — node_modules dependents, node:
  internal/, SES's own assert.js, the eventual-send shim, and ses-ava.
  These two mechanisms — permit-list on methods, censor-list on
  filenames — work together to produce stack traces useful for
  debugging without exposing channels (file paths, function bodies)
  that a malicious user-prepareFn could exploit.
parent: endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors
---

### §The 16-name CallSite method permit list

The §opening comment block names the V8 stack-trace API documentation:

> Permit names from https://v8.dev/docs/stack-trace-api
> Permiting only the names used by error-stack-shim/src/v8StackFrames callSiteToFrame to shim the error stack proposal.

The structural reading:

- **The permit list is *names from* the v8.dev documentation** — only the names V8 itself documents are eligible.
- **The list is further narrowed** to only the names *used by error-stack-shim/src/v8StackFrames* — a specific shim that implements the *Error Stack* proposal. The narrowing is by use-case: if no consumer needs a method, it's not in the list.

The 16 permitted method names with structural roles:

| Method | Role |
|---|---|
| `getTypeName` | Class name of the receiver (read-only). |
| `getFunctionName` | Name of the calling function. |
| `getMethodName` | Name when called as a method (vs. as a function). |
| `getFileName` | Source file URL. |
| `getLineNumber`, `getColumnNumber` | Source position. |
| `getEvalOrigin` | If the call is inside an `eval`, the location of the eval call. |
| `isToplevel`, `isEval`, `isNative`, `isConstructor`, `isAsync` | Five boolean predicates about the call's context. |
| `getPosition` | (Found by experiment, not in V8 docs.) |
| `getScriptNameOrSourceURL` | (Found by experiment, not in V8 docs.) |
| `toString` | Frame stringification — *TODO replace to use only permitted info*. |

The §inline comments highlight the *suppressed* methods:

```
// suppress 'getThis' definitely
'getTypeName',
// suppress 'getFunction' definitely
'getFunctionName',
...
// suppress 'isPromiseAll' for now
// suppress 'getPromiseIndex' for now
```

Three categories of suppression:

1. **`getThis` — suppressed definitely**: would expose the receiver object the function was called on. A malicious user-prepareFn could call `frame.getThis()` to obtain a reference to *any object on which any function in the stack was called* — a wildly powerful capability leak.

2. **`getFunction` — suppressed definitely**: would expose the function value itself. A malicious user-prepareFn could call `frame.getFunction()` to obtain function values from arbitrary frames, breaking closure-based encapsulation.

3. **`isPromiseAll` / `getPromiseIndex` — suppressed *for now***: less obvious channels; the *for now* note signals the suppression is conservative-by-default rather than principled-by-analysis. Future review could revisit.

The structural lesson: *the permit list is the central security artifact*. Adding a new method to it requires understanding what channel that method exposes; suppressing it is the safe default.

### §The safeV8CallSiteFacet wrapper

The §next-block comment-and-code names the cost:

> TODO this is a ridiculously expensive way to attenuate callsites. Before that matters, we should switch to a reasonable representation.

The implementation:

```js
const safeV8CallSiteFacet = callSite => {
  const methodEntry = name => {
    const method = callSite[name];
    return [name, () => apply(method, callSite, [])];
  };
  const o = fromEntries(arrayMap(safeV8CallSiteMethodNames, methodEntry));
  return create(o, {});
};
```

Structural reading:

- **For each permitted name**, capture the original method via `callSite[name]` and wrap it in an arrow `() => apply(method, callSite, [])`.
- **Build an object** with only the 16 wrapped methods as own properties.
- **Return that object via `create(o, {})`** — a fresh object with no prototype-inherited properties beyond what the permit list provides.

The *ridiculously expensive* cost: each call to `safeV8CallSiteFacet` allocates a closure per permitted method, plus an object with 16 entries. For a stack of N frames, that's *16N closures + N objects*. For a typical stack of 20-50 frames, hundreds of allocations *per error created*.

The comment acknowledges the cost honestly: *before that matters, we should switch to a reasonable representation*. The current design favors correctness (the safe minimal API surface) over efficiency. A future redesign could share a per-realm template or use a Proxy-based attenuation.

### §The five filename-censor regexes

The §next-section comments enumerate the five filename-censor regexes with rationales:

**Censor 1: `/\/node_modules\//`**

> If it has `/node_modules/` anywhere in it, on Node it is likely to be a dependent package of the current package, and so to be an infrastructure frame to be dropped from concise stack traces.

The structural reasoning: a stack frame inside a node_modules path is *almost certainly* in a dependency. The frame is not in *your* code, and the typical debugging case wants to see *your* code's stack. The censor drops these frames in *concise* mode (the default for SES errors).

**Censor 2: `/^(?:node:)?internal\//`**

> If it begins with `internal/` or `node:internal` then it is likely part of the node infrustructre itself, to be dropped from concise stack traces.

(*infrustructre* is a typo for *infrastructure*; preserved verbatim.)

The structural reasoning: Node's own internal modules (`node:internal/...`, `internal/...`) live in paths starting with these prefixes. Like node_modules frames, they are infrastructure that should not clutter the debugging view.

**Censor 3: `/\/packages\/ses\/src\/error\/assert\.js$/`**

> Frames within SES `assert.js` should be dropped from concise stack traces, as these are just steps towards creating the error object in question.

The structural reasoning: SES's `assert.js` is *the very code that wraps your assertion failure into an Error*. Its frames are *between* the assertion site and where the Error is reported — drop them so the concise stack starts at *your* assertion call.

**Censor 4: `/\/packages\/eventual-send\/src\//`**

> Frames within the `eventual-send` shim should be dropped so that concise deep stacks omit the internals of the eventual-sending mechanism causing asynchronous messages to be sent.
> Note that the eventual-send package will move from agoric-sdk to Endo, so this rule will be of general interest.

The structural reasoning: eventual-send's internals (the `E()` machinery, the HandledPromise scheduler, the turn-tracking glue) sit *between* the user code and the actual async dispatch. Like SES assert.js, these frames are *plumbing* that the user usually doesn't want to see.

The *will move from agoric-sdk to Endo* note records a *known migration in progress*. The rule is forward-compatible because the path-matching is by `packages/eventual-send/src/` which is invariant across the repo move.

**Censor 5: `/\/packages\/ses-ava\/src\/ses-ava-test\.js$/`**

> Frames within the `ses-ava` package should be dropped from concise stack traces, as they just support exposing error details to AVA.

The structural reasoning: ses-ava is the SES-compatible AVA test integration. Its frames sit *between* the test function and AVA's error reporting; drop them.

### §The filterFileName function

The five censors are combined in `FILENAME_CENSORS = [...]` and consulted by `filterFileName`:

```js
export const filterFileName = fileName => {
  if (fileName === null) {
    // Seems to suppress builtins like `Array.every (<anonymous>)`
    return false;
  }
  for (const filter of FILENAME_CENSORS) {
    if (regexpSearch(filter, fileName) !== -1) {
      return false;
    }
  }
  return true;
};
```

The structural reading:

1. **`null` fileName → return `false`**: anonymous-built-in frames (like `Array.every (<anonymous>)`) have `null` filename. The comment `// Seems to suppress builtins like Array.every (<anonymous>)` is *honest about uncertainty* — *seems to* signals the author observed this behavior in practice but didn't prove the implication.

2. **Loop through censors → return `false` on any match**: any filename matching any censor is dropped from concise stacks.

3. **Default → `true`**: filenames not matching any censor are *kept* in the concise stack.

The function is *exported only so it can be unit tested* — the comment is explicit about the export's purpose:

> Exported only so it can be unit tested.

The pattern is *export-for-testability* — internal-only functions get exported when test isolation requires it, with a comment explaining the non-API status. The pattern signals to future maintainers: *don't depend on this from outside; it's exposed only for tests*.

### §The TODO: future-work-tracked-in-comment

Two TODO notes in this section name future-work directions:

1. **`// TODO this is a ridiculously expensive way to attenuate callsites. Before that matters, we should switch to a reasonable representation.`** — the safeV8CallSiteFacet performance cost.
2. **`// TODO Enable users to configure FILENAME_CENSORS via `lockdown` options.`** — the censor list is hardcoded; future work makes it user-configurable.
3. **`// TODO Move so that it applies not just to v8.`** — the filterFileName function is in the V8-specific file but the censoring logic should apply across engines.

The three TODOs name three different forward-work-directions: *performance* (1), *configurability* (2), and *generalization-across-engines* (3). Each TODO is a *known future-work surface* the author wants future readers to consider.
