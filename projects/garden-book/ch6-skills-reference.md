---
created: 2026-09-30
author: gardener (job book-ch6, orchestration garden-book-orch)
grounded-on: main2 087f4e1c22b, skills/ as of 2026-09-30
---

# Chapter 6: Skills reference

A **skill** is a self-contained playbook for one capability:
`skills/<name>/SKILL.md`, with a purpose, inputs, state (if any), a
procedure, an output shape, and notes. Roles never inline a skill's body.
They name the skill by path, and a gardener reads it just-in-time, after
claiming a job whose role calls for it. Many skills are also backed by a
script under `scripts/jobs/`; in those cases the skill is the human- and
agent-readable contract, and the script is the deterministic mechanism.

`skills/` holds 98 skill directories as of `main2` `087f4e1c22b` (plus a
`README.md`). That is one more than the inventory in `CLAUDE.md` §
Current inventory, which omits `pty-context-introspection`. This chapter
is written in several cycles, and it gives each skill an entry built from
reading its `SKILL.md` in full:

- **Purpose**, in the skill's own terms.
- **When it's used**: which roles or scripts invoke it, or when it fires.
- **Key mechanics**: the few things that matter when deciding whether to
  reach for it.
- **Gotchas**: hard preconditions and pitfalls the file calls out. These
  are usually the most valuable lines in a skill file.

If an entry and its source file disagree, the file wins; each entry links
to its source.

## Coverage status

**Cycle 1 (job `book-ch6`) covers 31 skills**: the PR lifecycle, the review
panel, branch hygiene, review follow-up, and job-board coordination
(sections 6.1 through 6.5 below).

**Still to cover (67 skills)**, assigned to follow-on jobs that append to
this file:

- `book-ch6-skills-reference-part2` (33 skills): planning and design
  intake, testing and verification, the library and documentation, prose
  and code style, and security and trust surfaces. `pr-dependency-graph`,
  `pr-dependency-topo-sort`, `design-dependency-walk`,
  `design-to-pr-pipeline`, `gap-revealing-build`, `ownership-map`,
  `sibling-family-sweep`, `build-vs-buy`, `adversarial-tests`,
  `saboteur-adversarial-review`, `coverage-driven-testing`,
  `regression-evidence`, `review-retrospective`, `review-queue-poll`,
  `ci-failure-classification-loop`, `context-library`, `library-lookup`,
  `journalism`, `self-improvement`, `liaison-reports`, `mermaid-validation`,
  `em-dash-style`, `no-latin-shorthand`, `no-comment-banners`,
  `relative-paths`, `rename-discipline`, `typist-friendly-code-points`,
  `changeset-discipline`, `american-english-normalization`,
  `botese-normalization`, `gricean-maxims`,
  `foreign-content-preclassification`, `fully-qualified-github-urls`.
- `book-ch6-skills-reference-part3` (34 skills): watchers and
  acknowledgment, fleet infrastructure and operations, and project-specific
  technical skills (Endo and XS, Ironhorse and test262, Agoric,
  minion.town, web and CSS). `at-mention-surveillance`, `issue-inbox`,
  `reactji-acknowledgment`, `activity-feed-watcher`, `github-activity-poll`,
  `pages-build-shepherd`, `gardener-inbox-error-reporting`,
  `prompt-on-failure-capture`, `prompt-section-discovery`,
  `pty-context-introspection`, `self-healing-wrapper`, `restore`,
  `host-disposition-report`, `aws-administration`,
  `claude-usage-dashboard-scrape`, `node-lts-window-watch`,
  `node-parity-test`, `re-export-deprecation-policy`, `slog-debugging`,
  `xs-debugging`, `test262-independent-assertions`,
  `test-title-spec-spelling`, `agoric-chain-snapshot`, `typesafe-ai`,
  `oauth-use-case-patterns`, `url-path-math`,
  `minion-town-clip-publishing`, `minion-town-mcp-playwright-login`,
  `emoji-favicon`, `css-anchor-positioning-and-flip-fallbacks`,
  `css-design-tokens-and-theming`, `css-intrinsic-and-content-sizing`,
  `native-customizable-form-control-styling`,
  `supports-feature-query-progressive-enhancement`.

## Contents

