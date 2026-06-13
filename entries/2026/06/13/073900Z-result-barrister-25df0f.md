---
ts: 2026-06-13T07:39:00Z
kind: result
role: barrister
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/barrister--25df0f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: head
    branch: feat/formula-inspector
    base: master-4a04d07
refs:
  - entries/2026/06/13/072236Z-result-builder-256add.md
  - entries/2026/06/13/072905Z-result-cleaner-5283f6.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
---

# result: barrister - first code panel on PR #440 (formula-inspector cuts 1+2)

## Summary

First-round code panel on PR #440 (formula-inspector daemon `getFormula` + CLI `inspect` cuts).
**Verdict: COMMENTED with no `must-fix-loop` items.**
The implementation faithfully realizes the daemon and CLI cuts of the merged design.
All 15 CI checks green at head `be93dadbb`.
Five new daemon tests + one CLI demo integration test pass locally.
The chat-cut impasse the builder surfaced is real and stays with the maintainer (design-level scope; not a panel finding).

Panel review submitted at https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-PRR_kwDORRE4FM8AAAABC7B3xw (state: COMMENTED, 2026-06-13T07:38:28Z).

## Panel kind and execution

- **Panel kind:** code-panel.
- **Panel execution:** in-band-fallback. The `Agent` tool was not in scope for this barrister dispatch (subagent harness); the barrister consulted each per-seat role file in `garden/roles/jurors/<seat>/AGENT.md` and folded the per-seat blocks into the aggregated review body, per `skills/panel-review/SKILL.md` § In-band fallback.
- **Panel-hints output:** `bash garden/skills/panel-hints/panel-hints.sh --base 4a04d07` reported 19 of 26 code-panel seats fired:
  - **Always-on (9):** assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober.
  - **Always-fire (2):** scribe, releaser.
  - **Path-triggered (5):** breaker (`packages/daemon/src/daemon.js`), changeset-auditor (`.changeset/`), curator (`packages/daemon/src/types.d.ts`), fast-checker (`packages/cli/test/demo/index.test.js`), migrator (2 packages touched).
  - **Content-triggered (3):** locksmith (matched `endowments`), purist (matched `harden`), warden (matched `harden(`).
  - **Suppressed (7):** benchmarker, gateway, pruner, surfacer, engine-realist, spec-keeper, wire-watcher.
