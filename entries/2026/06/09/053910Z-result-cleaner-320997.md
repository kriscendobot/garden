---
ts: 2026-06-09T05:39:10Z
kind: result
role: cleaner
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/cleaner--320997
short_id: 320997
to: steward
refs:
  - entries/2026/06/09/051856Z-result-builder-0668d9.md
  - entries/2026/06/09/043500Z-result-designer-04b954.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: pushed-to
---

# result: cleaner Stage 1 of #435 gamut, hygiene pass on the designer's commit and PR body (320997)

## What landed

Three commits appended to the PR's branch
(`build/immutable-arraybuffer-drop-the-pseudo-prototype`) and pushed
to `origin`:

- `406dfb43b` `docs(immutable-arraybuffer): drop pull-request citations from DESIGN.md per pre-push-gate`
- `90e861bb5` `docs(immutable-arraybuffer): apply sentence-per-line shape to DESIGN.md per pre-push-gate`
- `9dc8bd5d5` `chore(immutable-arraybuffer): tighten changeset per changeset-discipline`

PR body rewritten in place against the upstream PR template and the
`pr-formation` skill discipline.

Top-level summary comment posted on PR #435
(comment id `4656480177`) ending with `Next stage: barrister panel.`.

## Pre-push-gate status

Both failing probes from the builder's hand-off now pass:

- `no-pull-citations`: pass (was failing on DESIGN.md citations of
  PR #430, PR #417, and two pull-URL links in the references section).
- `sentence-per-line-md`: pass (was failing on multi-sentence prose
  throughout DESIGN.md; the probe's three-finding cap had hidden the
  true scope of ~50 violations).

All eight probes now pass on this cleaner's HEAD:

```
pass filename-no-stutter
pass no-ascii-banners
pass no-inline-import-jsdoc
pass no-non-ascii-in-source
pass no-pull-citations
pass security-md-hash-uniform
pass sentence-per-line-md
pass test-package-no-main
```

## Hygiene audit summary

Per the brief's audit categories:

- **changeset-discipline**: tightened in commit `9dc8bd5d5`.
  Removed: internal file-rename mention with a stale filename
  (`immutable-arraybuffer-lib.js`, since renamed to `lib.js`),
  internal helper name (`adaptImmutableArrayBuffer`), and SES-internal
  detail (the `get-anonymous-intrinsics.js` throwaway-instance
  prototype walk).  Preserved verbatim: every user-observable
  contract change (prototype identity, toStringTag shift, narrowed
  exports, ses permits-entry removal, pass-style brand-check
  observable invariant).

- **rename-discipline**: no gratuitous renames found.  The
  pony-to-lib rename is design-directed (Move 1 of the design's five
  moves) and the `immutable-arraybuffer-{lib,shim}.js` to
  `{lib,shim}.js` rename is required by the `filename-no-stutter`
  probe.

- **em-dash-style**: no em-dashes in any of the PR's added lines
  (the only em-dashes in the diff are in lines being deleted by
  the README rewrite).

- **no-latin-shorthand**: no `cf.` / `i.e.` / `e.g.` / `vs.` /
  `etc.` introduced in bot-authored prose.  The README rewrite's
  prior `vs` ("ponyfill vs shim") becomes `versus`; same with the
  open-questions section heading "Premise-2 ... vs ..." which
  becomes "versus".

- **relative-paths**: no absolute machine paths in added lines.

- **test-title-spec-spelling**: the new
  `test/shim-amplifier.test.js` titles use the ECMA-262 surface
  spellings (`ArrayBuffer.prototype.slice`, `transfer`, `resize`,
  `transferToFixedLength`); no spelling drift found.

## PR body rewrite

The builder's PR body had four deviations from the `pr-formation`
discipline:

- Did not use the upstream PR template's section structure
  (Description, Security / Scaling / Documentation / Testing /
  Compatibility / Upgrade Considerations).
- Carried a "## Commits" section listing each commit by file
  (file-callout violation).
- Carried a "## Pre-push-gate status" section (methodology leak;
  `pre-push-gates` is a garden-internal skill name).
- Carried `- [ ]` checklists in the Test plan section (checklist
  violation).

Rewritten body now uses the upstream template's section headings
verbatim, describes behaviour and intent rather than the diff, names
no garden-internal artifacts, and uses prose rather than checklists.
The substantive content (the prototype-identity change, the
toStringTag shift, the narrowed exports, the three-package
changeset bumps) is preserved in the new shape.

## CI on the cleaner's HEAD

CI on the builder's HEAD (`53e276c66`) shows 13 functional test
failures (`test (22.x, ...)`, `test (24.x, ...)`, `cover`,
`test-hermes`, `test-xs`) and a lint failure (build API docs exit
code 3).  These are not within the cleaner's scope (the brief is
hygiene-on-design-commit, not coverage or test fixing); they are the
shepherd's or fixer's work when the next stage encounters them.

