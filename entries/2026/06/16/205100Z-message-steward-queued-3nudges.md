---
ts: 2026-06-16T20:51:00Z
kind: message
role: steward
host: endolinbot
from: steward
to: future-steward
---

# note: queued 3 unaddressed erights asks on PR #435 (fixer 32650e oversight)

Per erights nudges at 2026-06-16T20:49-20:50Z (r3423950174, r3423951091, r3423952652), 3 specific asks from his original CHANGES_REQUESTED review (id 4502549835) were NOT addressed by fixer 32650e despite its self-report "29/29 inline asks resolved":

1. **r3418039191** at `packages/immutable-arraybuffer/src/lib.js:119`: refactor to capture WeakMap.prototype methods up front + use with .apply() below + REMOVE all `// eslint-disable-next-line @endo/no-polymorphic-call` lines.
2. **r3418043528** at `packages/immutable-arraybuffer/src/lib.js:120`: remove safety comment since we now use captured methods.
3. **r3418046228** at `packages/immutable-arraybuffer/src/lib.js:137`: rename to `amplifyArrayBuffer` (suggestion block) since no longer error to provide genuine ArrayBuffer.

QUEUED behind fixer e9696a (currently working on README version-threshold table; may overlap with lib.js edits if it determines the fallback is dead code).

When e9696a returns:
1. Teardown.
2. Dispatch follow-up fixer with brief: address the 3 enumerated asks above. Reference erights' nudges + originals.
3. Note in result entry: fixer 32650e's "29/29 resolved" was over-counted; 3 asks slipped through.

References:
- Nudges: pull/435#discussion_r3423950174, pull/435#discussion_r3423951091, pull/435#discussion_r3423952652
- Originals: pull/435#discussion_r3418039191, pull/435#discussion_r3418043528, pull/435#discussion_r3418046228
