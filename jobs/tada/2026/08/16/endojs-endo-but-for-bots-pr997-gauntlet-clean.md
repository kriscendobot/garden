CI is GREEN (rc 0). The clean stage is complete.

## Completion report

**Stage:** CLEAN — endojs/endo-but-for-bots PR #997 (gauntlet `endojs-endo-but-for-bots-pr997-gauntlet`, iteration 0)

**PR shape:** `design(daemon): reassess worker retention, revocation, and the batch-flush retention root` — a **docs-only** PR. The diff touches only two files: `designs/README.md` (+18/−1) and `designs/worker-retention-and-revocation.md` (+822, new file). No source packages, tests, or code.

**Coverage pass:** No-op by construction. The change adds/edits Markdown design docs only — there are no touched packages to run a coverage pass over and no code orphaned by the change, so there was no dead code to remove.

**Follow-ups pushed:** None — nothing to change on the PR head.

**CI:** Watched to a terminal state with `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh ... --no-merge`. All 5 checks GREEN (browser-tests, lint, build, zizmor, and the docs-only `test` job that was IN_PROGRESS at claim time all resolved SUCCESS). Exit code 0.

No further work for this stage. PR remains draft (correct — later gauntlet stages handle panel/fix/un-draft).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 19 tokens (422454 cached reads)
- Output: 2639 tokens
- Cost: $0.594854
- Wall-clock: 292s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
