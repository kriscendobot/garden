The job is complete. Here is my report.

---

## Completion report: `fix-botanist-scripts-enabled-install-gap-gauntlet`

### What this job actually was, and why I did not run the gauntlet

This was an auto-gauntlet handoff to run the full gardening state machine (clean → panel → fixer → un-draft) on `endojs/endo-but-for-bots#867`. On inspection the handoff was **minted in error**: #867 is a **dependabot PR** (`chore: bump @noble/curves 1.9.0 → 2.2.0`, authored by `app/dependabot`), **not** a build artifact. The build `fix-botanist-scripts-enabled-install-gap` opened no PR of its own; it merely *cited* #867 as the botany that surfaced its gap. A botanist had already cleared #867 **MERGE-NOW**, awaiting the maintainer's approval. Running a cold panel review on it would have been wrong, so I did not.

This is the same class as the #671 incident that commit `0a2264228f` fixed for the *job-file* citation path — but #867 reached the hook through a path that fix did not cover.

### What I changed (landed on `main2` as `40dbe88b64`)

1. **`scripts/jobs/auto-gauntlet-handoff.sh`** — added a second, independent artifact test: the reported PR's **author must be the bot**. A build opens its PR under the bot identity (the fleet's `gh` wrapper pins every call), so a PR authored by anyone else cannot be a build artifact regardless of which document named it or in what form. The report-only rule (`0a2264228f`) closed the job-file path; this closes the remaining one — a completion **report** that cites another author's PR by full URL. The check runs **before any GitHub mutation**, so a mis-identified PR is never re-drafted first.
2. **`scripts/jobs/test/auto-gauntlet-handoff-test.sh`** — added an `author` field to the gh-stub fixtures and a regression case proving a dependabot-authored PR named in the report gets **no** gauntlet record and **no** `pr ready` mutation (only the read-only `pr view`). **Verified**: the new case **fails against the pre-fix hook** (`incorrectly received a gauntlet record`) and **passes against the fixed one** — full suite green, `exit=0`, on the pushed tree. `bash -n` and `shellcheck -x` clean (only the pre-existing SC1091 info on the dynamic `common.sh` source).
3. **`designs/gardening-state-machine.md`** — documented the second artifact test alongside the existing #671 note.

### Remediation of the live PR

The buggy handoff had force-drafted #867 out of the maintainer's queue (timeline: force-drafted 07-29 02:02Z, a requeue re-drafted it again 07-29 16:06Z). I restored it with `gh pr ready 867`. **Verified**: `867: isDraft=false state=OPEN` — back to the ready-for-review, MERGE-NOW-awaiting-approval state the maintainer expects to act on. I did **not** comment on #867: reverting our own erroneous draft toggle is not "pushing work," and initiating a comment on that PR is unauthorized by this job (the botanist's verdict is already posted there).

### Follow-ups

- None blocking. The fix is on `main2` but takes effect fleet-wide only after the next deliberate deploy; until then the deployed report-only code still blocks *this* specific recurrence for #867 (the build's completion report contains no full PR URL — the `pull/867` URL lived only in the build's job file).
- Optional: a sweep for other dependabot PRs that a citing build's handoff may have force-drafted on the old code. I did not run it; the author-identity fix prevents the class going forward.

Self-improvement: when fixing a "wrong PR identified" bug, prefer the robust structural invariant (author identity, since a build's PR is always bot-authored) over patching the document-of-origin symptom — the same class recurred through a second document path days apart because the first fix addressed the symptom, not the invariant. This is now encoded in the hook and the design doc, so no role/skill message is warranted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-botanist-scripts-enabled-install-gap-gauntlet.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 2 host(s) (7 unmetered)
- Input: 81 tokens (3986752 cached reads)
- Output: 40253 tokens
- Cost: $4.842089 (7 engagement(s) unpriced)
- Wall-clock: 2297s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
