This is a pure design/docs PR — it adds `designs/endoclaw-fetch-bytes-stream.md` and edits `designs/README.md`, touching no code packages. There is nothing to run a coverage pass on and no orphaned code to remove. CI is fully GREEN at the current head (the docs-only CI workflow plus lint/build/browser/zizmor all SUCCESS).

Per step 1 (idempotence), this stage is a NO-OP: the PR is already the right shape and CI is green.

## Completion report

**Stage:** CLEAN — endojs/endo-but-for-bots PR #673 ("design: binary media on the fetch surface (bytes() and stream())")

**Findings:**
- PR #673 is a **design-only** change: `designs/endoclaw-fetch-bytes-stream.md` (added, 261 lines) and `designs/README.md` (+15/-2). No source packages are touched, so the coverage pass (skills/coverage-driven-testing) and dead-code removal have no applicable surface.
- CI at the current head is **all GREEN**: lint, test, build (mutual-dependency-versions), browser-tests, and zizmor workflow-security-audit all report SUCCESS (docs-only CI path).
- PR is OPEN and still draft — draft state is the gauntlet's concern for a later (un-draft) stage, not the clean stage.

**Actions taken:** None required — idempotent no-op. No checkout, no follow-up commits, no push.

**Follow-ups:** None. The gauntlet may proceed to its next stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr673-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91501 cached reads)
- Output: 1270 tokens
- Cost: $0.3963845
- Wall-clock: 24s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
