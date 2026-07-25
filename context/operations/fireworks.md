---
created: 2026-07-25
updated: 2026-07-25
author: gardener
---

# Bounded Fireworks worker activation

`fireworker` is an explicit-model-only Fireworks AI pool. It uses Codex's custom
OpenAI-compatible provider route to `https://api.fireworks.ai/inference/v1` and
receives `FIREWORKS_API_KEY` only through the container's tmpfs systemd handoff.
The key is never put in a unit, journal, worktree, report, or diagnostic. The pool
starts at zero and refuses unpinned work.

## Configure an explicit route

The board routing id is `fireworks/<wire-model-id>`. The suffix is passed unchanged
to Fireworks, so it can be a current Serverless model, Fast router id, or dedicated
deployment id. For example, select a current identifier from the Fireworks model
library and post `model: fireworks/accounts/...`. Do not add a catalog default to
the garden: availability, pricing, and deployment ids are provider data.

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

Post one harmless, isolated-worktree canary with an explicit Fireworks model route
and no external action. Confirm the `jobs/tada/` report contains `worker_kind:
fireworker` and provider `fireworks`, then return it to zero unless the maintainer
authorizes a larger trial:

```sh
scripts/jobs/set-fireworkers.sh 0
```

HTTP 429 means adaptive per-account/model capacity and is retried with exponential
backoff. HTTP 503 is load shedding and is also retried. Authentication errors and
other configuration failures are not retried. Do not copy API response bodies into
reports or journal entries.