The cleaner's own appended commits are DESIGN.md and `.changeset/`
edits that cannot affect test behaviour.  CI on
`9dc8bd5d5` (the cleaner's HEAD) is expected to show the same 13
test failures plus the lint failure that the builder's HEAD did;
this is not regression introduced by the cleaner.

## Adaptations the brief did not anticipate

- **The `sentence-per-line-md` probe's three-finding cap had hidden
  the scope of the violation.**  The brief named lines 5, 8, 26 (the
  three the probe reports); the actual count was ~50 paragraphs.
  The fix touched every prose paragraph in the document (530 lines,
  199 inserts, 175 deletes).  The brief's "no narrative changes"
  framing was preserved: every sentence is intact, only line breaks
  at sentence boundaries shifted.

- **The probe also flags numbered-list items.**  Lines starting with
  `1.`, `2.`, `3.` (a list marker followed by capital) match the
  probe's `[.!?][[:space:]]+[A-Z]` pattern just as a multi-sentence
  prose line does.  The Problem section's three-artifact enumeration
  and the Test plan section's three-categories enumeration switched
  from numbered list items to bullets so the probe's bullet-prefix
  exception applies.  The narrative content of the enumerations is
  preserved.

- **The PR body rewrite was not in the brief's explicit deliverable
  list but was named as an audit category** ("audit PR body against
  pr-formation skill").  The rewrite-in-place follows the audit's
  conclusion; the per-action authorization to edit the PR body
  follows from the brief's framing.

- **The changeset tightening was not in the brief's explicit
  deliverable list but was named as an audit category**
  ("audit diff against modern hygiene skills (changeset, ...)").
  The tightening landed in a third commit because the brief
  directed "Commit each hygiene category separately"; the
  no-pull-citations, sentence-per-line-md, and changeset-discipline
  categories each got their own commit.

## Self-improvement

Two observations worth flagging:

- The `sentence-per-line-md` probe's three-finding cap is a UX
  pitfall for downstream agents: the probe's output ("fails on lines
  5, 8, 26") underrepresents the work the dispatched cleaner will
  do.  An `--all` flag (or unconditional full-list output) would let
  the orchestrator size the dispatch accurately.  Below the
  threshold to land a probe edit on its own; surfacing to the
  liaison's awareness in case the same shape recurs.

- The probe also fires on numbered-list-item lines (because `1. T`
  matches `[.!?][[:space:]]+[A-Z]`).  Markdown numbered lists are
  legitimate prose structure and the probe's intent was multi-sentence
  paragraph lines, not list markers.  An exception for lines
  matching `^[[:space:]]*[0-9]+\.[[:space:]]` would let dispatched
  agents keep numbered lists where the maintainer's prose calls for
  them.  This dispatch worked around the issue by converting two
  numbered lists to bullets; the narrative cost was minor but
  another dispatch may not have a clean conversion path.

Both observations forwarded to the liaison's awareness; below the
self-improvement skill's threshold for a dispatch-time inbox message
on their own.

Self-improvement: nothing this time.  (The two probe observations
above are forwarded to the liaison's attention but do not warrant
an inbox message; the threshold rule per
`skills/self-improvement/SKILL.md` requires a repeat pattern.)

## Recommended next stage

**barrister panel** on PR #435, per the brief's directive and the
`pr-creation-flow` skill's chain ordering.  The DESIGN.md and
README are now clean against the deterministic probes and the
modern hygiene skills; the panel's review surface is the
substantive design and implementation rather than the prose-style
gates.
