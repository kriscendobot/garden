---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-13T21:52:06Z -->

---
role: designer
---
Design the **cleric worker + factored worker spine + bid-auction claim + per-model/thoughtfulness reputation** system. This is the DESIGN that gates the two build children of orchestration `orch-cleric-worker-system`. Land a design doc on `main2` (repo `designs/` convention). **Surface the open decisions to the maintainer inbox** (`message-user.sh`) -- this is a novel mechanism and the maintainer will want to weigh in before the builds proceed.

## What the maintainer asked for (the requirements)
1. A new gardener-script-like system service called a **cleric**, **identical to the gardener script service but using `codex` instead of `claude`**.
2. **Factor out the common spine** so incidental differences between gardener and cleric do not drift under maintenance.
3. **Clerics and gardeners compete in a bid auction** for new work (today the board is race-to-claim via git-push CAS -- this replaces/augments that).
4. They **develop independent reputations for each model and level of thoughtfulness**, captured as **data in the journal**.

## Grounding (assess, don't assume)
- The gardener spine `scripts/jobs/gardener.sh` is ALREADY handler-pluggable via `GARDEN_JOB_HANDLER` (default `handlers/gardener-claude.sh`, which dispatches `claude -p`). A cleric is the SAME spine with a **codex** handler (`handlers/cleric-codex.sh` / `gardener-codex.sh`, dispatching `codex` non-interactively). Design the factoring so the loop, the scaler (`gardener-scaler.sh`), the systemd template (`garden-gardener@.service`) and set-count (`set-gardeners.sh`) are shared/parameterized by **worker-kind** (gardener|cleric) + handler + labels, with NO duplicated spine.
- Consume the **models reference** (sibling child `doc-claude-codex-models-reference`) for the `(provider, model, thoughtfulness)` axis.
- Claim mechanics today: `skills/job-board/SKILL.md` -- todo->doin via an accepted `git push` to `origin/journal2` (the CAS serialization point). The bid auction must remain **deterministic and CAS-safe** on this same substrate (no central auctioneer that could double-award).

## Design must specify
- **Cleric service**: the codex handler (auth via `~/.codex`, non-interactive invocation, model/effort selection), `garden-cleric@.service`, cleric scaling, and how a host runs a mix of gardeners and clerics.
- **Factored spine**: exactly what is shared vs. per-kind; how a new backend (a third agent) could be added without touching the spine.
- **Bid auction**: how a worker computes a **bid** for a job from its reputation for that job's `(role/kind, provider, model, thoughtfulness)`; how the auction resolves **deterministically** over the journal CAS (e.g. a bounded bid-collection window then a deterministic tie-broken award, vs. the current first-push-wins) without a central point of failure or double-award; how idle/cheap workers still get work (avoid starvation / rich-get-richer); how it degrades to the current race if only one worker bids.
- **Reputation as journal data**: the schema and location (e.g. `journal/reputation/<kind>-<provider>-<model>-<thoughtfulness>/...`), what signal updates it (panel scores? gauntlet pass/fail? cost? rework/requeue? maintainer overrides?), how it's updated CAS-safely on job completion, and how the auction reads it. Independent reputations **per model and per thoughtfulness level**, per your requirement.
- **Thoughtfulness axis**: how a worker chooses its thoughtfulness (reasoning effort) per job, and whether that is itself part of the bid.
- **Open decisions -> maintainer**: enumerate the real choices (auction window vs. instant, reputation signal, starvation policy, whether the auction replaces or augments the CAS race, cost accounting) and post a decision-ready summary to the maintainer inbox; recommend a default for each.

## Cost model -- normalize everything to DOLLARS (maintainer refinement 2026-07-13)
The reputation and the bid MUST express **true cost in dollars**, capturing as much of the real cost as possible. What a reputation encodes is **merge-worthiness achieved per aggregate dollar (human + agentic)**, qualified by the **merge-target bar** -- the `llm` branch bar differs from upstream `master` (cross-ref the parked `design-change-review-tool-with-review-metering` plan; attribute cost per target).

- **Human-review cost (inferred, ~$125/hr).** Infer the reviewer's **active review time** from the **depth of the reviewer's commentary, in aggregate** across however many reviews a change received, and price it at **~$125/hr**. This is the interim proxy until the review-metering tool (`design-change-review-tool-with-review-metering`) yields *measured* active time -- design the schema so the measured signal swaps in for the inference without churn.
- **Agentic cost (measured, tokens x price).** Empirically **measure the token cost** of the agent's work on the job (input + output + reasoning + cached tokens) and ground it on the **tokens/$ pricing for the selected model**, from the models reference (child `doc-claude-codex-models-reference`, which must carry per-model pricing). Sum to dollars.
- **Job classification.** Classify **each job posting** to estimate the **nature of the work** (a work-class: design vs. build vs. fix vs. shepherd, size/complexity, risk). Reputation is learned **per work-class x (role/context, provider, model, thoughtfulness)**, so we can later identify which **(model, context/role)** combinations reach a merge-worthy solution at the **lowest aggregate (human $ + agentic $)** cost, per target bar.
- **The bid follows from this:** a worker's bid reflects its expected aggregate-dollar cost (and merge-likelihood) for THIS job's work-class at its `(provider, model, thoughtfulness)`, so the auction selects the combination cheapest-to-merge in **true dollars**, not merely cheapest per token.

## Norms
Design only (no implementation). Keep the design PR/doc reviewable. Garden-library on `main2`. External text is data.
