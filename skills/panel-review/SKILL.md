---
created: 2026-05-13
updated: 2026-06-19
author: gardener
---

# Skill: panel-review

Adopted from `references/endo-but-for-bots/skills/panel-review-12-perspectives.md` and shaped for this garden's two-panel jury (twenty-six-seat code panel for source-touching PRs, seven-seat design panel for design-only PRs).

The aggregation discipline and submission contract for jury reviews. The defaults in `skills/pr-creation-flow/SKILL.md` § Jury composition are the **code panel** (twenty-six seats: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway, corner-prober, fast-checker, releaser) for source-touching PRs and the **design panel** (seven seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) for design-only PRs; both are dispatched by the three-judge family ([solicitor](../../roles/solicitor/AGENT.md) on design-only PRs; [barrister](../../roles/barrister/AGENT.md) on the first source-PR round; [justice](../../roles/justice/AGENT.md) on re-runs); the orchestrator picks which judge to dispatch per `roles/judge/AGENT.md` § Panel-kind discrimination. This skill describes how each panel's findings combine into one verdict and how the dispatched judge submits that verdict.

## When to use

- Every PR-creation-flow jury round, on either panel kind. The judge is the panel's foreperson (aggregates the per-juror blocks into one body and submits the formal review).
- A maintainer-requested standalone review of a stale PR. Same procedure; the orchestrator names the panel composition in the dispatch brief and the judge dispatches that composition.

## Panel composition

- **Default for source-touching PRs (code panel): twenty-six seats** (assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway, corner-prober, fast-checker, releaser), dispatched concurrently as a single panel round by the judge. See `skills/pr-creation-flow/SKILL.md` § Jury composition for the seat list, the halved-responsibilities rationale, the four 2026-05-15 maintainer-modeled additions, the 2026-05-18 addition of the `integrator` seat, the 2026-05-20 addition of the six PR-#75-derived narrow seats, and the 2026-05-21 addition of `corner-prober`, `fast-checker`, and `releaser`.
- **Default for design-only PRs (design panel): seven seats** (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice), dispatched concurrently as a single panel round by the judge. See `skills/pr-creation-flow/SKILL.md` § Jury composition for the seat list and the design-panel rationale. The judge discriminates between panels by the PR's file list per `roles/judge/AGENT.md` § Panel-kind discrimination.
- **Smaller panels** (3 to 6 seats from either default) are valid when the orchestrator names a reduced composition in the dispatch brief for a tiny PR. The aggregation discipline below applies unchanged.
- **Custom compositions** are valid when a maintainer's directive names them. The judge dispatches each named seat and aggregates them all. Cross-panel compositions are permitted (e.g., add the novice to a code-panel round when the PR's JSDoc revision warrants a new-reader's eye).

## Per-juror block shape

Each panel member returns:

```
### <perspective name>

**Verdict:** approve / request-changes / comment-only

**Findings:**
- (concrete actionable, file:line where applicable) [rule: <path>] OR [proposed-rule: <one-sentence proposal>]

**Notes (out of scope but worth flagging):**
- ... [rule: <path>] OR [proposed-rule: ...]
```

Each block under ~400 words. "Comment-only" is for taste; anything that warrants a code change is "request-changes".

Per the *Cite-or-propose discipline* below, every finding carries either a `[rule: <path>]` citation to the standing rule it enforces, or a `[proposed-rule: ...]` tag with a one-sentence proposal when the rule is novel. The judge drops findings that carry neither at aggregation.

## Aggregation

The judge groups findings into three buckets, then assigns one **disposition** to each finding (the disposition layer was added 2026-05-19; see *Dispositions* below).

The three buckets:

