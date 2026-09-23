All five checks are SUCCESS and the `ci-wait-merge.sh` bounded wait exited rc 0 (GREEN). CI is terminal and green.

## Completion report

**Stage:** clean — endojs/endo-but-for-bots PR #1098 (`design(endo-claude): fold sibling provider-adapter lessons into residuals`)

**What I did:**
- Idempotence check: PR is an open draft; its diff touches only `designs/endo-claude.md` (+78/-5) — a pure docs/design change under the "CI (docs-only)" workflow. No packages are touched.
- Coverage pass / dead-code removal: **not applicable** — no source, tests, or package code changed, so there is nothing to cover and nothing orphaned. No follow-up commits were needed; the PR head was left untouched.
- Watched CI to a terminal state with `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh endojs/endo-but-for-bots 1098 --no-merge` → **rc 0 (GREEN)**.

**Result:** All 5 checks SUCCESS — browser-tests, lint, build, zizmor, test.

**Changes pushed:** none (docs-only PR, already clean).

**Follow-ups:** none from this stage; the gauntlet driver proceeds to the next stage (panel review).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1098-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (439460 cached reads)
- Output: 3495 tokens
- Cost: $0.6727449999999999
- Wall-clock: 226s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
