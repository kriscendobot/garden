---
source: packages/init + packages/lockdown (entry-point files)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/init
source_path: packages/init/*.js, packages/lockdown/*.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - getting-started
genre: §endo-source-comment-fragment §canonical-bootstrap-pattern
cycle: 183
lane: chat
status: current
title: §The-LOCKDOWN_OPTIONS-sniff (the pragmatic escape hatch)
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

```js
let optionsString;
if (typeof LOCKDOWN_OPTIONS === 'string') {
  optionsString = LOCKDOWN_OPTIONS;
  console.warn(
    `'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' global variable\n`,
  );
} else if (
  typeof process === 'object' &&
  typeof process.env.LOCKDOWN_OPTIONS === 'string'
) {
  optionsString = process.env.LOCKDOWN_OPTIONS;
  console.warn(...);
}
```

§Two-source-priority: global variable first; environment
variable second. §Both-warn-via-console-when-detected — §sniffing-
is-acknowledged-not-hidden.

§The-design-justification-is-explicit (lines 35-47):

> The `init` module exists so the "main" of production code
> can start with the following import or its equivalent:
> `import '@endo/init';`
> But production code must also be tested. Normal ocap
> discipline of passing explicit arguments into the `lockdown`
> call would require an awkward structuring of start modules,
> since the `init` module calls `lockdown` during its
> initialization, before any explicit code in the start module
> gets to run.
>
> Instead, for now, `init` violates normal ocap discipline by
> feature testing global state for a passed "parameter". This
> is something that a module can but normally should not do,
> during initialization or otherwise. Initialization is often
> awkward.

§"Initialization-is-often-awkward" is the §honest-confession
disciplinary anchor. §The-design-names-the-violation-instead-of-
hiding-it.

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §revised-
scope-discussion-2026-04-15 and cycle 180-hex-package's §design-
phase-after-implementation-phase. §All-three-are-§honest-
admission-against-the-ideal-process patterns. §The-init-package
is the oldest in this family — the §awkward-initialization
violation has been documented in-source for years.

§JSON-error-handling-on-the-sniffed-value:

```js
if (typeof optionsString === 'string') {
  let options;
  try {
    options = JSON.parse(optionsString);
  } catch (err) {
    console.error('Environment variable LOCKDOWN_OPTIONS must be JSON', err);
    throw err;
  }
  if (typeof options !== 'object' || Array.isArray(options)) {
    const err = TypeError(
      'Environment variable LOCKDOWN_OPTIONS must be a JSON object',
    );
    console.error('', err, options);
    throw err;
  }
  rawLockdown({
    ...options,
    domainTaming: 'unsafe',
  });
}
```

§Three-validation-layers: JSON-parse + type-object + not-array.
§The-error-shape includes the offending value for diagnostic
purposes. §Cycle-177-netstring/reader.js' §four-pieces-of-
context-per-error sibling: §multiple-error-paths-with-named-
shape.
