---
ts: 2026-06-16T20:48:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--e9696a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435
  - https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3423929733
---

# dispatch: fixer — add version-threshold table to README on PR #435

erights asked at `packages/immutable-arraybuffer/src/lib.js:83` (discussion `r3423929733`, 2026-06-16T20:46Z):

> @kriscendobot , Please explain in this package's README.md the version thresholds for Hermes, Node.js, v8, JSC, SpiderMonkey, Chromium, Chrome, Safari, and Firefox

This expands the earlier JSC/SpiderMonkey research (fixer 678c48's inline reply) into a full README section covering all major engines.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#435`, head `717fb12b8`.

## Task

In your `project/` worktree at `717fb12b8`:

1. Read `packages/immutable-arraybuffer/src/lib.js` around line 83 (the polyfill fallback site) AND `packages/immutable-arraybuffer/README.md` to understand the existing prose + what the version thresholds matter for.
2. Research version thresholds for both APIs the lib references (`structuredClone` and `ArrayBuffer.prototype.transfer`) across:
   - **Engine**: V8, JSC, SpiderMonkey, Hermes
   - **Runtime**: Node.js, Chrome, Chromium (the standalone), Safari, Firefox
   - Sources: MDN browser compatibility tables, V8/SpiderMonkey/JSC release notes, Node.js changelog, Hermes release notes.
3. Build a structured table in `packages/immutable-arraybuffer/README.md` with:
   - Engine/runtime as rows.
   - `structuredClone` first version + ship date as a column.
   - `ArrayBuffer.prototype.transfer` first version + ship date as a column.
   - A "Notes" column for engine-specific caveats (e.g., Hermes: ship status, Node.js: align to LTS support window).
4. Add prose context around the table explaining what the polyfill fallback at `lib.js:83` is defending against (which engine x version combinations need it).
5. If the data shows the fallback is dead code on the project's stated support floor, note that explicitly and recommend a follow-up to drop the fallback.
6. Commit: `docs(immutable-arraybuffer): add version-threshold table for structuredClone / ArrayBuffer.transfer support per erights review`.
7. Push to `build/immutable-arraybuffer-drop-the-pseudo-prototype` (append only).
8. Reply on discussion `r3423929733` with link to the new README section + SHA.

## Authorizations

- Append-push.
- Inline reply.
- Do NOT touch upstream endojs/endo.

## Out of scope

- Do NOT re-open prior asks.

## Deliverable

A `result` entry naming:

- The version data gathered (per engine).
- Whether the polyfill fallback is dead code on the stated floor.
- Commit SHA.
- Inline reply URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (erights re-reviews).

End your turn with a concise summary back to the orchestrator. 15-25 min job given the research scope.