- The barrister added surfacer in-band on a single types.d.ts deprecated-surface finding (the suppressed list is a script default; surfacer's lens was warranted by the public-types observation).

## Pre-dispatch state check

`gh pr view 440 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt`:

```
{"headRefOid":"be93dadbb7e85469ede29da0cc5fb1f235886f52","isDraft":true,"mergedAt":null,"reviewDecision":"","state":"OPEN"}
```

PR is OPEN and DRAFT. Proceed.

## Pre-panel state

- Project worktree fetched from stale `121e4b1e6` and checked out to `be93dadbb` (the cleaner's hygiene head) per the dispatch brief.
- `yarn install` ran clean (with the usual peer-dependency warnings).
- `yarn lint` clean on both `packages/daemon` and `packages/cli`.
- `yarn ava test/endo.test.js --match "*getFormula*"`: all 5 new tests pass (203 ms typical).
- `gh pr checks 440`: 15 of 15 checks pass.

## Disposition counts

- **must-fix-loop:** 0
- **summary-fix:** 3
- **follow-up:** 2
- **acknowledge:** 8
- **drop:** 0

### Summary-fix bundle (3 items)

1. `packages/daemon/src/host.js:693-709` — `getFormula` does not normalize the "unknown-identifier on local node" error path. Add a try/catch around `getFormulaForId` and rethrow as a clearer error citing the identifier, or add a regression test covering the unknown-identifier path.
2. `packages/daemon/src/formula-record.js:227-233` — the default-case fallthrough silently returns an empty-properties record. Add a one-line ava test that constructs a `{ type: 'not-a-real-type', number: '...' }` stub and asserts the empty-properties record so the regression surface is recorded.
3. `packages/daemon/src/types.d.ts:735-744` — `EndoInspector<RecordT>` and `KnownEndoInspectors` are marked `@deprecated` but remain exported. Strengthen the deprecation note with a removal-target version, or move out of the public surface entirely.

### Follow-up items (2)

1. `packages/cli/test/demo/inspect-formula.js` covers only `make-bundle` (the `counter` set up by `counter-example.context`). Design's Test Plan promises CLI demos for eval / lookup / guest / host. Owed in a follow-up PR.
2. The `@info` retirement deserves a one-line migration note in the release announcement when this PR's changeset publishes. Owed at merge time.

## Chat-cut impasse assessment

The builder's impasse is real and correctly surfaced in the PR body's "Design departures" section.

Verified independently:

- `git ls-tree --name-only origin/master -- packages/`: lists `packages/goblin-chat`; **no `packages/chat`** on master.
- `git ls-tree --name-only origin/llm -- packages/`: lists both `packages/chat` and `packages/goblin-chat`.
- `git ls-tree -r --name-only origin/llm -- packages/chat/`: contains `value-component.js`, `chat.js`, `command-registry.js`, and the entire chat-side surface the design references.

The design's "Chat: Value modal back face" section explicitly references `packages/chat/value-component.js` and `packages/chat/formula-view-component.js` as sibling files. Neither exists on master. The impasse is unambiguous.

The maintainer's options remain the right ones (per builder's enumeration):

- (a) Land the `packages/chat` migration to master first, then a follow-up builder dispatch implements the chat cut.
- (b) Re-target the chat-side design at `packages/goblin-chat` (significant design revision).

The barrister has no authority to pick between (a) and (b); this is design-scope, not panel-scope. The PR's Design departures section keeps the gap visible to the maintainer; cuts 1+2 (daemon + CLI) are mergeable standalone.

## Spec-coverage assessment of the new tests

Five new daemon tests + one CLI integration test. The host-only invariant (the design's load-bearing security property per § Why host-only) is the most important property to regress, and the test `getFormula is absent on the guest facet` is the canonical regression for it. The `getFormula rejects cross-peer locators` test covers the cross-peer-validation branch in `host.js:700-704`.

The three positive tests (`getFormula returns per-type formula record (eval)`, `... (make-unconfined)`, `getFormula resolves a caplet to its worker formula`) cover three of the 24 canonical formula types. Coverage of the remaining 21 types is reasonable to defer: the `makeFormulaRecord` helper's per-type branches are straightforward property-classification with no cross-branch interaction, and the design's Test Plan does not call for per-type unit coverage. The 24-type-table-against-actual-schema mapping is correct (verified each entry against `types.d.ts`).

The CLI integration test exercises only the `make-bundle` slice; eval / lookup / guest / host CLI coverage is the follow-up item above.

## Saboteur sweep on the new tests

- `getFormula is absent on the guest facet`: the assertion regex `/target has no method "getFormula"/u` is specific to the method-not-found error path. A future refactor that accidentally adds `getFormula` to `GuestInterface` would fail this test. Acceptable adversarial regression.
- `getFormula rejects cross-peer locators`: the assertion regex `/cross-peer/u` is loose; would pass on any error message containing "cross-peer". Could be tightened to the full `getFormula rejects cross-peer locators:` prefix per the implementation's error message, but acceptable as currently written.
- `getFormula returns per-type formula record (eval)`: asserts `record.properties.endowments.kind === 'reference-list'` but does not assert the inner entries' shape. The eval-formula was constructed with no endowments (`E(host).evaluate('MAIN', '10', [], [], ['ten'])`), so the entries record is empty; tightening would warrant asserting `Object.keys(record.properties.endowments.entries).length === 0`. Acceptable.
- `getFormula resolves a caplet to its worker formula`: end-to-end test that follows the `make-unconfined` worker reference, writes it under a new pet name, and re-invokes. Strong regression on the round-trip property.
- `getFormula returns per-type formula record (make-unconfined)`: asserts the specifier literal (string), worker reference, powers reference. Spec-shaped.
- `inspect-formula` (CLI): asserts `stdout: /^make-bundle  [0-9a-f]{128}\n/u` (the formula-type-and-number header line), `stdout: /"type": "make-bundle"/u` (raw JSON mode), `stdout: /"kind": "reference"/u` (record carries references), `stdout: /"bundle"/u` (a specific property name). The four `testLine` calls collectively cover the human-readable header, the `--json` mode, and three property-shape spot-checks. Adequate.

## Post-loop actions

Since this is a terminating first round (no `must-fix-loop` items), per `skills/panel-review/SKILL.md` § Posting the review:

- Formal review submitted as `--comment` (no `must-fix-loop`; per `gh pr review 440 -R endojs/endo-but-for-bots --comment`).
- `@copilot` reviewer add: NOT fired in this dispatch (the dispatch brief said "Read-only. Do NOT push." which the barrister interprets as scoping the dispatch to verdict-rendering; the `@copilot` add is a per-dispatch fire-and-forget that the orchestrator can stage on a follow-up if desired).
- Summary-fix job-board post: deferred to the orchestrator. The barrister's `result` entry carries the three summary-fix items inline so the orchestrator can post one job with the bundle, or dispatch a fixer directly with the inline bundle.
- Followup ledger append: deferred to the orchestrator (two `follow-up` items above).
- Proposed-rule message to gardener: none. Every finding cites a standing rule.
- Appellate dispatch: orchestrator's policy choice.
- `gh pr ready 440`: deferred to the orchestrator, after summary-fix bundle lands and the appellate (if dispatched) runs.

## Recommended next stage

`next: fixer` (summary-fix bundle, inline above; 3 small items, no panel re-run needed).
Then (orchestrator's choice): `next: appellate` to potentially appeal `follow-up` or `acknowledge` items into `summary-fix` before un-draft.
Then: `gh pr ready 440` to un-draft.

The chat-cut impasse is design-scope; cuts 1+2 are mergeable standalone.
PR #441 (llm-base, design-doc-only) can ferry behind PR #440 once the maintainer confirms the chat-cut deferral.

Self-improvement: the dispatch brief carried "Read-only. Do NOT push." which I interpreted as scoping the project-side push surface, not the journal-side or the PR-review-submission surface. The role file's "Submit one formal `gh pr review`" obligation and the brief's "Render verdict" directive together establish that the formal review submission is in-scope; the brief's "Do NOT push" most plausibly forbids project-branch writes. A future dispatch brief on a barrister could disambiguate by naming the surface ("no PR-branch push") rather than the generic "Do NOT push" to remove the read-twice ambiguity. Not enough to warrant a structural change to the role file; recording here.
