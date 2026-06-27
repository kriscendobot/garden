Maintainer notified. Writing the completion report.

---

## Completion report

**Job:** `investigate-beta3-ymax0-portfolio-upgrade-stack-overflow` — claimed by bot gardener 73 on `endolinbot`.

**Outcome: declined and surfaced. No agoric-sdk investigation performed.**

This job was claimed but is out of scope and ungovernable on the bot fleet. I verified three independent blockers before declining:

1. **Scope** — the brief explicitly targets `agoric-sdk`, which is unconditionally off-limits for autonomous garden work (standing directive: "we must not and cannot do anything for agoric-sdk").
2. **Gate** — the brief's own header states it is go-ahead gated: "run only on explicit maintainer authorization, by the maintainer or a maintainer-supervised session. **Not bot-fleet work.**" It carries `gate=go-ahead` yet was promoted into `todo/` at `15:32:04Z` and auto-claimed by the fleet 4 seconds later (`15:32:08Z`).
3. **Artifacts absent** — every input lives on the maintainer's Mac (`/Users/kris/agoric-sdk` @ `ymax-v0.3.2606-beta3`, `beta2.js`/`beta3.js`, the slog crash JSON in `~/Downloads`). I confirmed none exist on this host (`/Users/kris` does not exist; no `agoric-sdk` checkout; no crash log). Only a stray `/home/kris/bundle-ymax0.json` is present, which is insufficient. The work is physically impossible here.

**What I did:**
- Verified host identity (`endolinbot`) and artifact availability (all absent).
- Traced the garden's own promotion gate: `plan_deferred_ranked` (common.sh:743) correctly excludes `gate=go-ahead`, so the **foreman did not auto-promote** this — it reached `todo/` via the explicit `promote-plan.sh` path, then the fleet race-claimed it within seconds.
- Messaged the maintainer (via `message-user.sh` → `inbox/maintainer`, delivered `20260627T153338Z-f3cc46`) with the full rationale and a request to re-engage the brief in a supervised session on the Mac, preserving the investigation's intent so it isn't lost when this board entry closes.

**Changed:** nothing in the repo or any agoric-sdk artifact.

**Follow-ups (for the maintainer to weigh — garden-infra, in scope):**
- The race window is the real defect: anything that lands in `todo/`, including a `gate=go-ahead` plan, is claimable by the fleet within seconds. Consider having `promote-plan.sh` refuse to promote a `gate=go-ahead` plan into `todo/` on a bot host absent a maintainer-supervised marker (or route go-ahead promotions to a maintainer-only lane the fleet does not poll). I did not post this as a fix job since it touches the promotion/claim contract and the maintainer's message may already prompt a decision; happy to post it if you'd like.
