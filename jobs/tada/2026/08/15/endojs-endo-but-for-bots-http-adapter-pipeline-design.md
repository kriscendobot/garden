No stale references; the document is complete and internally consistent. The design task is finished.

## Completion report

**What I did.** Elaborated the `endo http` controller/client pair into a composable, pass-style **HTTP adapter pipeline** design, as the follow-up requested on the PR #286 Phase 1 approval.

**Deliverable.** New design `designs/http-adapter-pipeline.md` (750 lines) in `endojs/endo-but-for-bots`, opened as **draft PR #992** against `llm` (https://github.com/endojs/endo-but-for-bots/pull/992). Plus a forward pointer from `designs/cli-http-client.md` and index entries in `designs/README.md`.

**What the design covers** (all five requested concerns as composable pass-style exo stages):
- **Pass-style middleware model** — maps the Koa/axios/undici onion onto exo facets: each stage implements a uniform `HttpStageInterface` whose `request()` calls `E(next).request()`, with `next` captured at composition **on the controller side**, preserving the Phase 1 invariant (controller holds immutable policy; client only exercises). Mapping table included.
- **Metering ⇄ byte-cap as one mechanism** — `maxResponseBytes` doubles as the worst-case response term of an up-front reservation; the bounded read enforcing the cap is what bounds actual ≤ reserved. Aligned to the mined **minion.town gateway ground rules** (`weblet-usage-metering.md`/`ertp-credits.md`): reserve worst-case before headers, refuse in the pessimal case before reading bytes, settle delivered-bytes-plus-wall-clock-capped-at-deadline, measurement at the resource boundary not the caller. Reuses the `daemon-xs-worker-metering` admission-control model.
- **Fees** — attenuated ERTP charge account (`limit`/`expiresAt`), endowed controller-side, never client-facing; `InsufficientFunds` refusal before the network, pure `estimateCost` probe.
- **Rate limiting** — position (above meter, below retry/breaker), per-client vs per-controller scope, the planned `setMaxRequestsPerMinute` knob.
- **Retries** — GET-class idempotent-only, deadline-shared jittered backoff with abortable sleeps.
- **Circuit breaking** — per-origin three-state machine keyed on server/transport error classes (not 4xx), wrapping retry.

Canonical stage order (pure pre-flight + effectful onion), new controller/CLI verbs, staging into cli-http-client's Phase 3/3.5/3.6/4 plan, preserved SSRF/DoS posture, four alternatives, test plan, and open questions all included. Treated the quoted review text as untrusted data per prompt-injection discipline.

**Follow-ups (surfaced as design open questions, not blockers):** unify the HTTP metering unit with the XS-worker computron ledger; streaming-body settlement granularity; breaker-state persistence; crash-recovery reconciler durability. The PR awaits maintainer design review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-http-adapter-pipeline-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 62 tokens (3107170 cached reads)
- Output: 39743 tokens
- Cost: $4.54072075 (1 engagement(s) unpriced)
- Wall-clock: 610s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
