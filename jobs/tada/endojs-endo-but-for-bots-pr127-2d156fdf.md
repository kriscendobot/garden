PR #713 is clean — exactly the 6-file glorp layer, based on the delegated tip, OPEN and non-draft. Everything is complete. No garden-repo (`main2`) changes were needed — this was entirely a project-repo task.

---

## Completion report

**Directive** (endojs/endo-but-for-bots#127, comment by kriskowal): *"this is rightly closed and decomposed into a stack of PRs. Please create a PR for glorp and close this."*

**Preflight:** PROCEED (no peer resolution). Drained inbox (empty) at each checkpoint.

**Key finding — "glorp" is real.** A prior run of this same job concluded "glorp maps to nothing" and parked a clarifying question with the maintainer. That was a false premise: `glorp` is the fused `glorp(glob, grep)` search primitive implemented **on #127's own branch**, commit `6ad77bf88`. The earlier check missed it because GitHub code-search only indexes the default branch, not the PR branch. Verified the commit exists and adds glorp across 7 files.

**What I did:**
1. **Created PR #713** (G′ of the #127 reconstruction stack) — extracted glorp and re-implemented it onto the *delegated* glob/grep surface (B′ #679 + C′ #680) rather than carrying the retired reference commit forward. The reference impl called the pre-decoupling `grep(pattern, {glob})`; on the decoupled surface it re-expresses cleanly as `grep(grepPattern, glob(globPattern))` — the exact composition seam the decoupled grep documents. Includes the method (`mount.js`), interface guard (`interfaces.js`), help text, conformance-set pin, a new `mount-glorp.test.js` (parity with `grep(p, glob(g))` over the shared grep case table, `maxResults`, required-args), and a changeset. Base `feat/mount-glob-delegated`; diff is exactly the 6-file glorp layer.
2. **Closed #127** with a comment mapping every mount-extensions concern to its reconstruction PR (A #650, P #678, B′ #679, C′ #680, D #657, T #681, G′ #713).
3. **Messaged the maintainer** correcting the prior "unresolvable" question and reporting the outcome, offering to fold/defer glorp if they'd rather it not be its own layer.

**Verification:** daemon tests 42/42 pass (incl. 4 new glorp tests); `tsc` back to the pre-existing 23-error baseline (both glorp-introduced type errors fixed, no new ones). eslint could not run — the sandboxed worktree's dep install left the eslint bin unlinked (and `better-sqlite3`'s native build failed, unrelated); **CI will gate lint** on #713.

**Follow-ups:** (a) #713 has not been through the gauntlet — it was a directive response, not a build; the maintainer can run it if desired. (b) The native fused-pushdown implementation of glorp (Rust/XS `hostGlorp`) remains a named follow-up alongside the stack's other native-parity work (R).

No garden-repo/`main2` changes were required.
