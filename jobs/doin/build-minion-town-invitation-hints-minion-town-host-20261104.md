---
posted_at: 2026-11-04T00:40:44Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
pr: https://github.com/kriscendobot/minion.town/pull/236 (and its Endo companion https://github.com/endojs/endo-but-for-bots/pull/1647)
tracker: https://github.com/kriscendobot/minion.town/issues/227
task: Maintainer decision (2026-11-04): advertise remote invitation hints as host `minion.town`, with the path to the HTTP/WS endpoint where appropriate (not a bare host:port to a separate TCP listener, if the WS route can carry the account daemon). Answers to the PR's open questions: use `minion.town`, no dedicated subdomain.

Do:
1. Re-examine the transport choice in PR 236/1647 (TCP :8940) against the WS route `wss://minion.town/.well-known/ocapn-cbor-np` (proven dialable from the garden host 2026-08-28, but it served demo containers, not the account daemon). Determine what it takes for the account daemon's remote invitation to carry a hint that names `minion.town` plus the WS path: which netlayer (the WS+Noise netlayer is endo-but-for-bots PR 684, a draft; check what is merged on llm now), which hint format, and what routing change (a Caddy handle to the account daemon) would be needed.
2. If the account daemon can be reached through that path with only merged Endo code, revise PR 236 (and 1647 only if still required) to advertise it. If it needs unmerged Endo work or a routing change, keep TCP with host `minion.town` in the PR as the fallback, and state the WS variant as an explicit request to the maintainer with the exact Caddy change. Do not change any routing, ports, or firewalls yourself.
3. Prove it with a scratch daemon, including the two-daemon accept that did not complete last time (run the daemons under a supervisor that survives the shell, e.g. a systemd-run scope or setsid with logs). Report the locator before and after.
4. Per the build-location rule: keep new code in minion.town; Endo changes only if minion.town cannot work without them.
Constraints: draft PRs; no deploy; no secrets in logs. Write the PR description as a production-outcome report.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T01:49:10Z
