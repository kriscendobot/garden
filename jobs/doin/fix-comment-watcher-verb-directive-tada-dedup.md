---
role: fixer
---
<!-- garden-promoted-from-plan: gate=deferred priority=high at=2026-07-18T04:19:03Z -->

# Fix: comment-watcher drops a fresh maintainer verb-directive when its deterministic base sits in tada/

Evidence (2026-07-18, found by the byte-array press): kriskowal commented
"Shepherd." on endojs/endo-but-for-bots PR #671 at 2026-07-15T05:40Z (issue comment
id 4977246906). The comment-watcher never acknowledged it (zero reactions) and no
job reached any board. Root cause hypothesis: the watcher's branch-op verbs derive
the deterministic base `endojs-endo-but-for-bots-pr671-shepherd`, and the lifecycle
dedup (`job_in_lifecycle`, scripts/jobs/comment-watcher.sh ~line 363: `for sub in
todo doin tada`) counts **tada** — a same-named auto-shepherd completed 2026-07-10,
so the NEW directive deduped against a FINISHED job and was silently dropped, with
no reactji and no surfacing. The PR then sat conflicting for 3 days against an
explicit maintainer directive.

Desired behavior to design/implement (gardener's judgment on mechanism):
- A fresh comment directive (new comment id) must never be swallowed by a tada/
  entry of the same base. Options: exclude tada from the verb-directive basename
  dedup (identity dedup already handles true re-sees), or date/comment-suffix the
  derived base, or on tada-collision repost with a disambiguated base.
- On any dedup-drop of a maintainer comment, at minimum leave the eyes reactji or
  log a surfaced skip, so a dropped directive is visible instead of silent.
- Add a regression test if the watcher has a test harness.

Related prior art: memory/press-schedule-cadence-gotchas (the press-side variant of
the same tada-counting dedup). Immediate stall was already corrected by jobs
endojs-endo-but-for-bots-pr671-weave-20260718 +
endojs-endo-but-for-bots-pr671-shepherd-20260718; this job is the durable fix.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-18T04:19:08Z
