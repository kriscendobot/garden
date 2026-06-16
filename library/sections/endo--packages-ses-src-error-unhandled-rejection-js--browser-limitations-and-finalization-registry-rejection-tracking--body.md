---
title: Body
source: packages/ses/src/error/unhandled-rejection.js
source_repo: endojs/endo
source_branch: master
source_commit: dae7235011da907823c27ca5dfb9ed72519a4062
source_date: 2022-09-16
source_authors: [Mathieu Hofman]
source_lines: "1-122 (full file: browser-limitations preamble + makeRejectionHandlers factory + state + FinalizationRegistry wiring + three handlers)"
topics: [hardened-javascript, errors]
status: current
notes: |
  Twelfth comment-fragment ingest. Mathieu Hofman-authored
  rejection-tracking machinery — *the* SES file that lets Node-and-
  browser SES embeddings detect unhandled promise rejections via
  GC-driven finalization rather than just the platform's
  `unhandledrejection` event (which browsers withhold in
  cross-origin/console/debugger contexts). The 122-line file is
  honestly one cohesive argument-cluster — a single rejection-
  tracking-machinery factory — and decomposes as a single-section
  ingest like cycle-95 chat-rename-dismiss-to-clear (75-line
  single-section). Three structural ideas: (1) the *browser-prevent-
  access* limitations frame the design — the platform's event API
  is insufficient, so the machinery uses `FinalizationRegistry` as
  an *unhandled-and-no-longer-reachable* alternative; (2) the
  triple-bookkeeping state (id-to-reason Map + promise-to-id
  WeakMap + FinalizationRegistry) is the *three-key-lookup* design;
  (3) the three-handler split (unhandled / handled-after-the-fact /
  process-termination) plus the *empty-pool cancel-checking* idiom
  for *no-work-no-timer* discipline.
parent: endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking
---

### §The browser-prevent-access framing

The §opening JSDoc block (lines 16-33) frames the entire module's *raison d'être*:

> Note that modern browsers *prevent* access to the `unhandledrejection` and `rejectionhandled` events needed:
> - in cross-origin mode, like when served from `file://`
> - in the browser console (interactively typed-in code)
> - in the debugger
>
> Then, they just look like: `Uncaught (in promise) Error: ...` and don't implement the machinery.

The §three-context enumeration is structurally significant:

- **`file://` cross-origin** — the *no-origin* origin is treated as cross-origin by modern browsers; security policies that gate the rejection events default to *withhold*.
- **Browser console** — code typed interactively into the dev-console doesn't see the events. The browser's debugger ownership precludes them.
- **Debugger** — when stepping through code, the rejection events are suppressed.

The §workaround prescription:

> The solution is to serve your web page from an `http://` or `https://` web server and execute actual code.

The §discipline: the module *cannot* fix the platform's withholding; it can only *document* that a developer hitting `Uncaught (in promise) Error: ...` should suspect the environment, not the SES module. The §honest-platform-limitation comment is the *failure-mode-attribution* discipline — by documenting *when this doesn't work*, the module saves debugging time for users who would otherwise blame SES.

The §contrast with cycle 96's `console.js` *no-special-privilege* framing: that file's opening axiom is about *what the module deliberately doesn't reference*; this file's opening axiom is about *what the platform deliberately doesn't expose*. The two are dual — *we don't use ambient authority* vs *platform doesn't give us ambient authority*.

### §The `makeRejectionHandlers` factory shape

The §function signature (line 34):

```js
export const makeRejectionHandlers = reportReason => {
  if (FinalizationRegistry === undefined) {
    return undefined;
  }
  // ... rest of factory ...
};
```

The §two-branch return:

- **No `FinalizationRegistry`** — return `undefined`. The §discipline: the host that calls `makeRejectionHandlers(reportReason)` must handle the undefined case (and presumably skip rejection tracking on that engine). The factory does *not* construct a degraded handler that just listens to platform events; it returns nothing so the host knows the capability is *unavailable*.
- **`FinalizationRegistry` present** — return the three-handler bag.

The §design intent: *fail-loud-not-degrade*. A host that needs the GC-driven detection cannot pretend to have it on engines without `FinalizationRegistry`. The undefined return is the honest signal.

