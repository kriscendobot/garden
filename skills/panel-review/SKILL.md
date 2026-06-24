---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: panel-review

The per-seat **review procedure** and the **disposition rubric** for the scripted jury panel. This is the substance the scripted panel run delegates to its seats and to its aggregate-and-decide step: how each seat produces its block, how the cite-or-propose discipline constrains every finding, how findings bucket and earn one of five dispositions, and how that aggregate becomes a posted GitHub review.

The control flow that runs the panel is the scripted panel run a gardener supervises (`scripts/jobs/gardening/panel.sh`); see [panel](../panel/SKILL.md) for the state machine (sense panel kind → fan one `claude -p` per seat → decide disposition → fixer-loop → appellate → un-draft) and the v1-role mapping. This skill is the *content* of the `seat_review` and `decide_disposition` hooks that panel describes; the two are companions and should be read together. In v1 this procedure was carried out by a judge agent (solicitor / barrister / justice) acting as the panel foreperson, dispatching jurors via `Agent` and aggregating by hand; in v2 the same procedure runs inside the supervised script — each seat is one `claude -p` over `roles/jurors/<seat>/AGENT.md`, and the aggregate-and-decide step is one `claude -p` the script invokes.

> Overlap note: much of the panel composition and the control-flow narrative also lives in [panel](../panel/SKILL.md). This skill keeps the per-seat block shape, the cite-or-propose discipline, the disposition rubric, the follow-up ledger, and the review-posting contract — the substance panel/SKILL.md delegates rather than restates. Where they touch (panel composition, panel-kind sensing), this skill defers to panel/SKILL.md.

## When to use

- Every panel round, on either panel kind. The seat hook reads this skill's *Per-juror block shape* and *Cite-or-propose discipline*; the decide hook reads this skill's *Aggregation*, *Dispositions*, and *Disposition rubric*.
- A maintainer-requested standalone review of a stale PR. Same procedure; the supervisor names a reduced seat list via the panel script's env overrides.

## Panel composition

- **Default for source-touching PRs (code panel): twenty-six seats** (assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway, corner-prober, fast-checker, releaser).
- **Default for design-only PRs (design panel): seven seats** (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice).
- **Smaller panels** (3 to 6 seats from either default) are valid when the supervisor names a reduced composition (`GARDEN_CODE_SEATS` / `GARDEN_DESIGN_SEATS`) for a tiny PR. The aggregation discipline below applies unchanged.
- **Custom and cross-panel compositions** are valid when a maintainer's directive names them (e.g., add the novice to a code-panel round when a JSDoc revision warrants a new-reader's eye).

