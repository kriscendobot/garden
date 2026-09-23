---
source_kind: agent-prompt-discipline
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: evoke/SOUL.md
source_line_range: 1-29
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 383 designs-lane ingest. 29-line SOUL.md at the
  endo-but-for-bots/llm repo root in evoke/. The literal
  file the genie framework's `soul` parameter reads in.
  Thirty-first AUTHORED conformant single-body section doc
  in post-refactor era. Seventy-third consecutive non-
  garden source after the pivot (310-383). §seventy-three-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  SOUL-md-as-agent-prompt-discipline-document — the file is
  what the cycle 381 genie README named as the `soul`
  field of systemBuilder ("Internal truths"). It is an
  agent's working discipline, in checked-in markdown,
  loaded into the agent's system prompt by the framework.
  §the-named-agent-discipline-as-source-controlled-file as
  tier-3 meta-pattern. Prompt engineering is treated as
  source code: versioned, diffable, reviewable, committable.

  §The-named-three-section-soul-shape — the document has
  three explicit headings: `## Role` (who the agent is),
  `## Workflow` (how the agent works), `## Constraints`
  (what the agent must not do), with a fourth pointer to
  CLAUDE.md for project specifics. §the-named-role-
  workflow-constraints-tripartite-decomposition as tier-3
  meta-pattern; the discipline divides cleanly into three
  named layers.

  §The-named-plan-before-code-test-before-finish-twin-
  mantras — lines 3-4 are two short sentences: "You plan
  before you code. / You test before you finish." Both
  pithy, both addressed to the agent in second person.
  §the-named-imperative-mood-second-person-for-soul as
  tier-3 meta-pattern; the soul-doc is written AT the
  agent, not ABOUT the agent.

  §The-named-one-task-at-a-time-with-commit-after-each —
  line 8: "One task at a time, if a task has sub-items, one
  item at a time. Commit after each." The workflow discipline
  pairs unit-of-work with unit-of-commit. §the-named-task-
  granularity-equals-commit-granularity as tier-3 meta-
  pattern.

  §The-named-small-vs-large-change-bifurcation — lines 10-12:
  "for small changes that are obvious, just do them / but
  for larger changes or to resolve multiple options, just
  updated your task file with a plan, and wait for review."
  Branching discipline on change scope. §the-named-scope-
  branching-on-change-size-and-uncertainty as tier-3 meta-
  pattern; small obvious = autonomous; large or ambiguous =
  plan and wait for review.

  §The-named-test-before-and-after-code-changes — line 13:
  run existing tests before AND after code changes. Test
  state captured at two moments to verify no regression
  caused by the change. §the-named-bookend-test-runs-for-
  regression-detection as tier-3 meta-pattern.

  §The-named-always-commit-to-git-twice-emphasized — lines
  16-18: `**Always Commit To Git**` appears twice with
  bold emphasis, with "DO NOT leave dirty changes" as
  closing. Repetition + bold + uppercase DO NOT = maximum
  emphasis. §the-named-rule-repeated-twice-with-bold-as-
  maximum-emphasis as tier-3 meta-pattern.

  §The-named-no-overwrite-without-diff-first — line 22:
  "Never overwrite files without showing a diff first."
  Diff is the consent-gate for changes; the agent must
  show what it will change before changing it. §the-named-
  diff-as-consent-gate as tier-3 meta-pattern.

  §The-named-three-files-as-max-before-breakdown — line 23:
  "If a task needs more than 3 files changed, break it
  down." Numeric ceiling on per-task blast radius. §the-
  named-numeric-ceiling-on-per-task-blast-radius as tier-3
  meta-pattern; three is the boundary between "atomic
  change" and "decompose first."

  §The-named-when-unsure-ask-not-guess-at-business-logic —
  line 24: "When unsure, ask. Don't guess at business
  logic." Ambiguity routes to the human, not to assumption.
  Sibling shape to cycle 357's §the-named-for-expedience-
  as-honest-acknowledgment — both surface uncertainty
  explicitly rather than papering over it. §the-named-
  ambiguity-routes-to-human-not-guess as tier-3 meta-
  pattern.

  §The-named-small-and-descriptive-commits — line 25:
  "Keep commits small and descriptive." Two adjectives;
  two qualities. §the-named-two-adjective-commit-discipline
  as tier-3 meta-pattern.

  §The-named-soul-defers-CLAUDE-md-for-code-style — line 29:
  "See CLAUDE.md for code style rules, operational
  commands, and other standards." The SOUL.md owns
  discipline (workflow, planning, constraints); CLAUDE.md
  owns code style + operations. Two complementary files
  at different layers. §the-named-soul-vs-style-as-layer-
  separation as tier-3 meta-pattern; the cycle 381 README
  named identity + soul + memory + tools + heartbeat as
  five fields; cycle 383 reveals SOUL is positioned at the
  HIGHER discipline layer, with CLAUDE.md (project rules)
  at a LOWER configuration layer.

  §The-named-evoke-directory-as-agent-disposition-source —
  the file lives at `evoke/SOUL.md`, suggesting a
  directory whose role is "things that evoke the agent's
  disposition." Other files in evoke/ may serve related
  purposes. §the-named-evoke-as-disposition-source-
  directory as tier-3 meta-pattern; the directory name
  carries semantic meaning about its contents.

  §The-named-twenty-nine-line-shape-encodes-agent-discipline
  — the entire discipline fits in 29 lines. Sibling shape
  to cycles 363/365/369/380 minimal-but-rich.

  Closes seven citation arcs: cycle 382 (1, adjacent
  forward; genie DESIGN named soul as "internal truths";
  cycle 383 shows the actual content of one) + cycle 381
  (1, README's soul-vs-identity decomposition gets its
  concrete file) + cycle 357 (1, for-expedience-as-honest-
  acknowledgment sibling; when-unsure-ask-not-guess is the
  same shape applied to agent autonomy) + cycle 367 (4,
  exo's defensive interface composes with agent discipline:
  the SOUL.md teaches the agent to be defensive about its
  own changes) + cycle 326 (57, pure-naming-as-discipline;
  Role + Workflow + Constraints + CLAUDE.md is pure naming
  of layers) + cycle 365 (2, skel as template; SOUL.md is
  template-like in that derivative-agents start from a
  baseline soul) + cycle 322 (57, errors not in scope of
  this small file). Pushes citation-arc-closures-in-pivot
  to THREE-HUNDRED-SIXTY (353 + 7 net new).
