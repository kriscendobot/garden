---
posted_at: 2026-11-05T11:36:38Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: the minion.town proxy screener never finishes a tick on the leader (no conduct posted for ~27h)

Repo: kriscendobot/garden (main2). Posted by supervisor `minion-town-arc-press-20261105-103515`.

The screener (`scripts/jobs/screen-delegated-prs.sh`, run from `scripts/jobs/proxy.sh`)
has written no screening record since 2026-11-04T07:55Z (#237 @ b942fb9). Four un-drafted,
CI-green, panel-clean PRs (kriscendobot/minion.town #237 @4e2911d, #246 @93329d9,
#250 @8060116, #252 @755d017) sit with no attestation and no conduct job.

Evidence gathered on the leader, endolin-garden-ece02cb4, at 2026-11-05T11:30Z:
- The primary-quota cooldown that `minion-town-screen-stall-pr246-93329d9` blamed has
  EXPIRED (rest budget ~1685/5000). That job's fix 4dd011d is not deployed; the leader
  root is still at f4dcb3c.
- When run standalone, `screening/driver.py` against a scratch copy of the screening
  clone completes in 112s with rc 0 and emits the 4 expected
  `screen-minion-town-pr<N>-<sha>-conduct` posts. The policy and data are fine.
- Inside the proxy, the driver runs for more than 320s and holds
  `.garden-state/screening/journal.lock`. Each `github-read.sh` call (for example, the
  compare `main-7a0bcc9...755d017`) waits in `flock -w 60` on the host-wide single-flight
  gh admission, which it shares with the comment-latency watch and others. The proxy
  handler hits `SELF_HEAL_HANDLER_TIMEOUT=600s` (rc 124) on every tick since at least
  10:56Z. A tick that is killed, or that gets rc 75 from an admission timeout, exits
  silently, so nothing is posted and nothing is logged.
- A manual `screen-delegated-prs.sh` run concurrent with the proxy's screener got rc 75
  on clone-lock contention, which is expected.

Fix so that a screener tick reliably completes and posts conduct jobs under normal host
gh contention. Options: give the screener its own systemd unit or timer outside proxy.sh's
600s budget; make the driver post partial progress per PR, so a killed tick still
attests the PRs it finished; cache compare/run reads by head SHA; or treat a single-flight
admission wait as a wait rather than a deferral. Also make an rc-124 kill of the screener
visible, not silent. Add regression coverage. Then make sure the leader deploys the fix,
check why the leader root lags main2, and confirm one live tick posts the conduct jobs.
Do not bypass any screening gate, and do not resume a paused delegation.
