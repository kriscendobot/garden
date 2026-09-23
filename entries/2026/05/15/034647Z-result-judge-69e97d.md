---
ts: 2026-05-15T03:46:47Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo
---

PR #248 (`design(ses,module-source): import-attributes proposal`).

- Panel kind: design-panel.
- Panel execution: in-band-fallback (the harness did not surface an `Agent` or `Task` tool to the judge subagent).
- Five seats dispatched: critic, skeptic, copyeditor, pedant, novice.
- Verdict: request-changes. Submission fell back to `--comment` because GitHub blocks `--request-changes` on a self-authored PR; the body carries the explicit "Must-fix before merge" heading so the orchestrator's dispatch matrix keys on it.
- Submitted as `kriscendobot` `COMMENTED` review at 2026-05-15T03:46:37Z on commit `bc3720dbb`.

### Maintainer inline comments enumerated separately

The maintainer (`kriskowal`) submitted a `CHANGES_REQUESTED` review at 2026-05-14T20:35:43Z with an **empty top-level body** but eleven substantive inline comments. The contractor's lesson from sibling PR #249 (empty-body kriskowal reviews can carry substantive inline comments) was honored. The eleven inline comments are the load-bearing must-fix list for the next fixer dispatch:

1. Line 6: front matter missing per `designs/CLAUDE.md`.
2. Line 63: dispatch a designer for this case as well.
3. Line 147: `\0` cannot be forbidden in specifiers; JSON-stringify both halves of the memo key.
4. Line 227: arity-based backward-compat is clever and shim-side, not proposed upstream.
5. Line 252: drop JSON modules; virtual module sources cover them today.
6. Line 362: do not mutate the options bag; normalize a clone, then freeze.
7. Line 369: throw if type is not `'js'` and arity is 1.
8. Line 380: drop the parse-in-hook-vs-linker open question.
9. Line 392: attributes do not pass through `resolveHook`; carry the "watch for a good reason" caveat.
10. Line 400: preserve existing shapes; add a `modulesWithAttributes` priming path.
11. Line 402: expand on the compartment-mapper implications.

### Per-seat findings (brief)

- **critic** request-changes: central claim sound; structure collapses under M5 (drop JSON modules) and needs substantial revision; null-byte premise contradicted by M3.
- **skeptic** request-changes: spec-reading clean; specifier-contents premise wrong (M3); test catalogue absent (S1); throw-text unnamed (S2).
- **copyeditor** comment-only: voice consistent; minor Oxford-comma inconsistency, tense slip, line-length over project convention.
- **pedant** request-changes: non-canonical metadata table (M1); serial-comma inconsistency (S6); citation form drift (S6); no em-dashes.
- **novice** request-changes: five comprehension breaks, three promoted to should-fix (S3 worked "before" memo key, S4 `hook.length` intro, S5 archive-concept intro).

### Counts

- Must-fix: 11 (all maintainer inline; panel findings deduped into the same list).
- Should-fix: 7 (S1 through S7 in the panel body).
- Out-of-scope / follow-up: 3 noted in body (code-panel for eventual implementation PR; CSS/Wasm potential future designs; `## Prompt` appendix missing).

### Loop next stage

Must-fix is non-empty; **`gh pr ready 248` was NOT run**. PR remains in DRAFT. The next stage is a fixer dispatch against PR #248 to address the eleven maintainer inline comments and the seven panel should-fix items, then a re-run of this judge dispatch against the fixer's head.

### Originating

This dispatch ran in `/home/kris/dispatches/judge--96490a/` per the dispatch prompt. The dispatch journal entry that originated this run is not present in `entries/2026/05/15/`; the orchestrator may have not yet landed it, or this run preceded the standard dispatch-entry write. Reporting back through the final-message channel.

Self-improvement: nothing this time. The in-band-fallback procedure in `roles/judge/AGENT.md` § In-band fallback worked as written for a design-panel run; the kriskowal-empty-body lesson was already carried in the dispatch prompt's *Critical context* paragraph (forwarded from PR #249 contractor learning) and is the right place for it. No structural change warranted on one engagement.
