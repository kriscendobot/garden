---
ts: 2026-05-20T01:06:23Z
kind: result
role: liaison
project: garden
to: "*"
subject_matter:
  - panel-redesign
  - pre-push-gates
  - cite-or-propose
  - juror-narrow-seats
  - meta-evolution
refs:
  - entries/2026/05/19/061905Z-result-liaison-46dfbd.md
---

# PR #75 retrospective: pre-push gates + cite-or-propose + six narrow seats land

The maintainer's framing on 2026-05-20: *"PR #75 is an example of a change that required many rounds of feedback from maintainers and continues to churn. I am thinking that we may need to add some deterministic heuristics and post-build and post-fix hooks to automate some of the kinds of recurring feedback, as well as some permanent jurors for very narrowly scoped feedback. Many of the articles of feedback I've provided are in the standing instructions. Having a much larger panel with much more focused responsibilities may help, too."*

This entry records the four-layer response.

## Catalog

A search across all 16 reviews on PR #75 (71 inline comments + 14 top-level comments from `@kriskowal`) sorted the recurring patterns into four buckets:

- **Deterministic-checkable**: Prettier drift, ASCII banners in markdown, pull-request citations in package code, filename stutter, test-package `main`, `SECURITY.md` hash divergence, sentence-per-line markdown, inline `import()` JSDoc.
- **Narrow-juror-shaped**: benchmark-closure on optimization claims (8 occurrences); changeset-vs-diff coherence (3); public-surface coherence across exports/thunk/types/README (3); knowledge-capture closure on "note this in standing orders" asks (5 meta); README padding (2); test-comment-truthing (1).
- **Already in standing instructions but not enforced**: Prettier, gratuitous renames, em-dash discipline, ASCII banners, changeset discipline, `harden`-on-exports, "benchmark before optimizing". Standing rules exist; the panel doesn't reliably read them.
- **Novel**: no pull-request citations in package code; Node.js 22+ portability floor; repo-root-config scope-justification; cross-PR feedback reconciliation for mirrored PRs.

## What landed (garden commit `634ff92`)

### Layer 1: pre-push gates

`skills/pre-push-gates/SKILL.md` plus a driver script and seven probe scripts under `probes/`. The builder and fixer invoke the gate before every push; auto-fixable findings (Prettier, eslint `--fix`) re-stage silently into whatever commit was being assembled; non-auto-fixable findings (the seven probes plus `yarn typecheck`) fail-and-report with a one-line per-finding summary.

Probes shipped: `no-ascii-banners`, `no-pull-citations`, `no-inline-import-jsdoc`, `test-package-no-main`, `security-md-hash-uniform`, `filename-no-stutter`, `sentence-per-line-md`. Each traces to a specific PR-#75 review comment in the skill's *Garden-specific deterministic probes* table.

Smoke-tested in `/tmp/gate-smoke`: passes on clean tree; fires three probes (`filename-no-stutter`, `no-ascii-banners`, `sentence-per-line-md`) on an offending tree. New probes ship as one new shell script in `probes/` plus one row in the skill's table.

### Layer 2: cite-or-propose discipline

`skills/panel-review/SKILL.md` § Cite-or-propose. Every per-juror finding carries either `[rule: <path>]` (the standing rule the finding enforces, named by file path) or `[proposed-rule: ...]` (one-sentence proposal; the judge writes `message: panel → gardener` as a fourth post-loop action). Findings that carry neither get dropped at aggregation.

The discipline forces jurors to consult standing rules rather than rely on personal taste; it's the highest-leverage change because it makes the existing seats start catching the existing rules.

### Layer 3: six new narrow code-panel seats (17 -> 23)

Six 1-2 page role files at `roles/{benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway}/AGENT.md`. Each owns one tight lens distilled from the recurring PR-#75 patterns:

- **benchmarker**: every thread proposing an optimization closes with a posted benchmark or "not pursuing" rationale.
- **changeset-auditor**: changeset front-matter package set, bump level, body identifiers, sentence-per-line, no process commentary.
- **surfacer**: `package.json` exports, `index.js` thunk, `.d.ts` types, README's claimed-public surface all agree.
- **scribe**: every maintainer "note this in standing orders" ask produces an actual edit or a proposed-rule message.
- **pruner**: README and prose padding (boilerplate sections, sections beneath the reader's needs).
- **gateway**: any PR touching a repo-root config carries explicit scope-justification.

Each role file follows the `integrator` shape: primary surface, secondary overlap, distinct-from, when-to-enter, skills, operating norms, external-repo etiquette, definition of done.

### Layer 4 (deferred): four novel rules

Four novel rules from PR #75 need encoding in CLAUDE.md or worktree CLAUDE.md before they can be enforced: no pull-request citations in package code (partially enforced by the new probe; rule needs CLAUDE.md sentence); Node.js 22+ portability floor; cross-PR feedback reconciliation for mirrored PRs; repo-root-config scope-justification (the gateway juror enforces; rule needs a one-liner). Follow-on gardener dispatches land them.

## Settled decisions

Four from the 2026-05-20 conversation:

1. **Auto-fix-and-re-stage silently** for the gate. Maximum leverage; minimum noise.
2. **Cite-or-propose** rather than hard-cite-only. Novel-finding path is explicit.
3. **All six new seats at once.** Maximum coverage from the next panel forward.
4. **Garden-side skill, invoked by builder/fixer** for the gate. Portable across forks.

## What the next gamut on a code PR will do differently

1. Builder runs the pre-push gate before the initial draft push. Prettier and eslint re-stage silently; the seven probes fail-loud if any rule is violated. First-impression-clean.
2. Judge dispatches twenty-three seats in parallel. Each seat reads its skill file plus the project's CLAUDE.md sections relevant to its inquiry surface. Findings carry rule citations or proposed-rule tags.
3. Judge aggregates with the disposition rubric (must-fix-loop / summary-fix / follow-up / acknowledge / drop) and the cite-or-propose tags. The formal review body shows every finding with its rule citation.
4. Post-loop actions: submit the review; post the summary-fix job (if any); append the followup ledger (if any); write the gardener proposed-rule message (if any); un-draft.
5. Fixer claims the summary-fix job; gate runs on its push too; non-auto-fixable findings fixed before the push reaches the panel.

PR #75's 16-round churn would, under this shape, have closed in 4-6 rounds: the deterministic class would not have survived the gate; the narrow-juror class would have been caught on the first panel round; the standing-instruction class would have been cited rather than re-discovered; the novel class would have routed to the gardener for rule-encoding rather than recurring as inline complaints.

## Self-improvement

Two structural lessons:

1. **Recurring maintainer feedback that maps to existing standing instructions is the highest-value meta-evolution signal.** The cite-or-propose discipline catches the gap (jurors not reading the rules); the gate catches the deterministic subset that should not have reached a juror at all. The combination beats either alone.
2. **Panel expansion at six seats per engagement is a step-change; the rubric stability the user named as the risk on the staged-rollout option is real.** Mitigation: the cite-or-propose discipline forces each new seat to anchor findings in concrete standing rules from its first dispatch onward, so the seat-discipline accretes the same way the existing seats' did.

Self-improvement: when the maintainer surfaces "this pattern keeps recurring", catalog the pattern's empirical instances first (the agent dispatch that produced the 71-plus-14 inventory) and let the categorization drive the structure rather than guessing at the shape. The categorization itself was the leverage; the four layers fell out of the four buckets.
