---
ts: 2026-06-24T10:38:07Z
kind: message
role: botanist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/06/24/103501Z-message-botanist-fe3588.md
  - entries/2026/05/25/193802Z-message-botanist-6166c6.md
---

# Dependabotany ledger row: endojs/endo-but-for-bots#197

Non-terminal verdict (HOLD, escalated). No embargo row and no recheck schedule:
the blocker is a merge conflict, not maturity, so the daily `dependabotany-recheck`
heartbeat is the wrong instrument. Appended to the `endojs/endo-but-for-bots`
dependabotany ledger under the standing `project: endo-but-for-bots` tag.

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [197](https://github.com/endojs/endo-but-for-bots/pull/197) | electron `^40.8.0` to `^42.0.1` in `@endo/familiar` + maintainer-directed ESM rework (base `llm`) | HOLD (escalate `next: weaver`) | n/a | OPEN | **Not a vanilla Dependabot PR.** Began as the electron 40->42 bump (commit `cf4f1ccc98`, author dependabot[bot]) but was taken over by a maintainer-directed ESM migration: 2 of 5 commits are authored by **kriskowal** (`35eff1d9f8` switch preload to ESM `.mjs`, `ed5542dd89` drop CJS bundle shims), with bot smoke-test + lockfile commits between. The thread is a multi-phase maintainer directive (Phase 1 = drop Node 18 from CI, merged as #232; Phase 2 = rebase onto post-#232 `llm`; Phase 3 = ESM rework). Pre-flight is therefore NOT "lockfile + manifest only" by design (source migration is the maintainer's intent), so the source-touching-Dependabot-PR REJECT rule does not fire; closing it would destroy directed maintainer work. **Supply-chain pre-assessment clean:** electron@42.0.1 published 2026-05-08 (47 days mature, well past the 7-day floor); no moved version under 24h old; OSV/GHSA shows no advisory on target 42.0.1 nor on current 40.9.3, so not CVE-repairing (no fast-track pressure). Lockfile transitive set is the `@electron/get` -> `got` install-time download stack only: `@electron/get` 2.0.3->5.0.0, `got` 11.8.6->14.6.6, `keyv` 4->5, `cacheable-lookup` 5->7, `normalize-url` 6->8, `p-cancelable` 2->4, `responselike` 2->4, `http2-wrapper` 1->2, with `cacheable-request`/`clone-response`/`json-buffer`/`@szmarczak/http-timer` and their `@types/*` dropped; all first-party sindresorhus/electron packages, nothing newly-introduced anomalous. **Blocker (decisive):** branch is **888 commits behind `llm`** (5 ahead, `status: diverged`), `mergeable: CONFLICTING` / `mergeStateStatus: DIRTY`; Dependabot has disabled auto-rebase (open >30 days). The 22-check green rollup is from 2026-05-12 against head `ed5542dd89` and was never validated against the current `llm` tip (`6da436b676`), so green-at-commit is both insufficient (major migration, payload not exercised by tests) and stale relative to base. Verdict comment posted ([issuecomment-4788361981](https://github.com/endojs/endo-but-for-bots/pull/197#issuecomment-4788361981)). Did NOT merge, did NOT close. |

## Escalation

`next: weaver` then a fresh botany pass. Recommended chain for the liaison:

1. **weaver** (rebase #197 onto current `llm`). The lockfile will conflict; the ESM
   bundle/preload rework was authored against a ~5-month-old `llm` tip, so expect the
   reconciliation to exceed a mechanical lockfile rebase. If the bundle pipeline or the
   daemon module-scope-await situation referenced in the PR body has shifted on `llm`
   since, a **builder** may be needed to re-land the ESM rework on the rebased base.
2. **shepherd** the rebased head to green (the recorded green is stale).
3. **re-botany** for the terminal MERGE-NOW / REJECT call. Because the supply-chain
   pre-assessment is already clean and 42.0.1 is mature, the re-assessment is cheap:
   confirm the rebase did not pull in a newer electron, re-run OSV against the final
   moved set, confirm CI green against the rebased head, then conduct.

Because the PR is maintainer-entangled (kriskowal-authored commits, directed migration),
the liaison should confirm with the maintainer whether to continue this PR or supersede
it before committing weaver/builder effort.

## Botanist self-notes for this PR

- **A dependabot[bot]-authored PR that a maintainer has commandeered is not subject to the source-touching REJECT rule.** The pre-flight "Dependabot PR that touches source is suspect" guard assumes Dependabot authored the source change. Check commit authorship: maintainer-authored commits on a dependabot branch mean the source touch is intentional, and the autonomous close authority does not apply (closing destroys directed work). Read the commit author list and the thread before pre-flight-rejecting.
- **A conflict short-circuits the terminal verdict; it is `next: weaver`, not MERGE-NOW/EMBARGO/REJECT.** Per the role's workflow step 6, a `mergeable: CONFLICTING` PR cannot be MERGE-NOW regardless of how clean the substance is. The verdict is HOLD with a weaver escalation, recorded as a non-terminal ledger row (no embargo date, no recheck schedule, since maturity is not the gate).
- **Cross-check the rollup against the base, not just the head SHA.** `gh api .../commits/<head>/check-runs` showed all-green at `ed5542dd89`, but `gh api repos/<r>/compare/<base>...<head>` showed `behind_by: 888, status: diverged`. Green-at-commit on a branch hundreds of commits behind base is stale CI; the merge has never been exercised. The compare endpoint is the cheap way to catch this before trusting a green rollup.
- **EMBARGO is for freshness, not for conflicts.** Maturity (47 days) was satisfied here, so no embargo row and no `dependabotany-recheck` schedule were added: the daily heartbeat acts on maturity dates and would be a no-op for a conflict-blocked PR. Adding one would have left a dead row to garbage-collect.