- [6.1 The PR spine: opening, describing, and gating a PR](#61-the-pr-spine-opening-describing-and-gating-a-pr)
- [6.2 The review panel](#62-the-review-panel)
- [6.3 Branch hygiene: worktrees, bases, rebases, and commit shape](#63-branch-hygiene-worktrees-bases-rebases-and-commit-shape)
- [6.4 After review: follow-ups, replies, CI, and the ferry](#64-after-review-follow-ups-replies-ci-and-the-ferry)
- [6.5 The job board and fleet coordination](#65-the-job-board-and-fleet-coordination)

## Skill index (cycle 1)

| Skill | Section | One line |
| --- | --- | --- |
| `pr-creation-flow` | 6.1 | The gauntlet: build, assay, clean, panel, fix loop, un-draft. |
| `pr-formation` | 6.1 | How to write a PR title and body; identity via `ensure-pr.sh`. |
| `pre-pr-checklist` | 6.1 | The human-facing review-yourself list before every push. |
| `pre-push-gates` | 6.1 | Deterministic auto-fixers and probes before every push. |
| `local-verify` | 6.1 | Local CI-parity verification harness, no LLM. |
| `panel` | 6.2 | The scripted jury-panel state machine (`panel.sh`). |
| `panel-review` | 6.2 | Per-seat block shape and the five-way disposition rubric. |
| `panel-hints` | 6.2 | Diff-signal recommender for which seats to fire. |
| `worktree-per-pr` | 6.3 | Every job gets its own project checkout. |
| `frozen-base-branch` | 6.3 | PRs target `<base>-<short-sha>` snapshots, not the trunk. |
| `verify-upstream-state-before-pinning` | 6.3 | Fetch the real upstream before pinning a version. |
| `conflict-resolution` | 6.3 | Honor both sides' intent; not `--ours`/`--theirs`. |
| `rebase-before-followup` | 6.3 | Rebase onto the current frozen base before a follow-up push. |
| `rebase-hygiene-audit` | 6.3 | Read-only batch audit of how PRs sit on their bases. |
| `retcon` | 6.3 | Restage a branch as per-package commits, same net diff. |
| `yarn-lock-separate-commit` | 6.3 | `yarn.lock` changes in their own `chore:` commit. |
| `stacked-pr-build` | 6.3 | Build on top of in-flight dependency PRs. |
| `cherry-pick-followup` | 6.3 | Carry a landed change to another branch by cherry-pick. |
| `review-feedback-followup-commits` | 6.4 | New commit per concern, not amends. |
| `pr-review-thread-replies` | 6.4 | Reply on each thread citing the fixing SHA. |
| `pr-completion-summary-comment` | 6.4 | The required top-level summary after a responsive push. |
| `pr-ci-watch` | 6.4 | Watch a PR's check rollup until every check settles. |
| `pr-handoff` | 6.4 | Ferry a finished PR upstream under the maintainer's identity. |
| `job-board` | 6.5 | Post, claim, and complete jobs over `journal2` push CAS. |
| `message-bus` | 6.5 | Topics, per-doer inboxes, and the maintainer channel. |
| `orchestration` | 6.5 | Parked children plus one record that sequences them. |
| `chained-followup` | 6.5 | Design, then a notice job, then the real follow-up. |
| `schedule` | 6.5 | Recurring and one-time jobs via the sole scheduler. |
| `bid-auction` | 6.5 | Opt-in auction choosing the cheapest arm to merge. |
| `model-selection` | 6.5 | The mentat/mentor/minion/myrmidon tier vocabulary. |
| `dispatch-worktree` | 6.5 | The v1 per-dispatch worktree triple (boatman only now). |

## 6.1 The PR spine: opening, describing, and gating a PR

These five skills describe the path from "a build job was claimed" to "a
draft PR is ready for the maintainer." `pr-creation-flow` is the map;
the other four are the steps a worker performs before and at every push.

### `pr-creation-flow`

Source: [`skills/pr-creation-flow/SKILL.md`](../../skills/pr-creation-flow/SKILL.md)

**Purpose.** The canonical procedure tying a PR's lifecycle stages together: which stage opens the PR, which stages touch it before the maintainer sees it, and which stage decides it is ready for review. The skill calls itself "the spine of the gauntlet," the end-to-end chain the gardening state machine (`scripts/jobs/gardening/garden-pr.sh`) drives.

**When it's used.** A gardener claims a `build` or `run the gauntlet #N` job off the job board and runs `garden-pr.sh`, reacting only to its terminal line or a failure or loop signal. The triager maps a maintainer's "run the gauntlet #N" PR comment to this job. `scripts/jobs/gardening/ensure-pr.sh` implements the find-or-create PR step this flow specifies. Every jury seat's `AGENT.md` cross-references this skill for the surrounding chain.

**Key mechanics.**
- Flow order: build (`ensure-pr.sh` opens or finds the one draft PR for a job), then the assayer step, then the cleaner step, then the panel (which itself loops fixer and re-panel), then an advisory appellate pass, then `gh pr ready <N>`.
- Every PR the garden opens is created draft; only the panel stage may un-draft, and only after the fixer loop clears all must-fix items.
- Variants skip stages by shape: tiny PRs skip the cleaner; design-only PRs (every changed path under a `designs/` directory) run build, design panel, fixer loop, un-draft, skipping assayer and cleaner.
- A "next-stage-owed heuristic" lets a gardener resume a stalled PR by reading live GitHub state (draft flag, mergeable state, panel verdicts) rather than journal entries.

**Gotchas.**
- "A second PR for one job" is a documented failure mode: a re-claimed job that calls `gh pr create` by hand rather than `ensure-pr.sh` can open a duplicate (grounding incident: `endojs/endo-but-for-bots#865` and `#871`, from one job claimed four times).
- Never force-push a PR head with plain `git push --force`; a follow-up push can rewind a peer's newer commits. Head pushes go through `safe-push-pr-head.sh`.
- A maintainer's `CHANGES_REQUESTED` does not reactivate draft state; the fix loop after maintainer review runs the fixer to CI-green without a re-cleaner or re-panel by default.
- The panel-fixer loop exits on "no in-scope must-fix," not "all complaints addressed."

### `pr-formation`

Source: [`skills/pr-formation/SKILL.md`](../../skills/pr-formation/SKILL.md)

**Purpose.** How to author or redraft a pull request's title and description so a maintainer can review the change without first reading the diff: which template to follow, what to include, and what to leave out. It governs PR prose; it does not decide PR identity.

**When it's used.** At the gardening state machine's PR-open step (`scripts/jobs/gardening/garden-pr.sh`), and at the ferry's upstream PR open (through `pr-handoff`). Referenced from the builder, fixer, boatman, and web-builder briefs. It is enforced at PR-open and at every panel round by `scripts/jobs/gardening/pr-body-template-check.sh`, invoked from `ensure-pr.sh` and `panel.sh`; the releaser and integrator jury seats also read the body against it.

**Key mechanics.**
- Fetch the base repo's `.github/PULL_REQUEST_TEMPLATE.md` at the head of the base branch and fill its sections verbatim; do not delete a heading even if it does not apply.
- The body carries four things in order: what the PR does, why, what to attend to, and what is intentionally out of scope. No checklists, no per-file tours, no inline test tallies.
- Identity is separate: hand the title and body to `ensure-pr.sh`, which finds or creates the job's PR by a `<!-- garden-job: <base> -->` marker, so a re-claimed job never opens a duplicate.
- An implementation of a design with numbered phases adds a machine-readable `## Phase and evidence ledger` block, validated by `phase-evidence-gate.sh` at PR-open and at the panel boundary.

**Gotchas.**
- "A bare `gh pr create` is the wrong tool for a garden PR."
- No methodology leak: the body never names an internal role, skill, job, or inbox. The one sanctioned exception is the opaque `garden-job` HTML-comment marker.
- Past about 300 words, cut. The panel's concision probe fires a pruner pass on a body carrying a checklist, a per-file tour, an inline test tally, or more than 300 words.

### `pre-pr-checklist`

Source: [`skills/pre-pr-checklist/SKILL.md`](../../skills/pre-pr-checklist/SKILL.md)

**Purpose.** The pre-PR gate: a human-facing, review-yourself checklist run before every push to a PR branch (initial or follow-up) and again before any `gh pr edit --body` rewrite. It covers the PR body template, the no-methodology-leak rule, and the separate lockfile commit, on top of the mechanical format, lint, and typecheck minimum.

**When it's used.** Named alongside `pre-push-gates` in the builder, assayer, cleaner, fixer, shepherd, and web-builder briefs as the step before every push (the builder before the initial push, the fixer before each follow-up push). `scripts/jobs/ensure-project-worktree.sh` also points to it.

**Key mechanics.**
- The minimum is format, lint on changed packages, docs and typecheck, at least the nearest tests, and a decision on a changeset entry. `pre-push-gates` mechanizes the deterministic subset and `local-verify` runs the broader suite, which leaves changeset judgment and other unprobed items to the worker.
- The PR body comes from the base repo's `.github/PULL_REQUEST_TEMPLATE.md`, with guidance prose deleted and headings filled in rather than invented; `ensure-pr.sh` refuses a body that drops or reorders a template heading.
- The body and title never mention the checklist, the state machine, the job board, or any internal role name, and never cite a literal `skills/...` or `roles/...` path.
- PR-body paragraphs are not line-wrapped, because GitHub renders single newlines as line breaks. This is a deliberate exception to the usual prose-wrapping convention.

**Gotchas.**
- Plain `yarn` may not be on `PATH` in a fresh worktree; use `npx corepack yarn`.
- Workspace-scoped commands need `npx corepack yarn workspace <name> exec <cmd>` or the `workspaces foreach -A` form.
- Underscore-prefixed unused identifiers clash with `no-underscore-dangle`; delete the identifier or use an eslint-disable comment.
- A generator script (the daemon's help-text generator, for one) can emit unformatted output whose diff looks misleadingly large until Prettier runs.

### `pre-push-gates`

Source: [`skills/pre-push-gates/SKILL.md`](../../skills/pre-push-gates/SKILL.md)

**Purpose.** The deterministic gate the gardening state machine runs before every push to a PR branch. It runs the project's auto-fixers (Prettier, eslint `--fix`) and silently re-stages their effects, runs a set of garden-specific deterministic probes, and runs the non-auto-fixable `typecheck` script. Auto-fixable findings land invisibly in the commit being pushed; the rest exit non-zero with one summary line per finding.

**When it's used.** At the PR-open step and at every follow-up push (fix-loop iterations), invoked by `scripts/jobs/gardening/garden-pr.sh` immediately before `local-verify.sh`. The builder, fixer, americanizer, deslopper, pages-shepherd, and web-builder briefs tell their workers to run it before pushing. The skill says plainly that it is "not an orchestrator concern": neither the liaison nor the panel runs it.

**Key mechanics.**
- Package-manager selection reads the root `packageManager` field or the lockfile (npm, Yarn, pnpm, Bun) through the shared `scripts/jobs/package-manager.sh`, so this gate and `local-verify` pick the same runner.
- The shipped probes live under `scripts/jobs/gardening/pre-push-gates/probes/`: `no-inline-import-jsdoc`, `typedefs-belong-in-dts`, `typist-friendly-code-points` (also an auto-fixer), `spell-out-identifiers`, `prefer-endo-primitives`, `build-vs-buy`, `no-plain-reexport`, and `no-nul-bytes`. Each is a small script, discovered by glob, that prints `pass` or `fail: <reason>`.
- A non-blocking comment-concision advisory reuses the panel-hints `C-pruner.sh` probe; it warns but does not fail the gate.
- Rules with no shipped executable (ASCII banners, `SECURITY.md` uniformity, and others) stay checklist or panel responsibilities. The probe table is authoritative, and the skill warns against describing unshipped rules as mechanically gated.

**Gotchas.**
- "A probe that's too aggressive blocks a legitimate diff" and auto-fix loops that do not converge are the named pitfalls. A formatter and linter that genuinely disagree is a project bug to surface, not a gate bug to retry.
- Judgment calls belong to a panel juror, not this gate: "deterministic-yes-or-no is gate-eligible."
- A passing `no-plain-reexport` probe does not prove every importer migrated; the `reexport-auditor` seat judges migration completeness.
- This gate is the mutating style and probe pass; `local-verify` is the read-only full verification. The push path runs both, in that order.

### `local-verify`

Source: [`skills/local-verify/SKILL.md`](../../skills/local-verify/SKILL.md)

**Purpose.** The deterministic, no-LLM verification harness (`scripts/jobs/gardening/local-verify.sh`) that runs a project's real CI-equivalent checks locally, in order, before a push, so CI stops being where failures are discovered. Running it is framed as an invariant, not an optimization: under the maintainer's standing policy, any CI lint or test failure is a defect in the garden's automation.

**When it's used.** By a builder, a fixer, or the gardening state machine before any push to a PR branch; it is the default body of the state machine's "evaluation gate (always)" (`GARDEN_EVAL` in `garden-pr.sh`). The botanist and pages-shepherd briefs reference it, and `ensure-project-worktree.sh`, `provision-moddable-xst.sh`, and `provision-node-lts.sh` support its runtime-parity guarantees.

**Key mechanics.**
- Steps run in a fixed order: `format, build, lint, zizmor, package-uniformity, root-types, codegen, test, test-xs, docgen`. `build` runs before `lint` so a typed linter can resolve every file. A "codegen-then-clean gate" treats a dirty tree after codegen as a stale checked-in artifact.
- Runtime parity is enforced: the harness resolves the project's pinned Node major and refuses to run under a mismatch, and resolves an exact pinned Moddable/XS release for `test-xs` rather than trusting a bare host `xst`.
- On failure it stores the combined output with `git hash-object -w` and prints only the blob SHA and a one-line tail, so a debugging agent reads only the slice it needs.
- When two or more failing steps that ran different commands produced byte-identical output, it reports one "environment fault" instead of several misleading independent failures.

**Gotchas.**
- "Parity is the contract": the local step set must cover every lint and test CI runs, enumerated from the project's actual CI config. A local-pass, CI-fail discrepancy (or the reverse) is itself a defect to close, never worked around with a one-off push.
- The container's inherited host git configuration is a standing source of divergence; the harness blanks it.
- It never commits, pushes, or mutates tracked files beyond what the project's own `format` and `build` scripts do.
- It verifies a project checkout only. The garden's own rolling-deploy candidate gate is a separate suite, and passing one says nothing about the other.

## 6.2 The review panel

A PR's review happens in a scripted jury panel. These three skills are
meant to be read together: `panel` is the state machine, `panel-review` is
what each seat and the aggregator do inside it, and `panel-hints` chooses
which seats to fire. The seats themselves are the juror briefs in
`roles/jurors/` (chapter 5).

### `panel`

Source: [`skills/panel/SKILL.md`](../../skills/panel/SKILL.md)

**Purpose.** The scripted jury-panel workflow: a gardener-supervised shell state machine (`scripts/jobs/gardening/panel.sh`) that runs a jury over a PR, collects each seat's verdict, decides the round's disposition, loops to a fixer stage while changes are required, and ends by un-drafting when the panel passes. It is the v2 translation of v1's judicial workflow (the retired solicitor, barrister, justice, and appellate roles), now a script that calls `claude -p` only for genuine judgments.

**When it's used.** As a stage of `pr-creation-flow` whenever a draft PR reaches its review point, and for a maintainer-requested standalone panel pass on a stale PR. Driven by `garden-pr.sh` and `scripts/jobs/gauntlet.sh`; referenced from `roles/COMMON.md`, the builder, fixer, cleaner, assayer, conductor, and designer briefs, and every juror seat.

**Key mechanics.**
- It senses the panel kind from the diff (a code panel of about 31 seats, or a design panel of 9), fans seats out concurrently (8 at a time by default), each as one `claude -p` call briefed with `roles/jurors/<seat>/AGENT.md`, then aggregates and decides `must-fix` or `pass`.
- On `must-fix` it calls a pluggable fixer hook and re-runs against the new head, until a pass or `GARDEN_PANEL_MAX_ROUNDS`. On pass it runs an advisory appellate pass, then un-drafts through a pluggable hook (`gh pr ready`).
- An empty diff (a diagnostic baseline PR, for one) short-circuits to a zero-round pass with no seats dispatched.
- Each run pushes one compact, best-effort record to `panel-runs/<owner>-<repo>-<pr>/<run-id>.md` on `journal2`, carrying verdict classes and truncated titles only, never seat prose.

**Gotchas.**
- A `GARDEN_PANEL_SEAT` hook must not read its own block file; the script truncates it before the hook runs, so a replay must read from a separate archive directory.
- Hooks live under `$GARDEN_SCRATCH`, not `/tmp`: `/tmp` is `noexec` on fleet hosts, and a hook there fails with exit 126.
- Quiet on success is deliberate: per-seat verdicts go to a run directory, not stdout, to keep the supervising gardener's context clean.
- Seats are metered and tiered per `seat-model-tiers.tsv`; tiering only ever downshifts from the ceiling.

### `panel-review`

Source: [`skills/panel-review/SKILL.md`](../../skills/panel-review/SKILL.md)

**Purpose.** The per-seat review procedure and disposition rubric that a panel run delegates to: how each seat produces its block, how findings cite or propose a standing rule, how findings sort into five dispositions, and how the aggregate becomes a posted GitHub review. It is the content of the `seat_review` and `decide_disposition` hooks that `panel` describes.

**When it's used.** Every panel round, on either panel kind, by the seat and decide hooks inside `panel.sh`. Every juror brief links here for the block shape and rubric, and `scripts/jobs/assert-panel-head-fresh.sh` and `gardener.sh` reference its freshness and posting contract.

**Key mechanics.**
- Each seat returns a fixed block (Verdict, Findings, Notes) under about 400 words. Every concrete finding carries a `[rule: <path>]` citation or a `[proposed-rule: ...]` tag, or it is dropped at aggregation.
- Findings sort into must-fix-loop, summary-fix, follow-up, acknowledge, or drop. Follow-up items go to a per-(project, repo, PR) ledger that is revisited automatically when the PR (or its upstream mirror) merges.
- PRs from external authors get a calibration pass: garden-only prose conventions (em dash style, no Latin shorthand, American English, Botese normalization) drop rather than being imposed on outside contributors.
- The review is posted as a formal `gh pr review` (`--request-changes`, `--comment`, or `--approve`, keyed off the dispositions), with each seat's block collapsed in a `<details>` disclosure and only the top-level verdict visible.

**Gotchas.**
- GitHub blocks `--request-changes` on a self-authored PR, so the script falls back to `--comment` with the full body; downstream automation keys on the "Must-fix before merge" heading for bot-authored PRs.
- A variable-shadowing finding may be a panel hallucination and deserves a 30-second sanity check before promotion.
- A failed read-only round can leave residue from a seat that created a scratch reproducer; compare against the clean baseline before retrying.
- Panel-report prose ships in a public PR review, so it is not exempt from the style rules (no em dashes, no methodology leaks).

### `panel-hints`

Source: [`skills/panel-hints/SKILL.md`](../../skills/panel-hints/SKILL.md)

**Purpose.** A deterministic diff-signal recommender (`panel-hints.sh`) that suggests which jury seats to fire on a PR, so the code panel can keep adding narrow, specialized seats without every PR paying for all of them. It is biased toward firing: any positive signal triggers a seat, and suppression requires every signal to be absent.

**When it's used.** By `panel.sh` at seat selection, before dispatch. The maintainer can also run it ad hoc to preview which seats a diff would fire, and it serves as a smoke test when a new juror seat lands. Referenced from the builder, barrister, and prosecutor briefs and from several juror briefs (archivist, breaker, curator, pruner).

**Key mechanics.**
- It decides the panel kind with an exact-match path test, then for the code panel runs the probe scripts under `probes/*.sh`, each emitting `fire <seat> <reason>` or `skip <seat>`.
- Seat categories: an always-on core of 9; always-fire seats whose signal lives outside the diff (`scribe`, `releaser`, and the cost-gated `coverage-auditor`); path-triggered seats; content-regex-triggered seats; and cross-panel seats (`pedant` and `copyeditor` firing on substantial Markdown in a code PR).
- Some checks run as dedicated deterministic pre-passes instead of diff probes, because the signal is not diff-shaped: the integrator's related-design and phase-evidence checks, the PR-body template check, and the decomplector's ownership-map check.
- Stateless: each run reads the diff fresh, and the panel records the output in its run directory next to the seat blocks.

**Gotchas.**
- An over-eager regex costs one extra `claude -p` call; a too-narrow path pattern that misses a real trigger is the worse failure. When in doubt, broaden.
- Design-only detection is exact-match: one source change among many design docs routes the whole PR to the code panel.
- PR-comment history is not in the diff, so `scribe` and `releaser` must stay always-fire.
- Probe output must match the parse contract exactly (`^fire ` or `^skip `); stray formatting pollutes the recommended set.

## 6.3 Branch hygiene: worktrees, bases, rebases, and commit shape

These skills govern where a worker edits, what its PR is based on, how it
moves that base, and what the commit history looks like when it pushes.
The weaver, fixer, and conductor roles lean on them most.

### `worktree-per-pr`

Source: [`skills/worktree-per-pr/SKILL.md`](../../skills/worktree-per-pr/SKILL.md)

**Purpose.** How a gardener or subagent gets an isolated working tree for a PR: never the orchestrator's own checkout, always a per-job (or per-dispatch) checkout, so concurrent work on one PR never shares a tree.

**When it's used.** Every mutating role (builder, fixer, weaver, shepherd, conductor, designer, cleaner, americanizer, deslopper, botanist, assayer) references it, and so do the jury seats for read-only diff review. In the v2 path, a gardener's handler starts in a per-job garden worktree and calls `scripts/jobs/ensure-project-worktree.sh <base> <owner/repo> <branch>` for its project checkout.

**Key mechanics.**
- Three lanes: mutating workers edit a project worktree; read-only jury seats get a detached, never-committed project worktree; API-only work gets none.
- All worktrees are detached HEAD. Commits go to `HEAD` and push with `git push origin HEAD:<branch>` (or, for a fork PR head, fetch and reset to the fork remote, then push with `--force-with-lease`).
- The checkout is keyed by the job's unique base, not by repo and branch or PR number. That is the mechanical guarantee against two gardeners sharing a tree, the endo-but-for-bots #58 incident ("two jobs sharing one ... tree, edits bleeding across").

**Gotchas.**
- "Fork PR heads are not branches of the base repo": resolve `headRepositoryOwner` and `headRefName` with `gh pr view` and pass the head fork's owner/repo to `ensure-project-worktree.sh`.
- Long worktree paths can push a Unix socket path over the 108-byte `sockaddr_un` cap in daemon tests; keep slugs short.
- "`git stash` as a baseline-test trick is the failure mode itself": use `git diff HEAD~1`, `git show`, or a separate detached baseline worktree. (The stash stack is shared across every worktree of the repo.)
- A stale local base ref can inflate a diff by thousands of unrelated files; compare the PR's commit count with the local count before trusting `<base>...HEAD`.

### `frozen-base-branch`

Source: [`skills/frozen-base-branch/SKILL.md`](../../skills/frozen-base-branch/SKILL.md)

**Purpose.** Every fork-side PR the garden opens targets a frozen base branch, `<base>-<short-sha>`: a snapshot of the moving upstream branch at PR-open time, not the floating trunk. When a weave (rebase) job runs, the head moves onto a fresh snapshot and the PR's `base` field moves with it. This isolates each PR's review from other PRs' concurrent trunk drift.

**When it's used.** At the PR-open step and the weave step of the gardening state machine. Referenced from the builder, weaver, conductor, boatman, designer, groom, and web-builder briefs. Enforced by the deterministic sensor `scripts/jobs/gardening/assert-pinned-base.sh` (called from `ensure-pr.sh`, `gauntlet.sh`, and `ci-wait-merge.sh`), and cleaned up on PR close by `sweep-frozen-bases.sh`.

**Key mechanics.**
- Naming is `<base>-<7-char sha>` (`master-abc1234`, `llm-abc1234`), captured once from `origin/<base>` and reused for every later operation in that step.
- PR-open pushes the captured SHA to the new branch and branches the head from it. A weave mints a new frozen base at the current upstream tip, rebases with `git rebase --onto`, force-pushes, and moves the PR with `gh pr edit --base`.
- Before any `gh pr merge`, the base must be restored to the live trunk ("unfreeze before merge"). The exception is `endojs/endo-but-for-bots` `master`, which has no live counterpart and ferries upstream instead.
- In a stack, each PR gets its own frozen base; the dependent PR's snapshot comes from the parent's head, and rebasing the parent does not move the child.
- `sweep-frozen-bases.sh` re-checks the authoritative PR list immediately before each ref deletion and repairs a lost race, because GitHub ref deletion has no compare-and-swap.

**Gotchas.**
- "There is no floating-base exception for designs." `GARDEN_ALLOW_FLOATING_BASE=1` is a rare, individually justified escape, not a routine path.
- Rebasing onto a moving branch can entrain dozens of unrelated commits ("79 commits entrained, many irrelevant," #831). Rebase onto the pinned snapshot with `--onto`, and check that `git diff --stat <frozen-base>..HEAD` shows only your files before pushing.
- Two PRs sharing one frozen base is normally harmless, but not for a garden open-questions review PR: merging one advances the shared base under the other.
- CI workflows keyed on a bare `master` may need a pattern that also matches `master-[0-9a-f]{7}`.

### `verify-upstream-state-before-pinning`

Source: [`skills/verify-upstream-state-before-pinning/SKILL.md`](../../skills/verify-upstream-state-before-pinning/SKILL.md)

**Purpose.** Before pinning an external dependency's version, capturing a sha256, or embedding upstream metadata, fetch the upstream's current state yourself instead of trusting a guessed or reviewer-quoted version, which is "frequently months stale."

**When it's used.** When a reviewer, an inbox message, or a build or dependency-triage job asks to pin something. Referenced from the builder brief and `scripts/jobs/comment-watcher.sh`.

**Key mechanics.**
- Read the upstream's directory listing or release page directly (`curl`, `gh release list`, the project's downloads index), not training-data recall.
- Compute the sha256 from a fresh download; never copy one from elsewhere.
- Put the version and sha256 in workflow-level environment variables so a later bump is a two-line change, and key any download cache on both, so a stale blob cannot shadow a bump.
- Cite the verification source in the commit message body.

**Gotchas.** None beyond the core discipline.

### `conflict-resolution`

Source: [`skills/conflict-resolution/SKILL.md`](../../skills/conflict-resolution/SKILL.md)

**Purpose.** Resolve every merge or rebase conflict by reading both sides' intent and writing a resolution that honors both, instead of mechanically taking one side.

**When it's used.** In weave and rebase jobs. Referenced from the weaver, fixer, and conductor briefs, and it is where `scripts/jobs/gardening/safe-rebase.sh` hands off: that script handles only the lockfile-only case itself and fails closed on anything else.

**Key mechanics.**
- List conflicted files (`git status --short`); read the markers plus `git log -1 --stat` on both sides (`HEAD` and `MERGE_HEAD` or `REBASE_HEAD`); read each author's version with `git show <sha>:<file>`; then write the file as if authoring it fresh with both intents in mind.
- "`--ours` and `--theirs` are right about 5% of the time and wrong the rest." The narrow exceptions are generated files: `yarn.lock` (drop both and regenerate, per `yarn-lock-separate-commit`), a Changesets-owned `CHANGELOG.md`, and whitespace-only Prettier conflicts. Even there you recompute rather than choose.
- Run the affected package's tests after each conflicted file, to catch the silent loss of a function one side added.

**Gotchas.**
- "Two aborts is a signal that a merge commit may be more honest than a rebase." Surface that choice through the gardener's loop signal or the message bus instead of thrashing.
- A clean rebase can still break a PR's own enforcement check (lint, policy script, schema validator) if the new base added a file the check covers; rerun those checks on the rebased tree.
- The hardest named case: both sides add a new parameter to the same signature. Keep both, keep the base side's slot so existing call sites still work, and check positional callers.

### `rebase-before-followup`

Source: [`skills/rebase-before-followup/SKILL.md`](../../skills/rebase-before-followup/SKILL.md)

**Purpose.** Always rebase a PR branch onto its current base before pushing a follow-up commit, so the branch does not fall behind or run CI against outdated dependencies.

**When it's used.** In the fixer's follow-up step, before applying and pushing review fixes, and in any hand-applied follow-up. Referenced from the fixer, weaver, americanizer, and deslopper briefs.

**Key mechanics.**
- Standard shape: fetch the base, work from the current PR head, rebase, apply fixes, commit, and push with `--force-with-lease origin HEAD:<branch>`.
- The rebase target is the PR's *current frozen base*, never the floating trunk. Only a weave job mints a new frozen base; a follow-up that rebases onto `origin/master` directly is out of bounds.
- Before pushing, `git diff --stat <frozen-base>..HEAD` must show only your files. A ballooned count means base commits were entrained, and the fix is `git rebase --onto <base> <old-base> HEAD`.

**Gotchas.**
- Never `--ours` or `--theirs` (see `conflict-resolution`).
- A rebase silently drops commits that already landed on the base; check that the rebased diff still carries the PR's intent.
- A token without the `workflow` scope rejects a push touching `.github/workflows/*`; push over SSH instead.
- A cross-base rebase needs the explicit `--onto` form; a bare `git rebase <new-base>` replays everything between the new base and `HEAD`.
- Byte-identical duplicate commits across old and new bases do not always auto-skip; they can surface as conflicts that need an explicit drop.

### `rebase-hygiene-audit`

Source: [`skills/rebase-hygiene-audit/SKILL.md`](../../skills/rebase-hygiene-audit/SKILL.md)

**Purpose.** A batch, read-only audit across open PRs that answers "are these cleanly stacked on their bases?" and produces a maintainer-actionable report. It never pushes or rebases.

**When it's used.** It feeds weave jobs: a `needs-rebase` verdict marks a branch with rebase work pending, and the triager turns a surfaced PR into a "weave #N" job. Referenced from the conductor brief and `scripts/jobs/gauntlet.sh`.

**Key mechanics.**
- Per PR it computes behind, ahead, and merge-commit counts, a `git merge-tree` clean-or-conflict check, and the pinning state from `assert-pinned-base.sh pr <owner>/<repo> <N>` (exit 0 ok, 4 inconclusive, 5 unpinned or floating base, 6 wide entrained delta).
- Categories: green, needs-rebase, needs-rebase-with-conflicts, has-merge-commits, base-not-on-remote, unpinned-base, wide-entrained-delta, and inconclusive or sensor-error.
- It lists PRs once (`gh pr list --json number,baseRefName,headRefName`) and fetches refs in batches of about 50 instead of one fetch per PR.
- Output is a Markdown report grouped by category, with a summary table and two or three sentences of recommendations.

**Gotchas.**
- Inconclusive or sensor-error must never be reported as green.
- Long-lived feature branches with intentional merges read as `has-merge-commits` but should be flagged, not rebased.
- Stale Dependabot PRs can be 700 or more commits behind; recommend "dependabot recreate" instead of a manual rebase.

### `retcon`

Source: [`skills/retcon/SKILL.md`](../../skills/retcon/SKILL.md)

**Purpose.** Reset a PR branch to its base and restage the identical net diff as a sensible history: one commit per affected package (implementation and tests together), a separate `chore: Update yarn.lock` commit, and conventional-commit messages. The diff does not change; only the grouping does. The name is the maintainer's verb for retroactively fixing a branch's continuity.

**When it's used.** As a job: the triager maps a maintainer's "retcon #N" comment to a board job, and a gardener runs it as the fixer step. Referenced from the fixer, triager, conductor, and shepherd briefs; the comment watcher recognizes the verb.

**Key mechanics.**
- Tag the pre-retcon tip, `git reset --mixed origin/<base>` (unstaging everything while keeping the working tree), restage and commit by package, commit the lockfile last on its own, and push with `--force-with-lease`.
- Net-diff invariance is checked: `git diff origin/$BASE..HEAD --stat` must match the pre-retcon stat, and `git diff <pre-retcon-sha>..HEAD` must be empty. If either fails, roll back and start over.
- Later minor corrections use `git commit --fixup=<introducing-sha>`. Before review these are autosquashed; after review they stay visible until the conductor's noninteractive `git rebase -i --autosquash` at merge time.
- A branch already in canonical shape is left alone and the confirmation reported, since re-partitioning identically only mints new SHAs and resets CI.

**Gotchas.**
- A retcon is "not a rebase onto a new base." If the branch lags its base, weave first (or chain "weave then retcon").
- Forgetting the pre-retcon tag leaves the no-net-change check nothing to compare against.
- `git reset --hard` instead of `--mixed` throws away the diff.
- If `--force-with-lease` rejects the push because a fixer pushed concurrently, do not switch to `--force`; abort and redo on the new tip.

### `yarn-lock-separate-commit`

Source: [`skills/yarn-lock-separate-commit/SKILL.md`](../../skills/yarn-lock-separate-commit/SKILL.md)

**Purpose.** Every change to `yarn.lock` ships in its own `chore: Update yarn.lock` commit, separate from the `package.json` change that caused it, while implementation and tests stay together in the package's commit.

**When it's used.** In the builder and fixer steps, and retroactively across a branch by `retcon`. Referenced from the builder, fixer, weaver, conductor, cleaner, assayer, and web-builder briefs; the packager and changeset-auditor seats check for the split. Its rebase-recovery form runs deterministically in `scripts/jobs/gardening/safe-rebase.sh`.

**Key mechanics.**
- Order matters: the lockfile commit comes after the `package.json` commit, so dropping the lockfile commit still leaves a coherent state.
- Rebase recovery is drop-and-regenerate, not a manual merge: `git rebase --skip` the old lockfile commit on conflict, then run `npx corepack yarn install` and commit a fresh lockfile against the new base.
- `safe-rebase.sh` does exactly this when the *only* conflict is a lockfile-only commit; any other conflict fails closed (exit 3) for a weaver or fixer to resolve by hand.
- A package rename changes the workspace key inside `yarn.lock`; let `yarn install` regenerate it after all renames, never hand-edit it (see `rename-discipline`).

**Gotchas.**
- "`git commit --amend` on the package.json commit silently drags the lockfile in if it is staged." Stage and commit the lockfile last.
- A combined commit caught in review is split with `git reset HEAD~1` and two commits, or fixed branch-wide with a retcon.

### `stacked-pr-build`

Source: [`skills/stacked-pr-build/SKILL.md`](../../skills/stacked-pr-build/SKILL.md)

**Purpose.** Build a PR on the implementation branch with one or more in-flight dependency PR heads merged in, so dependent work is developed and reviewed against the code its dependencies deliver. It is the operational counterpart to the registry-reading skills `pr-dependency-graph` and `pr-dependency-topo-sort`: what base to compute, how to commit, how to show reviewers the dependence, and what to do when the stack moves.

**When it's used.** In a `build` job when dependency triage returns `stack-on-PRs`, or when a maintainer says "build X on top of #N and #M." No role file names it; it lives inside the build job's dependency-triage branch, and `design-dependency-walk` and `frozen-base-branch` point to it.

**Key mechanics.**
- The PR targets the implementation base (not the topmost stack PR), with each dependency merged in by `git merge --no-ff`, so the stack shows as merge commits and reviewers see the whole diff in one place.
- `stack:` metadata (the base plus each dependency's pinned `head_sha`) goes in the PR's dependency-registry entry on `journal2`, so later passes know it is a stack.
- Three transitions are handled across passes: a dependency merges (the stack shrinks at the next rebase), a dependency's head advances (leave it or rebuild), or a dependency closes unmerged (surface on the message bus and re-enter triage).

**Gotchas.**
- Targeting the topmost stack PR's branch is tempting but wrong; it hides the stack from the reviewer.
- Without `--no-ff` the history is linear and the stack disappears from `git log --graph`.
- Resolve non-trivial conflicts in a separate `chore: reconcile stack with <dep>` commit, not inside the merge commit.
- Stacking deeper than two PRs grows review and rebase cost "geometrically"; the default is to build the deeper dependency in its own job first.

### `cherry-pick-followup`

Source: [`skills/cherry-pick-followup/SKILL.md`](../../skills/cherry-pick-followup/SKILL.md)

**Purpose.** When a doc, style, or policy change has landed on another branch, apply it to the current branch by cherry-pick instead of reauthoring it.

**When it's used.** As a step inside follow-up work, not a standalone job. Referenced from the weaver brief ("when only a subset of commits should move"), the designer brief (keeping a long-lived `design/<slug>` branch coherent), and the web-designer brief.

**Key mechanics.**
- `git cherry-pick <sha>`, resolve conflicts by hand, confirm with `git log --oneline -2`.
- To land it on another worktree's branch, run the cherry-pick from inside that worktree.

**Gotchas.**
- The same commit picked onto several branches gets a different SHA on each; compare messages or trees, not SHAs.
- Projects differ in where they keep style rules (`CLAUDE.md` in one, `AGENTS.md` in another). Detect that case and edit the right file instead of making a no-op cherry-pick.

## 6.4 After review: follow-ups, replies, CI, and the ferry

Once a PR has been reviewed, these skills shape the response: what the
fix commits look like, how each thread and the PR as a whole are answered,
how CI is watched to a settled state, and how finished work is carried
upstream.

### `review-feedback-followup-commits`

Source: [`skills/review-feedback-followup-commits/SKILL.md`](../../skills/review-feedback-followup-commits/SKILL.md)

**Purpose.** The shape of commits made in response to review: add a follow-up commit on top instead of amending, one concern per commit, then close each thread with a reply citing the SHA and finish with a top-level summary.

**When it's used.** In the fixer step of the gardening state machine. Referenced from the fixer, americanizer, deslopper, and conductor briefs, so it applies whenever those roles push fixes in response to maintainer or panel review.

**Key mechanics.**
- Amending is reserved for a just-rebased tip nobody else has pushed since, or an explicit maintainer ask about author or message only. Otherwise each fix is a new commit, so the reviewer's diff since last review stays small.
- Rebase first (`rebase-before-followup`), and ship lockfile changes as their own `chore: Update yarn.lock` commit.
- Some requests call for more reading: pinning an external dependency (`verify-upstream-state-before-pinning`), a major rewrite (land it as one commit, not staged theatrically), a package-rename cascade, or a post-retcon style fix (`git commit --fixup=<sha>` for autosquash).
- Close out with `pr-review-thread-replies` and a top-level summary mapping each item to its commit.

**Gotchas.**
- A PR can merge between the fixer's preflight and its push. If the reviewed branch is gone, rebase onto the live base and open a follow-up PR; never recreate or force-push the deleted merged branch (minion.town PR #40 and #46).
- A job's line-number citation is authoritative but can be off; check it against the actual file before editing.

### `pr-review-thread-replies`

Source: [`skills/pr-review-thread-replies/SKILL.md`](../../skills/pr-review-thread-replies/SKILL.md)

**Purpose.** After addressing an inline review thread, reply on that thread citing the commit SHA, so the reviewer does not have to re-walk the diff. It is the close-out step of `review-feedback-followup-commits`.

**When it's used.** In the fixer step, after pushing fixes that address inline comments. Referenced from `roles/COMMON.md` and the fixer, americanizer, and deslopper briefs; its command-injection guidance is enforced in code by `scripts/jobs/comment-body-guard.sh`.

**Key mechanics.**
- Find each thread's parent comment id with `gh api .../pulls/<N>/comments`, then reply on the `/replies` endpoint. Posting to the parent endpoint makes a new top-level comment, not a threaded reply.
- Every cited SHA comes from `git rev-parse` or `git log --format=%H` in the same session, never from memory or a hand-extended short SHA.
- Answer the question asked and stop. A reply over about 80 words or three bullets is checked with `panel-hints/probes/C-pruner-pr-body.sh --kind reply`.
- Pass the body as a file (`--field body=@file`), never as a `-f` value or inline shell text. Then post the top-level summary with `gh pr comment <N>`.

**Gotchas.**
- `-f body="@/tmp/reply.md"` does not dereference the file; it posts the literal string. Body text with backticks or `$(...)` on the command line gets command-substituted by the shell, which stripped inline code on endo-but-for-bots #475.
- Inline comments visible on the PR page but missing from the REST index (pending review state) need a top-level fallback comment mapping each comment id to its outcome.
- Posting on someone else's repository requires explicit per-action authorization in the job; without it, stop and ask over the message bus.

### `pr-completion-summary-comment`

Source: [`skills/pr-completion-summary-comment/SKILL.md`](../../skills/pr-completion-summary-comment/SKILL.md)

**Purpose.** After pushing work to a PR in response to a directive, review, or feedback, post a top-level summary comment. It is the human-readable acknowledgment that closes the loop, required in addition to per-thread inline replies.

**When it's used.** Referenced from `roles/COMMON.md` and from the builder, weaver, conductor, fixer, botanist, shepherd, web-builder, and pages-shepherd briefs and the scribe seat. Required after any push responding to feedback: a fixer addressing a review, a weaver explaining a conflict resolution, a shepherd reporting CI green, a conductor noting a merge, a botanist giving a Dependabot verdict. Not required when opening a draft PR, whose body is the opening summary.

**Key mechanics.**
- The comment names the head SHA, what changed (mapped to commit SHAs), what was declined and why, and verification status (tests, lint, types).
- Bulk detail goes in collapsible `<details>` blocks, but one loop-status line (round number, CI state, what happens next) always stays visible.
- When a summary aggregates sections from different roles or models, each section gets its own provenance footnote from `comment-provenance.sh` (`provenance_footnote`, `provenance_footnote_for_kind`), in addition to the fleet's single whole-body footer.

**Gotchas.**
- Inline replies alone are not enough; the rule comes from maintainer feedback on PR #474 ("I expect feedback on the PR in general").
- A silent push with no comment is never acceptable in response to a directive.
- Leaving out declined items "hides the decision the maintainer most needs to see."
- On a repo other than `endojs/endo-but-for-bots` (which has standing comment authorization), without the job's comment authorization the summary goes in the completion report instead.

### `pr-ci-watch`

Source: [`skills/pr-ci-watch/SKILL.md`](../../skills/pr-ci-watch/SKILL.md)

**Purpose.** Watch one PR's CI status-check rollup, emit one line per check transition, and stop once every check has settled. It is the CI-watch step behind the gauntlet's loop-on-CI decision.

**When it's used.** By the conductor, whose merge job waits on the rollup while CI is in flight, and by the groom, which uses it to check a design's claimed status against real PR state. `scripts/jobs/gardening/ci-wait-merge.sh` wraps its one-tick logic in a real timeout and backoff loop.

**Key mechanics.**
- It reads `gh pr view --json statusCheckRollup,headRefOid`, normalizes Actions `CheckRun` and legacy `StatusContext` shapes into one form, and diffs against a stored `prev_rollup.txt` to emit only transitions.
- The first tick on which every check is `COMPLETED` writes a `terminal.txt` sentinel (`total=<n> failed=<m> sha=<commit>`); later ticks short-circuit to a one-line report.
- Each tick costs one GraphQL point regardless of check count; about one tick a minute is the suggested cadence.
- `check_run` and `check_suite` events never appear on the repo events feed, so the rollup, not the activity feed, is the source of truth.

**Gotchas.**
- "Waiting for CI is NOT a terminal state." A merge job that completes while CI is merely pending strands a green, unmerged PR (endo-but-for-bots #178, which "bit the same PR twice").
- `mergeStateStatus: BLOCKED` with `REVIEW_REQUIRED` and an all-green rollup is a normal "waiting for human review" end state, not a CI failure.
- An empty rollup long after a push often means the PR is `CONFLICTING` or `DIRTY`, so GitHub never created the merge ref to run workflows on. It needs a rebase, not a re-run.
- A CANCELLED check next to a FAILURE on the same matrix is fail-fast fallout, not a separate bug.

### `pr-handoff`

Source: [`skills/pr-handoff/SKILL.md`](../../skills/pr-handoff/SKILL.md)

**Purpose.** How to carry a finished garden-side PR to its upstream repository: the three shapes a ferry takes (first-time, re-ferry with recompute, fast-forward append), the attribution rewrite from bot author to the named human, the trailer-strip and body-edit disciplines, and the line between a ferry and a rebase or conflict resolution.

**When it's used.** It is the procedure the boatman runs for a ferry (the boatman brief calls it "the rebase-and-rewrite-and-push procedure"). A ferry is staged as a `journal/jobs/ferry/<name>.md` directive and executed by the maintainer's `scripts/ferry.sh` on the credentialed host (chapter 5, the boatman). It also feeds `scripts/jobs/record-mirror.sh` and `mirror-closer.sh`, which record and later act on the upstream-to-mirror PR mapping.

**Key mechanics.**
- It requires `gh auth status` to show the maintainer's identity and the directive to carry `identity_switch_authorized: true`. The bot identity never pushes to a primary upstream repo.
- The attribution rewrite uses local `git config` plus `git commit --amend --reset-author --no-edit` per commit; the skill says cherry-pick's `--author` flag and `GIT_AUTHOR_*` variables do not work for this.
- A standing per-commit `git interpret-trailers --parse` check strips `Co-authored-by:` and generator trailers before anything ships.
- It ends with `record-mirror.sh` writing the upstream-to-mirror mapping, so the deterministic mirror-closer service can close the mirror later.

**Gotchas.**
- "A ferry must be issued from the host that holds the kriskowal credentials"; on the wrong host, stop rather than push as the bot.
- The trailer strip runs on every ferry: an eyeball check once missed a trailer further down a commit body (PR #73).
- Never plain `--force`. The re-ferry shape uses `--force-with-lease`; the append shape requires a `git merge-base --is-ancestor` check before pushing.
- No comments on primary upstream repos under the maintainer's identity; explanations go to the liaison over the message bus.

## 6.5 The job board and fleet coordination

These skills are the substrate the fleet runs on: how work is posted,
claimed, sequenced, scheduled, priced, and routed to a model, and how
workers talk to each other and to the maintainer.

### `job-board`

Source: [`skills/job-board/SKILL.md`](../../skills/job-board/SKILL.md)

**Purpose.** Coordinates many gardeners across many hosts on one shared queue with no lock service, using the `git push` to `origin/journal2` as the compare-and-swap. It defines how producers post jobs, how concurrent consumers claim them safely, and how jobs complete, all under `journal/` (`jobs/{todo,doin,tada}/`, `jobs/plan/`, `work/<base>`, `inbox/<base>/`).

**When it's used.** Nearly every role touches it: the liaison posts work, gardeners claim and complete, the foreman posts next steps, and the triager, scheduler, and watchman post from their sources. `post-job.sh`, `post-plan.sh`, `claim-job.sh`, `complete-job.sh`, and `reaper.sh` implement the protocol, with shared helpers in `common.sh`.

**Key mechanics.**
- The basename is the reservation: bare and idempotent for one-shot work (`design-X`, `build-X`), but a recurring verb against the same target (`weave`, `shepherd`, `retcon`) needs an ISO-date suffix, or an earlier completed job silently swallows the new one.
- `jobs/plan/` holds parked work outside the claim lifecycle, gated `go-ahead`, `deferred`, `awaiting-maintainer`, `blocked`, or `orchestrated`, each with its own promotion path (`promote-plan.sh`, `unblock.sh`, the orchestrate watcher).
- A per-job `handler-timeout:` (default 2400 seconds, larger for builder, fixer, shepherd, conductor, panel, and botanist work) bounds the handler before SIGTERM; a long job without a budget dies on every requeue.
- Claims back off on contention while posts and completions retry, because a retried claim could steal a job but a completion only fast-forwards its own files.

**Gotchas.**
- A stale `doin/` claim is "ownership evidence, not liveness"; check claim time and progress markers before assuming a job is abandoned.
- Producers post sequentially against the shared clone; concurrent fan-out against one clone causes needless contention.
- Directive-identity dedup (`--identity`) is separate from basename idempotency: two producers can name different jobs for one PR comment, so watchers pass `--identity` explicitly.

### `message-bus`

Source: [`skills/message-bus/SKILL.md`](../../skills/message-bus/SKILL.md)

**Purpose.** Agent-to-agent and agent-to-maintainer messaging over `journal2`, used even between workers on one host because the garden may span many. It has two mechanisms: topic fan-out (`msgs/role/<r>`, `msgs/broadcast`, and `msgs/host/<GARDEN>` for the sysop) and a directed per-doer inbox (`inbox/<doer>/{unread,read}`) that lives only as long as the claimed job.

**When it's used.** Every working gardener polls `role/gardener` and `broadcast` (gardener brief, `roles/COMMON.md`). The liaison watches the maintainer inbox with `maintainer-watch.sh` under a Monitor and answers with `maintainer-reply.sh` or `maintainer-archive.sh`. The watchman, foreman, researcher, scholar, librarian, and proxy use it for their own coordination.

**Key mechanics.**
- A gardener reaches the maintainer with `message-user.sh`, which lands in the standing `inbox/maintainer/`; the reply comes back into the gardener's own inbox, read with `inbox-read.sh`.
- Each send mints a fresh id unless `GARDEN_MSG_ID` is set. With `GARDEN_MSG_COALESCE=1` and a stable id, repeats amend one entry in place (bumping `notice_count`) under a one-hour per-key throttle, instead of piling up files.
- Both directions serialize by CAS on the journal push: senders append and retry, and the receiver is the only one that moves `unread` to `read`.
- Every author-written send runs `check-issue-refs.sh` and refuses a body with a bare `#N`; references must be `owner/repo#N` or a full URL.

**Gotchas.**
- Deadline warnings are "queued journal messages, not mid-turn model input"; a running job sees one only when it next calls `inbox-read.sh`.
- Relay producers forwarding generated or external bodies set `GARDEN_SKIP_REF_CHECK=1` to skip the reference gate.
- An empty `maintainer-reply.sh` (blank body and stdin) delivers nothing and just moves the message to read, which is the deliberate way to dismiss one.

### `orchestration`

Source: [`skills/orchestration/SKILL.md`](../../skills/orchestration/SKILL.md)

**Purpose.** Split a multi-part job into parked child jobs plus one orchestration record that promotes the children into `todo/` (serially by default, or in parallel) and watches them to completion, so a follow-up step is never forgotten. It implements the maintainer's standing directive (2026-07-01): for a multi-part job, always make an orchestration job. This chapter is itself one child of such an orchestration (`garden-book-orch`).

**When it's used.** The orchestrator role is built on it; the gardener brief invokes it whenever a job decomposes into ordered parts ("orchestrate it, don't pile up loose posts"); the liaison uses it for multi-part asks. Any producer sets one up with `post-plan.sh --orchestrated --orchestrated-by <orch>` per child and then `post-orchestration.sh`.

**Key mechanics.**
- The deterministic `orchestrate.sh` watcher (the leader-only `garden-orchestrate` timer, no `claude -p`, about every 3 minutes) drives the record. Serial promotes one child and waits for it to reach `tada/`; parallel promotes all at once.
- Child state comes from one committed board snapshot: done, active, parked, or failed (promoted but absent from every board directory, or reported with `orchestration-failed: true`).
- On failure the recorded policy applies: `halt` stops a serial run, leaves the rest parked, and tells the maintainer; `continue` proceeds.
- A halted run can self-correct: if the blamed child later shows up in `tada/`, the watcher re-posts a resumed orchestration over the still-parked remainder.

**Gotchas.**
- A recurring-verb child (weave, shepherd, conduct, or retcon of a given PR) needs an ISO-date suffix, or `post-plan.sh` silently no-ops because the bare name collides with a completed job.
- Park the children before creating the record; `post-orchestration.sh` checks each child is really its own (`gate: orchestrated` with matching `orchestrated_by`) before writing anything.
- `budget_tokens` works only for serial runs, and budgets gate admission, not execution: an already-promoted child is never killed for overshooting.
- For a plain two-step dependency, `post-plan.sh --blocked --blocked-on <predecessor>` is the lighter tool.

### `chained-followup`

Source: [`skills/chained-followup/SKILL.md`](../../skills/chained-followup/SKILL.md)

**Purpose.** Wire a follow-up that must run only after a design advances to a build, possibly across a repo boundary, on an event that no single job's completion names. It adds a notice job as a level of indirection instead of posting a blind follow-up that would fire against nothing.

**When it's used.** For the maintainer's standing ask "post a job to design X, and a follow-up triggered when it lands" (kriscendobot/minion.town#41). `scripts/jobs/handlers/follow-up-claude.sh` names it for the design-build recheck pattern, describing the check as mechanical.

**Key mechanics.**
- Three jobs: D (the design, posted normally), N (a notice job parked with `post-plan.sh --blocked --blocked-on D`), and F (the real follow-up, posted by N only after it confirms the design reached a build).
- N's build check is a read-only, deterministic `gh` PR-state query, never an LLM judgment, so it is cheap and safe to repeat.
- N can be anchored on D's completion (the default), on a known build PR URL, or on a recurring `once:` schedule with a deterministic preflight when there is no board job to block on.
- A plain two-step dependency with no second event just uses a `--blocked-on` edge.

**Gotchas.**
- Never post F up front; a follow-up in `todo/` or deferred runs before the implementation exists.
- The trigger is the build, not the design: D reaching `tada/` only means the design is written.
- When the build is not there yet, N re-arms itself. A declined design ends the chain with a maintainer note, which keeps "not yet" distinct from "never."

### `schedule`

Source: [`skills/schedule/SKILL.md`](../../skills/schedule/SKILL.md)

**Purpose.** Race a schedule change onto the journal so the single `garden-scheduler` dispatches a recurring (or one-time future) job on its cadence, instead of a host-local crontab that other hosts cannot see.

**When it's used.** The liaison uses it to add, change, or remove recurring work; the groom, journalist, scholar, and botanist depend on schedule rows for their cadences. `set-schedule.sh`, `set-schedule-once.sh`, and the `scheduler.sh` service (`garden-scheduler.timer`) implement it; the scheduler is the only dispatcher and stamps `last_dispatched` atomically so no host double-dispatches.

**Key mechanics.**
- Two cadence families. Interval cadences (`weekly`, `daily`, `<N>s/m/h/d`) fire a fixed offset after the previous dispatch and drift forward after a late tick. Anchored cadences (`daily-at-HH:MM-<TZ>`, `weekly-at-<Day>-HH:MM-<TZ>`) pin to wall-clock time and never drift.
- An optional `preflight:` script decides in plain code whether there is work: exit 0 posts, exit 2 skips and advances the clock, and anything else (or a missing script) fails open with one deduplicated maintainer escalation.
- `occupancy: skip` or `occupancy: carry-forward` keeps a job that outlives its cadence from accumulating concurrent instances.
- Dispatch passes the same budget-hold and drain gates as `post-job.sh`: under budget backoff the job parks in `plan/`; under a fleet drain nothing is dispatched and no clock advances, so exactly one dispatch happens per period after the drain lifts.

**Gotchas.**
- The old `ironhorse-ratchet` schedule is retired; never recreate or unsnooze it.
- A `once:` schedule fires exactly once, and the scheduler deletes its file in the same commit.
- A reply dead-lettered to a finished tick's sub-job is recovered by `deadmail.sh` into a `carry-forward/` mailbox and injected into the schedule's next tick.

### `bid-auction`

Source: [`skills/bid-auction/SKILL.md`](../../skills/bid-auction/SKILL.md)

**Purpose.** A decentralized auction and dollar-normalized reputation system that picks which worker arm runs an opted-in job, choosing the combination cheapest *to merge* in true aggregate dollars rather than cheapest per token, with no central auctioneer. It rides the same push CAS as an ordinary claim.

**When it's used.** No role brief invokes it; it is machinery inside the worker spine (`claim-job.sh`, `gardener.sh`, `cleric-codex.sh`, `worker-common.sh`, `auction.sh`, `reputation.sh`). A producer opts a job in with `market: bid` frontmatter; everything else stays on the ordinary race.

**Key mechanics.**
- Bidding happens inside `claim-job.sh` with no LLM. While the bid window is open, an eligible worker writes a bid file (a seeded Thompson draw over its arm: kind, provider, model, thoughtfulness) and moves on without claiming.
- The award (`auction_award_order`) is a pure function of the committed journal: every worker ranks bids by the same seeded draw, and the rank-1 bidder claims through the ordinary todo-to-doin push. Eligibility widens in timed steps, so a dead winner never strands the job.
- `complete-job.sh` records a reputation event per job. The leader-only `reputation-reduce.sh` timer is the only writer of arm projections, folding cost samples (ledger-priced where available, wallclock-proxy-priced otherwise) with a Welford accumulator.
- Arms with few samples draw from a wide prior so they still sometimes win (exploration); a confidently cheap arm wins most auctions.

**Gotchas.**
- "Censored" means the cost ledger was absent, not that the run was withheld. A zeroed `mean_dollars` must never be read as a real posterior, or that arm would win every auction on price.
- With no positive wallclock rate there is no cost proxy, and the event stays censored rather than being priced at zero.
- The temporary quota route makes some hosts (`endolin-garden*`) treat `market: bid` as a plain race; producers keep the header so reverting the route restores bidding without rewriting queued work.

### `model-selection`

Source: [`skills/model-selection/SKILL.md`](../../skills/model-selection/SKILL.md)

**Purpose.** Defines the fleet's closed dispatch vocabulary, in descending thoughtfulness (mentat, mentor, minion, myrmidon), mapped onto the executable model inventory in `scripts/jobs/model-tier-inventory.tsv`. The inventory is closed: every enabled model has exactly one row, and an unknown model cannot get an automatic route.

**When it's used.** `CLAUDE.md` names it as the canonical map the fleet reads through `role_default_model` and `resolve_model_tier` in `common.sh`. The liaison uses it to route manual `mentat` work through `post-manual-job.sh`. `post-job.sh` and `post-plan.sh` apply it to automatic producers, rewriting each automatic body to `tier: mentor`, `fallback-tier: minion` (as in this job's own header).

**Key mechanics.**
- Mentat is manual-only (`post-manual-job.sh`, stamping `dispatch: manual`), with one scoped exception: a maintainer-authorized Ironhorse test262 watcher may emit a canonical mentat task under an explicit journal authorization that is revalidated at every promotion.
- Mentor is the default ceiling for automatic work and is multi-provider (Opus 5.5 on a monk, Sol on a cleric, Kimi K3 on a mystic, GLM 5.2 on a Fireworks worker).
- A per-role floor (`role_tier_floor`) stops the reaper's reroute from demoting a job below its role's minimum: designer and builder (and their web variants) floor at mentor, every other role at minion.
- Several provider lanes (OpenRouter, Ollama Cloud "friar," the retired local "hermit") are explicit-pin only or inert by default; no automatic or unpinned job can reach them.

**Gotchas.**
- The monk handler and the claim-eligibility predicate must agree on which tiers Anthropic serves. A past mismatch (claim said yes, handler said no) put a host into a hot claim, die, requeue loop across the board; the agreement is now an asserted invariant with tests.
- A Fireworks `tier: mentor` job always resolves to GLM 5.2, because the resolver is first-match; Fireworks-served Kimi K3 is not independently reachable yet.
- Adding a model needs an exact provider, id, and tier row in `model-tier-inventory.tsv` and the same id in `model-routing-defaults.tsv`. Wildcard provider patterns are disallowed because they would silently classify new models.

### `dispatch-worktree`

Source: [`skills/dispatch-worktree/SKILL.md`](../../skills/dispatch-worktree/SKILL.md)

**Purpose.** The per-dispatch worktree triple (`garden/`, `journal/`, and an optional `project/`), prepared right before an `Agent` invocation and torn down right after, together with the identity pin that keeps a subagent's commits on the bot identity instead of the maintainer's.

**When it's used.** This is v1 machinery; `CLAUDE.md` marks the liaison-dispatch route retired, and the skill "survives only where a role still needs the triple shape." In practice that is the boatman, the only role allowed to override the identity pin. `roles/COMMON.md` and the gardener brief still cite it for the worktree shape's rationale.

**Key mechanics.**
- `dispatch-prepare.sh <role> <purpose-slug> [<owner>/<repo> <branch>]` creates `dispatches/<role>--<short-id>/` with detached-HEAD worktrees; `dispatch-teardown.sh <dispatch-root>` removes them idempotently.
- Identity pinning copies the bot identity from the garden repo's local `.git/config` into each worktree's local config, so a subagent cannot inherit the maintainer's global identity.
- The boatman's override is a single-commit `git -c user.name=... -c user.email=...`, allowed only when its directive carries `identity_switch_authorized: true` and names a `human:` author.
- The directory name leaves out the slug and timestamp (kept in the paired journal entry) because longer paths overran the 108-byte Unix socket limit in daemon tests.

**Gotchas.**
- If teardown never runs (a crash before the post-dispatch step), the dispatch root is stranded and needs manual cleanup.
- The bare clone `worktrees/<owner>-<repo>.git/` must already exist; prepare will not create it, and it rolls back with a hint if it is missing.
- Running `git checkout <branch>` inside a sub-worktree breaks the detached-HEAD assumption and can collide with other worktrees on that branch; push with `git push origin HEAD:<branch>` instead.
