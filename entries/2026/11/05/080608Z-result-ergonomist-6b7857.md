---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-11-05T08:06:10Z
---
Originating dispatch: user-requested ergonomist review of
`endojs/endo-but-for-bots` PR #1652, reviewed only as
`48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c...HEAD`.

**Verdict:** request-changes

**Findings:**
- must-fix: `designs/unified-virtual-filesystem.md:248-252,377-380` calls
  `list`, `listTree`, `glob`, `grep`, and `glorp` a canonical method family,
  but leaves every caller to handle an unspecified choice between a
  backpressured reader and a continuation-bearing page.  This is the primary
  discovery surface for bounded results.  Define one common return protocol
  (including item shape, page/continuation fields, and reader completion), or
  prescribe a method name per shape.  Existing sibling surfaces already
  diverge between arrays and cursors, which this design is meant to reconcile;
  a new ambiguity makes the caller inspect each provider before it can consume
  a search result.  [rule: roles/jurors/ergonomist/AGENT.md \u00a7 Operating norms]

- should-fix: The `RESULT_TOO_LARGE` recovery message at
  `designs/unified-virtual-filesystem.md:356-367` tells a caller that `glob`
  can locate relevant ranges and then recommends `readTextRange`, although
  `glob` yields paths only and `readTextRange` needs line offsets.  Make each
  advertised recovery path independently executable: for example, recommend
  `grep`/`glorp` for line ranges, or direct the caller to a bounded sequential
  reader after `glob`.  The teaching error is part of the public affordance, so
  its first suggested next action should not strand the caller.  [rule:
  roles/jurors/ergonomist/AGENT.md \u00a7 Operating norms]

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: nothing this time.