---

29-line SOUL.md at endo-but-for-bots/llm repo root in evoke/. The literal file the genie framework's `soul` parameter reads in. §the-named-SOUL-md-as-agent-prompt-discipline-document (single most structurally interesting move; agent discipline as source-controlled file). §the-named-agent-discipline-as-source-controlled-file (prompt engineering treated as source code). §the-named-three-section-soul-shape (Role + Workflow + Constraints + deferred-to-CLAUDE-md); §the-named-role-workflow-constraints-tripartite-decomposition. §the-named-plan-before-code-test-before-finish-twin-mantras; §the-named-imperative-mood-second-person-for-soul. §the-named-one-task-at-a-time-with-commit-after-each; §the-named-task-granularity-equals-commit-granularity. §the-named-small-vs-large-change-bifurcation; §the-named-scope-branching-on-change-size-and-uncertainty. §the-named-test-before-and-after-code-changes; §the-named-bookend-test-runs-for-regression-detection. §the-named-always-commit-to-git-twice-emphasized (rule repeated twice with bold). §the-named-no-overwrite-without-diff-first; §the-named-diff-as-consent-gate. §the-named-three-files-as-max-before-breakdown (numeric ceiling). §the-named-when-unsure-ask-not-guess-at-business-logic (ambiguity routes to human). §the-named-soul-defers-CLAUDE-md-for-code-style; §the-named-soul-vs-style-as-layer-separation. §the-named-evoke-directory-as-agent-disposition-source. Seven citation arcs closed.
