---
gate: orchestrated
orchestrated_by: fireworks-glm52-kimik3
priority: normal
posted_by: producer
posted_at: 2026-07-28T07:15:34Z
---

# Canary GLM 5.2 and Kimi K3 on Fireworks

Third child of orchestration `fireworks-glm52-kimik3`. Runs **after**
`fireworks-glm52-kimik3-build` lands. This is the bounded-activation step from
[context/operations/fireworks.md](../../context/operations/fireworks.md) § Create
and canary — follow it exactly.

## Hard precondition — check first, and stop if unmet

This job **requires a container carrying `FIREWORKS_API_KEY`**.

**Amended 2026-07-28T07:3xZ by the liaison.** The original text here said the key
was **absent** on `endolin-garden-ece02cb4`. That was true at 07:15Z and is **no
longer true**: the container was recreated with the key at 07:20Z, and the liaison
verified presence-only at 07:3xZ through the tmpfs handoff
(`/run/environment.d/60-garden-api-keys.conf` now carries both `MOONSHOT_API_KEY`
and `FIREWORKS_API_KEY`), `systemctl --user show-environment`, and the environments
of the running workers. So a key-bearing host exists.

Two things this does **not** settle. First, key presence is confirmed on
`endolin-garden-ece02cb4` **only**; the leader, `endolin-garden2-5bcdff64`, is
**unverified**, and this job runs wherever a gardener claims it. Second, the key can
still be supplied **only at container creation** (`./garden reset` then
`FIREWORKS_API_KEY=... ./garden create`), which is a **maintainer act**. No agent
may self-provision it, and nothing here should attempt to.

So the precondition stands as a **check, not a foregone conclusion**: verify the key
is present on the host you are actually running on (presence only, never its value).
If it is absent **there**, do **not** improvise, do not switch providers, and do not
mark this done. Report the gap to the maintainer inbox naming which host you ran on,
mark the report `orchestration-failed: true` so the orchestration's halt policy
engages, and stop.

## Procedure

1. Optional authenticated probe that prints **only a status code**:
   `curl -sS -o /dev/null -w '%{http_code}\n' -H "Authorization: Bearer $FIREWORKS_API_KEY" "$GARDEN_FIREWORKS_BASE_URL/models"`
2. On a good status, enable exactly one worker: `scripts/jobs/set-fireworkers.sh 1`.
3. Post **one** harmless, isolated-worktree canary per model — GLM 5.2 and Kimi K3 —
   each with its explicit `fireworks/<wire-id>` route and **no external action**
   (no PR, no comment, no upstream push). Use the canary shape the build child's
   report specified.
4. Confirm each `jobs/tada/` report carries `worker_kind: fireworker` and provider
   `fireworks`, with tool-verified evidence the model actually did the work rather
   than merely returning text.
5. Return the pool to zero — `scripts/jobs/set-fireworkers.sh 0` — unless the
   maintainer has explicitly authorized a larger trial. Do not widen it yourself.

## Constraints

- HTTP 429 (capacity) and 503 (load shedding) are retried with backoff. Auth and
  configuration errors are **not** retried — surface them.
- **Never** copy a key, an `Authorization` header, or an API response body into a
  report, the journal, or a diagnostic. Status codes only.
- Judge the two models on the canary evidence and say plainly how each did,
  including if it did badly. A canary that produced plausible-looking but unverified
  output is a **failed** canary.

## Done when

Both canaries have run under a key-bearing container with tool-verified evidence,
the pool is back at zero, and the report states — per model — whether the route is
sound and what work classes it should be trusted with next. Or: the key was absent,
and the report says so with `orchestration-failed: true`.
