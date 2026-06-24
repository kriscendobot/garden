---
ts: 2026-05-20T03:10:03Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--a1bed8/project
---

PR #307 round-2 revision per kriskowal `CHANGES_REQUESTED` review id `PRR_kwDORRE4FM8AAAABAcgKjA`.

Two inline asks investigated and folded into the revised design:

1. **Drop `err` from `diagnose`** (inline 3270967922 at line 166). Verified feasible against `packages/patterns/src/patterns/patternMatchers.js`: `confirmMatches(spec, patt, false)` already returns boolean without throwing (it powers `matches(specimen, pattern): boolean`). The lane API was reshaped from `diagnose(err, { specimen, pattern }): string | undefined` to `diagnose({ specimen, pattern }): Trace | undefined`, mirroring `matches`'s non-throwing shape. The renderer was split into `render(trace, options?): string`. Callers no longer need try/catch; idiomatic use is `const trace = diagnose({ specimen, pattern }); if (trace) console.error(render(trace));`. The cause-chain-walk fallback phase was dropped (no error means no chain to walk).

2. **Compactness for AI-agent legibility** (inline 3270964963 at line 290). The renderer now has two formats: a default `compact` form (one-line-per-mismatch with ` | `-separated columns: `path | found | expected | reason`, documented grammar, ~100 columns) and an opt-in `expanded` form (`render(trace, { format: 'expanded' })`, Rust-compiler-style indented line-art for human REPL inspection). Compact is the default because the primary beneficiary is an AI agent; a line-per-mismatch shape is both smaller in tokens and easier to line-grep than indented multi-line output. JSON-Lines was considered and rejected: the ` | ` form is shorter and equally machine-parseable. Consumers that genuinely want JSON parse the `Trace` directly, bypassing the renderer.

Commits: 52d58ef8 (`designs(patterns-diagnostic-feedback): non-throwing diagnose + compact renderer`). Single commit; both asks collapsed into one diff because the API reshape and renderer reshape are coupled (the `Trace` return type and the split renderer compose).

Push: pushed to `origin/design/patterns-diagnostic-feedback` (range `c0e569236..52d58ef8e`).

Inline replies: 3270997518 (err-drop on comment 3270967922), 3270998127 (compactness on comment 3270964963).
Top-level summary comment: 4494138948 on PR #307.

Files changed: `designs/patterns-diagnostic-feedback.md` (313 insertions, 243 deletions); `designs/README.md` (3 rows synced: status table Updated date, scope-table description, size-estimate row).

Pre-push gates: ran `bash garden/skills/pre-push-gates/pre-push-gates.sh --probes-only --summary`. Repo-wide pre-existing findings surfaced (filename-no-stutter on packages/chat and packages/daemon, no-inline-import-jsdoc on packages/chat etc., no-pull-citations, security-md-hash-uniform divergences, sentence-per-line-md false positives on numbered-list items in the Investigation section that pre-existed in 87dc4 commit, not introduced by this revision). The probes scan against `origin/<base>...HEAD` when nothing is staged and against the staged diff otherwise; with my markdown-only changes staged, the probes still flagged repo-wide items because most of the probes do not actually scope to the diff. The dispatch noted "diff-only scoping for now" and the staged-only run still produced the same noise. No new violations introduced by this revision.

Self-improvement: nothing this time. The dispatch was tightly scoped and the existing pr-review-thread-replies skill, em-dash-style, and pre-push-gates ran as documented. One paper-cut worth flagging if it recurs: the `sentence-per-line-md` probe flags numbered list items (`1. ...`, `2. ...`, `3. ...`) as multi-sentence lines when those items happen to start with a number-period-space. If a future builder or fixer hits the same false positive, the probe should learn to skip lines matching `^\s*\d+\.\s` (a numbered-list-item start), but the wider issue (probes running repo-wide rather than diff-scoped) is the gardener's call; recording here so it surfaces if the pattern recurs.
