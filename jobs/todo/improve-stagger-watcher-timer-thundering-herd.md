---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/systemd/garden-ci-watcher@.timer
The journalctl tail shows dozens of "transient gh-api blip (5xx/HTML/rate-limit) — skipping tick" WARNs clustered within the same 1-2 second window, repeated every cadence period (14:05:43, 14:06:49-50, 14:07:55-57, 14:08:19, 14:09:52-55, 14:11:19, 14:13:21-26), across every ci-watcher/dependabot-watcher/comment-watcher/approval-reconciler instance for all ~15 watched repos. Root cause: `garden-ci-watcher@.timer` (and its siblings `garden-comment-watcher@.timer`, `garden-dependabot-watcher@.timer`, `garden-approval-reconciler@.timer`) anchor every per-repo template instance to the same `OnBootSec` monotonic reference with no `RandomizedDelaySec`, so all ~15 instances of each watcher fire `gh api` in the same second, every cadence, forever — a self-inflicted thundering herd that GitHub's API answers with exactly the "transient blip" the watchers then correctly (but wastefully) skip. `garden-triager@.timer` already diagnosed and fixed this identical mechanism ("every template instance becomes due on the same OnBootSec boundary and GitHub can reject the authentication burst") by adding `RandomizedDelaySec=30s`. Add the same `RandomizedDelaySec` (scaled to each timer's own cadence — e.g. 30s for the 90s-cadence ci-watcher/comment-watcher, larger for the 300s dependabot-watcher and 15min approval-reconciler) to all four timer units so per-repo instances spread out instead of picketing the same second; this should measurably cut the "skipping tick" rate without changing any watcher logic.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->
