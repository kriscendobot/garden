Not yet landed. Read-only upstream check complete; nothing committed or changed.

## Report

**Recurring check: XS 65535-locals-per-frame parser fix — NOT yet landed upstream.**

### What I checked
- `Moddable-OpenSource/moddable` active development tip, now on the **`public`** branch (the repo's default), at **`b6e06ba70506a7381ffb28e09e3175bf4e99f305`** (2026-09-04, "cleanup (thanks Peter)").
- The `9.5.0` release (published 2026-09-05, newer than the 2026-09-04 cutoff): its annotated tag resolves to the **same commit** `b6e06ba705` — i.e. 9.5.0 is just a tag on the already-checked tip, no new engine work.
- Older release tags/branches: `master` branch now points to `48ee02d8` (2026-06-17, = 8.2.3), older than the active tip; no newer release than 9.5.0 exists.

### Evidence the fix is absent
- Only `65535` occurrences in `xs/sources` are in `xsCode.c:305,350` — these are **operand-width encoding** promotions (`RESERVE_1/RETRIEVE_1/GET_LOCAL_1…` → wider 2-/4-byte operand forms), i.e. the *pre-fix* codegen path that silently emits byte code rather than rejecting it.
- Frame-local accounting in `xsScope.c` (`fxBinderPushVariables`/`scopeMaximum` → `scopeCount`) has **no bounds check**; the only parser errors matching "too many" are `"too many arguments"` (`xsSyntaxical.c:2191`, `xsScope.c:1249`), which are unrelated to the frame-locals count.
- No parse-time syntax error rejecting an over-limit frame exists anywhere in `xsScript.c`, `xsSyntaxical.c`, `xsLexical.c`, `xsTree.c`, or `xsScope.c` at that commit.

So the parser still generates byte code for over-65535-local frames instead of rejecting them at parse time. **Fix not landed.**

### Note for the maintainer (branch rename)
Since the 2026-09-14 check, the repo's layout shifted: what that check called the "master tip `b6e06ba70`" is now the **`public`** branch tip (the default branch), and the `master` branch now trails at an older commit. Same commit content, different branch name. Future ticks should track the **`public`** branch (repo default) — or just the latest release tag — not `master`, which is now stale. I did **not** update the schedule text; flagging it here in case you want the watch's language adjusted.

### Disposition
Not the terminal run: **schedule NOT retired**, no commits/pushes made, no upstream interaction. This watch ticks again in a week.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs-locals-limit-check-20260921-212315.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (767825 cached reads)
- Output: 7410 tokens
- Cost: $1.0111625
- Wall-clock: 158s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
