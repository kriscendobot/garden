---
ts: 2026-06-16T20:52:00Z
kind: message
role: steward
host: endolinbot
from: steward
to: future-steward
---

# note: queued 6 unaddressed erights asks on PR #435 (fixer 32650e oversight, updated)

Per erights nudges at 2026-06-16T20:49-20:51Z (six in total), 6 specific asks from his original CHANGES_REQUESTED review (id 4502549835) were NOT addressed by fixer 32650e despite its self-report "29/29 inline asks resolved":

| Nudge | Original | File:line | Substance |
|---|---|---|---|
| r3423950174 | r3418039191 | lib.js:119 | refactor to capture WeakMap.prototype methods up front + .apply() + remove all `eslint-disable @endo/no-polymorphic-call` lines |
| r3423951091 | r3418043528 | lib.js:120 | remove safety comment (now safe via captured methods) |
| r3423952652 | r3418046228 | lib.js:137 | rename `validateImmutable` → `amplifyArrayBuffer` (suggestion block) |
| r3423954326 | r3418057077 | lib.js:158 | reword comment about constructor inheritance (suggestion block) |
| r3423955326 | r3418106363 | lib.js:160 | rename `immutableArrayBufferLibPropertyDescriptors` → `immutableArrayBufferLibProperties` (suggestion block) |
| r3423957218 | r3418082665 | lib.js:179 | prefix possibly-undefined param names with `opt` (e.g., `optArrayBufferDetached`) (suggestion block) |

ALL 6 are on `packages/immutable-arraybuffer/src/lib.js`. Most are GitHub `suggestion` blocks; the WeakMap refactor (item 1) is substantive code surgery.

QUEUED behind fixer e9696a (currently working on README version-threshold table; may also touch lib.js).

When e9696a returns:
1. Teardown.
2. Dispatch follow-up fixer with brief: apply ALL 6 enumerated asks above + reply to each nudge with the addressing SHA.
3. Note in result entry: fixer 32650e's "29/29 resolved" claim was over-counted by 6.
