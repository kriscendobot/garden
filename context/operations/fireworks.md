---
created: 2026-07-25
updated: 2026-07-30
author: gardener
---

# Bounded Fireworks worker activation

`fireworker` is a provider-constrained, tier-pinned Fireworks AI pool. It uses Codex's custom
OpenAI-compatible provider route to `https://api.fireworks.ai/inference/v1` and
receives `FIREWORKS_API_KEY` only through the container's tmpfs systemd handoff.
The key is never put in a unit, journal, worktree, report, or diagnostic. The pool
starts at zero and refuses unconstrained work.

## Registered route

The closed inventory registers `fireworks/accounts/fireworks/models/glm-5p2` as a
`mentor` model. The garden namespace is removed before the request reaches
Fireworks. New selectors fail closed until an inventory, routing-default, resolver,
and test update lands; do not use a wildcard route.

Standard is the documented default serving path. A Fast router is selected by its
explicit wire model id. Priority requires Fireworks's `service_tier: "priority"`
JSON request field. The current Codex custom-provider surface has no verified
per-request field injection, so this worker deliberately does not claim to select
Priority. Keep Priority disabled until the maintainer chooses and validates an
adapter that can send that field.

To use a nonstandard compatible endpoint, set `GARDEN_FIREWORKS_BASE_URL` when the
container is created. The endpoint and retry knobs (`GARDEN_FIREWORKS_RETRY_ATTEMPTS`
and `GARDEN_FIREWORKS_RETRY_DELAY`) are operational configuration, not journal data.

## Create and canary

Recreate the container with the key supplied only in the creation command. Avoid
shell tracing, `docker inspect`, verbose curl, or commands that print environments.

```sh
./garden reset
FIREWORKS_API_KEY='replace-with-secret' ./garden create
```

Inside `./garden sh`, an optional authenticated probe prints only a status code:

```sh
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $FIREWORKS_API_KEY" \
  "$GARDEN_FIREWORKS_BASE_URL/models"
```

On a successful status, enable one worker only:

```sh
scripts/jobs/set-fireworkers.sh 1
```

Post one harmless, isolated-worktree canary with a Fireworks provider constraint
and no external action. The canary names `provider: fireworks` and `tier: mentor`,
but never a concrete `model:` in its body; the closed tier resolver selects GLM 5.2.
Put the harmless task in `canary.md`, then post it with:

```sh
scripts/jobs/post-job.sh --provider-canary fireworks mentor fireworks-glm52-canary canary.md
```

Confirm the `jobs/tada/` report contains `worker_kind: fireworker`, provider
`fireworks`, tier `mentor`, and the resolved GLM 5.2 model, then return it to zero
unless the maintainer authorizes a larger trial:

```sh
scripts/jobs/set-fireworkers.sh 0
```

HTTP 429 means adaptive per-account/model capacity and is retried with exponential
backoff. HTTP 503 is load shedding and is also retried. Authentication errors and
other configuration failures are not retried. Do not copy API response bodies into
reports or journal entries.

## Validated end to end (2026-07-28)

The lane was exercised end to end on `endolin-garden2-5bcdff64` and returned to
zero. What the run established, so a later operator need not rediscover it:

**Resolving a wire id.** The canary used the reviewed
`fireworks/accounts/fireworks/models/glm-5p2` selector. Confirm it with
`resolve_model_tier fireworks fireworks/accounts/fireworks/models/glm-5p2`, which
echoes the id back only when the exact inventory entry and routing row agree.
Unknown selector/provider/tier combinations fail closed and cannot be claimed.

**The provider-constraint gate holds.** Observed directly in the logs: all eight
gardeners (anthropic), the cleric (openai), and the mystic (moonshot) each declined
the canary with `pinned to a model this <kind> (<provider>) cannot honor; skipping
(backend-fit)`. Only the fireworker claimed it. A Fireworks-constrained job cannot
wander onto another lane, and an unconstrained job cannot wander onto Fireworks.

**Reputation scoping is correct despite the shared handler.** `handlers/cleric-codex.sh`
serves both the cleric (openai) and the fireworker, so mis-scoping would silently
bill Fireworks work to the **openai** arm. It does not: the event recorded
`kind: fireworker`, `provider: fireworks`,
`model: fireworks/accounts/fireworks/models/glm-5p2`,
`recorded_by: …/fireworker-1`. Re-check this specific field set on any future change
to the shared handler.

**The codex lane emits no token data.** The successful canary's ledger row was
`{"outcome":"tada","source":"none","elapsed_s":8}` — `complete-job.sh`'s fallback,
with no token fields. The handler has a parse path for it (the jq extraction of
codex's terminal `token_count` event, ~line 258), but it yielded nothing. This is
codex-lane-wide rather than a Fireworks defect: of the 110 ledger rows carrying
`source: "result"` with real tokens and dollars, every one is the anthropic/claude
lane, and no codex-lane row has ever carried tokens. Wall-clock, by contrast, is
recorded reliably. Consequently a Fireworks arm stays `agentic_dollars: censored`,
and cost for this lane is currently unmeasured — weigh that before authorizing a
trial larger than a canary.

**Declaring zero is not the same as declaring nothing.** The scaler treats an absent
`fireworkers:` line as "this host does not declare this kind" and leaves the pool
alone; an explicit `fireworkers: 0` means the same thing operationally but records
that the kind was considered and is deliberately off. This host now carries the
explicit `0`.