The §`reportReason: (reason: unknown) => void` parameter is the *injectable side-effect* — the host provides the callback that gets invoked for each *unhandled-and-no-longer-reachable* rejection. The module does *not* know whether to log, throw, panic, or telemetry-emit; the host decides.

### §The triple-bookkeeping state

The §three state members serve three distinct lookup directions:

- **`idToReason: Map<ReasonId, unknown>`** — *ReasonId → reason* (the strong record).
- **`promiseToReasonId: WeakMap<Promise, ReasonId>`** — *Promise → ReasonId* (the weak back-reference).
- **`FinalizationRegistry<ReasonId>`** registered with each promise — invokes `finalizeDroppedPromise(reasonId)` when the promise is GC'd.

The §design intent:

- The `idToReason` Map is *strong* because the reason value must survive until either: (a) a handler is attached after-the-fact (rejectionHandledHandler removes the entry); (b) the promise is GC'd (FinalizationRegistry callback removes the entry and reports); (c) the process terminates (processTerminationHandler flushes all).
- The `promiseToReasonId` WeakMap is *weak* on the promise key so the promise itself can be GC'd without the WeakMap holding a strong reference back. The WeakMap is the *handler-attached-after-the-fact* lookup path — when `rejectionHandledHandler(pr)` arrives, we need to find the ReasonId.
- The FinalizationRegistry is the *third* observer — it watches *the promise* and fires when the promise's reachability ends.

The §three keys (Map-by-id + WeakMap-by-promise + FinalizationRegistry-on-promise) are kept in sync via `unhandledRejectionHandler`'s three-write commit (lines 88-90) and `removeReasonId`'s sole-key-drop (the WeakMap entry is left to be GC'd along with the promise; the FinalizationRegistry registration is left in place but a no-op once the ReasonId is removed from idToReason).

### §The `cancelChecking` empty-pool-cancel idiom

The §`cancelChecking` thunk (lines 45-46):

```js
/** @type {(() => void) | undefined} */
let cancelChecking;
```

The §`removeReasonId` (lines 48-55):

```js
const removeReasonId = reasonId => {
  mapDelete(idToReason, reasonId);
  if (cancelChecking && idToReason.size === 0) {
    // No more unhandled rejections to check, just cancel the check.
    cancelChecking();
    cancelChecking = undefined;
  }
};
```

The §discipline: a host may set `cancelChecking` to a thunk that *cancels a periodic check timer*. When the unhandled-rejection pool drains to zero, the timer is no longer needed; calling `cancelChecking()` lets the host stop the timer until a new unhandled rejection arrives.

The §honest gap: the module's exports (lines 117-121) do *not* surface a way for the host to *set* `cancelChecking`. As of this commit, the variable is declared and read but never written within the module. The §intended-usage-pattern (inferred from the variable's presence) is that some later patch exposes a setter or the host wires it in through SES's larger integration. The §discipline: the variable is *defensively present* so the cleanup code is in place if/when the setter lands.

The §empty-pool-cancel pattern is reusable for any *background-task-with-no-work-no-timer* discipline: the task starts the timer only when work arrives; cancels it when the queue drains; restarts on next arrival.

### §The `finalizeDroppedPromise` GC-driven detection

The §GC-finalization callback (lines 65-71):

```js
const finalizeDroppedPromise = heldReasonId => {
  if (mapHas(idToReason, heldReasonId)) {
    const reason = mapGet(idToReason, heldReasonId);
    removeReasonId(heldReasonId);
    reportReason(reason);
  }
};
```

The §detection condition:

- **The promise has been GC'd** (because FinalizationRegistry invoked the callback).
- **The ReasonId is still in the Map** (i.e., the rejection was not handled after-the-fact — `rejectionHandledHandler` would have removed it).

When both are true: the rejection was *unhandled-and-no-longer-reachable*. No code holds a reference to the promise anymore, so no code can attach a handler in the future. The rejection is *definitively unhandled*. Report it.

The §`mapHas`-check is *the* discriminator. Without it, every GC'd promise — handled or not — would be reported. The check distinguishes:

- **Promise GC'd while handled** (rejection-handled-handler already ran) → no entry → skip.
- **Promise GC'd while unhandled** (no handler ever attached) → entry exists → report.

