---
ts: 2026-06-05T04:48:23Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--f1c59f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 57
    role: target
refs:
  - entries/2026/06/05/044613Z-dispatch-liaison-f1c59f.md
  - https://github.com/endojs/endo-but-for-bots/pull/57
  - https://github.com/endojs/endo-but-for-bots/pull/57#discussion_r3142207495
---

# result: fixer — #57 prefer `*b0b5cafe` example landed

Addressed kriskowal's `CHANGES_REQUESTED` review `4175819493` on
endojs/endo-but-for-bots#57 by replacing the byteArray hex example in
`packages/marshal/docs/smallcaps-cheatsheet.md` line 13.

## Change

Old (line 13):

```
| byteArray        | ByteArray     | `buf.toImmutable()`   | `"*deadbeef"` // after `*`, hex encoding |
```

New (line 13):

```
| byteArray        | ByteArray     | `buf.toImmutable()`   | `"*b0b5cafe"` // after `*`, hex encoding |
```

## Sweep

Grep over `packages/marshal/` for `deadbeef|cafebabe|c0ffee|babe|dead`
(case-insensitive) surfaced four other hits:

- `packages/marshal/package.json:61`: `babel-eslint` (unrelated, false hit).
- `packages/marshal/src/dot-membrane.js:121`: "dead zone" prose (unrelated).
- `packages/marshal/test/byteArray.test.js:24,53,77`: three test fixtures that
  use `deadbeef` as the byteArray hex test pattern (source code, not
  authorized to modify per the dispatch; the maintainer asked specifically
  about the docs example).

No other docs-side hex examples to sweep. The maintainer's ask is fully
addressed by the single-line cheatsheet edit.

## Commit and push

- Branch: `kriskowal-marshal-binary` (regular append; no force).
- Commit: `2c8c2bfbb6263f29746a00b854a15462697faee3`
  (`docs(marshal): prefer b0b5cafe in smallcaps-cheatsheet example`).
- Previous head: `59bb8bc21`.
- Pushed to `origin/kriskowal-marshal-binary` (fast-forward).

## Inline reply

Reply on inline comment `3142207495` (line 13):

> Addressed in 2c8c2bfb (docs(marshal): prefer b0b5cafe in
> smallcaps-cheatsheet example).

Reply id: `3360428735`.

## Out of scope (per dispatch authorization)

- No top-level summary comment (not authorized; the inline reply alone
  was authorized).
- No review re-request (not authorized).
- Pre-push gate surfaced pre-existing branch-state findings (yarn format,
  yarn lint, filename-no-stutter for `marshal-justin.js` and friends,
  non-ASCII em-dashes in `encodePassable.js`, divergent SECURITY.md
  hashes, inline `import()` JSDoc in `marshal-test-data.js`). None of
  these are introduced by this fixer's diff; the dispatch limits this
  fixer to the docs file only. Surfacing here for the orchestrator's
  awareness; these belong to a separate dispatch if the maintainer wants
  them addressed under this PR.

Self-improvement: nothing this time.
