---
ts: 2026-05-21T07:36:47Z
kind: result
role: judge
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/judge--926021/project
refs:
  - (originating dispatch: judge --926021, panel on PR #101)
---

Panel verdict on PR #101 (chat voice input + voice command parser design).

## Round

First panel round under the gauntlet, after kriskowal's 2026-05-21T06:34Z directive to subsume #102 into #101 and run the gauntlet.
The subsume + cleaner work was already done by prior dispatches (head at `be4516b0e`).

## Panel kind

code-panel (twenty-three seats).
The PR touches source (`packages/chat/voice-input.js`, `packages/chat/chat-bar-component.js`, `packages/chat/index.css`), tests (`packages/chat/test/component/voice-input.test.js`, `packages/chat/test/helpers/dom-setup.js`), package docs (`packages/chat/README.md`), and a design document plus its index (`designs/chat-voice-command-parser.md`, `designs/README.md`).
Mixed shape per the maintainer's subsume directive, but the source-touching content keys panel-kind discrimination to the code panel.

## Panel execution

in-band-fallback.
No `Agent` (or `Task`) tool was surfaced to this dispatch's harness; the judge ran each of the twenty-three seats' blocks against the per-seat role file one at a time per `roles/judge/AGENT.md` § In-band fallback, then aggregated.
Each block was written before the next was read, to preserve the bias-isolation property the multi-seat-dispatch mode would have given.

## Verdict

`--comment` (self-review fallback per `skills/panel-review/SKILL.md` § Pitfalls).
The PR is authored by `kriscendobot` and the gh-authenticated identity on this dispatch is also `kriscendobot` (the bot identity pinned to this host's worktree), so GitHub blocks `--request-changes`.
The review body opens with `> **Must-fix before merge.**` so the orchestrator's dispatch matrix keys on the heading even though `reviewDecision` does not flip.

Submitted review URL: https://github.com/endojs/endo-but-for-bots/pull/101#pullrequestreview at submitTime `2026-05-21T07:36:16Z`.
`@copilot` reviewer was added alongside the panel per the code-panel norm (idempotent on re-rounds).

## Disposition counts

| Disposition       | Count |
| ----------------- | ----- |
| must-fix-loop     | 1     |
| summary-fix       | 3     |
| follow-up         | 7     |
| acknowledge       | 3     |
| drop              | 0     |

### must-fix-loop (1)

1. `designs/README.md` is incomplete for the new `chat-voice-command-parser` design.
   The PR adds the summary-table row at line 25 but omits the milestone assignment, the milestone-table row, the dependency-graph node (the design declares three dependencies: `chat-command-bar`, `chat-pending-commands`, `chat-slot-slash-commands`), and the size/duration estimate.
   `designs/CLAUDE.md` § Progress Tracking is explicit: "New designs must be incorporated into the README plan. This means: adding a row to the summary table, **assigning the design to a milestone**, **adding it to the appropriate milestone table**, **inserting it into the dependency graph if it has dependencies or dependents**, **adding a per-design size/duration estimate**, and updating the milestone totals and timeline if the new work changes the critical path."
   Source juror: integrator.
   Suggested target: Milestone 4 (UX Polish and Agent Tooling); the chat-UX subgraph of the dependency mermaid; per-design size around S to M depending on phasing.
   Also bump the masthead `Last updated` at `designs/README.md:3` from `2026-05-05` to today.

### summary-fix (3)

Bundle target for the post-loop `summary-fix` job once the must-fix-loop disposition is cleared:

1. `packages/chat/README.md:91-98`: split the joined-with-semicolon sentences across two lines per the project's per-sentence-per-line markdown style.
2. `packages/chat/voice-input.js:6-12`: JSDoc says "the button is hidden" but the module returns `null` and never creates the button.
   Reword to "the button is not added".
3. Commit hygiene squash: four style/lint fixup commits (`style(chat): drop em-dashes from voice-input comments`, `style(chat): prettier-format index.css`, `style(chat): prettier-format voice-input tests`, `fix(chat): lint-clean voice-input and its callsite`) should squash into their feature parents.
   Net: eleven commits become six or seven readable commits in the merge log.

### follow-up (7)

To append to the followup ledger after loop termination per `skills/panel-review/SKILL.md` § Follow-up ledger:

1. `packages/chat/voice-input.js:113`: add a leading comment naming the `InvalidStateError` DOMException being swallowed.
2. `packages/chat/voice-input.js`: replace `/** @type {any} */ (window).SpeechRecognition` with a `SpeechRecognitionCtor` JSDoc typedef so the four downstream `any` casts can drop.
3. `packages/chat/test/component/voice-input.test.js`: add a double-destroy idempotency test.
4. Design privacy doc: when phase 4 lands, document which browser Web Speech implementations are on-device vs cloud-routed.
5. Adversarial phase-2 test for `quote` escape semantics in `designs/chat-voice-command-parser.md`.
6. Hostile-browser loop bound at `voice-input.js:142` (`Math.min(results.length, 100)`).
7. Phase-4 cutover test plan in the design.

### acknowledge (3)

1. No `harden()` calls in `voice-input.js`: chat-UI package precedent (`send-form.js`, `chat-bar-component.js`, `inline-command-form.js`, `blob-viewer.js` are also no-harden).
2. `// @ts-nocheck` in the test file: consistent with `packages/chat/test/helpers/dom-setup.js:1` precedent.
3. Design-plus-implementation in one PR: explicitly authorized by the maintainer's subsume directive.

### drop (0)

No findings were dropped this round.

## Cite-or-propose accounting

Roughly 60% of findings cite an existing rule (CLAUDE.md sections, designs/CLAUDE.md sections, neighbor-file precedent, `skills/retcon`, `skills/changeset-discipline`, `skills/coverage-driven-testing`, `skills/saboteur-adversarial-review`).
The remainder propose new rules (six `[proposed-rule]` tags across the body).
A `message: judge → gardener` proposed-rule bundle should follow loop termination per `skills/panel-review/SKILL.md` § Cite-or-propose discipline; the proposals are listed inline in the review body and will be inlined in the gardener message at that time.

## CI

Four pre-existing infra red checks observed on this PR head and noted in the panel body:

- `zizmor` (Workflow security audit): pre-existing on the `llm` base; PR does not touch workflows.
- `lint` (CI): upstream `makeClient` API gap on `llm` base; PR does not touch the failing surface.
- `cover (20.x, ubuntu-latest)`: same upstream `makeClient` gap.

All PR-touched checks are green (`browser-tests`, `build`, `test`, `familiar-bundle`, `test (20.x, ubuntu-latest)`, `test (22.x, ubuntu-latest)`, `test-async-hooks (22, ubuntu-latest)`, `test262`, `test-hermes`, `check-action-pins`, `test-ocapn-python`, `build-wasm`).
These reds do not block this PR's gauntlet.

## Cross-PR findings

- PR #102 was the original design-only sibling for the voice command parser; it is closed.
  The `designs/README.md` plan-integration owed (the must-fix above) would have landed with #102 had it shipped alone; it remains owed on #101.
- PR #44 is the original (pre-fork) source of the voice-input work; the bot-account re-open is recorded in the #101 body.

## Next stage owed

The round is non-terminating: one `must-fix-loop` disposition is present.
The orchestrator's next stage per `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop is a `fixer` dispatch against PR #101 carrying the panel review at `https://github.com/endojs/endo-but-for-bots/pull/101#pullrequestreview` (submitted 2026-05-21T07:36:16Z), focused on the one must-fix item (the `designs/README.md` plan integration).
After the fixer's `result` lands, re-dispatch this judge on the new head; the next round should terminate if the must-fix is addressed and no new in-scope items appear.

Post-loop actions (deferred until the round terminates):

1. The same disposition-tagged review will be the terminating round's body.
2. The three summary-fix items get bundled into one `summary-fix` job on the job board.
3. The seven follow-up items get appended to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--101.md` with `status: parked`.
4. The six `[proposed-rule]` findings get bundled into one `message: judge → gardener` entry.
5. `gh pr ready 101 -R endojs/endo-but-for-bots` un-drafts the PR (it is already not-draft, so the call is a no-op; the journal entry still records that the loop terminated and the un-draft authority was exercised).

This dispatch did not perform the un-draft because the round is non-terminating.

Self-improvement: nothing this time. The in-band-fallback procedure performed as documented in `roles/judge/AGENT.md` § In-band fallback. The cite-or-propose discipline and disposition rubric on the twenty-three-seat code panel performed as documented; the integrator seat's lens on `designs/CLAUDE.md` § Progress Tracking was load-bearing in surfacing the one must-fix item, which would have been easy to miss without the integrator's named focus.
