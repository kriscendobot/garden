---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1329-comment-5785807820
verdict: miss
category: naming
pr: 1329
cluster: avoid-name-abbreviations
cluster_pattern: An abbreviated identifier in freshly-authored code that a panelled PR let through.
review_at: 2026-09-22T23:09:56Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1329#issuecomment-5785807820
identity: endojs/endo-but-for-bots#1329:comment:5785807820
producing_role: builder
producing_job: endo-revive-registry-host-formula-migration
missed_by: stylist; spell-out-identifiers pre-push gate
severity: minor
grounds: |
  PR #1329 added a test helper openTestDb and local `db` variables in
  packages/daemon/test/registry-endo.test.js. The 31-seat code panel ran
  (run-the-gauntlet-endo-pr1329-20260922-expanded-window, base 2d0f7fb) and let
  them through; the maintainer asked why the stylist did not recommend
  expanding the initialism to Database. The never-abbreviate convention was a
  standing rule (cluster avoid-name-abbreviations, gate spell-out-identifiers
  landed aa2da527e5 2026-07-11, stylist brief check), but `db` was absent from
  both the gate's curated blocklist and the stylist example list, and the
  stylist's surrounding-code-consistency principle argued for copying the
  sibling endo.test.js convention. Already remedied by the hand-posted
  investigate-stylist-db-initialism-miss job: main2 fbf05a3dd5 (2026-09-23)
  added db to the probe blocklist with regression tests and made the stylist
  brief say local convention is no exemption. Recorded here because the
  comment-watcher dropped the comment, so no retro was minted for it.
---

# Miss: PR #1329 `db` initialism

A freshly-authored helper and locals abbreviated "database" as `db`; the panel
and the spell-out gate both passed them because the gate matches a curated list
that lacked `db`. See `comment_url` for the untrusted verbatim comment.
