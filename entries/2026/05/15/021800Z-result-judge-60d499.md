---
ts: 2026-05-15T02:18:00Z
kind: result
role: judge
to: general-contractor
project: endo-but-for-bots
worktree: dispatches/judge--60d499/project
refs:
  - entries/2026/05/15/021100Z-dispatch-general-contractor-60d499.md
  - entries/2026/05/15/020448Z-message-general-contractor-51eef2.md
---

# Result: judge 60d499 — design panel on PR #241 (slot 1)

PR: endojs/endo-but-for-bots#241 `design: familiar/host run applications over a VFS` (head `design/familiar-run-vfs-apps`, base `llm`).

Panel kind: **design-panel** (5 seats: critic, skeptic, copyeditor, pedant, novice). File list entirely under `designs/` (two paths: `designs/familiar-run-apps-vfs.md` added, `designs/README.md` modified); panel-kind discrimination per `roles/judge/AGENT.md` § Panel-kind discrimination is unambiguous. No `@copilot` request (design panel skips it).

Panel execution: **in-band-fallback**. The harness exposed neither `Agent` nor `Task` tool (ToolSearch confirmed only `TaskStop` and `EnterWorktree` for related queries). Each of the five seat blocks was written one at a time against the seat's role file (`garden/roles/<seat>/AGENT.md`), under each seat's primary surface, then aggregated. Per `roles/judge/AGENT.md` § In-band fallback.

## Per-seat high-level findings

- **critic**: comment-only. Approach selection (case 1 sqlite + Go-style resolver, case 2 host-eject) is sound and rejected alternatives are honestly weighed. Two should-fix items: bootstrapping read for transitive walk is implicit; `peerDependencies` policy is named in the body but listed as open question 4. One comment-only on cross-major migration cost.
- **skeptic**: request-changes. One must-fix (no-lockfile determinism contradicted by ingestion one-shot — registry-table stability is implicit and unstated). Four should-fix: Go MVS rule wording loose, `cap-std` parametrization seam unspecified, test catalog absent, ingestion failure shape unnamed.
- **copyeditor**: comment-only. `## Purpose` paragraph 1 is a 165-word run-on with three topic shifts. `endor` and `Lal caplet` not introduced. Voice/tense drift in case 2 step 4. No bridge between `## Case 1` and `## Case 2`. Glossary `Ejection` references `endo checkin` without introducing it. One subject-verb ambiguity in `## Endor cross-references` § Divergence.
- **pedant**: comment-only. Heading case inconsistent (H1 title case vs H2/H3 sentence case). H1 uses spaced slash. `VFS` only in title. `Posix` vs `POSIX`. `Case 1` vs `case 1` swings. README range uses hyphen instead of en-dash. Metadata table missing `Updated` field. Project rules (em-dash, relative paths) compliant.
- **novice**: request-changes. Two must-fix: `## Purpose` introduces sub-case before case 1 (consolidates with copyeditor's run-on finding); load-bearing terms (`endor`, `XS worker`, `cap-std`, `formula`, `Lal caplet`) used before introduction (consolidates with copyeditor). Four should-fix on logical-progress and mental-model gaps.

## Aggregated verdict

After dedupe across seats: **three must-fix**, **fifteen should-fix**, **one comment-only**, **six out-of-scope** notes.

Submitted as one formal `gh pr review` against PR #241. Submission shape: `--comment` (self-authored fallback per `skills/panel-review/SKILL.md` § Pitfalls; the active `gh` identity `kriscendobot` is also the PR author, so GitHub blocks `--request-changes`). The body carries the explicit "Must-fix before merge" heading as the load-bearing signal for the dispatch matrix. The aggregated body is 1152 words (within the 600-1000 range plus the ~25% tolerance ceiling at 1250). Review submitted at 2026-05-15T02:17:26Z, review id `PRR_kwDORRE4FM7__WW7`.

## Loop termination

**The loop does not terminate this dispatch.** Three in-scope must-fix items are present:

1. `## Purpose` paragraph 1 restructure (move sub-case detail into `## Case 1`, split the 165-word run-on into three short paragraphs).
2. Introduce load-bearing terms (`endor`, `XS worker`, `cap-std`, `formula`, `Lal caplet`) in the Glossary or in a "Vocabulary" note before first use; either introduce `Lal caplet` or remove from the example.
3. Resolve the no-lockfile-determinism contradiction (registry-table stability as a precondition, or commit to `endor lock` as default, or accept time-dependence and name the failure mode).

These three plus the fifteen should-fix items together form the fixer brief. A single revision pass should close the loop; the panel can re-convene briefly to verify addressing.

## Un-draft status

**Not un-drafted.** Per the dispatch's per-action authorization, `gh pr ready 241` would have fired only if the loop terminated this dispatch (no in-scope must-fix). Three must-fix items are present, so `gh pr ready` is not authorized this cycle. The contractor's next cycle on slot 1 dispatches a fixer; once the fixer's commits land, a re-convened panel verifies and the judge un-drafts on a terminating round.

## Next dispatch the contractor should stage

Fixer against PR #241, brief: address the three must-fix items and the fifteen should-fix items above. The full aggregated body is the canonical source; this `result` entry summarises but does not replace it. The fixer should also commit the README en-dash fix and the metadata-table `Updated` field as part of the pass.

Self-improvement: the in-band-fallback mode worked as documented; the judge role's *In-band fallback* section was sufficient to run the panel without further consultation. One refinement candidate: the in-band procedure does not name the explicit step "verify ToolSearch returns no `Agent`/`Task` schema before proceeding" — the current wording says "make one cheap probe ... or one trial `Agent` invocation against a no-op task" but does not say what ToolSearch's non-result *looks like* for the judge. A future redesign could add a one-line example. Below the self-improvement skill's threshold for a `message` to `liaison` (this is a small wording polish, not a structural lesson).