Panel-kind sensing (code vs design, by the diff's path set) is the panel script's `sense_panel_kind` step; the recommended seat subset for a given diff is [panel-hints](../panel-hints/SKILL.md). This skill takes the seat list as given.

## Per-juror block shape

Each seat returns:

```
### <perspective name>

**Verdict:** approve / request-changes / comment-only

**Findings:**
- (concrete actionable, file:line where applicable) [rule: <path>] OR [proposed-rule: <one-sentence proposal>]

**Notes (out of scope but worth flagging):**
- ... [rule: <path>] OR [proposed-rule: ...]
```

Each block under ~400 words. "Comment-only" is for taste; anything that warrants a code change is "request-changes". Every finding carries either a `[rule: <path>]` citation or a `[proposed-rule: ...]` tag (see *Cite-or-propose discipline*); the decide step drops findings that carry neither at aggregation.

## Aggregation

The decide step groups findings into three buckets, then assigns one **disposition** to each finding.

The three buckets:

- **Must fix before merge** (any "request-changes" with concrete code / test / doc impact). Default disposition: `must-fix-loop`; these drive the panel's fixer loop.
- **Should fix in this PR** (taste or clarity items raised independently by at least two seats; on the code panel the deliberate inquiry-area overlap means routine duplicate flagging is expected and is the signal "promote to should-fix"). Default disposition: `summary-fix`.
- **Out of scope / follow-up** (useful but not blocking this round). Default disposition: `follow-up`.

Dedupe overlapping findings. Where seats disagree, present both views and pick the side most consistent with the project's `CLAUDE.md` (or `AGENTS.md`); make the disagreement explicit so the supervisor can act.

The bucket is the rubric's input; the disposition is the output.

## Dispositions

Every aggregated finding ends with one of five dispositions, recorded next to the finding in the aggregated body so the maintainer can see how the panel is responding:

| Disposition       | What it means                                                                                                | Where the work lives                                                       |
| ----------------- | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| **must-fix-loop** | Blocks un-draft. The panel's fixer loop iterates until no must-fix-loop items remain.                        | The fixer stage of the scripted panel run (`GARDEN_PANEL_FIXER`); see [panel](../panel/SKILL.md). |
| **summary-fix**   | Small, addressable without a panel re-run. All summary-fix items for the round are bundled and handed to one fixer pass; no panel re-run; the un-draft is not blocked. | A bundled fixer pass within the run (or a posted job for a separate consumer per [job-board](../job-board/SKILL.md)). |
| **follow-up**     | Useful but out of scope for this PR. Appended to the follow-up ledger with `status: parked`; revisited automatically at merge time. | The follow-up ledger (see *Follow-up ledger*).                            |
| **acknowledge**   | Real observation, no work warranted. The disposition itself is the response; the aggregated body records the reasoning. | The aggregated review body only. No further action.                       |
| **drop**          | Deliberate no-op on second read (the finding was wrong, or a panel disagreement resolved in favor of the PR's current shape). A one-line rationale is recorded per dropped finding in the run dir so the audit trail does not silently lose the panel work. | The run dir (`GARDEN_PANEL_RUNDIR`).                                       |

### Cite-or-propose discipline

The load-bearing observation from PR #75: many recurring maintainer complaints map to rules already documented in the garden's `skills/`, `roles/`, or the worktree-side CLAUDE.md, but seats don't reliably read those rules and tag findings against them. The fix is structural: **every finding either cites a standing rule or proposes one**.

Each per-juror block tags every concrete finding with one of:

- **`[rule: <path>]`** — the standing rule the finding enforces, named by the file path that documents it. Examples: `[rule: skills/rename-discipline/SKILL.md]`, `[rule: skills/em-dash-style/SKILL.md]`, `[rule: worktrees/.../CLAUDE.md § Prettier]`. The aggregate preserves the citation; the posted review carries it alongside the finding so the maintainer can see which standing rule the panel is enforcing.
- **`[proposed-rule]`** — the finding is novel; no standing rule exists today. The block proposes the rule in one sentence. After the round, each `[proposed-rule]` finding is forwarded to the gardener over the message bus (`send-msg.sh role/gardener …`, inlining the finding text and proposal) per [message-bus](../message-bus/SKILL.md). The gardener encodes accepted proposals into the relevant role / skill / CLAUDE.md on a later run; until then the finding is recorded against `[proposed-rule]` and may still be addressed per its disposition.

A finding that carries **neither** is **dropped** at aggregation with the rationale "no rule cited and no proposed-rule note; the finding cannot be acted on systematically". The drop is the rubric's pressure on seats to consult the standing instructions.

The cite-or-propose tag is **independent of the disposition tag**: a finding can be `[rule: …]` and `must-fix-loop`, or `[proposed-rule]` and `summary-fix`, or `[rule: …]` and `acknowledge`. The rule citation answers "where does this come from"; the disposition answers "what do we do with it".

Each seat's brief inlines the relevant standing-rule sections (its juror role file's *Notes from the field*, the worktree-side CLAUDE.md sections touching the seat's surface). The seat reads those rules before producing findings; every finding then traces to a rule or a proposed rule.

### Disposition rubric

The decide step classifies at aggregation by applying this rubric in order:

1. **Bucket-driven default.** Use the bucket's default disposition (must-fix-loop / summary-fix / follow-up) as the starting point.
2. **Demote on weak signal.** A bucket-default `summary-fix` whose underlying finding is single-seat, comment-only, and lacks a concrete actionable change demotes to `acknowledge`. Same for a single-seat `follow-up` whose value is informational.
3. **Demote on contradiction.** Any finding the panel itself disagrees on, where the side opposing the change has the stronger rationale per the project's conventions, demotes to `drop` with a one-line rationale.
4. **Promote-to-drop on second-read error.** A `must-fix-loop` finding that fails a 30-second sanity check (e.g., the panel's "shadow" hallucination per *Pitfalls*) demotes to `drop`.
5. **Bundle scoping for summary-fix.** Group all `summary-fix` items for the round into one fixer pass; no per-item overhead.
6. **Per-PR scoping for follow-up.** Append all `follow-up` items for this PR (across rounds, if multiple) to the same ledger file, keyed by `(repo, pr_number)`, not by round.

The rubric's failure mode is fewest `acknowledge`/`drop`, not most: an unjudged finding always falls back to its bucket default. The rubric is conservative.

### External-author calibration

When the PR is **external-authored** (the GitHub `author.login` from `gh pr view <N> --json author` is not the host's bot identity — not `kriscendobot`, not `endolinbot`), apply the following at aggregation, in addition to the rubric:

1. **Garden-only prose conventions downgrade to `drop`.** Findings citing [em-dash-style](../em-dash-style/SKILL.md) or [no-latin-shorthand](../no-latin-shorthand/SKILL.md) (both scoped to *garden-authored* prose per their own `## Scope`) downgrade to `drop` with the rationale "garden convention; not in scope on external-author PR". External contributors follow the project's own house rules (`CONTRIBUTING.md`, existing `designs/`, prior accepted PRs' prose style).
2. **`proposed-rule` tags escalate to the gardener for the garden, not to the project.** A `[proposed-rule]` raised on an external-author PR is forwarded to the gardener over the message bus as a candidate for *the garden's* role/skill encoding; it is *not* bundled into the posted review as a project-side ask.
3. **Other findings unaffected.** Correctness, security, public-API impact, and test-coverage findings apply uniformly regardless of authorship. The calibration narrowly covers garden-only prose conventions and proposed-rule escalation.

Purpose: prevent the garden from imposing internal stylistic conventions on contributors whose work it is reviewing rather than producing. Provenance: liaison-to-gardener message 2026-06-19 on `endojs/endo-but-for-bots#467` (a design panel had tagged 120 em-dash uses as `summary-fix` on a kumavis-authored design PR; the maintainer dropped the sweep and the calibration landed).

## Follow-up ledger

The producer-side discipline for the `follow-up` disposition. The ledger is a journal file per (project, repo, PR) accumulating findings deferred for revisit at merge time.

### Path

```
journal/projects/<slug>/followups/<repo-with-dash>--<pr-number>.md
```

Examples: `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--289.md`, `journal/projects/agoric-sdk/followups/kriscendobot-agoric-sdk--3.md`. The `<repo-with-dash>` form replaces `/` with `-` so the filename is single-segment. The slug is the project slug per `roles/COMMON.md`; the `<repo-with-dash>` is the actual repository the PR lives on (which may differ from the slug when the PR is on a fork).

### Frontmatter schema

```yaml
---
project: <slug>
pr_repo: <owner/name>
pr_number: <int>
upstream_mirror_repo: <owner/name>   # optional; the ferried-upstream PR
upstream_mirror_pr: <int>            # optional; populated when the ferry knows it
created_at: <ISO>                    # set at first append
last_appended_at: <ISO>              # bumped on each round that appends
status: parked | actioned | dropped
actioned_at: <ISO>                   # set when the action job is posted
actioned_via: jobs/tada/<...>        # the job that processed the ledger
merge_event: <ISO>                   # the merge timestamp that triggered actioning
---

# Follow-ups for <repo>#<N>

## Items

- [ ] <finding text>
  **Source seat(s)**: <seat>[, <seat>...]
  **Round**: <N>
  **Recommended action**: <what to do when the ledger actions; e.g. "file as issue on <repo>", "open follow-up PR with <scope>", "amend design doc <path>">

(one bullet per finding)
```

### Producer rules (the panel run)

- The ledger is written or appended as part of the round's post-aggregation work, **before** un-draft. One journal commit per round; multiple rounds on the same PR all append to the same file.
- If the file does not exist, create it with `status: parked` and `created_at: <now>`; bump `last_appended_at:` on each subsequent append.
- The run does not populate `upstream_mirror_*`; those land later when a ferry carries the PR upstream and knows the upstream number.

### Consumer rules (the merge-watch producer)

In v2 there is no steward. The merge-watch is a **producer** (a triager or the watchman per [job-board](../job-board/SKILL.md) § producers) running on a cadence:

- Scan `journal/projects/*/followups/*.md` for `status: parked` entries.
- For each, poll the PR's merge state via `gh pr view <pr_number> -R <pr_repo> --json state,mergedAt`. If `mergedAt` is non-null, the PR merged. If `upstream_mirror_pr` is set, also poll the mirror; either merge triggers actioning.
- On actioning, **post an `action-followups` job** to the board (`post-job.sh`, items inlined as the brief) per [job-board](../job-board/SKILL.md). A gardener claims it and acts (a follow-up-PR build for items warranting one; an issue file or design-doc amendment otherwise).
- After posting, update the ledger: `status: actioned`, `actioned_at: <now>`, `merge_event: <merge-ISO>`, `actioned_via: jobs/...`.

### Why merge is the trigger

A follow-up filed pre-merge is premature: the maintainer may close the PR, reshape it, or address the item directly. Filing on merge is precisely when the follow-up becomes load-bearing. Maintainer framing 2026-05-19: *"Use the journal, but arrange for the follow-up to be revisited automatically when the PR is merged or its mirror is merged upstream."*

## Posting the review

**Submit as a formal review, not a plain comment.** A plain `gh pr comment` does not flip `reviewDecision`, so downstream automation never sees the verdict and the fixer loop never advances.

```sh
# Any must-fix-loop disposition present → request-changes (loop continues):
gh pr review <N> -R <repo> --request-changes --body-file <run-dir>/review.md
# Any summary-fix, follow-up, or acknowledge disposition but no must-fix-loop:
gh pr review <N> -R <repo> --comment --body-file <run-dir>/review.md
# All findings are drop or the panel net-approves with no findings:
gh pr review <N> -R <repo> --approve --body-file <run-dir>/review.md
```

The submission verdict is keyed off the dispositions, not the raw buckets: any `must-fix-loop` forces `--request-changes`; otherwise `--comment` is the default if any disposition above `drop` is present; `--approve` lands only on a fully clean or fully dropped panel.

The body is the aggregated report (typically 2300 to 3600 words for the 26-seat code panel, 900 to 1400 for the 7-seat design panel; smaller panels run shorter). Group findings by perspective where seats agreed; do not list individual seat names beyond the perspective heading. Each finding line carries its disposition in a leading tag plus the rule citation (or proposed-rule note):

```
- **[must-fix-loop]** `packages/foo/src/bar.js:42` — `harden(x)` missing on the returned object. [rule: worktrees/.../CLAUDE.md § harden-on-exports]
- **[summary-fix]** `packages/foo/src/bar.js:18` — JSDoc parameter type drift (`string` should be `string | undefined`). [rule: skills/pre-push-gates/probes/no-inline-import-jsdoc.sh]
- **[follow-up]** Adjacent refactor opportunity in `packages/baz/src/quux.js`; not in this PR's scope but worth picking up after merge. [rule: skills/changeset-discipline/SKILL.md § scope-by-package]
- **[acknowledge]** Naming choice `frob` vs `frobnicate` flagged by stylist; family-consistency choice is deliberate per `designs/naming.md`. [rule: skills/rename-discipline/SKILL.md]
- **[drop]** Variable-shadowing claim on line 31 is a panel hallucination; the names are in different lexical scopes. [rule: skills/panel-review/SKILL.md § Pitfalls]
- **[summary-fix]** `packages/random/README.md`: section "About this document" pads with no reader benefit. [proposed-rule: README boilerplate sections beneath the reader's needs should be omitted]
```

The summary-fix bundle, the follow-up ledger append, and the proposed-rule message to the gardener all land on the same beat as the review submission; the un-draft is the last step of the round.

## Pre-round state check

The panel run probes PR state before fanning seats (this is the script's responsibility, not a separate dispatch):

```sh
gh pr view <N> -R <owner>/<repo> --json state,isDraft,mergedAt
```

Short-circuit to a no-op terminal line when any of:

- `state != "OPEN"` (the PR is `CLOSED` or `MERGED`).
- `isDraft == false` (already un-drafted; re-reviewing a post-draft PR is a discipline violation). The exception is the maintainer-requested standalone-review variant naming a stale post-draft PR explicitly.

The short-circuit costs one `gh` call rather than a full seat fan-out plus run scratch. Precipitating evidence (v1): a barrister read PR state at top-of-dispatch and short-circuited cleanly 27 seconds after a `gh pr close` on `endojs/endo-but-for-bots#421`.

## Pitfalls

- **Panel-report prose is not exempt from the project style rules.** The aggregated body ships in a public PR review. The same prose rules apply (no em-dashes per [em-dash-style](../em-dash-style/SKILL.md), no methodology leaks). Sweep the body before submitting.
- **A "shadow" finding may be a panel hallucination.** Variable-shadowing claims need a 30-second sanity check before promoting. Re-read the lines and confirm they are in the same lexical scope.
- **Sibling-package forks miss recent peer fixes.** When a PR introduces a package by forking a peer, diff the new sibling against the peer's recent commits for fixes that landed between the fork point and submission.
- **GitHub blocks `--request-changes` on a self-authored PR.** When the authenticated identity is also the PR's author, the submission returns a GraphQL error. Fall back to `--comment` with the full body; the verdict is preserved in the body even though `reviewDecision` does not flip. Downstream automation keying on `reviewDecision` also keys on the "Must-fix before merge" heading in the body for bot-authored PRs.
- **Design-plus-implementation in one PR needs a design-assessment posture.** When a PR implements all phases of a design as a single deliverable to assess the design's completeness, the panel's job grows to include "did the design specify enough to implement, and where did the builder fill gaps?". The aggregate carries an "Out of scope but worth flagging (design feedback)" section as input back to the design PR.

## Notes from the field

- _2026-06-24_: migrated to v2. The judge-as-foreperson `Agent`-dispatch orchestration collapses into the scripted panel run a gardener supervises ([panel](../panel/SKILL.md) / `scripts/jobs/gardening/panel.sh`); the three v1 judge roles (solicitor / barrister / justice) plus appellate are now stages of that one script. This skill retains the per-seat review procedure and the disposition rubric — the content the `seat_review` and `decide_disposition` hooks carry. The `summary-fix` job-board posting, the follow-up merge-watch, and the proposed-rule routing all rewire onto the v2 job board and message bus; "gamut" is renamed "gauntlet" throughout.
- _2026-05-21_: three narrow code-panel seats land (corner-prober, fast-checker, releaser); code panel reaches 26.
- _2026-05-20_: cite-or-propose discipline added; six narrow code-panel seats land (benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway). PR #75's 71 inline + 14 top-level comments across 16 reviews were the empirical catalog.
- _2026-05-19_: disposition layer added — the panel "is not responding to all of the aggregate feedback of the jury". Pre-change, the run un-drafted as soon as must-fix was empty, leaving should-fix and out-of-scope items ignored. Post-change, every non-must-fix finding gets one of four explicit dispositions.
- _2026-05-14/15_: the two-panel split (code panel for source PRs, design panel for design-only PRs) landed; the design panel grew from five seats to seven (decomplector, ergonomist added).
