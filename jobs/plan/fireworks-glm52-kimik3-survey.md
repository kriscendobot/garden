---
gate: orchestrated
orchestrated_by: fireworks-glm52-kimik3
priority: normal
posted_by: producer
posted_at: 2026-07-28T07:15:17Z
---

# Survey Fireworks serving for GLM 5.2 and Kimi K3

First child of orchestration `fireworks-glm52-kimik3`. **Research and proposal
only — change no routing and enable no worker in this job.**

Maintainer directive (kriskowal, 2026-07-28, via the liaison on
`endolin-garden-ece02cb4`): *"build out what's needed to take advantage of the new
FIREWORKS_API_KEY for GLM 5.2 and Kimi K3."*

## Why a survey first

The garden deliberately bakes **no Fireworks catalog default**: availability,
pricing, and deployment ids are provider data that goes stale
([context/operations/fireworks.md](../../context/operations/fireworks.md)). The
`fireworker` route is `fireworks/<wire-model-id>`, with the suffix passed
unchanged to the endpoint. So the first thing the build needs, and does not yet
have, is the **current wire model id** for each of the two targets.

## Deliver

1. **Wire model ids.** The current Fireworks Serverless (or Fast-router) wire ids
   for **GLM 5.2** and **Kimi K3**, each quoted exactly as it must appear after the
   `fireworks/` prefix. Cite where each id came from (the Fireworks model library
   or an authenticated `/models` listing) and the date observed.
2. **Availability check.** For each: is it on Serverless, Fast, or dedicated-only?
   Note context-window and any documented tool-calling / structured-output support,
   since garden roles depend on tool use.
3. **Kimi K3 overlap — call this explicitly.** K3 already has a garden backend: the
   `mystic` pool via the official Kimi Code CLI (`provider: moonshot`,
   `model: kimi-k3`, handler `handlers/mystic-kimi.sh`,
   [context/operations/kimi-k3.md](../../context/operations/kimi-k3.md)). A
   Fireworks-served K3 would be a **second, independent backend for the same
   model**. Recommend how the two should relate — distinct routing ids, which is
   preferred for which work class, and whether the reputation projections should be
   kept separate (they describe different serving paths and should probably not be
   pooled). Do **not** assume the Fireworks path supersedes the Moonshot CLI path.
4. **GLM 5.2.** New to the garden. Say what work classes it is plausibly suited to,
   grounded in what you can actually verify rather than vendor marketing.
5. **A concrete build proposal** the next child can execute: exactly which files
   change, which routing/eligibility entries are added, and what each canary posts.

## Preconditions and constraints

- **`FIREWORKS_API_KEY` is NOT present on `endolin-garden-ece02cb4`.** The tmpfs
  handoff (`/run/environment.d/60-garden-api-keys.conf`) carries only
  `MOONSHOT_API_KEY` as of 2026-07-28T07:1xZ. Per the runbook the key can be
  supplied **only at container creation**
  (`FIREWORKS_API_KEY=... ./garden create`), which is a maintainer act — no agent
  can self-provision it. **This job does not need the key**: it is research and a
  written proposal. If you find you cannot answer a question without an
  authenticated call, say so and leave that item open rather than blocking; note it
  as a canary-time question for the child that runs under a key-bearing container.
- Determine whether any host in the fleet *does* carry the key (check the leader,
  `endolin-garden2-5bcdff64`) and record the answer — the canary child needs to run
  somewhere the key exists.
- **Never** print, echo, log, or copy a key value, an `Authorization` header, or an
  API response body into a report, the journal, or a diagnostic. Status codes only.

## Done when

A `jobs/tada/` report carries the wire ids (or an explicit statement that one could
not be established and why), the K3 dual-backend recommendation, and a build
proposal specific enough to execute without re-research.
