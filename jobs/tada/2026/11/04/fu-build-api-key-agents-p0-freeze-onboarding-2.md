I fixed `phase-evidence-gate.sh` so it can read a governing design that lives in another repo, and pushed the fix to main2 as `9c71b5bb62d`. The gate's test suite passes, 35 of 35, including 5 new tests for this case.

**Why #241 was blocked.** The PR body named `designs/claude-bare-course-correction.md`. That file only exists on endojs/endo-but-for-bots#1543, so the minion.town checkout couldn't read it. The body also said "step 1", so the gate returned "undetermined" (exit 3), and `ensure-pr.sh` treats that as a refusal.

**How the gate finds the design now.** It looks in this order:
- **The project's own checkout**, as before.
- **A downloaded copy:** `--design-dir` or `GARDEN_PHASE_EVIDENCE_DESIGN_DIR`, matched by path and then by filename. This works without network access.
- **A link to the file** (`github.com/<owner>/<repo>/blob/<ref>/<path>`): the gate reads the design at that ref.
- **A link to a PR** (`github.com/<owner>/<repo>/pull/N`): the gate takes the design files that PR changes whose path or bare filename appears in the body, and reads them at the PR's head commit.

Setting `GARDEN_PHASE_EVIDENCE_REMOTE=0` turns off the GitHub lookups.

**Other changes:**
- A design from another repo shows up in the gate's output as `owner/repo:path`. The ledger's `Design:` line can name it by path, filename or link.
- Ledger rows may say `Step N:` as well as `Phase N:`. Before this, #241's hand-written `Step` rows didn't match the ledger format, so the gate would have reported every step as missing if it had ever checked that ledger.
- `skills/pr-formation/SKILL.md` now explains how to cite a design from another repo, and says not to work around the gate.
- The new tests use a stand-in for `gh` (`scripts/jobs/test/phase-evidence-remote-gh-stub.sh`). They cover a PR link with a bare filename, a link to the file, a ledger that names the design by filename with `Step` rows, the no-design-available case (still exit 3), and the offline downloaded copy.

**Checked against the real case:** I ran the gate against #241's body, in its original form that named the path, from an empty checkout. With GitHub lookups on, it read the design from #1543's head; with them off, it still returns exit 3.

**Follow-ups:**
- **The #1543 design never triggers the ledger check anyway.** Its sequence heading is "Independently shippable sequence", which the gate doesn't recognize as a sequence section, and the design has no stop-gate or acceptance-evidence section. So p1–p5 won't be blocked, but their ledgers won't be checked automatically either. Widening what counts as a sequence heading is a separate decision I didn't make.
- **#241's body is now out of date.** It says the gate can't read the design. A later fixer could restore the `designs/...` path or link so the gate checks the ledger itself rather than leaving it to the panel's manual comparison.
- **The builder said it saved a memory note telling p1–p5 to work around the gate.** I couldn't find it in the shared memory directory. If it exists somewhere else, it should be updated or removed.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `2866a26dbfe791e9a0ed771d52ad727e826d32da`; this job presented `c27d13c647c0fd01e90c9379f365bc87878156e6`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-build-api-key-agents-p0-freeze-onboarding-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1320348 cached reads)
- Output: 18348 tokens
- Cost: $1.2997176
- Wall-clock: 277s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
