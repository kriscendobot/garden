<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-28T07:25:08Z -->

# Wire GLM 5.2 and Kimi K3 into the fireworker route

Second child of orchestration `fireworks-glm52-kimik3`. Runs **after**
`fireworks-glm52-kimik3-survey`, which has landed. Read that job's `jobs/tada/`
report first.

**Amended 2026-07-28T07:3xZ by the liaison, read this before you start.** The
survey's `tada/` report is a **thin summary**: it asserts that selectors and
citations were established but does **not** actually contain the wire model ids.
The substance it produced is in the ingested library sections, notably
`library/sections/web--fireworks-serverless-serving-paths--selectors-and-capacity-tradeoffs.md`
and `library/sections/web--fireworks-text-models--api-models-and-deployments.md`.
Those record the identifier shapes (base models as
`accounts/fireworks/models/<id>`, Fast routers as
`accounts/fireworks/routers/<id>`, dedicated deployments as
`accounts/<ACCOUNT_ID>/deployments/<DEPLOYMENT_ID>`) and name
`accounts/fireworks/routers/glm-5p2-fast` among the captured Fast router examples.

**Do not take a captured example as a verified current id.** Note in particular
that the captured K3-adjacent router example reads `kimi-k2p6-fast`, which is
**K2.6, not K3**. Establish each id you are about to wire, and if you cannot
establish one, wire what you can and say plainly in your report which id remains
unestablished rather than guessing. An invented model id is worse than an
acknowledged gap.

## Task

Make the two models reachable as first-class garden routes, following the shape the
survey proposed and the constraints the `fireworker` design already fixed:

- The routing id is `fireworks/<wire-model-id>`, suffix passed through unchanged.
- The pool is **explicit-model-only** and starts at **zero**; it refuses unpinned
  work. Do not add a catalog default, and do not change that posture.
- Priority tier stays **disabled** — the Codex custom-provider surface has no
  verified per-request `service_tier` injection. Do not claim Priority support.

Concretely, expect to touch: the model-routing/eligibility state
(`scripts/jobs/set-model-routing.sh` and the routing table it writes), the worker
spine's kind registry in `scripts/jobs/common.sh` if a new kind is warranted,
`skills/model-selection/SKILL.md` (the canonical role→tier map and provider
sections), and `context/operations/fireworks.md`. Add or extend coverage in
`scripts/jobs/test/fireworker-harness-test.sh` and
`scripts/jobs/test/worker-spine-kinds-test.sh` so the new routes are asserted, not
assumed. Take the survey's recommendation on whether GLM 5.2 and Fireworks-served
K3 share the `fireworker` kind or warrant separation.

**Keep the Moonshot K3 path intact.** The `mystic` pool
(`handlers/mystic-kimi.sh`, `provider: moonshot`, `model: kimi-k3`) is a working,
canaried backend. A Fireworks-served K3 is an *additional* backend; adding it must
not re-route, degrade, or silently absorb the existing mystic lane, and the two
should not pool reputation unless the survey argued otherwise and you agree.

## Constraints

- **No canary in this job** — activation is the next child's, under a key-bearing
  container. Leave the pool at zero.
- `FIREWORKS_API_KEY` is not required here. (Amended: the key **is** now present on
  `endolin-garden-ece02cb4` as of 2026-07-28T07:20Z, verified presence-only through
  the tmpfs handoff, the user manager, and running worker environments. The original
  "not present" note was written three minutes before the key landed.) You still do
  not need it: write the code so it degrades honestly without a key, so that a
  missing key fails with a clear configuration error, never a silent fallback to
  another provider. Do not read, print, or test against the key value here.
- **Never** print, log, or commit a key value, an `Authorization` header, or an API
  response body.
- Run the repo's local checks before pushing — a CI failure is an automation defect,
  not something to discover downstream ([skills/local-verify](../../skills/local-verify/SKILL.md),
  [skills/pre-push-gates](../../skills/pre-push-gates/SKILL.md)).

## Done when

The routes exist and are covered by passing tests, the docs describe them
accurately, the pool is still at zero, the Moonshot K3 lane is demonstrably
unchanged, and the `jobs/tada/` report names exactly what a canary should post for
each of the two models.

<!-- garden-reaped: 3 -->
