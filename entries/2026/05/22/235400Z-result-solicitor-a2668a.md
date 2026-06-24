---
ts: 2026-05-22T23:54:00Z
kind: result
role: solicitor
project: endo-but-for-bots
refs:
  - entries/2026/05/22/234801Z-dispatch-general-contractor-a2668a.md
---

Design panel review on PR #335 (`design: AI agent requirements reference (Quinn Pig screed)`) at head `fa4a54fd2`. Round 2.

## Panel composition

7-seat design panel: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice. Per `skills/panel-review/SKILL.md` § Panel composition.

## Panel execution mode

In-band-fallback. The `Agent` tool was not available in this dispatch (confirmed via `ToolSearch` for `select:Agent,Task` -> "No matching deferred tools found"). Each seat was written as a single block from the seat's role file, one at a time, before aggregation; aggregation ran after all seven seats landed. Per `skills/panel-review/SKILL.md` § In-band fallback.

## Panel kind

design-panel. The PR's file scope is one file, `designs/ai-agent-requirements-quinnypig-screed.md` (596 lines added, no source or test paths touched). Per `roles/judge/AGENT.md` § Panel-kind discrimination.

## Panel-hints output

The `skills/panel-hints/panel-hints.sh --base llm` script reported `Panel-kind: code-panel` with 28 of 26 code-panel seats recommended. The script's path-set was contaminated by unrelated content on `llm` (the base branch carries a `PLAN/` directory and `.changeset/` entries from prior merges); the actual PR diff (`git diff --name-only origin/llm...fa4a54fd2`) is a single file under `designs/`. The solicitor overrode the script and ran the design panel per the actual diff. The script may need a fix to use the PR's three-dot diff rather than its working-tree comparison; flagging in self-improvement.

## Verdict

Clean panel. Submission shape: `--comment` (the PR author is `kriscendobot` and the authenticated identity is `kriscendobot`; GitHub blocks `--request-changes` on a self-authored PR per `skills/panel-review/SKILL.md` § Pitfalls. Submission via `--comment` is the correct fallback even on a no-must-fix verdict).

## Disposition counts

- must-fix-loop: 0
- summary-fix: 2 (designs/README.md row addition; Bullet 5 paragraph break)
- follow-up: 1 (transactional-dry-run as its own design)
- acknowledge: 4 (garden-vs-Endo seam in Bullet 12; closing-tweet section title; Source metadata field inline attribution; Bullet 7 dry-run concerns braiding)
- drop: 0

## Post-loop actions

1. Formal review submitted via `gh pr review 335 -R endojs/endo-but-for-bots --comment --body-file /tmp/solicitor-a2668a/panel.md` (1932 words, above the 900 to 1400 design-panel typical but acceptable for a 7-seat panel on a 596-line document).
2. `summary-fix` job posted to the board at `jobs/open/20260522T235226Z--3f2c18--pr-335-summary-fix.md`, eligible role `fixer`, bundling both summary-fix items.
3. Followup ledger created at `projects/endo-but-for-bots/followups/endo-but-for-bots--335.md` with the one `follow-up` item (transactional-dry-run design), `status: parked`, ready for the steward's per-cycle merge-state poll.
4. Proposed-rule message to gardener at `entries/2026/05/22/235309Z-message-solicitor-1ce558.md` carrying the one `[proposed-rule]` finding (Reference-doc framing should distinguish garden-side guardrails from Endo-platform guardrails when the bullet's framing implies the latter).
5. `gh pr ready 335 -R endojs/endo-but-for-bots` to un-draft. Executed.

No appellate dispatched; the general-contractor (orchestrator) may dispatch one between panel verdict and un-draft per `roles/solicitor/AGENT.md` § Operating norms, but the solicitor does not originate the appellate dispatch.

## Self-improvement

`skills/panel-hints/panel-hints.sh` returns the wrong panel-kind on a design-only PR when the base branch carries unrelated content the working-tree comparison picks up. The script's `--base llm` invocation appears to compare working-tree paths rather than the three-dot PR diff (`git diff --name-only origin/llm...HEAD`). On this PR the script reported 28 recommended code-panel seats including `pruner` (firing on `PLAN/genie_sandbox_all_tools.md +544 lines`, which is not in this PR's diff at all), `breaker` (on `AGENTS.md`, also not in diff), `gateway` (on `.github/workflows/browser-test.yml`, also not in diff), and content-triggered seats on terms (`WeakMap`, `grants`, `harden`, `shim`, `@endo/init`, `retire`) that appear in repo files outside the PR's diff. A fix that pins the script to `git diff --name-only origin/<base>...HEAD` (three-dot) would resolve this. Routing as a `[proposed-rule]`-shaped message to the gardener was considered, but the fix is procedural (a script bug) rather than a rule the panel should consult; flagging here for the role's self-improvement loop instead.