The §timing observation: the GC-finalization fires *after* the promise is unreachable but at the engine's leisure. A long-lived application may accumulate unhandled rejections for some time before GC runs. The §`processTerminationHandler` is the *fallback flush* for that case — see below.

### §The three platform-event handlers

The §`unhandledRejectionHandler(reason, pr)` (lines 83-91):

```js
const unhandledRejectionHandler = (reason, pr) => {
  lastReasonId += 1;
  const reasonId = lastReasonId;

  // Update bookkeeping.
  mapSet(idToReason, reasonId, reason);
  weakmapSet(promiseToReasonId, pr, reasonId);
  finalizationRegistryRegister(promiseToReason, pr, reasonId, pr);
};
```

The §entry path. The host wires this to platform events:

- Node: `process.on('unhandledRejection', unhandledRejectionHandler)`.
- Browser: `window.addEventListener('unhandledrejection', evt => unhandledRejectionHandler(evt.reason, evt.promise))`.

The §three-write commit:

- **`mapSet(idToReason, reasonId, reason)`** — strong record.
- **`weakmapSet(promiseToReasonId, pr, reasonId)`** — weak back-reference.
- **`finalizationRegistryRegister(promiseToReason, pr, reasonId, pr)`** — register for GC-callback.

The §fourth argument to `finalizationRegistryRegister` is the *unregister token*; using `pr` as both the registration target and the unregister token is the discipline: *if the registration ever needs to be torn down explicitly, the promise itself is the token*. As of this commit, no `unregister` call exists in this file — the unregister token is *defensively present* for future use.

The §`rejectionHandledHandler(pr)` (lines 101-104):

```js
const rejectionHandledHandler = pr => {
  const reasonId = weakmapGet(promiseToReasonId, pr);
  removeReasonId(reasonId);
};
```

The §two-line discipline. When a handler is attached to a previously-rejected promise (Node `process.on('rejectionHandled')`; browser `'rejectionhandled'`), look up the ReasonId in the WeakMap and remove it from the strong Map.

The §honest no-check-needed pattern: `removeReasonId(undefined)` doesn't error because `mapDelete(idToReason, undefined)` is a no-op (the Map never has `undefined` as a key under this module's discipline). The §`weakmapGet` returns `undefined` for unregistered promises, so the no-op path is the *defensive fallback*.

The §JSDoc reasoning (lines 94-99):

> Deal with the addition of a handler to a previously rejected promise.
>
> Just remove it from our list. Let the FinalizationRegistry or processTermination report any GCed unhandled rejected promises.

The §division-of-responsibility: this handler is for the *was-unhandled-but-now-is* transition. The FinalizationRegistry handles the *was-unhandled-and-promise-GC'd* transition. The processTermination handler handles the *was-unhandled-and-process-exiting* transition.

The §`processTerminationHandler` (lines 110-115):

```js
const processTerminationHandler = () => {
  for (const [reasonId, reason] of mapEntries(idToReason)) {
    removeReasonId(reasonId);
    reportReason(reason);
  }
};
```

The §at-exit flush. When the agent cluster terminates (Node `process.on('beforeExit')`; browser doesn't really have an analog — the close event is too brief), iterate every still-pending unhandled rejection and report it. The §rationale (lines 106-109):

> Report all the unhandled rejections, now that we are abruptly terminating the agent cluster.

The §discipline: don't let unhandled rejections silently vanish when the process exits. If the process exits before the GC has run on still-rejected-but-now-unreachable promises, the FinalizationRegistry never fires; this handler catches that case.

### §The mutation-during-iteration safety

The §`processTerminationHandler` iterates `mapEntries(idToReason)` while calling `removeReasonId(reasonId)` which mutates `idToReason`. This works because:

- `mapEntries` returns an iterator that, on V8 and SpiderMonkey, accepts in-place deletion of *visited* entries without invalidating the iteration.
- The iteration order is insertion order, and deletion of the current key advances to the next still-present key.

The §discipline: the JavaScript spec defines `Map.prototype.entries` to handle deletion of the current key safely. This is *unusual* — most iterator-during-mutation patterns are unsafe — and the file *relies* on this guarantee without commenting on it.

The §alternative would be to first collect all entries into an array, *then* iterate the array while deleting from the map. The §choice not to is a micro-optimization: the iterator-with-delete pattern is allowed by spec and avoids the intermediate array allocation.
