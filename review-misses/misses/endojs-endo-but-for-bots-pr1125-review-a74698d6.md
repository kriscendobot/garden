---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1125-review-a74698d6
verdict: miss
category: style-convention
pr: 1125
cluster: comment-banner-decoration
cluster_pattern: A code comment that uses repeated rule characters as decoration (a full-width rule, or a short run bracketing a section title like "// --- title ---") reaches maintainer review, because the banner detector/archivist only recognizes a line made entirely of 4+ rule characters.
review_at: 2026-09-15T21:35:00Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5215956390
identity: endojs/endo-but-for-bots#1125:review:5215956390:retro
producing_role: builder
producing_job: unknown (invitation-flow commits on bot/build/endo-guest-invite-primitive, reviewed head 97891bb30f)
missed_by: archivist + scripts/jobs/gardening/detect-banners.sh (panel pre-pass); the then-live banner-sweep handler used the same regex
severity: minor
grounds: |
  Paraphrase: a CHANGES_REQUESTED review on head 97891bb30f with two inline
  threads on packages/daemon/src/manager.js. (1) The invitation flow added
  section comments of the shape "// --- <title> ---"; the maintainer said
  no banners and asked that the existing automation trigger a juror on
  them. (2) Code that minted an @pins entry named from structure
  (<pin>-from-<handle number>) for legacy formulas; the maintainer said to
  omit the pins instead, since pet names are chosen by the user and must
  never be inferred from structure.
  Verdict rests on (1): a miss. The no-comment-banners skill (since
  2026-06-25) says the rules bracketing a section title are forbidden, and
  a deterministic pre-pass existed. It did not bind because the detector
  (and the sweep handler of the time) matches only a line made entirely of
  4+ rule characters. A 3-dash run bracketing a title fails that regex, so
  no seat saw it across the PR's panel rounds.
  (2) alone would be new direction. No garden seat, skill, or instruction
  states the pet-names-are-never-inferred rule. The fix commit 02d5610a2a
  (21:30:50Z) also landed before the review was submitted, so the comment
  was about already-superseded code.
  Checked in the world: 15ebcccb31 removed both "// --- ... ---" lines from
  the PR. Garden main2 441cafdc2a (the primary's "automation") makes
  detect-banners force-add the archivist. DISCREPANCY: the detector regex
  is unchanged at main2 8335bc2422 and still does NOT match the flagged
  line. Tested "        // --- Fallible work, before the consume ---"
  against detect-banners.sh's awk predicate: MISS. The maintainer's
  directive (trigger a juror on *this*) is therefore unmet. The primary's
  report says it is met.
