---
gate: go-ahead
priority: normal
role: builder
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-07T03:03:21Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T03:03:21Z
---

---
posted_at: 2026-11-06T05:16:31Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
tier: mentor
---
Maintainer directive (kriskowal, liaison session 2026-11-06): write the Oros Studio hand-off for the provider-secrets release, so the operator of `oros-studio-garden-ce242c49` (a Mac) can make that host capable of running the new bubblewrap sandbox before it deploys.

Background. `1e1968c0781` (file-based provider key management) wraps each secret-bearing harness launch in `scripts/secrets/run-sandboxed.sh`, which exits 75 with "bubblewrap unavailable; refusing a secret-bearing harness" when `bwrap` is missing. On 2026-11-05 the leader deployed it without the container rebuild that `context/operations/secrets.md` § One-time compatibility migration requires, and the endolin fleet completed nothing for about 17 hours. Oros has not deployed it (its canary is held at 2c082b9acbc), so Oros is safe until it does. Do not let it deploy first.

Deliverable: `context/operations/oros-secrets-handoff.md` on `main2` (pushed directly per the garden's no-PR convention), covering:
1. Why bubblewrap is Linux-only and how the garden container on a Mac (Docker Desktop or other Linux VM) acquires it: the `./garden build` image gains `bubblewrap`; state the exact Dockerfile and launcher change this requires, and confirm it is already in `main2`.
2. What the container must permit for bwrap to work inside it (unprivileged user namespaces, seccomp/AppArmor profile, `--cap-add`, `/proc` visibility), with a copy-paste smoke test such as `bwrap --ro-bind / / --unshare-all true` and the exact success/failure outputs. Check how `run-sandboxed.sh` invokes bwrap and list every capability it needs.
3. The ordered operator procedure for Oros: drain, `./garden build`, `./garden reset`, `./garden create`, the six-variable import (`scripts/secrets/import-environment.sh`, `scripts/secrets/status.sh`), verification that a harness job completes, then lift the drain. Note that placing keys is the operator's act; no agent handles values.
4. How to hold the Oros deploy until the operator confirms (name the existing mechanism, for example the `upgrade-ready` fact or a hold), and how the leader's rolling deploy should treat an Oros that cannot run bwrap.
5. A rollback if bwrap cannot be made to work on the Mac.
Also report whether the deploy gate or canary should check `command -v bwrap` before advancing, and file that as a follow-up recommendation in your completion report rather than implementing it.
