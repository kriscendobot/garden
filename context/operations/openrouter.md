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
(`handlers/cleric-codex.sh`, the `$custom_openai_compat` path). Design and the
stealth-model policy: [`designs/openrouter-provider.md`](../../designs/openrouter-provider.md).

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
| `openrouter/deepseek/deepseek-chat-v3-0324:free` | `deepseek/deepseek-chat-v3-0324:free` | `minion` | Named free variant; **verify live on the model page + the status probe below before enabling** |
| `openrouter/meta-llama/llama-3.3-70b-instruct:free` | `meta-llama/llama-3.3-70b-instruct:free` | `myrmidon` | Named free variant; **verify live before enabling** |

Both wire ids are asserted by `scripts/jobs/test/openrouter-harness-test.sh`
§ ROUTES and `scripts/jobs/test/worker-spine-kinds-test.sh`, so a change to either
fails a test rather than silently sending a bogus model name. The two sit at
**different** tiers, so each is independently tier-selectable (no first-match
collision like the Fireworks GLM/K3 pair).

**These ids are transcribed, not live-verified.** The authoring worktree had no key
and made no network call. Confirm each wire id with the status-only probe below
(a **200** vs a **404**) before enabling any worker; a `:free` id that has rotated
away 404s and must be removed from the inventory rather than dispatched.

To use a nonstandard compatible endpoint, set `GARDEN_OPENROUTER_BASE_URL` when the
container is created. The endpoint and retry knobs (`GARDEN_OPENROUTER_RETRY_ATTEMPTS`
and `GARDEN_OPENROUTER_RETRY_DELAY`) are operational configuration, not journal data.

## Terms and data-retention — decide before enabling

This is a maintainer decision, not a settled premise (design § Open questions):

- OpenRouter's **free** model variants commonly require, at the account level, that
  prompt/response **logging and provider training be enabled** — otherwise the free
  endpoint is unavailable. A zero-data-retention (ZDR) route excludes providers that
  don't support it and is generally a **paid** posture. Decide whether garden job
  prompts (which frame a job body as data but still carry repo context) may be
  logged/trained on before enabling a free lane.
- The design ships only **named** free models precisely because a cloaked/stealth
  model's operator and data policy are **undisclosed by definition**. Do not enable
  a stealth lane on "allegedly fine" terms.

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

# Per-model recognition (max_tokens:1, status only) — the discriminating probe:
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" -H 'Content-Type: application/json' \
  -X POST "$GARDEN_OPENROUTER_BASE_URL/chat/completions" \
  -d '{"model":"deepseek/deepseek-chat-v3-0324:free","max_tokens":1,"messages":[{"role":"user","content":"ping"}]}'
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
scripts/jobs/post-job.sh --provider-canary openrouter minion openrouter-deepseek-canary canary.md
```

`--provider-canary openrouter minion` resolves to the DeepSeek-free route; use
`myrmidon` for the Llama-free route. Confirm the `jobs/tada/` report contains
`worker_kind: openrouter`, provider `openrouter`, the resolved model
`openrouter/deepseek/deepseek-chat-v3-0324:free`, and **tool-verified** evidence the
model did the work (a file create → readback → remove, reported with its tool
output) rather than plausible text alone. Output with no tool result behind it is a
failed canary. Then return the pool to zero unless the maintainer authorizes a
larger trial:

```sh
scripts/jobs/set-openrouters.sh 0
```

## Cost is unmeasured on this lane

Like the fireworker, the codex handler emits **no per-request dollars** for
OpenRouter, so a reputation event stays `agentic_dollars: censored` and the arm is
priced from the provisional rate-card row (`rate-card-defaults.md`,
`openrouter | * | *`). Free models are $0-list but rate-limited and (see above)
often logged; weigh that before authorizing a trial larger than a canary. A paid
OpenRouter route would want its own reviewed inventory row and a revisited rate.

## Declaring zero is not the same as declaring nothing

As with the fireworker: an absent `openrouters:` line means "this host does not
declare this kind"; an explicit `openrouters: 0` records that the kind was
considered and is deliberately off.
