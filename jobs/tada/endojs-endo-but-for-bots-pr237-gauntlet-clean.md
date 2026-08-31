This PR #237 is a **docs-only design PR** — it only modifies `designs/README.md` and adds `designs/lal-jessie-blocky.md`. There is no source code touched, so there is no coverage pass to run and no orphaned dead code to remove. All CI checks are already GREEN and the PR is OPEN (not draft).

Per step 1 (idempotence), this stage is a NO-OP: the PR is already in the right shape.

## Completion report

**Stage:** clean (gauntlet `endojs-endo-but-for-bots-pr237-gauntlet`, iteration 0)
**PR:** endojs/endo-but-for-bots #237 — "design: lal define-jessie tool with Blockly rendering"

**Findings:**
- PR state: OPEN, not draft.
- Head: `endojs:design/lal-jessie-blocky` @ `62b16fea38047b03a78ebcec486d52d6c4233417`.
- Diff scope: docs-only — `designs/README.md` (+17/−6) and new `designs/lal-jessie-blocky.md` (+569). No package source touched.
- CI: all four checks SUCCESS (browser-tests, lint, build, test).

**Action taken:** None required. A coverage pass and dead-code removal are inapplicable to a design/docs-only change, and CI is already terminal-green at the current head. Idempotent no-op.

**Follow-ups:** None.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr237-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91338 cached reads)
- Output: 1160 tokens
- Cost: $0.39275400000000005
- Wall-clock: 29s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
