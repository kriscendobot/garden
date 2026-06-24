---
ts: 2026-05-22T21:40:08Z
kind: result
role: fixer
project: endo-but-for-bots
host: endolinbot
slot: 3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
refs:
  - entries/2026/05/22/211703Z-dispatch-general-contractor-eb50c1.md
---

# Result: fixer eb50c1 — endo-but-for-bots#290 (lal pi-harness refactor)

Addressed all 5 inline-comment threads on PR #290 from the 2026-05-19/20 review (`reviewDecision: CHANGES_REQUESTED`, inline-comment-only).

## Inline-comment inventory

5 threads across 3 files:

- `packages/lal/agent.js`: 3 threads (line 84 type-guards, line 295 smallcaps+jcorbin, line 1607 lost-comments)
- `packages/lal/README.md`: 1 thread (line 42 prettier alignment)
- `packages/lal/primer/smallcaps.md`: 1 thread (line 7 overstated claim)

## Per-thread resolution

| File:line                | Reviewer(s)         | Resolution                                                                                                                                                              | Replied | Resolved |
| ------------------------ | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | -------- |
| `agent.js:84`            | kriskowal           | Code fix in `b5d903d0c`: new `packages/daemon/src/type-guards.js` exports `NameShape`/`NamePathShape`/`NameOrPathShape`/`NamesOrPathsShape`; daemon `interfaces.js` and lal `agent.js` both import from it; new `./type-guards.js` entry in `@endo/daemon` package exports; changeset added. | yes     | yes      |
| `agent.js:295`           | kriskowal, jcorbin  | No new commit: current code only coerces SmallCaps on per-tool `bigintArgs`; tool-call wire format stays in each pi-ai provider; primer rewritten as background. Cited the smallcaps-footgun test suite that pins the contract. No `parseJsonWithRepair` in lal's tree (jcorbin's note was about pi-ai internals). | yes     | yes      |
| `agent.js:1607`          | kriskowal           | No new commit: restored inline comments survived the branch retcon. Cited current line numbers (1244-1351).                                                              | yes     | yes      |
| `README.md:42`           | kriskowal           | No new commit: prettier-aligned tables survived the retcon; verified with `prettier --check`.                                                                            | yes     | yes      |
| `primer/smallcaps.md:7`  | kriskowal           | No new commit: deemphasized primer survived the retcon; overstated transparency claim is gone.                                                                            | yes     | yes      |

Top-level summary comment posted on the PR citing `b5d903d0c` and the per-thread resolution table.

## Commits pushed to `feat/lal-pi-harness`

- `b5d903d0c` refactor(daemon,lal): export pet-name shapes from `@endo/daemon/type-guards.js`

(Single atomic commit; no separate yarn.lock change because no dependency churn.)

## CI status at end of dispatch

12 pass, 8 pending, 6 fail. The 6 failures are all in `@endo/fae` (`test/configurations.test.js` + `test/cursor.test.js` hang with "Failed to exit when running test/cursor.test.js"). **Pre-existing flake**, not caused by this push: the same 8 jobs failed on the prior head `02eaaf2dd` in run 26143077811 with identical signatures. The lint, build, browser-tests, test262, zizmor, and test-async-hooks checks all pass; lal's own tests pass locally (`yarn test` in `packages/lal/` shows 17 pass + 1 skipped, including the `smallcaps-footgun` suite that pins the args-boundary contract).

Recommend the contractor dispatch a shepherd to drive the `@endo/fae` flake to green, or escalate to a justice if the panel deems the @endo/fae stall a blocker for un-draft. Out-of-scope per dispatch: did not un-draft (justice's call); did not dispatch the justice.

## Posture during dispatch

- 1 commit (`b5d903d0c`) authored under pinned `endolinbot` identity, pushed to `endojs/endo-but-for-bots@feat/lal-pi-harness`.
- 5 inline replies posted on PR #290 (one per thread).
- 5 `resolveReviewThread` GraphQL mutations succeeded.
- 1 top-level issue comment posted on PR #290 (the summary).
- No actions outside PR #290.

Self-improvement: when a branch's review-thread SHAs are absent from the current HEAD (retcon dropped the citation but the content survived), the fixer's per-thread reply should explicitly call out the retcon and re-cite the current line numbers so the reviewer can re-verify; a silent "outdated thread" leaves the reviewer guessing whether the work was lost or merely re-anchored.
