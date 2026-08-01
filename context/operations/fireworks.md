---
created: 2026-07-25
updated: 2026-08-01
author: gardener
---

# Bounded Fireworks worker activation

`fireworker` is a provider-constrained, tier-pinned Fireworks AI pool. It uses Codex's custom
OpenAI-compatible provider route to `https://api.fireworks.ai/inference/v1` and
receives `FIREWORKS_API_KEY` only through the container's tmpfs systemd handoff.
The key is never put in a unit, journal, worktree, report, or diagnostic. The pool
starts at zero and refuses unconstrained work.

## Registered routes

The closed inventory (`scripts/jobs/model-tier-inventory.tsv`) registers two
reviewed Fireworks routes, each verified against the provider's own model page. The
garden-only `fireworks/` namespace is removed before the request reaches Fireworks;
the wire id is passed through unchanged. New selectors fail closed until an
inventory, routing-default, resolver, and test update lands; do not use a wildcard
route.

| Garden id (inventory) | Wire id sent to Fireworks | Tier | Provenance |
| --- | --- | --- | --- |
| `fireworks/accounts/fireworks/models/glm-5p2` | `accounts/fireworks/models/glm-5p2` | `mentor` | [model page](https://fireworks.ai/models/fireworks/glm-5p2) — Available Serverless, ~1,040k ctx |
| `fireworks/accounts/fireworks/models/kimi-k3` | `accounts/fireworks/models/kimi-k3` | `mentor` | [model page](https://fireworks.ai/models/fireworks/kimi-k3) — serverless, ~1,040k ctx |

Both wire ids are asserted by `scripts/jobs/test/fireworker-harness-test.sh`
§ ROUTES and `scripts/jobs/test/worker-spine-kinds-test.sh`, so a change to either
fails a test rather than silently sending a bogus model name.

### The GLM 5.2 / K3 mentor-tier collision (a maintainer routing decision)

Both models are frontier-class and sit at the **same** `mentor` tier, and the
tier resolver is **first-match** (`tier_model_for_provider`, uniform across the
handler, the claim path, and the reputation arm). So a plain `provider: fireworks`
+ `tier: mentor` job resolves to **GLM 5.2** (the first mentor Fireworks row), and
**Fireworks-served K3 is registered with a verified id but is not independently
tier-selectable while it shares the tier.**

This is deliberate and left as a maintainer decision rather than guessed at, because
each resolution has a real cost:

- **Per-model selection for a provider-constrained job.** Honor an explicit reviewed
  `model:` pin at resolution time (not just for eligibility). Reverts the tier
  refactor's principle that `model:` is a bounded migration surface and no consumer
  resolves from it; a coordinated change across the handler, `claim-job.sh` arm
  stamping, and `rep_resolve_arm`.
- **A distinct tier for K3.** Cleanly selectable, but misrepresents its capability
  (K3 is not a minion/myrmidon-class model).
- **Accept GLM 5.2 as the sole Fireworks mentor model** and treat the K3 row as
  documentation-only (or remove it).

Until that decision lands, a job that pins `model: fireworks/accounts/fireworks/models/kimi-k3`
is eligible for the fireworker but **runs GLM 5.2** — the tier resolver ignores the
pin. Do not post such a job expecting K3; use the canary GLM path below, and raise
the collision with the maintainer if a first-class K3 route is wanted.

Standard is the documented default serving path. A Fast router
(`accounts/fireworks/routers/glm-5p2-fast`, verified present on the provider) is
selected by its explicit wire model id; it is **not** registered here because it is
the same model and tier as GLM 5.2 Standard, so the tier resolver has no slot to
distinguish it — it becomes selectable only once the collision above is resolved.
There is **no verified Kimi K3 Fast router**: the provider's serving-paths page
lists `kimi-k2p6-fast` and `kimi-k2p7-code-fast` (K2.6/K2.7), so none is registered
and none should be invented. Priority requires Fireworks's `service_tier: "priority"`
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

Inside `./garden sh`, an optional authenticated probe prints only a status code —
never a body, header, or the key:

```sh
# List endpoint (broad reachability + auth):
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $FIREWORKS_API_KEY" \
  "$GARDEN_FIREWORKS_BASE_URL/models"

# Per-model recognition (max_tokens:1, status only) — the discriminating probe:
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $FIREWORKS_API_KEY" -H 'Content-Type: application/json' \
  -X POST "$GARDEN_FIREWORKS_BASE_URL/chat/completions" \
  -d '{"model":"accounts/fireworks/models/glm-5p2","max_tokens":1,"messages":[{"role":"user","content":"ping"}]}'
```

Read the status, not a body: **200** serves; **404** means the wire selector is
unrecognized (a real selector problem — re-check the inventory row); **401/403** is
an auth/key failure; **412** means the selector is **recognized** but an
account-level precondition (payment method, terms, or an on-demand deployment) is
unmet — the id is live but the account cannot serve yet. **429/503** are transient
capacity (the handler retries with backoff). A `zzz-does-not-exist` control selector
returning **404** while the real id returns something else is the cheap way to prove
the id itself is recognized.

**Probe of record (2026-08-01, secret-safe, status only).** From
`endolin-garden2-5bcdff64`: `GET /models` → **412**; `POST /chat/completions`
`accounts/fireworks/models/glm-5p2` → **412**; a bogus control selector → **404**.
Reading: the GLM 5.2 wire id is **recognized/live** (404 for bogus, not for GLM),
auth is accepted (no 401/403), but the account has an **unmet precondition** so no
completion is served yet. The pool therefore stays at zero and the live canary below
is **blocked on clearing that account precondition** (add a payment method / accept
terms in the Fireworks console), not on any garden-side selector or routing defect —
those are verified (`resolve_model_tier`, `tier_model_for_provider`, and the hermetic
tests all agree). Re-run the per-model probe after clearing it; a 200 unblocks the
canary.

On a successful (200) status, enable one worker only:

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
`fireworks`, tier `mentor`, and the resolved model
`fireworks/accounts/fireworks/models/glm-5p2`, with **tool-verified** evidence the
model did the work (a file create → readback → remove, reported with its tool
output) rather than merely returning plausible text. Output with no tool result
behind it is a failed canary. Then return the pool to zero unless the maintainer
authorizes a larger trial:

```sh
scripts/jobs/set-fireworkers.sh 0
```

**A Kimi K3 canary is blocked on the mentor-tier collision above.** The
`--provider-canary fireworks mentor` path resolves to GLM 5.2, so there is no way
to exercise `accounts/fireworks/models/kimi-k3` until the maintainer picks a
resolution. Once K3 is independently selectable, its canary should confirm the same
field set with the resolved model `fireworks/accounts/fireworks/models/kimi-k3` and
tool-verified evidence — and it must stay strictly separate from the working
Moonshot/mystic K3 lane (`handlers/mystic-kimi.sh`, `provider: moonshot`, bare
`model: kimi-k3`), which this route neither re-routes nor shares reputation with.

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