- **Must fix before merge** (any "request-changes" with concrete code / test / doc impact). The default disposition for items in this bucket is `must-fix-loop`; they drive the jury-fixer loop per `skills/pr-creation-flow/SKILL.md`.
- **Should fix in this PR** (taste or clarity items raised independently by at least two seats; on the seventeen-seat code panel the deliberate inquiry-area overlap means routine duplicate flagging is expected and is the signal "promote to should-fix"). Default disposition: `summary-fix`.
- **Out of scope / follow-up** (useful but not blocking this PR's loop). Default disposition: `follow-up`.

Dedupe overlapping findings. Where panel members disagree, present both views and pick the side most consistent with the project's `CLAUDE.md` (or `AGENTS.md`); make the disagreement explicit so the orchestrator can act.

The bucket is the rubric's input; the disposition is the output. The judge keeps the bucket structure (it is what jurors return) and adds a per-finding disposition column the rubric below picks.

## Dispositions

Every aggregated finding ends with one of five dispositions. The judge assigns the disposition at aggregation time per the rubric below. The disposition is recorded in the aggregated review body next to each finding so the maintainer can see at review time how the panel is responding to it:

| Disposition       | What it means                                                                                                | Where the work lives                                                       |
| ----------------- | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| **must-fix-loop** | Blocks un-draft. Standard jury-fixer loop iterates until the panel returns no must-fix-loop items.            | The fixer-loop machinery in `skills/pr-creation-flow/SKILL.md`.            |
| **summary-fix**   | Small, addressable without a panel re-run. The judge posts one `summary-fix` job to the job board bundling all summary-fix items for this round. One fixer dispatch addresses the bundle; no panel re-run; the un-draft is not blocked. | A `summary-fix` job in `journal/jobs/open/` (see `skills/job-board/SKILL.md`). |
| **follow-up**     | Useful but out of scope for this PR. The judge appends the item to `journal/projects/<slug>/followups/<repo>--<N>.md` with `status: parked`. The steward's per-cycle survey polls each parked ledger entry's PR (and its upstream mirror when set) for merge state and posts an `action-followups` job when any has merged. The follow-up is automatically revisited at merge time. | The followup ledger (see *Follow-up ledger* below).                       |
| **acknowledge**   | Real observation, no work warranted. The disposition itself is the response; the aggregated body records the reasoning ("noted; family-consistency choice is deliberate, see #146"). The maintainer reading the review sees the seat's finding and the judge's rationale. | The aggregated review body only. No further action.                       |
| **drop**          | Deliberate no-op on second read (the finding was wrong, or the panel disagreement resolved in favor of the PR's current shape). The judge's `result` entry carries a one-line rationale per dropped finding so the audit trail does not silently lose the panel work. | The judge's `result` journal entry.                                       |

### Cite-or-propose discipline

The 2026-05-20 framing addresses a load-bearing observation from PR #75: many of the maintainer's recurring complaints map to rules already documented in the garden's `skills/`, `roles/`, or the worktree-side CLAUDE.md, but the panel doesn't reliably read those rules and tag findings against them. The fix is structural: **every finding either cites a standing rule or proposes one**.

Each per-juror block tags every concrete finding with one of:

- **`[rule: <path>]`** — the standing rule the finding enforces, named by the file path that documents it. Examples: `[rule: skills/rename-discipline/SKILL.md]`, `[rule: skills/em-dash-style/SKILL.md]`, `[rule: worktrees/endojs-endo-but-for-bots/.../CLAUDE.md § Prettier]`. The judge's aggregation preserves the citation; the formal review body carries the citation alongside the finding so the maintainer can see at review time which standing rule the panel is enforcing.

- **`[proposed-rule]`** — the finding is novel; no standing rule exists today. The juror's block briefly proposes the rule (one sentence). The judge's post-loop actions grow a fourth action: write a `message: panel → gardener` entry inlining each `[proposed-rule]` finding's text and proposal. The gardener encodes accepted proposals into the relevant role / skill / CLAUDE.md on a subsequent dispatch; until then, the finding is recorded against `[proposed-rule]` and may still be addressed in the PR per its disposition.

A finding that carries **neither** citation is **dropped** at aggregation with the rationale "no rule cited and no proposed-rule note; the finding cannot be acted on systematically". The drop is the rubric's pressure on jurors to actually consult the standing instructions; the discipline aligns the panel's lens with the documented rule set rather than each juror's personal taste.

The cite-or-propose tag is **independent of the disposition tag**. A finding can be `[rule: skills/rename-discipline]` and `must-fix-loop`, or `[proposed-rule]` and `summary-fix`, or `[rule: ...]` and `acknowledge`. The two tags answer different questions: the rule citation answers "where does this come from"; the disposition answers "what do we do with it".

The 2026-05-20 framing for jurors: each seat's brief at dispatch time inlines the relevant standing-rule sections (per-seat skill file's *Notes from the field*, the worktree-side CLAUDE.md sections that touch the seat's surface). The juror reads those rules before producing findings; every finding then traces to a rule or a proposed rule.

### Disposition rubric

The judge classifies at aggregation by applying this rubric in order:

1. **Bucket-driven default.** Use the bucket's default disposition (must-fix-loop / summary-fix / follow-up) as the starting point.
2. **Demote on weak signal.** A bucket-default `summary-fix` whose underlying finding is single-seat, comment-only, and lacks a concrete actionable change demotes to `acknowledge`. Same for a single-seat `follow-up` whose value is informational.
3. **Demote on contradiction.** Any finding the panel itself disagrees on, where the side opposing the change has the stronger rationale per the project's conventions, demotes to `drop` with a one-line rationale.
4. **Promote on second-read error.** A `must-fix-loop` finding that fails a 30-second sanity check (e.g., the panel's "shadow" hallucination per *Pitfalls* below) demotes to `drop`.
5. **Bundle scoping for summary-fix.** Group all `summary-fix` items for this round into one job-board post. The fixer that claims it addresses the bundle in one dispatch; there is no per-item job overhead.
6. **Per-PR scoping for follow-up.** Append all `follow-up` items for this PR (across all rounds, if multiple panel rounds happen) to the same followup ledger file. The ledger is keyed by `(repo, pr_number)`, not by round.

The rubric's failure mode is fewest `acknowledge` and `drop` dispositions, not most: an unjudged finding always falls back to its bucket default. Aggressive demotion to `acknowledge` would silently consume panel work the same way today's un-action-on-clean does; the rubric is conservative.

### In-scope vs out-of-scope (legacy framing)

The pre-disposition framing (in-scope drives the loop; out-of-scope sits in the report) is now subsumed by the disposition layer:

- `must-fix-loop` is the load-bearing "in-scope" disposition. The jury-fixer loop iterates only on items with this disposition.
- `summary-fix` is "in-scope but defer one round": the work lands but does not block.
- `follow-up`, `acknowledge`, and `drop` are the dispositions for items previously categorized as out-of-scope or non-blocking.

See `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop for the loop's exit condition; the rule reduces to "no `must-fix-loop` items remain after the panel round".

### External-author calibration

When the PR under panel is **external-authored** (the GitHub `author.login` from `gh pr view <N> --json author` is not the host's bot identity — today: not `kriscendobot`, not `endolinbot`), the judge applies the following calibration at aggregation, in addition to the disposition rubric above:

1. **Garden-only prose conventions downgrade to `drop`.** Findings citing `skills/em-dash-style/SKILL.md` or `skills/no-latin-shorthand/SKILL.md` (both of which explicitly scope to *garden-authored* / *bot-authored* prose per their own `## Scope` sections) downgrade to `drop` with a one-line rationale ("garden convention; not in scope on external-author PR"). The convention applies to *garden-authored work*; external contributors follow the project's own house rules (the repo's `CONTRIBUTING.md`, existing `designs/`, prior accepted PRs' prose style).
2. **`proposed-rule` tags escalate to the gardener for the garden, not to the project.** A `[proposed-rule]` tag that the panel raises on an external-author PR is forwarded to the gardener as a candidate for *the garden's* role / skill encoding; it is *not* bundled into the formal review as a project-side ask. The aggregated review does not carry the tag as a finding against the external author's PR.
3. **Other findings unaffected.** Substantive findings (correctness, security, public-API impact, test coverage) apply uniformly regardless of authorship. The calibration narrowly covers garden-only *prose conventions* and *proposed-rule escalation*; the rest of the disposition rubric is unchanged.

The calibration's purpose: prevent the garden from imposing internal stylistic conventions on contributors whose work the garden is reviewing rather than producing. Provenance: liaison-to-gardener message 2026-06-19T01:34Z on `endojs/endo-but-for-bots#467` (solicitor `f8c3fa` had tagged 120 em-dash uses as `summary-fix` on a kumavis-authored design PR; the maintainer dropped the sweep and the calibration landed).

## Follow-up ledger

The producer-side discipline for the `follow-up` disposition. The ledger is a journal file per (project, repo, PR) that accumulates findings the judge deferred for the steward to revisit at merge time.

### Path

```
journal/projects/<slug>/followups/<repo-with-dash>--<pr-number>.md
```

Examples: `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--289.md`, `journal/projects/agoric-sdk/followups/kriscendobot-agoric-sdk--3.md`. The `<repo-with-dash>` form replaces `/` with `-` so the filename is single-segment.

The slug is the project slug per `roles/COMMON.md` § Project context (`endo-but-for-bots`, `agoric-sdk`, `garden`, etc.). The `<repo-with-dash>` is the actual repository the PR lives on, which may differ from the project slug when the PR is on a fork (e.g., `kriscendobot-agoric-sdk` for a PR on the bot's fork of `agoric-sdk`).

### Frontmatter schema

```yaml
---
project: <slug>
pr_repo: <owner/name>
pr_number: <int>
upstream_mirror_repo: <owner/name>   # optional; the boatman's ferried-upstream PR
upstream_mirror_pr: <int>            # optional; populated by the boatman when known
created_at: <ISO>                    # set at first append
last_appended_at: <ISO>              # bumped on each judge round that appends
status: parked | actioned | dropped
actioned_at: <ISO>                   # set when the steward posts the action job
actioned_via: jobs/done/<...>.md     # the job that processed the ledger (when status=actioned)
merge_event: <ISO>                   # the merge timestamp that triggered actioning
---

# Follow-ups for <repo>#<N>

## Items

- [ ] <finding text>  
  **Source juror(s)**: <seat>[, <seat>...]  
  **Round**: <N>  
  **Recommended action**: <what to do when the ledger actions; e.g. "file as issue on <repo>", "open follow-up PR with <scope>", "amend design doc <path>">

(one bullet per finding)
```

The body is the running list of items. The status field moves through parked → actioned (or dropped) as the steward's per-cycle survey processes the ledger.

### Producer rules (judge)

- The judge writes or appends to the ledger as part of the post-aggregation work, **before** un-drafting. The append is one journal commit per panel round; multiple rounds on the same PR all append to the same ledger file.
- If the file does not exist, the judge creates it with `status: parked` and `created_at: <now>`. The `last_appended_at:` field gets bumped on each subsequent append.
- The judge does not populate `upstream_mirror_*` fields itself; those land later when a boatman ferries the PR and the boatman's `result` entry knows the upstream PR number. A separate scout-style sweep keeps the mirror fields current per the steward's merge-watch sub-step.

### Consumer rules (steward)

- The steward's per-cycle survey scans `journal/projects/*/followups/*.md` for `status: parked` entries (per `roles/steward/AGENT.md` § Parked followup revisit).
- For each parked entry, poll the PR's merge state via `gh pr view <pr_number> -R <pr_repo> --json state,mergedAt`. If `mergedAt` is non-null, the PR merged.
- If `upstream_mirror_pr` is set, also poll the upstream mirror. Either merge triggers actioning.
- When actioning, the steward posts an `action-followups` job to `journal/jobs/open/` with the ledger's items inlined as the brief and `eligible_roles: [steward, liaison]`. The job's body is the same shape the ledger carries; the consumer that claims dispatches the appropriate role (builder for items warranting a follow-up PR; liaison for items warranting an issue file or a design-doc amendment).
- After the action job is posted, the steward updates the ledger's `status: actioned`, `actioned_at: <now>`, `merge_event: <merge-ISO>`, `actioned_via: jobs/open/<path>`. The path becomes a `jobs/done/...` path after the consumer completes the job; the steward updates the ledger on the matching completion event.

### Why merge is the trigger

A follow-up filed pre-merge is premature: the maintainer may close the PR, reshape it, or address the item directly. Filing on merge is precisely when the follow-up becomes load-bearing — the PR landed and the deferred items are now real debt rather than possible debt. The maintainer's framing on 2026-05-19: *"Use the journal, but arrange for the follow-up to be revisited automatically by the steward when the PR is merged or its mirror is merged upstream."*

## Posting the review

**Submit as a formal review, not a plain comment.** A plain `gh pr comment` does not flip `reviewDecision`, so the orchestrator's dispatch matrix never sees the verdict and the jury-fixer loop never advances.

```sh
# Any must-fix-loop disposition present → request-changes (loop continues):
gh pr review <N> -R <repo> --request-changes --body-file /tmp/panel.md
# Any summary-fix, follow-up, or acknowledge disposition but no must-fix-loop:
gh pr review <N> -R <repo> --comment --body-file /tmp/panel.md
# All findings are drop or the panel net-approves with no findings:
gh pr review <N> -R <repo> --approve --body-file /tmp/panel.md
```

The submission verdict is keyed off the dispositions, not the raw buckets: any `must-fix-loop` disposition forces `--request-changes`; otherwise `--comment` is the default if any disposition above `drop` is present; `--approve` lands only on a fully clean or fully dropped panel.

The judge submits the formal review. The body is the same aggregated report (typically 2300 to 3600 words for the twenty-six-seat code-panel default, 900 to 1400 words for the seven-seat design-panel default; smaller panels run shorter still). Cite findings by perspective grouped where members agreed; do not list individual agent names. Each finding line carries its disposition in a leading tag plus the rule citation (or proposed-rule note) so the maintainer can scan the body for what is being deferred and which rule the panel is enforcing:

```
- **[must-fix-loop]** `packages/foo/src/bar.js:42` — `harden(x)` missing on the returned object. [rule: worktrees/.../CLAUDE.md § harden-on-exports]
- **[summary-fix]** `packages/foo/src/bar.js:18` — JSDoc parameter type drift (`string` should be `string | undefined`). [rule: skills/pre-push-gates/probes/no-inline-import-jsdoc.sh]
- **[follow-up]** Adjacent refactor opportunity in `packages/baz/src/quux.js`; not in this PR's scope but worth picking up after merge. [rule: skills/changeset-discipline/SKILL.md § scope-by-package]
- **[acknowledge]** Naming choice `frob` vs `frobnicate` was flagged by stylist; family-consistency choice is deliberate per `designs/naming.md`. [rule: skills/rename-discipline/SKILL.md]
- **[drop]** Variable-shadowing claim on line 31 is a panel hallucination; the names are in different lexical scopes. [rule: skills/panel-review/SKILL.md § Pitfalls (shadow false-positives)]
- **[summary-fix]** `packages/random/README.md`: section "About this document" pads with no reader benefit. [proposed-rule: README boilerplate sections beneath the reader's needs should be omitted]
```

The summary-fix job is posted **after** the review submission and **before** un-drafting; the followup ledger is appended on the same beat; the proposed-rule message to the gardener is written on the same beat (per *Cite-or-propose discipline*). The un-draft is the last step of the round.

## Pre-dispatch state check

Every judge dispatch (`solicitor`, `barrister`, `justice`) runs a top-of-dispatch precondition probe before any `panel-hints` invocation or juror fan-out:

```sh
gh pr view <N> -R <owner>/<repo> --json state,isDraft,mergedAt
```

Short-circuit to a `no-op` `result` when any of:

- `state != "OPEN"` (the PR is `CLOSED` or `MERGED`).
- `isDraft == false` (the PR has been un-drafted already; the chain's terminal step has run, and a panel pass here would be a discipline violation by re-reviewing a post-draft PR). The exception is the maintainer-requested standalone-review variant where the dispatch brief explicitly names a stale post-draft PR.

The short-circuit's `result` entry uses verdict `no-op (closed-before-panel)` or `no-op (already-un-drafted)`, with the disposition counts all zero. No juror is dispatched, no `gh pr review` is submitted, no `@copilot` re-request fires. The PR-state-changed-between-dispatch-and-pickup case (most often a liaison `gh pr close` 20 to 60 seconds before the dispatched judge wakes; on a parallelized contractor or a steward per-cycle scan the window widens) thus costs one `gh` call rather than twenty-six juror dispatches plus the same number of worktree triples.

Precipitating evidence: barrister dispatch `22271c` against `endojs/endo-but-for-bots#421` at 2026-06-03T23:41:31Z, 27 seconds after the liaison's `gh pr close` on the same PR at 23:41:04Z. The barrister read the PR state at top-of-dispatch and short-circuited cleanly; the rule is now standing per `journal/entries/2026/06/03/234132Z-message-barrister-f3ef40.md`.

## Concurrent dispatch and in-band fallback

The judge role (in any of its three specializations — `solicitor`, `barrister`, `justice`) prepares one dispatch-root worktree per juror seat and invokes `Agent` once per seat. Concurrent fan-out is the default at every panel size (twenty-six seats for the code panel, seven for the design panel); sequential dispatch is valid only when the orchestrator explicitly requests it (e.g., when one seat's findings should inform another's). After every juror returns, the judge runs `dispatch-teardown.sh` on each dispatch root.

The dispatched seat list is computed by `skills/panel-hints/panel-hints.sh` at top-of-dispatch. The script discriminates the panel kind (code vs design) from the diff's path set, lists the always-on core (9 code-panel seats; design panel is wholesale-7), lists the always-fire seats (2 on the code panel: `scribe` and `releaser`, whose signals live outside the diff), runs per-seat probes under `skills/panel-hints/probes/` against the diff, and emits the fired seats in path-triggered and content-triggered sections plus a cross-panel section for design seats firing on substantial markdown in a code PR. The script's bias is toward firing — any positive signal triggers the seat — so the recommended set is typically 12-22 seats on a code-panel first round, 10-18 on a re-run, and 7 on a design-only PR. The judge dispatches the recommended set as the default and may add any suppressed seat (or remove any fired seat) per its own judgment; the `result` entry records the script's output verbatim and the overrides. The full per-seat probe catalog and the policy rationale live on `skills/panel-hints/SKILL.md`.

For code-panel rounds (`barrister` and `justice`), one fire-and-forget shell call fires alongside the juror dispatches:

```sh
gh pr edit <N> -R <owner>/<repo> --add-reviewer @copilot
```

The call is idempotent on re-rounds. The design panel (`solicitor`) does not fire `@copilot`: the design surface is prose, not code, and Copilot's code-review heuristics do not apply.

### In-band fallback

Some Claude Code harnesses do not surface the `Agent` (or `Task`) tool to a subagent. The judge tolerates the absence by running the panel in-band against the per-seat role files, at the cost of the panel-bias-isolation property the role names explicitly ("a foreperson who also reviews biases the aggregation toward its own findings"). Treat in-band mode as a compensated fallback, not as a posture choice.

Procedure per dispatch:

1. **Top-of-dispatch tool-availability check.** Make one cheap probe, either a `ToolSearch` for "Agent" / "task spawn" / "subagent dispatch", or one trial `Agent` invocation against a no-op task. Absence (the query returns nothing and no `Agent` tool is in scope) triggers in-band mode for the rest of the dispatch. The check is one call, not a retry loop; if the answer is ambiguous, fall to in-band.
2. **In-band mode: each seat is a single block, written one at a time.** Read the seat's role file in `<dispatch-root>/garden/roles/jurors/<seat>/AGENT.md`, write that seat's per-juror block against the **primary surface only** the role file names, and call out the secondary-overlap slice deliberately ("breaker note: this is also archivist's secondary surface; flagging here so aggregation can dedupe"). Move to the next seat only after the current block is complete. The discipline replaces the bias isolation a separate subagent would have given: each block is bounded by its own role file before the next block is read.
3. **Aggregation runs after all seats land, not concurrently with any of them.** Do not start the must-fix / should-fix / out-of-scope partition while seats are still being written; the partition's job is dedupe across the whole panel, and partial-panel dedupe biases the survivors. This applies to both panel sizes (twenty-six seats for the code panel, seven for the design panel).
4. **One formal `gh pr review`** per *Posting the review* above, exactly as in the multi-seat-dispatch case. The submission contract does not change with the mode.
5. **The `result` entry names the mode and the panel kind** ("Panel execution: multi-seat-dispatch" or "Panel execution: in-band-fallback"; "Panel kind: code-panel" or "Panel kind: design-panel") so the audit trail records which discipline was active and which seat list ran. These are two extra lines; future maintainers (and the gardener's merged-PR feedback watch) can grep for either.

The mode is per-dispatch, not per-judge. A subsequent judge dispatch with the `Agent` tool in scope runs the multi-seat default; one with the tool absent runs in-band. The orchestrator does not need to know which mode the judge will use.

## Pitfalls

- **Panel-report prose is not exempt from the project style rules.** The aggregated body ships in a public PR review. The same prose rules apply (no em-dashes per `skills/em-dash-style/SKILL.md`, no methodology leaks per `skills/pre-pr-checklist/SKILL.md`). Sweep the body before submitting.
- **A "shadow" finding may be a panel hallucination.** Variable-shadowing claims need a 30-second sanity check before promoting to a should-fix item. Re-read the offending lines and confirm they are in the same lexical scope. A panel run that reads the diff once can mis-name a parameter as shadowing an outer const that lives in a different function.
- **Sibling-package forks miss recent peer fixes.** When a PR introduces a package by forking an existing peer, the correctness perspective should diff the new sibling against the peer's recent commits for fixes that landed between the fork point and the PR's submission. A one-line check that pays for itself on every sibling-fork PR.
- **GitHub blocks `--request-changes` on a self-authored PR.** When the authenticated identity is also the PR's author, the submission returns a GraphQL error. Fall back to `--comment` with the full body; the verdict is preserved in the body, but `reviewDecision` does not flip. The orchestrator's dispatch matrix that keys on `reviewDecision` also keys on the "Must-fix before merge" heading in the body for bot-authored PRs.
- **Design-plus-implementation in one PR needs a design-assessment posture.** When a PR implements all phases of a design as a single deliverable explicitly to assess the design's completeness, the panel's job grows beyond "is this code correct" to include "did the design specify enough to implement, and where did the builder fill in gaps?". The aggregate body carries an "Out of scope but worth flagging (design feedback)" section listing the panel's answers, intended as input back to the design PR rather than as fixer-brief items.

## Notes from the field

- _2026-05-21_: three more narrow code-panel seats land. `corner-prober` (edge-and-corner-case enumeration distinct from saboteur and breaker; walks per-domain boundary sets and flags missing test coverage). `fast-checker` (a partisan of `fast-check`-shaped property-based testing). `releaser` (reads from the upgrading user's perspective; decides whether a changeset belongs at all and whether its content is addressed to an upgrading user; refactorings and internal maintenance do not warrant changesets; severe bug fixes do). Code panel grows from twenty-three to twenty-six. Same day, the 30 jury role files moved from `roles/<seat>/` to `roles/jurors/<seat>/` so the top-level `roles/` index reads as orchestrator-dispatchable roles only.
- _2026-05-20_: cite-or-propose discipline added; six new narrow code-panel seats land (benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway); code panel grows from seventeen seats to twenty-three. The 2026-05-20 framing (the maintainer's): *"PR #75 is an example of a change that required many rounds of feedback from maintainers and continues to churn. We may need deterministic heuristics and post-build / post-fix hooks to automate recurring feedback, permanent jurors for very narrowly scoped feedback. Many feedback items are in the standing instructions. A larger panel with more focused responsibilities may help."* The four-layer response: pre-push gates (deterministic; `skills/pre-push-gates/SKILL.md`); cite-or-propose discipline (force panel to consult standing rules); six narrow seats (focused responsibilities); proposed-rule routing to the gardener. PR #75's 71 inline comments + 14 top-level comments across 16 reviews were the empirical catalog.
- _2026-05-19_: disposition layer added per the maintainer's framing that the judge "is not responding to all of the aggregate feedback of the jury". Pre-change behavior: the judge un-drafted as soon as must-fix was empty, leaving should-fix and out-of-scope items in the public review body where they were, in practice, ignored. The 2026-05-15 PR #75 panel run (`entries/2026/05/15/051017Z-result-judge-199aa7.md`, "Gamut complete: 0 must-fix items, all 12 seats comment-only") is the worked example of feedback going nowhere. Post-change behavior: every non-must-fix finding gets one of four explicit dispositions (summary-fix / follow-up / acknowledge / drop); summary-fix lands as a job-board post; follow-up lands in the per-PR ledger and is revisited on merge by the steward. Settled decisions in this round: judge classifies at aggregation (not jurors); summary-fix does not block un-draft; follow-up lives in the journal with the steward as merge-watcher.
- _2026-05-13_: adopted from the reference and reshaped for the 2-member default panel (juror plus saboteur). The reference's 12-perspective form was preserved as a larger-panel option.
- _2026-05-14_: redesign. The default panel grew from 2 seats to 6 named seats (assessor, stylist, archivist, curator, locksmith, saboteur), the judge role was introduced as the panel's foreperson (it aggregates and submits, but is not itself a reviewer), and per-juror block submission migrated from "the juror is the panel-side editor" to "each seat returns a block, the judge aggregates". The orchestrator names a different composition in the dispatch brief when the default does not fit.
- _2026-05-14_ (same day, later): twelve-seat default. The maintainer's directive was to halve each seat's responsibilities so the panel could be deeper in each inquiry area. Each of the six prior seats split into two successor seats; concurrent dispatch became the explicit default at twelve. The aggregation discipline (must-fix / should-fix / out-of-scope grouping, dedupe of overlapping findings) is unchanged.
- _2026-05-14_ (later same day): design panel landed in parallel to the code panel. The five-seat design panel (critic, skeptic, copyeditor, pedant, novice) reviews design-only PRs (file additions only under `<project>/designs/`); the existing twelve-seat code panel reviews source-touching PRs. The judge picks the panel per `roles/judge/AGENT.md` § Panel-kind discrimination. The aggregation discipline is unchanged; only the seat list and the typical aggregated-body word range differ.
- _2026-05-15_: design panel grew from five seats to seven. Two new seats joined: the `decomplector` (Rich-Hickey-lens reader on complexity / state / identity / value modeling) and the `ergonomist` (interface-ergonomics reader on the proposed API or UI surface). The aggregated-body word range for the design panel was widened to roughly 900 to 1400 words to absorb the two additional seats' blocks. The aggregation discipline is unchanged.
