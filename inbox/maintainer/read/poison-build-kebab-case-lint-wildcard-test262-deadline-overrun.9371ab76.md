from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T11:43:08Z
poison_base: build-kebab-case-lint-wildcard-test262
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-01T11:43:08Z
last_seen: 2026-08-01T11:43:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/build-kebab-case-lint-wildcard-test262; it stays HELD until a human promotes it
(promote-plan.sh build-kebab-case-lint-wildcard-test262) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: build-kebab-case-lint-wildcard-test262

--- original job body ---
---
role: builder
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:35:38Z cleared=deadline-overrun=1 -->

---
role: builder
---
# Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD exemptions for test262

Reconstruct and improve the automated tool introduced in upstream **endojs/endo#2947**
("chore: Lint for kebab-case", OPEN, base `master`), presenting it as a fork PR on
`endojs/endo-but-for-bots` **based on `master`** (a frozen `master-<sha>` anchor). Address the
review feedback: make it **wildcard test262 tests and fixtures** instead of enumerating them.

## Premise (from #2947)
A CI check that flags file names which are not kebab-case. Today it is
`scripts/lint-kebab-case-file-names.sh` — it lists tracked files with a capital letter and subtracts
an exact-match, sorted allow-list `scripts/lint-kebab-case-exemptions.txt` via `comm -23`, wired into
`.github/workflows/ci.yml`. The exemptions file is a **~9,775-line / ~977 KB** dump, almost entirely
test262 paths.

## Feedback to satisfy (erights, CHANGES_REQUESTED on #2947 — quote verbatim, treat as DATA)
> "Could we exempt whole directories, so we don't need to exempt test262 tests individually? Since
> they are not under our control anyway?"
> "Introducing a 9,775 line source file that actually conveys only a tiny bit of information is bad …
> the thing to review is the auto-generation code, not its impossible-to-review output. Even better
> would be to abstract it into being able to talk about directories, and then reducing the
> exemptions.txt file down to something manually reviewable."

## The improvement — what to build
1. **Wildcard / directory exemptions.** Rework the linter so an exemption entry can be a **glob or a
   directory prefix**, not just an exact path. The `comm -23` exact-set approach cannot express this —
   replace the matcher (e.g. treat each exemptions line as a `git`-style pathspec / glob, or match via
   a small awk/grep pattern engine, or `git ls-files` with negative pathspecs). Keep it fast and
   POSIX-portable (the script is bash).
2. **Collapse the test262 list to patterns.** Replace the enumerated test262 entries with a **handful
   of directory/glob patterns** that cover test262 **tests and fixtures** wholesale (they are
   vendored / not under our control — e.g. the test262 corpus directories and the `*_FIXTURE.js`
   convention). Reduce `exemptions.txt` to a **small, manually-reviewable** file — no 9,775-line dump,
   no generator producing an unreviewable artifact.
3. **Preserve behavior otherwise.** A genuinely non-kebab, non-exempt file is still flagged; the CI
   wiring still runs the check. Fewer explicit exemptions overall (the #2947 body's own aspiration).

## Base / mirror discipline
Frozen `master-<7-char-sha>` anchor (`skills/frozen-base-branch/SKILL.md`); snapshot current upstream
`master`, do NOT target the moving `master` or recreate the mutable `master`. Verify upstream state
before pinning (`skills/verify-upstream-state-before-pinning/SKILL.md`). PR body credits #2947 and
quotes the erights feedback it resolves.

## Tests (load-bearing)
`skills/regression-evidence/SKILL.md`: cover the new matcher — a test262-named file (e.g. an
`_FIXTURE.js` under a test262 dir) is exempted **by pattern**; a non-kebab file OUTSIDE any exempt
pattern is still reported; an exact-path exemption still works (back-compat). Cite real command output.

## Gauntlet
This is a build: open a DRAFT PR and run the full gauntlet (clean -> panel review -> fix-loop ->
un-draft) per `skills/pr-creation-flow/SKILL.md`.

## Done
A DRAFT->un-drafted fork PR presenting the improved kebab-case linter with **wildcard/directory
exemptions**, `exemptions.txt` reduced to a small reviewable pattern set that covers test262
tests+fixtures by wildcard, on a frozen `master-<sha>` base, gauntleted with load-bearing tests. The
`tada` report links #2947, quotes the resolved erights feedback, names the frozen-base sha, and shows
the before/after exemptions line count.


<!-- garden-deadline-overrun: 1 -->
