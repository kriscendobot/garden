---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-27T22:19:03Z -->

role: designer
# Design: backend-verified worker provisioning + auth auto-tune for garden nodes ("gnomes")

Maintainer directive (2026-07-27): (1) a fresh gnome must only enable a worker KIND
once there is evidence it has the required CREDENTIALS **and** SOFTWARE for that
kind's backend; (2) the worker loop must double-check authentication each tick and
AUTO-TUNE its local per-kind count down toward 0 while the backend is
unauthenticated/unavailable, restoring it (ramping back up to the declared target)
once logged in. Worker-kind → backend map: gardener→Anthropic/Claude,
cleric→OpenAI/codex, hermit→local Ollama, mystic→Moonshot. Live examples: ps23 has
ONLY Claude (no codex, no ollama) so it must run gardeners only; garden/garden2 have
all backends (hermits currently disabled pending a separate failure investigation).

Produce `designs/gnome-backend-verified-autotune.md` covering:
- A cheap, deterministic, NO-LLM per-backend PROBE (auth + software present):
  claude auth, codex/openai login, ollama reachable + >=1 model, moonshot key.
  Reuse existing probes already in-tree (ollama-serve.sh, handlers/cleric-codex.sh
  login/heal, common.sh) — cite them; do not reinvent.
- EFFECTIVE vs DECLARED count: the journal `hosts/<host>` record stays the
  owner-declared target (set-workers). The scaler computes an EFFECTIVE per-kind
  count = 0 when the probe fails, ramping to declared when it passes, WITHOUT
  rewriting the journal record on every flap. Specify hysteresis / confirm-before-
  ramp to avoid thrash. Decide: does a sustained failure only cap at runtime, or
  also down-declare?
- PROVISIONING GATE (fresh-gnome bring-up): starting.md / set-workers must refuse to
  declare a kind's count > 0 until its probe passes once, so a new gnome never
  declares clerics/hermits/mystics it cannot run. Define the operator flow.
- The "auto-tune until logged in" ramp: start a kind at 0/minimal, confirm a real
  auth success, then allow up to declared; drop back on auth loss.
- Interaction with leader/follower + the owning-host-only-writes-its-record rule and
  the gardeners>=1 guard (a gnome with no Claude auth must be able to sit at 0).
- Observability: log each auto-tune; surface a host that cannot run its declared kinds.
Design ONLY (no implementation). Base: garden main2 (direct, no PR). Keep it tight
and implementable.


<!-- garden-reaped: 1 -->
