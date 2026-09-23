---
kind: result
role: purist
host: endolin-garden-ece02cb4
at: 2026-08-22T04:05:00Z
---
Purist code-panel review of endojs/endo-but-for-bots PR #796 (dispatch
`endojs-endo-but-for-bots-pr796-gauntlet-resume-20260821-panel-1`), diff
`origin/llm...HEAD` in worktree
`project-wt-endojs-endo-but-for-bots-pr796-gauntlet-resume-20260821-panel-1-a55b0f0f`.

### purist

**Verdict:** request-changes

**Findings:**
- `packages/daemon/src/hashline.js:315-318` and `:334,339` — `validateEditOp`
  reads `raw.anchorEnd` and `raw.payload` twice each across a condition-then-use
  pair (`raw.anchorEnd !== undefined` then `validateAnchor(raw.anchorEnd, ...)`;
  `Array.isArray(raw.payload)` then `raw.payload.map(...)`), where `raw` is
  `unknown` input the module's own doc explicitly says gets "re-validated here
  regardless of what an intermediate hop claims to have validated." A getter on
  `anchorEnd`/`payload` that returns a different value on each access defeats
  that guarantee: the value inspected by the guard is not necessarily the value
  fed to the validator/splice. Read each untrusted property into a local once
  and validate/use that local. [proposed-rule: a validator crossing a
  capability boundary must read each property of an `unknown`-typed input
  exactly once, into a local, before inspecting or using it]
- `packages/daemon/src/hashline.js:169-174` (`lineAnchorHash`) and `:697-713`
  (`searchReapply`) — a blank/whitespace-only line's anchor hash is seeded
  with its *own current line number* (`normalized === '' ? \`${lineNumber}\`
  : normalized`). The bounded reapply search recomputes each candidate's hash
  using the *candidate's* line number, so a blank line that has moved from its
  authored position can only "match" by CRC32 coincidence — the position-
  dependent seed makes the position the very thing reapply is searching for,
  silently defeating relocation for the entire blank-line value class. This
  contradicts the design's stated reapply intuition ("find the line even if
  its number drifted", `designs/cli-edit-verb.md:938-940`) for one whole
  category of lines, undocumented in either the design doc's *Reapply mode*
  section or the module's own doc comment. Either document the limitation
  explicitly or seed blank-line disambiguation some other way (e.g. relative
  offset from the nearest non-blank line) that survives relocation.
  [rule: designs/cli-edit-verb.md § Reapply mode]
- `packages/crc32/src/crc32.js:42,52,60,65,70,79` — six raw `throw
  TypeError(...)`/`throw RangeError(...)` sites in new code; the repo
  convention is `@endo/errors`' `makeError(X\`...\`, errConstructor)` (which
  supports typed constructors, e.g. `makeError(X\`...\`, RangeError)`), not a
  hand-rolled throw. `hashline.js` in the same PR gets this right
  (`makeError(X\`...\`, ...)` throughout). [rule: AGENTS.md § Hardened
  JavaScript (SES) conventions § Error handling]

**Notes (out of scope but worth flagging):**
- The `@endo/crc32` extraction itself is a clean instance of the reuse
  discipline this seat looks for (`packages/zip/src/crc32.js` deleted, both
  `reader.js`/`writer.js` now import the shared, hardened package) and its
  proxy-rejecting `Uint8Array` length check is a good ocap-conscious pattern;
  no finding, noted as a positive precedent for the family. [rule:
  roles/jurors/purist/AGENT.md § Reuse over re-implementation of `@endo/*`
  primitives]

Self-improvement: the getter-double-read pattern (condition-check-then-reuse
on an `unknown` property) is worth a named rule under a purity- or
warden-adjacent skill; today it only exists as this seat's proposed-rule.
