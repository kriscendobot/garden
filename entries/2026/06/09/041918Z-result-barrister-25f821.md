---
ts: 2026-06-09T04:19:18Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/09/035906Z-result-cleaner-73d540.md
---

# Code panel (first round) on PR #60: test(ses): replace deleted get-intrinsics test

PR: https://github.com/endojs/endo-but-for-bots/pull/60
Panel comment: https://github.com/endojs/endo-but-for-bots/pull/60#issuecomment-4656055777
PR head: `c2c1cd33b` (post-cleaner; rebased onto master `4a04d078b` plus one no-pull-citations hygiene commit)

## Pre-dispatch state check

`gh pr view 60 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt` returned `state: OPEN, isDraft: false, mergedAt: null`. The brief's framing applies despite `isDraft: false`: this is the "rerun-the-improved-gamut" variant the cleaner already established, the PR is six weeks old and has accumulated no panel verdict, and the maintainer's directive (`@kriscendobot This is pretty old. Please rerun the improved gamut.`) is the dispatch's authorization. No short-circuit fired.

## Panel composition

`bash garden/skills/panel-hints/panel-hints.sh --base master` returned `code-panel`, 14 of 26 seats, no overrides applied:

- Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober.
- Always-fire (2): scribe, releaser.
- Path-triggered (1): fast-checker (matched `packages/ses/test/get-intrinsics.test.js`).
- Content-triggered (2): spec-keeper (matched `shim`), warden (matched `globalThis`).
- Cross-panel (0): none.
- Suppressed (14): benchmarker, breaker, changeset-auditor, curator, gateway, migrator, pruner, surfacer, engine-realist, locksmith, purist, wire-watcher, copyeditor, pedant. None added back by barrister judgment; the diff is a single test file and the suppressed seats' lenses do not apply (no benchmark, no breaking-change surface, no new dep graph, no rename, no API export, no SES boundary cross beyond what `warden` already covers).

Plus the fire-and-forget `gh pr edit 60 -R endojs/endo-but-for-bots --add-reviewer @copilot` (returned `https://github.com/endojs/endo-but-for-bots/pull/60`).

## Panel execution

**Panel kind: code-panel. Panel execution: in-band-fallback.** The `Agent` tool was not in scope for this dispatch (ToolSearch for `Agent` returned no matches). Each seat's per-juror block was written one at a time against the seat's role file in `garden/roles/jurors/<seat>/AGENT.md`, in the order panel-hints emitted them, before aggregation. The body that landed in the PR comment carries each block in full plus the aggregated-dispositions tail.

## Verdict and disposition counts

Submission shape: posted as a **top-level PR comment** (`gh pr comment 60 -R endojs/endo-but-for-bots --body-file ...`) per the brief's explicit "post the verdict as a top-level comment on PR #60" framing. A formal `gh pr review --request-changes` would have been blocked by GitHub's self-author block (the PR's author is `kriscendobot` and the reviewing identity is also `kriscendobot`); the panel-review skill's pitfall covers this case. The comment carries the full panel body so the verdict is preserved; `reviewDecision` is not flipped (and is `""` for this PR).

Disposition counts:

- **must-fix-loop: 6.** All sit on the PR body, not the source diff. Six items from the cleaner's audit, now formally on the panel record: template-shape deviation, checklists in `## Test plan`, file-by-file callouts in body lines 12-13, em-dashes in body lines 5/24/25/26/27, ellipsis character in body line 20, methodology leak (first-person verification narrative in body). Bundle-addressable in one fixer dispatch. Sub-bullet: the `Closes #390` reference at the end of the body should also be qualified `Closes endojs/endo#390` per the cross-repo qualification the cleaner already applied to the in-source `#372` reference.
- **summary-fix: 0.** The PR body redraft absorbs everything the panel would otherwise bundle as summary-fix; no separate job-board post needed.
- **follow-up: 1.** Post-lockdown counterpart test for `getAnonymousIntrinsics`. Surfaced by saboteur and warden; the PR's test is pre-lockdown-only (deliberate per the test's leading comment). The follow-up ledger entry would propose adding a sibling test that runs after `lockdown()` to verify the same intrinsics survive the frozen-intrinsics pass. **Ledger append deferred** because: this is the first round, the PR's terminating shape under the rerun-the-improved-gamut variant is still being determined by the maintainer (the PR is non-draft already and the gamut may not run to un-draft on this turn), and the `[proposed-rule]` tag attached to the finding is the relevant carrier. If the steward decides to ferry this PR, the post-lockdown follow-up belongs in the upstream PR's ledger; if the PR merges as-is, the next time `getAnonymousIntrinsics` is touched will be the right moment to add the post-lockdown counterpart.
- **acknowledge: 3.** Closing `expectedKeys` deepEqual fail-closed check (prover, archivist); `t.true(actual === expected)` over `t.is` for iterator prototypes (saboteur); no changeset present and none warranted (releaser).
- **drop: 0.** No findings carried neither rule citation nor `[proposed-rule]` tag; nothing got dropped at aggregation.

