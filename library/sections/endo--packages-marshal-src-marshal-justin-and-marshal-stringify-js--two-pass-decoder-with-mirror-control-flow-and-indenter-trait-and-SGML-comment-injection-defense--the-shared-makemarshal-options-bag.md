---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §The-shared-makeMarshal-options-bag
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
const { serialize, unserialize } = makeMarshal(
  doNotConvertValToSlot,
  doNotConvertSlotToVal,
  {
    errorTagging: 'off',
    // TODO fix tests to works with smallcaps.
    serializeBodyFormat: 'capdata',
  },
);
```

§Two-options-pinned: §errorTagging-off (the no-slot path
doesn't need error tagging) + §serializeBodyFormat-capdata.

§The-§TODO-named: "fix tests to works with smallcaps." §The-
preferred-format-is-smallcaps (cycle 69 encodeToSmallcaps);
§the-current-tests-only-work-with-capdata. §Migration-deferred-
with-named-blocker.

§Compare-to-cycle-180-hex-package's §five-known-gaps and cycle
188-perf's §four-remaining-optimization-opportunities. §All-
three-are-§named-deferrals.
