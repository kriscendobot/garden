---
ts: 2026-06-04T04:21:09Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--bb2325
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4424448137
---

# dispatch: fixer — #417 revise spackle/permits/naming per kriskowal review 4424448137

Maintainer review `4424448137` (CHANGES_REQUESTED,
2026-06-04T04:20:13Z) — body-only review with 10 inline
comments. Substantial refactoring of the spackle, permits,
and naming.

Pre-dispatch sweep complete: 10 inline comments tied to this
review; no other unaddressed standing asks on #417.

## 10 inline asks

### Permits (5)

1. **`packages/ses/src/permits.js:1465`** (`3353294634`):
   Use `RegisteredSymbol(sliceToImmutable)` instead of the
   complex shape. erights likely to suggest just
   monkey-patching `sliceToImmutable` and `transferToImmutable`.

2. **`packages/ses/src/permits.js:1278`** (`3353301111`):
   "Avoid non-ASCII. This is in the guide. Dispatch a
   gardener to revise the driver to have deterministic
   automation to keep source generally in the ASCII range."
   → Replace non-ASCII chars with ASCII equivalents (or
   identify which non-ASCII chars and remove them).
   The gardener directive (driver auto-enforcement) is a
   garden-meta FOLLOW-UP — journal a message; don't dispatch.

3. **`packages/ses/src/permits.js:1283`** (`3353303304`):
   "Reasonable. We can't assume we'll get these specified."
   → No code change; positive ack.

4. **`packages/ses/src/permits.js:1284`** (`3353305820`):
   Use simply `fromImmutable` (not a symbol) — guessing
   erights's preference.

5. **`packages/ses/src/permits.js:390`** (`3353315386`):
   Use `RegisteredSymbol(freezable)` (simpler form).

### `@endo/immutable-arraybuffer` package shape (1)

6. **`packages/immutable-arraybuffer/package.json:31`**
   (`3353323302`): "Move the ponyfill into `@endo/bytes` and
   keep it hidden. `@endo/immutable-arraybuffer` largely
   serves to house the shim."
   → Move `freezable-typedarray-pony.js` etc. into
   `@endo/bytes` as INTERNAL (not exported). Update
   `@endo/immutable-arraybuffer` to only host the shim.

### `@endo/bytes` package (4)

7. **`packages/bytes/src/concat-immutables.js:4`**
   (`3353401644`): Look at `@endo/harden` for naming
   precedent. Don't use "spackle" term explicitly in code.
   → Sweep code for "spackle" mentions; replace with
   harden-style naming.

8. **`packages/bytes/src/from-string.js:4`** (`3353412248`):
   "`Function` suffix smacks of Hungarian Notation. Can
   simply be `bytesFromText`." Spackle symbol:
   `Symbol.for('fromText')`.
   → Drop `Function` suffixes everywhere. Update symbol
   names to match.

9. **`packages/bytes/src/spackle-install.js:58`**
   (`3353418383`): Add `Symbol.for('toStrictText')` paired
   with `Symbol.for('toText')`. Former has fatal-throw
   behavior; latter has replacement-character behavior.
   → Add the strict variant + wire installer.

10. **`packages/bytes/src/spackle-install.js:1`**
    (`3353430209`): "This module concentrates dependency on
    potentially unused functions. Please divide into a
    parallel set of modules, e.g., `install-concat-
    immutables.js` for `concat-immutables.js`,
    `install-from-immutable.js` for `from-immutable.js`."
    → Split monolithic `spackle-install.js` into per-source-
    module install files.

## Procedure

1. Read all current state in `packages/ses/src/permits.js`,
   `packages/immutable-arraybuffer/`, `packages/bytes/`.
2. Apply the 9 actionable items (skip #3 which is just
   ack).
3. Split `spackle-install.js` per #10 — each source module
   gets its own install file.
4. Move the ponyfill from `@endo/immutable-arraybuffer` into
   `@endo/bytes` as internal (no public export from
   bytes).
5. Rename `bytesFromTextFunction` → `bytesFromText` etc.
   per #8.
6. Add `toStrictText` symbol per #9.
7. Drop "spackle" term from code identifiers per #7.
8. Sweep non-ASCII chars from `permits.js:1278` area per #2.
9. Simplify permit symbols per #1, #4, #5.
10. Run gates: `yarn lint`, `yarn lint:types`, `yarn ava`
    on touched packages.
11. Commit (multiple commits OK for review-friendly
    granularity).
12. Push.
13. Post inline replies on each addressed comment + a
    top-level summary.

## Garden-meta gardener follow-up

Per ask #2 second clause: "Dispatch a gardener to revise the
driver to have deterministic automation to keep source
generally in the ASCII range."

Journal a `message → gardener` describing the ASCII-only
discipline. The actual gardener dispatch is the steward /
liaison's job (separate from this fixer).

## Per-action authorizations

- Read all relevant files. Authorized.
- Edit `packages/ses/`, `packages/immutable-arraybuffer/`,
  `packages/bytes/`, `packages/eslint-plugin/` (if eslint
  rule's identifier whitelist needs updating). Authorized.
- One or more regular-append commits + push to
  `mirror/3164-freezable-typedarrays`. Authorized.
- Inline-thread replies + top-level summary. Authorized.

## Not authorized

- Modifying upstream endo#3164.
- Force-pushing.
- Editing the garden directly (gardener message journaled
  only).
- Un-drafting / re-drafting (#417 already un-drafted).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--bb2325/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--bb2325/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. Other skills referenced just-in-time.

Project worktree at `project/` on `mirror/3164-freezable-typedarrays`
(head `83133cceb`).

## Report

A `result` journal entry. Include:

- Per-comment status (addressed / acked / deferred).
- Per-package summary (files moved, files split, renames).
- New head SHA + commit shape.
- Local gate exit codes.
- Top-level + inline reply IDs.
- Gardener message path (for steward to queue).
- Judgment calls.