## Source-side substance: clean

The test file (`packages/ses/test/get-intrinsics.test.js`, +351 / -0) passes the panel cleanly on every primary surface the dispatched seats own: correctness, types, naming, regression evidence, adversarial inputs, edge-case enumeration, spec rigor, and SES-boundary discipline. The fail-closed `expectedKeys` deepEqual at lines 346-350 is the load-bearing invariant the panel singled out as positive; the two regression experiments the PR body documents confirm the test reddens under intentional mis-assignment. The cleaner's no-pull-citations qualifier on the in-source `#372` reference is the only source-side hygiene fix needed.

## Post-loop actions

This round does **not** terminate the loop. With 6 `must-fix-loop` items, the orchestrator's next dispatch is a fixer that redrafts the PR body. Post-loop actions on first-round termination (summary-fix job, ledger append, gardener `[proposed-rule]` message, appellate dispatch, `gh pr ready`) do **not** apply on this round. Specifically:

- **No `summary-fix` job posted.** Zero summary-fix dispositions.
- **No followup ledger append.** Deferred per the rationale above (the follow-up's home depends on the gamut's eventual terminating shape; the `[proposed-rule]` tag in the panel body carries the finding for now).
- **No `to: gardener` `[proposed-rule]` message.** The two `[proposed-rule]` notes (post-lockdown counterpart test; existential-only tests do not require property-based shapes) are recorded in the panel body; if the gardener decides to harvest either into a standing rule, the panel-body text is the canonical source. Writing a separate message for two seat-internal proposals on a first-round panel would be premature.
- **No `gh pr ready` un-draft.** The PR is already `isDraft: false`; nothing to un-draft.

The next round is the **justice's**, not the barrister's, per the role file's "Hand off to the justice on the next round" norm.

## CI state at panel time

`browser-tests` was the lone non-green check at cleaner-result time (stalled on Playwright browser install, documented as upstream infra flakiness). Panel did not re-poll CI; the panel reads code rather than CI state. If `browser-tests` ultimately reds out, a shepherd dispatch can re-run the workflow; that is orthogonal to the panel verdict.

## Recommended next stage

**fixer** (PR-body redraft per the six `must-fix-loop` items above; no source-side changes). Reset the PR body to `.github/PULL_REQUEST_TEMPLATE.md`'s shape (`## Description` plus the six `### *Considerations` headings), fold the existing content section-by-section into the template, remove all em-dashes and the ellipsis character, remove the `- [x]` checklists, remove the file-by-file callouts in the existing `## Why a new test is needed` section, rewrite the methodology-leak paragraph in third-person declarative prose, and qualify the closing `Closes #390` as `Closes endojs/endo#390`. After the fixer's `result` lands, dispatch the **justice** for the re-run round (not the barrister); a clean justice re-run terminates the gamut. Because the PR is already `isDraft: false`, the terminating step is not `gh pr ready` but simply the comment-form submission of the justice's verdict.

Self-improvement: nothing this time. The in-band-fallback mode was straightforward on a single-file test PR; the 14-seat panel-hints recommendation was honored as-is and the disposition split (6 must-fix-loop on the PR body, 0 in the source, 1 follow-up, 3 acknowledge, 0 drop) reads cleanly. The decision to post as a top-level comment rather than a formal `gh pr review` follows the brief's explicit framing and side-steps the self-author block; the lesson is already captured in `skills/panel-review/SKILL.md` § Pitfalls (GitHub blocks `--request-changes` on a self-authored PR).
