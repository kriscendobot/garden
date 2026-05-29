---
title: The 16-name V8 call-site method allowlist (suppressing `getThis`, `getFunction`, `isPromiseAll`, `getPromiseIndex`); the five filename-censor regexes that drop infrastructure frames from concise stack traces (node_modules / node-internals / SES assert.js / eventual-send / ses-ava); the `filterFileName` function that consults the censor list; the TODO-this-is-ridiculously-expensive admission about the per-call attenuation cost
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
---

## Abstract

The §opening cluster of `tame-v8-error-constructor.js` establishes the *two-layer attenuation* of the V8 stack-trace API. **Layer 1: the 16-name CallSite method permit list** — `safeV8CallSiteMethodNames` enumerates exactly the methods a user-prepareFn may invoke through the *safeV8CallSiteFacet* wrapper: `getTypeName`, `getFunctionName`, `getMethodName`, `getFileName`, `getLineNumber`, `getColumnNumber`, `getEvalOrigin`, `isToplevel`, `isEval`, `isNative`, `isConstructor`, `isAsync`, plus two by-experiment-found names not in the V8 spec (`getPosition`, `getScriptNameOrSourceURL`), and `toString` (with a *TODO replace to use only permitted info* note). Explicitly *suppressed*: `getThis` (would expose the receiver object), `getFunction` (would expose the function value itself), `isPromiseAll` (suppressed for now), `getPromiseIndex` (suppressed for now). The list's authors document the cost: *TODO this is a ridiculously expensive way to attenuate callsites. Before that matters, we should switch to a reasonable representation.* — a candid admission that the per-frame proxy-creation overhead is high but acceptable until a redesign. **Layer 2: the five filename-censor regexes** that drop infrastructure frames from concise stack traces: (1) `/\/node_modules\//` — frames in dependent packages on Node are usually infrastructure; (2) `/^(?:node:)?internal\//` — Node's own internals; (3) `/\/packages\/ses\/src\/error\/assert\.js$/` — SES's `assert.js`, the *steps towards creating the error object in question*; (4) `/\/packages\/eventual-send\/src\//` — the eventual-send shim, *deep stacks omit the internals of the eventual-sending mechanism causing asynchronous messages to be sent* (and the comment notes the package's planned migration from agoric-sdk to Endo); (5) `/\/packages\/ses-ava\/src\/ses-ava-test\.js$/` — the ses-ava test infrastructure. The `filterFileName(fileName)` function returns `false` for any frame whose `fileName` matches any of the five censor patterns or is `null` (which suppresses anonymous-builtin frames like `Array.every (<anonymous>)`). The `// TODO Enable users to configure FILENAME_CENSORS via `lockdown` options.` comment names a *known future-work direction*: today the censor list is hardcoded; tomorrow it should be user-configurable.

## Body

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

## Connection to the wider library

This section is the **canonical worked example of *attenuating-the-V8-stack-trace-API channel at the SES layer***. Three threads:

1. **The permit-list-for-CallSite-methods discipline** is reusable for any *capability-narrowing wrapper* around a richer host API. Generalizes to: *enumerate the names you allow; suppress everything else; wrap each allowed name in a closure that calls the original under controlled-this-binding*.

2. **The filename-censor pattern is reusable for any *frame-filtering* concern**: identify the categories of frames that are infrastructure (not user code); express them as regexes; consult the list in the filter. Generalizes to logging filters, profiler frame attribution, etc.

3. **The TODO-in-comment as future-work-marker** is a corpus-wide discipline. The library can cite this section whenever a design needs to *record known future-work without blocking current implementation*.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Permit list (allowlist) of CallSite methods | Standard capability-attenuation pattern; *positive spec* on the allowed surface. |
| `suppress 'getThis' definitely` | The two-tier suppression labeling: *definitely* (deep semantic reason) vs *for now* (conservative-by-default). |
| `TODO this is a ridiculously expensive way` | Honest cost-disclosure as TODO; signals future-redesign without blocking. |
| Five filename-censor regexes | Frame-filtering by source-path heuristic. |
| `Note that the eventual-send package will move from agoric-sdk to Endo` | In-comment future-work note for a known monorepo migration. |
| `Exported only so it can be unit tested.` | The export-for-testability pattern; signals non-API status. |
| `Seems to suppress builtins like Array.every (<anonymous>)` | Honest-uncertainty comment style; the author's observation is documented even when not proved. |
| `TODO Enable users to configure FILENAME_CENSORS via lockdown options.` | Configurability future-work direction. |
| `TODO Move so that it applies not just to v8.` | Generalization-across-engines future-work direction. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate. tame-v8-error-constructor.js is one of SES's V8-specific taming files.
- [[errors]] (topic) — the broader SES error-handling surface.
- [[capability-security]] (topic) — the permit-list-for-CallSite-methods is the canonical capability-attenuation pattern at the V8-stack-API layer.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` (cycle 87) — the *complementary* pass-style-layer V8-stack-accessor work: the pass-style side repairs the *accessor*; the SES side (this file) attenuates the *method-call surface*. Both handle V8-specific stack-trace channels.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the causal-console module that the eventual-send shim feeds, instrumented with turn-and-event labels. The censor list keeps eventual-send frames out of concise stacks, but track-turns adds *causal* annotations that survive.
- `endo--packages-marshal-src-marshal-js--error-diagnostic-priority` (cycle 74) — the marshal-side complement: why the stack is deliberately not put on the wire. The wire-side and the local-stack-side handle different channels of the same stack-trace security concern.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns` — the next section in this source: the four regex patterns that shorten kept callsite strings.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns` — the third section: how the tameV8ErrorConstructor function wires together attenuation + system-vs-user prepareFn distinction.

## Common confusions

- **"The permit list is too restrictive — what if a user-prepareFn needs `getThis`?"** That is *precisely the point*. A user-prepareFn that needs `getThis` is reaching for a capability that should not be exposed to user code under the SES discipline. The library's design favors *suppress-by-default*; if a use case emerges that justifies adding `getThis`, the addition would require a security review.
- **"The TODO 'ridiculously expensive' suggests the file is broken."** It is not broken; it is *correctly slow*. The implementation is honest about the trade-off: correctness now, performance redesign later. Until error-creation rates make the cost matter, the simple design is acceptable.
- **"The eventual-send censor is too aggressive — sometimes I want to debug eventual-send itself."** Then run without `concise` stack-filtering. The censor only applies to concise stacks; *verbose* stacks include all frames. The `stackFiltering` lockdown option is the user-control mechanism.
- **"The `null` fileName check is fragile."** It works in practice for V8's anonymous-builtin frames. The comment `// Seems to suppress` is honest about the empirical-rather-than-formal basis. If V8 changes, this could need adjustment — but that's a known sensitivity, not a hidden bug.
- **"The five censors should be in a configuration file, not hardcoded."** The `TODO Enable users to configure FILENAME_CENSORS via lockdown options` records that future direction. Until configurability lands, the hardcoded list serves the common case (Node + SES + eventual-send + ses-ava).
- **"`getPosition` and `getScriptNameOrSourceURL` are *Additional names found by experiment* — that's sketchy."** The comment is honest about the discovery method. V8's stack-trace API has some undocumented surface that proves useful in practice; the file documents what was found *and* what is officially in the V8 docs. This is *honesty-about-the-API-frontier* discipline.
