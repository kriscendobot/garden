---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1393-review-9416ed93
verdict: miss
category: process
pr: 1393
cluster: post-gauntlet-fixer-change-unreviewed
cluster_pattern: A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head.
review_at: 2026-10-22T06:44:25Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1393#pullrequestreview-5610193365
identity: endojs/endo-but-for-bots#1393:review:5610193365:retro
producing_role: fixer (parcel pivot restack)
producing_job: endojs-endo-but-for-bots-pr1393-parcel-restack-20261015-r5527149922
missed_by: gauntlet chain (endojs-endo-but-for-bots-pr1393-gauntlet halted at clean on 2026-10-15 and was never resumed, so no panel ran over the post-pivot head); would-be seat typist (any-widening), stylist/ergonomist (module-name stutter)
severity: minor
grounds: |
  Paraphrase: CHANGES_REQUESTED review whose body only asks the bot to
  acknowledge, with three inline threads on head 6976bb0ee5. (1) The maintainer
  suggests a different ordered-encoding prefix letter for Parcels than "t".
  (2) The maintainer asks why a JSDoc import in marshal-justin.js now points at a
  module whose name repeats "types" twice. (3) The maintainer rejects a
  Map annotation in makeFullRevive that was widened to Map<number, any>, says
  falling back to any is a general rule, and asks for a job that sets up
  systematic no-any type checking.
  Verdict: a process miss on the post-panel-head freshness pattern. Six panel
  rounds (gauntlet ebfb-sturdyref-layer4-marshal-20260930, last round 6 on
  head 4445fbf937, 2026-10-03) reviewed the pre-pivot SturdyRef version. At that
  head marshal.js still typed the map precisely
  (Map<number, RemotableObject | Promise | SturdyRef>) and marshal-justin.js
  imported from ./types.js; both regressions arrived with the 2026-10-15 Parcel
  pivot restack. The restack did stage a fresh gauntlet
  (endojs-endo-but-for-bots-pr1393-gauntlet, kind probe), but its clean stage
  failed on an unrelated daemon CI flake the bot could not rerun and the
  gauntlet sat halted for a week. The post-pivot head reached the maintainer
  with no panel. Finding (3) is in panel range: the typist seat flagged an
  any-typed SturdyRef in dot-membrane.js in round 5, so the seat knows the lens,
  and replacing a precise type with any is the same shape. Finding (2) is a
  plausible stylist/ergonomist catch. Finding (1) is taste: the "t" prefix was
  present and passed through all six panel rounds, and the suggested letter is
  already taken by strings. The systematic no-any job request is new direction,
  first stated here, and belongs to the primary.
  Checked in the world: PR head 2a40caf714 (2026-10-22T08:59Z) restores
  Map<number, RemotableObject | Promise> and imports Encoding from ./types.js.
