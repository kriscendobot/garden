---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1348-review-4984e562
verdict: not-a-miss
category: new-direction
repo: endojs/endo-but-for-bots
pr: 1348
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1348#pullrequestreview-5398940612
identity: endojs/endo-but-for-bots#1348:review:5398940612:retro
review_at: 2026-10-03T04:11:48Z
surface: pr-review-body
author: kriskowal
grounds: >-
  The review (CHANGES_REQUESTED, 2026-10-03) is an exploratory design expansion,
  not a defect report: it asks to grow the confined-command grammar with a broad
  example corpus of well-attenuated commands, asks whether the grammar can express
  symlink-resolved workspace-prefix confinement, whether the executor DSL can compose
  pipelines/process substitution from workspace-free or shared-workspace commands
  (e.g. cat as a capability with redirect-based "copy"), and whether a second grammar
  for a pipeline builder is warranted. The command-grammar surface itself was only
  introduced on 2026-10-03 in response to the maintainer's own 2026-10-01 directive
  (replace allowed-commands with passable command expressions); these questions are
  first stated in this review and no seat brief, skill, or standing rule requires them.
  The PR did run the full gauntlet (journal jobs/tada/2026/09/29 pr1348-gauntlet,
  panel-1..4, fix-2..5, viability), so there is no process miss. Primary deliverable
  verified in the world: head 808f0372 adds packages/exo-shell/examples/agent-command-grammars.js
  and a 2026-10-05 review-follow-up comment addressing the examples and path/pipeline questions.
---
Maintainer asked for the new command grammar to be enriched with a comprehensive
example set and probed whether it can express symlink-aware path confinement,
pipeline composition across shared or path-free capabilities, and a separate
pipeline-builder grammar. New direction on a just-introduced surface; dismissed.
