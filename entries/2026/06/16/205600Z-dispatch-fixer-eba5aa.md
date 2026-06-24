---
ts: 2026-06-16T20:56:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--eba5aa
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/16/205200Z-message-steward-queued-6nudges-updated.md
---

# dispatch: fixer — apply 7 unaddressed erights asks on PR #435 lib.js (fixer 32650e oversight)

erights posted 7 nudges between 2026-06-16T20:49Z and 20:53Z, each "please do this, or ask a question if you do not understand" on inline asks from his original CHANGES_REQUESTED review (id 4502549835) that fixer 32650e claimed addressed but actually missed.

## The 7 unaddressed asks (all in `packages/immutable-arraybuffer/src/lib.js`)

| Nudge | Original | File:line | Substance |
|---|---|---|---|
| r3423950174 | r3418039191 | lib.js:119 | refactor: capture `WeakMap.prototype` methods up front + `.apply()` + REMOVE all `// eslint-disable-next-line @endo/no-polymorphic-call` lines (refer to erights' PR on master) |
| r3423951091 | r3418043528 | lib.js:120 | remove safety comment (now safe via captured methods) |
| r3423952652 | r3418046228 | lib.js:137 | rename to `amplifyArrayBuffer` (suggestion block) since no longer error to provide a genuine ArrayBuffer |
| r3423954326 | r3418057077 | lib.js:158 | reword constructor inheritance comment (suggestion block) |
| r3423955326 | r3418106363 | lib.js:160 | rename to `immutableArrayBufferLibProperties` (suggestion block) |
| r3423957218 | r3418082665 | lib.js:179 | prefix possibly-undefined param names with `opt` (e.g., `optArrayBufferDetached`) (suggestion block) |
| r3423965637 | (?) | lib.js:304-305 | "This now applies to line 304-305 below. Please do this, or ask a question." (follow-up to a prior ask — read the in_reply_to_id chain) |

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#435`, head `82b8fa90f`.

## Task

In your `project/` worktree at `82b8fa90f`:

1. For EACH ask above:
   - Read the current code at the cited file:line.
   - Apply the requested change (if a suggestion block, apply the literal text).
   - For the WeakMap refactor (#1), this is substantive: capture `WeakMap.prototype.get`, `WeakMap.prototype.set`, `WeakMap.prototype.has` (and whatever else is used) at top of module, use `.apply()` patterns instead of method calls, and remove ALL `// eslint-disable-next-line @endo/no-polymorphic-call` comments.
   - For #7 (r3423965637): fetch the original comment by following its `in_reply_to_id` chain via `gh api /repos/endojs/endo-but-for-bots/pulls/comments/3423965637` to see the substance.
2. Run `corepack yarn workspace @endo/immutable-arraybuffer test` to confirm tests still pass.
3. Run pre-push-gates.
4. Commit per logical group:
   - One substantive commit for the WeakMap refactor.
   - One commit for the renames + comment updates (or per-ask if the maintainer's style prefers granularity).
5. Push to `build/immutable-arraybuffer-drop-the-pseudo-prototype` (append only).
6. Reply on each of the 7 nudge threads (r3423950174, r3423951091, r3423952652, r3423954326, r3423955326, r3423957218, r3423965637) with the addressing SHA.
7. Post a top-level comment on PR #435 at-mentioning @erights AND @kriskowal:
   - Per-ask resolution table (the 7).
   - Acknowledge fixer 32650e's overcounting.
   - Commit SHAs.

## Authorizations

- Append-push.
- Inline replies on 7 review threads.
- Top-level comment.
- Do NOT touch upstream endojs/endo.

## Out of scope

- Do NOT re-open prior addressed asks.
- Do NOT touch the README version-table (fixer e9696a's just-landed work).

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Per-ask resolution mapping (cite each commit SHA + which ask it addresses).
- Test results.
- pre-push-gates result.
- 7 inline reply URLs + top-level comment URL.
- A `Self-improvement: ...` line (in particular: how did 32650e overcount? read its result entry briefly for the gap).
- **Recommended next stage**: `next: liaison` (erights re-reviews).

End your turn with a concise summary back to the orchestrator.
