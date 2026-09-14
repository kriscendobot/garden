Confirmed. The `value > 65535` branches in `xsCode.c` (lines 305, 350) are just the byte-code emitter **widening** the local-index encoding to a 4-byte form — the pre-fix behavior — not a parse-time rejection. The only `fxReportParserError` calls for count limits are "too many arguments" (xsScope.c:1249, xsSyntaxical.c:2191), which is the pre-existing arguments check, not a frame-locals check. No new parser-side frame-locals limit has landed.

## Report

**Job: xs-locals-limit-check-20260914-212007 — recurring upstream watch**

**Result: NOT YET LANDED.**

- Checked `Moddable-OpenSource/moddable` **master** (default branch), tip `b6e06ba705` dated **2026-09-04T19:34:19Z** — identical to the job's baseline (`b6e06ba70`, 2026-09-04). No new commits have landed upstream since the last check.
- No release tag newer than 2026-09-04 exists; the newest tag is `OS221101` (Nov 2022). All release tags predate the baseline.
- Searched the XS parser/codegen sources at that commit (`xsScript.c`, `xsSyntaxical.c`, `xsTree.c`, `xsCode.c`, `xsScope.c`) for a parser-side frame-local-count check. Found none. The `if (value > 65535)` branches in `xsCode.c` (lines 305, 350, …) belong to the byte-code emitter and merely **widen the local-index opcode to a 4-byte form** — this is exactly the pre-fix behavior that can emit byte code crashing at runtime, not a parse-time rejection. The only `fxReportParserError` count checks are `"too many arguments"` (xsScope.c:1249, xsSyntaxical.c:2191), a distinct, pre-existing argument-count limit.

**Actions taken:** Read-only inspection of upstream only. No comments, issues, PRs, commits, or builds — as required (upstream third-party repo, and the fix wasn't found so the terminal-run steps do not apply).

**Schedule:** NOT retired. `schedules/xs-frame-locals-limit-upstream-watch.md` remains in place; the watch ticks again in a week.

**Follow-ups:** None. Iron Horse's independent port (`ironhorse-port-xs-frame-locals-limit`) reconciliation is deferred until the upstream fix appears.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs-locals-limit-check-20260914-212007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (263529 cached reads)
- Output: 4207 tokens
- Cost: $0.5855855
- Wall-clock: 71s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
