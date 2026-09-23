---
role: fixer
priority: urgent
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: comment-latency-watch and journal-contention-watch are flooding the maintainer inbox with false alarms

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR). Both watches were
built today (comment-latency: 3b536fd4e8; journal-contention: 0ee659b7da, 5fd533bcc1) and deployed to
both hosts. Within ~2.5h the maintainer inbox gained ~70 watchdog notices. Read the live notices under
`journal/inbox/maintainer/unread/watchdog-{comment-watcher-dead,journal-clone-oversized,journal-fetch-drift,journal-lock-contention}-*`
for exact details. Fix every defect below, with a regression test for each.

1. **comment-latency-watch: `comment-watcher-dead-<slug>` for ALL 16 armed repos** (leader
   endolin-garden-ece02cb4, notice_count 26, since 18:37Z). Detail:
   `watcher heartbeat (age=-13s outcome=cooldown)`. Two defects:
   (a) a NEGATIVE heartbeat age: a clock or parse bug (timezone, ms vs s, or reading a future
   timestamp). A negative or skewed age must never classify as dead.
   (b) `outcome=cooldown` must classify as **muted** per `designs/comment-latency-watch.md` § 2/§ 4.
   Only a cooldown STUCK beyond the stuck threshold (1200s) may alert, and then as its own class
   (`comment-watcher-stuck-cooldown-*`), not "dead". Also determine read-only whether the leader's
   comment watchers really ARE in journal-outage cooldown on most ticks. If so, that is a real
   finding (the 4.5h-incident class); report it with evidence and alert it ONCE as a single
   host-level notice, not 16 per-repo ones.
2. **journal-contention-watch: `journal-clone-oversized-*` for ~40 healthy clones on both hosts.**
   Example: `…/garden2/.garden-state/sysop/journal: packs 57 >= 50; size=55468032B`. That is a 55 MB
   clone. A 50-pack threshold is far too low for these clones. Recalibrate using the real
   distribution (run the probe on both hosts): key the hard guard on SIZE (the incidents were 6.6 GB
   and 105 GB) and on `gc.log` presence; if pack count is kept at all, make it an order of magnitude
   above the healthy population (e.g. the leader's ci-watcher/verify had 40,806 packs, which is the
   pathological case). Report the chosen thresholds and the distribution they came from. Make sure the
   automatic remedy does not churn-rebuild healthy clones.
3. **journal-contention-watch: `journal-fetch-drift-*` fires BELOW its own floor.** Example: oldest-third
   median 2.29s, newest 3.82s, "1.5x floor=10s", but it still alerted. The floor must gate the alert:
   no drift alert unless the newest median ≥ floor. Also require the projection-to-guard to be
   meaningful (e.g. within 24h, as designed; 27561s ≈ 7.6h is inside that, so the floor check is the
   real gate). Short-lived per-job inbox clones (`inbox/<job-base>/journal`) have too few samples for
   drift at all; require a minimum sample count and span.
4. **`journal-lock-contention-_home_kris__garden_fetch_test_clone`:** a TEST fixture path
   (`/home/kris/.garden_fetch_test_clone`) is feeding the real stats. Tests must write to an isolated stats
   dir (e.g. `$GARDEN_STATE` under a temp root), never the live one. Find which test does it.
5. **Close the false notices:** after the fix deploys, the watches must emit `--recovered` for
   conditions that no longer hold under the new rules, so the existing notices close themselves. Also
   add a **fleet-wide storm guard**: if more than N (say 5) distinct keys of one watch class open within
   one tick window on a host, collapse them into ONE summary notice.

Run the new and existing test suites for both watches, then push to `main2`. Rollout goes through the
normal rolling deploy. Complete the job via the normal completion path when done.

<!-- garden-transient-elapsed: kind=signature through=0 values=677 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T21:05:26Z
