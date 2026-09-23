---
ts: 2026-06-14T09:08:25Z
kind: result
role: appellate
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/appellate--c72f2f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: reviewed
refs:
  - entries/2026/06/14/090800Z-dispatch-appellate-c72f2f.md
  - entries/2026/06/14/090300Z-result-barrister-9c09ea.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--442.md
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/endojs/endo-but-for-bots/pull/442#pullrequestreview-0
---

# result: appellate — promotions audit on PR #442 (daemon-cas extraction)

Audit of the barrister's first-round terminating verdict per the dispatch brief at `entries/2026/06/14/090800Z-dispatch-appellate-c72f2f.md`.
Pre-audit state: PR OPEN, isDraft true, head `f472c43c5`, base `llm-c85d618`.
Items considered: **3 follow-up + 21 acknowledge = 24 deferred dispositions**.

## Proposed promotions

- **finding**: `packages/daemon-cas/test/content-store.test.js:294-317` — the "joinPath is the only path primitive" test asserts `joinCalls >= 1` after a single `store(...)`. The test's intent (`store`, `fetch`, `has`, `remove` each call joinPath at least once) is good but the assertion does not exercise the full set. Strengthen the assertion: invoke all four operations against the same store, then assert `joinCalls >= 4`. The current shape passes even if a refactor accidentally hard-codes a Node path-separator in `fetch` / `has` / `remove`.
  **judge's disposition**: follow-up
  **appellate's proposal**: summary-fix
  **rationale**: Small (add three method calls and change `>= 1` to `>= 4` in the existing test that already has the `joinCalls` counter and a `realFile` `joinPath` shim wired up; the test already invokes `store(...)` and `has(...)`, so the delta is one `fetch(sha)`, one `remove(sha)`, and one numeric change). In-context (modifies the test file the PR introduced, in service of an assertion the PR also introduced). Loss-track risk high: the rule citation explicitly identifies a known-weak load-bearing assertion (`skills/regression-evidence/SKILL.md § load-bearing assertions`) that "passes even if a refactor accidentally hard-codes a Node path-separator in `fetch` / `has` / `remove`". A weak assertion left in the codebase to be strengthened later defeats the assertion's purpose; the strengthening is a one-line numeric change plus a few lines of test invocation that belong in the same PR that introduced the weakness. [rule: skills/regression-evidence/SKILL.md § load-bearing assertions]

## Items considered and not appealed (rationale, terse)

The remaining 2 follow-up and 21 acknowledge items did not meet the appellate's three-question bar. Brief notes on the closer calls:

- **follow-up: shared `ContentStoreFilePowers` test helper extraction.** Small (yes; ~55-line helper to lift into `_node-fs-powers.js`), in-context (yes; touches files the PR introduced), but loss-track risk is *low by design*: the followup ledger's own recommended action explicitly says "Wait to extract until the third reproduction surfaces (e.g., when `@endo/git-cas` lands and reaches for the same shape) so the helper's signature is shaped by two distinct call sites rather than one." The deferral carries a positive design rationale (rule-of-three for shared helpers), not a forget-risk. Deferral stands.
- **follow-up: revisit XS coverage when Phase 5 lands.** Not small in-context: the package's `test:xs` is `exit 0` *because* the implementation depends on `node:fs` powers threaded in by the test; an XS test cannot be added pre-Phase-5 without first inventing a Phase-5-shaped surface, which is out of scope. The ledger entry is a merge-watcher reminder for the right future moment. Deferral stands.
- **follow-up: `ContentStoreReader` typedef may drift from `@endo/stream`.** This finding appears in the barrister's review body as the eighth bullet but is not in the followup ledger (the ledger carries 3 items; the review body's eighth bullet on the typedef divergence was either treated as overlapping with the helper-extraction follow-up or rolled into the same Phase-5 / `@endo/git-cas` re-evaluation surface). On its own merits: not small in-context (the resolution either takes an `@endo/stream` dep, restructuring the package's runtime-dep graph, or hoists into a hypothetical `@endo/platform/types` surface that does not yet exist; both are PR-scope decisions, not in-PR tweaks). Deferral stands.
- **21 acknowledge items**: each is either (a) a positive validation of a choice the PR made (the `harden()` placement, the factory-thunk equivalence, the `package.json` / `tsconfig.composite` / `.gitignore` / README / CHANGELOG / SECURITY / LICENSE / index.js shapes, the PR-body shape, the stacked-PR base, the sibling-fork peer-fix check, the cross-supervisor XS wiring, the `await null;` Jessie insertion equivalence) or (b) an out-of-context observation explicitly framed as belonging elsewhere (the atomic-rename failure-path test "belongs in a daemon-side integration suite, not the unit"; the per-test `t.timeout(...)` "is not required by the project's rule"; the `has` bare-catch shape is a documented exception under `skills/saboteur-adversarial-review/SKILL.md § tight-try-discipline exceptions`). None embed a small-and-in-context fix that would be lost. Deferral stands across the set.

## Orchestrator follow-up shape

The single proposed promotion targets the existing `summary-fix` job at `journal/jobs/open/20260614T090132Z--7e80fa--endo-but-for-bots-442-summary-fix.md`.
The orchestrator's action shape:

1. Amend that job to bundle the joinPath assertion strengthening alongside the `@endo/ses-ava` test wrap (one fixer pass handles both).
2. Remove the "Strengthen the `joinPath`-only-path-primitive assertion from `>= 1` to `>= 4`" bullet from `projects/endo-but-for-bots/followups/endo-but-for-bots--442.md` (the ledger then carries 2 items: the shared `ContentStoreFilePowers` helper deferral and the Phase-5 XS coverage deferral).
3. Proceed with fixer dispatch, then `gh pr ready 442`, then conductor sequence per the standard handoff.

## Notes on the audit

- The appellate's conservative bias held. The single appeal candidate cleared all three questions with no judgment-call softening (small: trivially yes; in-context: trivially yes; loss-track risk: explicit rule-citation about a known-weak assertion that the deferral would leave in the codebase). The other two follow-ups and all 21 acknowledges either failed small/in-context or carried explicit positive deferral rationale.
- No `[proposed-rule]` tags landed in the barrister's body; the single appealed finding carries the standing `skills/regression-evidence/SKILL.md § load-bearing assertions` citation, which the fixer can quote when composing the addressing commit's body.

Self-improvement: nothing this time. The barrister's disposition rubric held up well under appellate review: only one of 24 items warranted promotion, the modal "in-context + small + high loss-track" item (a known-weak assertion left in the same test file that introduces it), which is exactly the appellate's narrow target. The appeal-rate signal (1/24 = 4%) is in line with the conservative-bias norm. The `ContentStoreReader` typedef finding appearing in the review body but not in the followup ledger is a minor barrister-side hygiene gap (the ledger should mirror the body's `[follow-up]` set faithfully so the steward's per-cycle merge-watcher sees everything); flagging here in the result rather than as a separate `message: appellate -> gardener` because the omission did not affect the appellate's verdict and the next barrister run may surface the same gap, at which point a structural fix is warranted. Operational, not structural; no message to gardener.
