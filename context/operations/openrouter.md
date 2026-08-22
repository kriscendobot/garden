---
created: 2026-08-22
updated: 2026-08-22
author: gardener
---

# Bounded OpenRouter worker activation

`openrouter` is a provider-constrained, explicit-model-only pool. It uses Codex's
custom OpenAI-compatible provider route to `https://openrouter.ai/api/v1` and
receives `OPENROUTER_API_KEY` only through the container's tmpfs systemd handoff.
The key is never put in a unit, journal, worktree, report, or diagnostic. The pool
starts at zero and refuses unconstrained work: no automatic or unpinned board job
can reach it (`claim-job.sh` fences it to a `provider: openrouter` canary or an
explicit `openrouter/<wire-id>` pin). It shares one handler with the fireworker
(`handlers/cleric-codex.sh`, the `$custom_openai_compat` path), but adds a mandatory
per-job privacy adapter described below. Design and the stealth-model policy:
[`designs/openrouter-provider.md`](../../designs/openrouter-provider.md).

## Registered routes

The closed inventory (`scripts/jobs/model-tier-inventory.tsv`) registers reviewed
OpenRouter routes. The garden-only `openrouter/` namespace is removed before the
request reaches OpenRouter; the wire id (including any `:free` suffix) is passed
through unchanged. Only **stable, NAMED** free models earn a row; **cloaked/stealth
ids are excluded** (they fail closed, exactly like any unreviewed selector) until
they de-cloak under a real vendor/model name — see the design's stealth policy. New
selectors fail closed until an inventory, routing-default, and test update lands; do
not use a wildcard route.

| Garden id (inventory) | Wire id sent to OpenRouter | Tier | Provenance |
| --- | --- | --- | --- |
| `openrouter/z-ai/glm-5.2:free` | `z-ai/glm-5.2:free` | `minion` | Named free variant; returned by OpenRouter's public ZDR endpoint inventory on 2026-08-22 with zero prompt/completion price and tool support; authenticated completion still requires the canary below |

The wire id is asserted by `scripts/jobs/test/openrouter-harness-test.sh` § ROUTES
and `scripts/jobs/test/worker-spine-kinds-test.sh`, so a change fails a test rather
than silently sending a bogus model name. There is deliberately no OpenRouter
myrmidon row.

**The two original seed rows were removed by the privacy review.** On 2026-08-22,
`GET /api/v1/models/deepseek/deepseek-chat-v3-0324:free/endpoints` and the equivalent
Llama 3.3 70B URL both returned an empty endpoint list, while neither appeared in
the active model list. The public `GET /api/v1/endpoints/zdr` inventory returned only
`z-ai/glm-5.2:free` among zero-price text/tool endpoints. This is live public-catalog
evidence, not an authenticated inference: confirm the replacement with the
status-only policy probe below before enabling any worker. A `:free` id that rotates
away must be removed from inventory rather than dispatched.

To use a nonstandard compatible endpoint, set `GARDEN_OPENROUTER_BASE_URL` when the
container is created. The endpoint and retry knobs (`GARDEN_OPENROUTER_RETRY_ATTEMPTS`
and `GARDEN_OPENROUTER_RETRY_DELAY`) are operational configuration, not journal data.

## Enforced terms and data-retention policy

Garden prompts and responses may not be retained or used for training. OpenRouter's
current API exposes two distinct provider preferences, so the handler forces both on
every inference request:

```json
{"provider":{"data_collection":"deny","zdr":true}}
```

`data_collection: "deny"` excludes endpoints that may collect/train on user data;
`zdr: true` further restricts routing to endpoints with a zero-data-retention policy.
The fields are unconditional and not sourced from a job body. Codex's custom-provider
configuration cannot add arbitrary body fields, so `cleric-codex.sh` starts
`openrouter-privacy-proxy.mjs` on loopback, points Codex only at that adapter, and the
adapter overwrites even attempted permissive values before forwarding to the fixed
HTTPS OpenRouter origin. Missing Node, a missing adapter, invalid JSON, or startup
failure stops the request path rather than bypassing policy. The harness test sends
`allow`/`false` and observes `deny`/`true` at a mock upstream.

