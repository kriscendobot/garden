---
ts: 2026-05-15T06:11:21Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/15/055100Z-result-judge-0258e4.md
---

# Result: fixer on PR #266 (`design: opencode comparative analysis + gap-closing raft (endopen)`)

Dispatch root: `dispatches/fixer--02ad10/`.
PR: [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266).
Addressing SHA: `8a4dc743ede3a94f5436ec1e17b9a2b6c8cc8725`.

## What I did

One follow-up commit on top of `7424956fd` addressing every item the
design panel surfaced in the [055100Z judge result](055100Z-result-judge-0258e4.md):
1 must-fix and 8 should-fix items.
The diff touches all five `designs/endopen-*.md` files (-354 / +608 lines)
and is entirely documentation revision (no source changes, no
package.json or yarn.lock churn).

## Must-fix item addressed

- **Project markdown-style reflow** (`<project>/CLAUDE.md` § Markdown
  Style: 80 to 100 column wrap, sentence-per-line so diffs are
  per-sentence).
  Prose reflowed across `endopen.md`, `endopen-acp-server.md`,
  `endopen-concurrent-subagents.md`, `endopen-openrouter.md`, and
  `endopen-tui-shell.md`.
  Tables, fenced code blocks, ASCII diagrams, and markdown link targets
  retain their natural shape (intrinsically wide; the spirit of the
  rule is per-sentence diffability of prose, not literal column count
  on every line).

## Should-fix items addressed

1. **Formula-type count 33 -> 30** in `endopen.md` § Persistence and
   `endopen-concurrent-subagents.md` § Design Decisions 1.
   Line range corrected from "lines 6 through 35" to "lines 6 through 37"
   per `packages/daemon/src/formula-type.js`.
2. **Panel-conflation correction** in `endopen-concurrent-subagents.md`
   § Reuse: the judge dispatches one of two panel kinds per PR (the
   12-seat code panel for source-touching PRs, the 5-seat design panel
   for design-only PRs); never a single 17-seat round.
3. **OpenRouter provider-detection ordering** in `endopen-openrouter.md`:
   inline code comment in Phase 1's `detectProviderKind`, a new
   "Ordering as a design decision" paragraph, and Design Decisions 3.
   Phase 2's registry encodes ordering as a per-entry `match(baseURL)`
   predicate evaluated in declared order rather than relying on source
   position.
4. **Vocabulary list recast** (copyeditor) in
   `endopen-concurrent-subagents.md`: the four panel terms now lead
   with the role and end with the term, so the definitions are not
   self-referential.
5. **ACP-method list normalized** (copyeditor) in
   `endopen-acp-server.md`: each session-scoped method's object is
   the session, with the inner-object (in-flight prompt, child session)
   named after the colon.
6. **Heading-case consistency** (pedant should-fix 6): sentence-case
   headings under `endopen.md` § Major Gaps, § Major Contrasts, and
   § Summary converted to title case per the `endoclaw.md` precedent.
7. **"Claude Code" defined on first use** (novice) in `endopen.md`
   § Background: parenthetical "Anthropic's terminal coding agent"
   added.
8. **vat / SES-compartment model grounded** (novice):
   `endopen-concurrent-subagents.md`'s problem statement now opens
   with an explicit vat definition and cross-links to
   `daemon-capability-filesystem.md` and `formula-type.js`;
   `endopen.md`'s unit-of-isolation paragraph cross-links to
   `daemon-256-bit-identifiers.md` and `daemon-capability-filesystem.md`.

The copyeditor's ambiguous-parenthetical finding in `endopen.md`
§ Background (the "captured 2026-05-15" modifier) was addressed in
the same pass: the modifier now unambiguously attaches to the HEAD
reference rather than to the clone path.

## Commit shape

A single commit. The panel verdict explicitly called the must-fix
"mechanical, single follow-up commit" and the should-fix items
landed in the same reflowed paragraphs (each substantive correction
sits inside a paragraph being reformatted, so splitting commits would
create artificial whitespace-only churn). The commit message body
lists every addressed item by name for the judge's verification pass.

## CI status

PR #266 is in draft. No CI workflows ran on the new head (or on the
prior head 7424956fd either) -- this repo's `pull_request`-triggered
workflows do not fire on draft PRs in practice. The dispatch's
"4 design-only checks" was an estimate that did not materialize; the
PR's `statusCheckRollup` remains empty.
This is consistent with the design-only nature of the PR: no source
changes, nothing for the lint / depcheck / browser-test / CI matrix
to evaluate.

## Top-level PR summary

Posted at [#266 comment](https://github.com/endojs/endo-but-for-bots/pull/266#issuecomment-4457356548)
citing the addressing SHA and enumerating every must-fix and should-fix
item handled. No inline thread replies (the panel verdict was posted
as a single review with no inline comments; the must-fix and
should-fix items appeared in the review body, not as inline threads).

## Out-of-scope items (per panel verdict)

Five items the panel classified as out-of-scope ride out of this
fixer loop: em-dash use (consistent with the `endoclaw` precedent and
not a project violation), the design-stage test catalog (deferred to
implementation PRs), `endopen-tui-shell.md`'s opencode-shaped-space
premise (deferred to implementation PR), potential overlap with the
sibling endopi raft #265 (cross-link belongs in `designs/README.md`
when both un-draft), and `external/opencode/` citation discipline
preamble (could be documented in the `## Citation Index` preamble of
each comparative analysis as a separate follow-up).

## Next-stage-owed

**Judge verification.** The next orchestrator turn should dispatch
the judge on PR #266 to re-run the design panel against the new head
and confirm that the must-fix and the eight should-fix items are
addressed. The panel verdict's framing was that the next panel round
is likely terminal after the fixer's pass; if the panel returns a
comment-only verdict with no in-scope must-fix and no kriskowal inline
comments, the judge un-drafts and the PR-creation-flow chain
terminates.

Self-improvement: when a must-fix is "mechanical reflow" and the
should-fix items live in the same paragraphs as the reflow, treat
the must-fix and those entangled should-fix items as one inseparable
commit rather than fighting `git add -p` to fabricate per-concern
splits. The `review-feedback-followup-commits` skill's "one concern
per commit" rule is for code PRs where lines can be reverted
independently; in a design-doc PR where the reviewer reads rendered
markdown, a single well-described commit naming each addressed item
in its body serves the same audit-trail purpose with less ceremony.
Threshold: this is a per-skill note (the existing skill already
permits the major-rewrite exception "Land the rewrite as commit A;
treat any subsequent follow-ups as additive sharpenings"); a brief
addition naming the design-doc reflow case as a second exception
would prevent a future fixer from spending the same minutes on the
split-vs-combine debate. Route as a `message` to `liaison` for the
review-feedback-followup-commits skill's *Patterns that trigger a
deeper read* section if confirmed.
