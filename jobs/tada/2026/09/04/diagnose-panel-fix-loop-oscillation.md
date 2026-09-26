Pushed to main2 (`87208c580a`). No PR needed — garden meta-repo lands bare on main2, and the doc carries a recommendation, not open questions.

## Completion report

**Job:** Determine why panel `must_fix_total` oscillates (dip then bounce, never →0) across the gauntlet's fix loop — distinguish **(1)** the fixer creating genuinely-new must-fix material from **(2)** panel nondeterminism, by diffing the actual items, not the counts.

**What I did:** Extracted the per-round must-fix item sets for the two cited runs from `journal2 panel-runs/` (#1018 → `designs/ironhorse-panic.md`; #231 → `designs/familiar-release.md`; both are **design** panels), confirmed the 6 real rounds + 1 error-retry per PR, classified each round's items into carried-over / new / reappearing, read the count-generating code (`scripts/jobs/panel-run-record.sh`), and obtained deterministic corroboration via `git grep` on the actual docs at each head.

**Finding — explanation (2), nondeterminism, dominates.** The oscillation has three drivers, largest first:
- **~30–40% measurement artifact (code-confirmed):** `must_fix_total` is *not* a must-fix count. `seat_titles()` counts **every** bullet of any seat whose overall verdict is must-fix — including its own `[should-fix]`/`[comment-only]` bullets — and its `fallback` branch emits `## Per-juror block` headers and `None —` lines as items. One seat flipping verdict injects its whole bullet-set at once.
- **~40–50% seat nondeterminism (git-proven):** the pedant blocks **17** and **65** em-dashes as must-fix (R2, R6) but silently **passes 30 and 53** (R4, R5) on the same monotonically-worsening `ironhorse-panic.md` — an objective, reproducible verdict flip on a worsening condition. Plus pervasive thematic re-litigation of the same clusters by different seats at shifting severities (Formal-Panic discipline, host-fn vocabulary, G4 chrome-sandbox, Severity-field complecting, credential "user-tested"), each with `absent→present` reappearances against heads that didn't newly introduce them.
- **~15–20% genuinely-new/fixer-attributable:** mainly #231 R6 where the critic pivoted to reviewing `model.js` code the prior 5 doc-focused rounds never looked at — itself a nondeterministic *surface-selection* shift, not fixer spray. The loop demonstrably converges when a finding is objective+specific (dead cross-refs and #231 em-dashes were fixed and stayed fixed).

**Remedy (proportionate; do NOT raise `max_iterations`):** (1) make `must_fix_total` count only true must-fix bullets; (2) route objectively-checkable classes (em-dashes, glyphs, dead cross-refs) to a deterministic gate, not an LLM seat — kills the largest nondeterminism source; (3) reinforce the parent report's severity floor + cross-round memory for the subjective recurrence. The costly identical-head re-run was deliberately skipped: the em-dash table is stronger and cheaper evidence.

**What changed:** appended a dated "Follow-up (2026-09-04): item-level discrimination" section (with the per-round classification, the em-dash verdict-flip table, cited commands, and the refined remedy) to `designs/gauntlet-panel-fix-nonconvergence.md` — the existing 2026-08-17 report that diagnosed non-convergence broadly but never separated nondeterminism from fixer-churn. Committed and pushed to `main2` (`87208c580a`).

**Follow-ups (maintainer's call, not done here):** the three remedy items above are policy/observability changes left for the maintainer, per the job's "report and let the maintainer choose" instruction.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/diagnose-panel-fix-loop-oscillation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s)
- Input: 64 tokens (2105888 cached reads)
- Output: 40188 tokens
- Cost: $3.065315250000001
- Wall-clock: 624s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