OpenRouter documents that it does not itself store prompt/response content unless an
account owner explicitly opts into one of its content-logging features, and that it
retains request metadata such as token counts and latency. It documents no per-request
switch that can override an account owner's explicit content-logging opt-in, so key
provisioning must leave both OpenRouter content-logging settings off. That is separate
from the downstream-provider policy enforced here: `zdr: true` ORs with account and
guardrail ZDR settings and therefore cannot be relaxed by them. Sources:
[provider routing](https://openrouter.ai/docs/guides/routing/provider-selection),
[ZDR](https://openrouter.ai/docs/guides/features/zdr), and
[data collection](https://openrouter.ai/docs/guides/privacy/data-collection).

The design still ships only **named** models because a cloaked/stealth model's
operator and provenance are undisclosed. A future stealth lane must inherit this
same adapter; it cannot relax these fields.

## Create and canary

Recreate the container with the key supplied only in the creation command. Avoid
shell tracing, `docker inspect`, verbose curl, or commands that print environments.
Key provisioning and the first canary are a **separate, maintainer-directed step**
(same as fireworks/kimi-k3) — this activation page arms nothing on its own.

```sh
./garden reset
OPENROUTER_API_KEY='replace-with-secret' ./garden create
```

Inside `./garden sh`, an optional authenticated probe prints only a status code —
never a body, header, or the key:

```sh
# List endpoint (broad reachability + auth):
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  "$GARDEN_OPENROUTER_BASE_URL/models"

# Per-model policy probe (status only) — mirrors the two enforced request fields:
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" -H 'Content-Type: application/json' \
  -X POST "$GARDEN_OPENROUTER_BASE_URL/responses" \
  -d '{"model":"z-ai/glm-5.2:free","max_output_tokens":1,"input":"ping","provider":{"data_collection":"deny","zdr":true}}'
```

Read the status, not a body: **200** serves; **404** means the wire selector is
unrecognized or the free id has rotated away (remove the inventory row rather than
dispatching); **401/403** is an auth/key failure; **402** means a credit/payment
precondition is unmet; **429** is rate-limit/quota (the handler retries with
backoff); **503** is load shedding (also retried). A `zzz-does-not-exist` control
selector returning **404** while the real id returns something else is the cheap way
to prove the id itself is recognized. Do not copy any response body into a report or
journal entry.

On a successful (200) status, enable one worker only:

```sh
scripts/jobs/set-openrouters.sh 1
```

Post one harmless, isolated-worktree canary with an OpenRouter constraint and no
external action, using a **reviewed named** pin. Put the harmless task in
`canary.md` (a file create → readback → remove), then post it with:

```sh
scripts/jobs/post-job.sh --provider-canary openrouter minion openrouter-glm-canary canary.md
```

`--provider-canary openrouter minion` resolves to the GLM-5.2-free route. There is no
reviewed OpenRouter myrmidon route. Confirm the `jobs/tada/` report contains
`worker_kind: openrouter`, provider `openrouter`, the resolved model
`openrouter/z-ai/glm-5.2:free`, and **tool-verified** evidence the
model did the work (a file create → readback → remove, reported with its tool
output) rather than plausible text alone. Output with no tool result behind it is a
failed canary. Then return the pool to zero unless the maintainer authorizes a
larger trial:

```sh
scripts/jobs/set-openrouters.sh 0
```

## The promo (stealth) lane — `openrouter-promo`

`openrouter-promo` is the **second** OpenRouter kind: the deliberately-admitted rotating
cloaked ("stealth") lane (maintainer decision, 2026-08-22;
[`designs/openrouter-provider.md`](../../designs/openrouter-provider.md) § the
stealth/promotional lane). It shares the stable lane's handler, endpoint, key
(`OPENROUTER_API_KEY`), and the **same fail-closed ZDR/deny-collection privacy proxy** —
using a cloaked model accepts only *not knowing which model it is*, never logging. It has
its **own** kind/provider/unit/namespace and a **separate reputation arm**, so a cloaked
model's short-lived, re-reviewed history never pools with a named model's.

Unlike the stable lane, its selectable ids are **journal-backed and cadence-gated**, not
a tracked inventory: they live in the ledger `config/openrouter-promos`
(`<wire-id>  <tier>  <attested_at>  <attested_by>`), and a row **fails closed the moment
its attestation is older than 24h** (`GARDEN_OPENROUTER_PROMO_CADENCE_SECS`) — the
re-review cadence enforces itself with no daemon. Ships **inert**: empty ledger, pool
zero.

### Attest → canary → enable (maintainer-directed, host-side)

```sh
# 1. Re-review + enable one cloaked id (running this IS the periodic re-review). The
#    <wire-id> is the EXACT id OpenRouter serves, e.g. openrouter/horizon-beta.
scripts/jobs/openrouter-promo-attest.sh openrouter/horizon-beta minion "<your-login>"

# 2. Status-only policy probe (never prints a body/header/key) — 200 serves, 404 means
#    the cloaked id has rotated away (do NOT attest it):
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" -H 'Content-Type: application/json' \
  -X POST "$GARDEN_OPENROUTER_BASE_URL/responses" \
  -d '{"model":"openrouter/horizon-beta","max_output_tokens":1,"input":"ping","provider":{"data_collection":"deny","zdr":true}}'

# 3. Enable ONE worker and post a tool-using canary on the namespaced promo pin:
scripts/jobs/set-openrouter-promos.sh 1
scripts/jobs/post-job.sh --provider-canary openrouter-promo minion openrouter-promo-canary canary.md
# Confirm the tada report carries worker_kind: openrouter-promo, provider openrouter-promo,
# the resolved model openrouter-promo/openrouter/horizon-beta, and TOOL-verified evidence.
scripts/jobs/set-openrouter-promos.sh 0   # back to zero unless a larger trial is authorized
```

### The re-review cadence (auto-disable)

Register the deterministic recheck as a **daily schedule preflight** (leader-only; it
runs in plain code and dispatches **no** agent, exiting 2 = "no work" after enforcing):

```sh
printf 'openrouter-promo re-review cadence (deterministic; see the preflight)\n' > /tmp/promo-recheck.md
GARDEN_SCHEDULE_PREFLIGHT=openrouter-promo-recheck.sh \
  scripts/jobs/set-schedule.sh openrouter-promo-recheck daily openrouter-promo-recheck /tmp/promo-recheck.md
```

Each day it prunes any ledger row whose attestation has gone stale (>24h) and — when the
key is present — 404-probes each surviving id and **drops any that has rotated away**,
alerting the maintainer per disable. Even without the schedule armed, the read-side
staleness filter already fails a stale id closed; the schedule is the janitor + liveness
probe on top. Run it by hand for an immediate sweep: `scripts/jobs/openrouter-promo-recheck.sh`.

### Rip-cord

Two independent levers — use either or both to kill a cloaked id immediately:

```sh
scripts/jobs/set-openrouter-promos.sh 0                 # zero the pool: no worker runs a cloaked model
scripts/jobs/openrouter-promo-drop.sh openrouter/horizon-beta   # drop the id's row: unclaimable even at pool>0
```

### When a stealth id is unmasked — carry its reputation forward

A cloaked id runs under its own `openrouter-promo` kind/provider/namespace precisely so
its short-lived, separately-re-reviewed reputation **never pools** with a named model's.
When OpenRouter later **publishes what a stealth id actually was** (or you otherwise
learn it) — an **external fact only a human confirms, never automatic** — you can carry
the accumulated history forward onto the now-named model's arm rather than restarting it
at zero:

```sh
# 1. (recommended) preview which events would move — no writes:
scripts/jobs/rerecord-reputation-arm.sh \
  openrouter-promo/openrouter-promo/openrouter-promo/openrouter/horizon-beta \
  openrouter/openrouter/openrouter/z-ai/glm-5.2:free \
  --authorized-by <your-login> --dry-run

# 2. do it (maintainer-attested; <your-login> must be on the journal maintainers/allowlist):
scripts/jobs/rerecord-reputation-arm.sh \
  openrouter-promo/openrouter-promo/openrouter-promo/openrouter/horizon-beta \
  openrouter/openrouter/openrouter/z-ai/glm-5.2:free \
  --authorized-by <your-login>
```

An **arm key** is `<kind>/<provider>/<model>` using the **raw** identity values as they
appear in an event's frontmatter (a promo model is namespaced `openrouter-promo/<wire-id>`;
a named model is `openrouter/<wire-id>`). `kind` and `provider` are single slash-free
tokens, so the first two slashes split the key and everything after is the model.

The migration **goes through the reducer's single source of truth**: it relabels the
`kind`/`provider`/`model` fields of every event (and not-yet-finalized pending event)
belonging to the old arm to the new arm's values — preserving thoughtfulness / work_class
/ target / acceptance / dollars — and the next `reputation-reduce.sh` tick re-projects
that full history onto the named model's arm(s). Because the reducer recomputes each arm
from **all** its events, relabeling onto a target arm that **already** has history simply
**folds the two together** (a clean rename and a merge-on-collision are the same
operation here). The old arm's now-orphaned projection subtree is removed in the same
commit so no stale reputation lingers. It is **idempotent** (a re-run matches no old-arm
events and no-ops) and **auditable** (an append-only `reputation/migrations/` record and a
`rerecorded_from`/`_to`/`_by`/`_at` stamp on every moved event). Attestation follows the
sysop's destructive-op precedent: `--authorized-by <login>` with `<login>` on the journal
`maintainers/allowlist`.

This handles **only** the reputation carry-forward. Retiring the cloak itself is separate
and existing: `openrouter-promo-drop.sh <wire-id>` removes the promo ledger row, and the
now-named model earns an ordinary reviewed `model-tier-inventory.tsv` row if you want to
keep serving it on the **stable** lane.

## Cost is unmeasured on this lane

Like the fireworker, the codex handler emits **no per-request dollars** for
OpenRouter, so a reputation event stays `agentic_dollars: censored` and the arm is
priced from the provisional rate-card row (`rate-card-defaults.md`,
`openrouter | * | *`). The reviewed model is $0-list but rate-limited and its route
may disappear; weigh that before authorizing a trial larger than a canary. A paid
OpenRouter route would want its own reviewed inventory row and a revisited rate.

## Declaring zero is not the same as declaring nothing

As with the fireworker: an absent `openrouters:` line means "this host does not
declare this kind"; an explicit `openrouters: 0` records that the kind was
considered and is deliberately off.
