---
ts: 2026-05-20T03:40:35Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--8fd52e/project
refs:
  - entries/2026/05/20/031003Z-result-designer-9f87dd.md
---

PR #307 round-3 revision per kriskowal `CHANGES_REQUESTED` review id `PRR_kwDORRE4FM8AAAABAcko0w`. Four inline asks acked.

**Load-bearing pivot: sibling package retired, replaced by submodule of `@endo/patterns`.** The R3 ask was "Let's take a different gambit and export as a submodule `@endo/patterns/explain-mismatch.js`" (inline 3271039316 at line 622). Reshaped throughout: the facility now lives at `packages/patterns/src/explain-mismatch.js` and is exported via the package's `exports` field as `@endo/patterns/explain-mismatch.js`. The submodule imports `matchHelpers` and `confirmMatches` from the same package directly, so its recursion shares the matcher's building blocks rather than re-implementing them. Download cost stays opt-in because `./explain-mismatch.js` appears nowhere on the production matcher's import graph (bundlers and Node's ESM loader pull a submodule only when an import names it).

**Public-API collapse: two-function `diagnose` + `render` folded into one `explainMismatch`.** Per the second clause of the same R3 ask the public surface collapsed from `diagnose({ specimen, pattern }): Trace | undefined` + `render(trace, options): string` to a single `explainMismatch({ specimen, pattern, context?, format?, width?, color? }): string | undefined` that returns a rendered string directly (or `undefined` on match). The internal `Trace` type stays internal; if a structured-trace export becomes load-bearing later it lands as a second submodule entry, not as a knob on the renderer.

**"Indistinguishable" collapse (inline 3271041722 at line 630).** The anchored pair is the two drift-mitigation options under *Tracing-matcher drift from the production matcher*: (a) shared test corpus where both implementations produce the same verdict, and (b) factor the production matcher into a visitor shape both lanes consume. In the submodule world the two options dissolve into one statement: because `explain-mismatch.js` imports `matchHelpers` in place, there is no second matcher copy to drift from, and the shared-corpus + shared-helpers properties come for free. The whole open-question section disappeared; what survived is design decision #7 ("Tracing recursion reuses the matcher's helpers in place").

**Other inline asks:**

- `r3271033529` ("prettier" at line 526): ran prettier explicitly via `--ignore-path /dev/null` because the repo's `.prettierignore` excludes `*.md` from the default `yarn format` sweep. Normalized metadata-table column padding and converted asterisk-bracketed emphasis (`*foo*`) to underscore-bracketed (`_foo_`, prettier markdown default).
- `r3271042769` ("Okay." at line 639): acknowledged; the exo-guard open question reframed against the new `context` field on `ExplainMismatchInput` and stays open pending an in-repo user.

**Commits and push:**

- 6f81f910 `designs(patterns-diagnostic-feedback): submodule pivot + collapse to single explainMismatch`
- 20dad47f `designs(patterns-diagnostic-feedback): prettier`

Pushed cleanly: `origin/design/patterns-diagnostic-feedback 52d58ef8e..20dad47f5`.

**Inline reply ids:** 3271076169 (prettier), 3271077209 (submodule pivot), 3271077805 (indistinguishable collapse), 3271078248 ("Okay." ack).
**Top-level summary comment:** 4494279342 on PR #307.

**Files changed:** `designs/patterns-diagnostic-feedback.md` (full rewrite of *Design*, *Surface*, *Tracing matcher* sections; *Open Questions* trimmed from three items to one; Revision-log entry appended for R3 in the Prompt-trailer) and `designs/README.md` (see-also blurb, summary-table description, per-design estimate row, last-updated date).

**Pre-push gates:** ran `bash garden/skills/pre-push-gates/pre-push-gates.sh` from `project/`. Same noise pattern as the R2 result entry (`031003Z-result-designer-9f87dd.md`): the `sentence-per-line-md` probe falls through to `git diff origin/master...HEAD` when nothing is staged, which surfaces the entire repo's pre-existing prose findings (lal/primer/, ocapn/, sandbox/, zip/, pivoker/, rust/) plus the same numbered-list false-positives in this design's *Today's shape* section (lines 86, 89, 92) that pre-existed in commit 87dc49085. No new findings introduced by this revision; the relevant diff against `origin/llm` is two markdown files, both prettier-clean. The probe's "diff-only scoping for now" goal documented in the dispatch is not met by the current `sentence-per-line-md.sh` (it defaults to `master` not the actual upstream); recording so the pattern surfaces if the gardener wants a probe fix.

Self-improvement: nothing this time. The dispatch was tightly scoped (one comment was load-bearing, two were small reshapes, one was an ack) and the existing skills (`pr-review-thread-replies`, `em-dash-style`, `pre-push-gates`) ran as documented. The pre-push-gates noise pattern is a recurrence of the same observation in the R2 result entry; flagging again so two consecutive designer-on-#307 dispatches show the same paper-cut and the gardener has a data point if a probe fix is on the table.
