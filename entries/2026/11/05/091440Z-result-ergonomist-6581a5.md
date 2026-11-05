---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-11-05T09:14:43Z
job: endojs-endo-but-for-bots-pr1652-gauntlet-panel-3
claim: 28b6a9aba4d605df
---
Design-panel juror block for `endojs/endo-but-for-bots` PR #1652, against
`48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c...HEAD`.

**Verdict:** request-changes

**Findings:**

- should-fix. `## Standard method families` specifies `has(path)` while its
  sibling traversal operations are already represented inconsistently, and the
  established `ReadableTree`, Mount, and Git-tree surfaces all spell presence
  checks as `has(...path)`.  This makes ordinary existing calls such as
  `has(...segments)` fail only for the presence check, while lookup keeps a
  path argument.  Choose and state one canonical calling convention for the
  whole traversal family, then explicitly retain the other form as an adapter
  where migration needs it. [rule: designs/fs-interface-reconciliation.md § Interface differences]

- must-fix. The proposed streaming search surface has no consumable path
  contract.  `glob()` promises only "matching paths", `listTree()` emits a
  `{ path, kind }` record, and tree `grep()` also emits `path`, but none says
  whether a path is a `Path` array or a string, or whether it is relative to
  the receiver or to the queried subtree.  That is particularly surprising
  after `## Core model` forbids slash-splitting strings.  Specify one `Path`
  representation and origin for every returned path, so a record can be passed
  directly to `lookup` without guesswork or string reconstruction. [proposed-rule: a filesystem API that returns paths defines their representation and base consistently across list and search results.]

**Notes (out of scope but worth flagging):**

- None.

Self-improvement: nothing this time.
