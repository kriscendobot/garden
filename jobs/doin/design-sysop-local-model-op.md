---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-01T08:52:22Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Produce a design document under
`designs/` and land it on main2 (no PR — CLAUDE.md § Conventions).

# Design: a host-addressed local-model provisioning op for the sysop

## Motivation

The garden has **no host-targeted job dispatch**. `requires:` gates on host *capability*
and `designs/host-requirements-gating.md` states it "does not reserve a job for a
particular host"; `post-job.sh --identity` is a provider-canary directive. The sysop
(`scripts/jobs/sysop.sh`, `designs/sysop.md`) is the fleet's ONLY genuinely host-addressed
channel (`host/<GARDEN>` bus kind), and it exists precisely for the unattended-follower
case: "throttle host Y" should not wait for a human to sit at Y.

Concrete driver (maintainer, 2026-08-01): the local-inference lane must be brought to the
same configuration on both `endolin-garden2-5bcdff64` and `endolin-garden-ece02cb4`. The
model is `qwen3.6` (~22 GB). One host has it on disk; the other's state is unknown and
unreachable — the peer checkout is not visible from inside a sibling container, which is
correct isolation. There is currently no supported way to make a named host pull a model.

Related in-flight work: job `garden-heal-local-qwen36-routing` corrects the phantom
`qwen3:0.6b` pin across the tree. This design must consume the CORRECTED inventory rather
than hardcode any tag.

## What to design

A new sysop op (working name `local-model`) that provisions the host's local-inference
model. Settle at least these questions; each is a real fork, not a formality:

1. **Async execution.** Every existing sysop op is fast and idempotent within one tick.
   A 22 GB pull is neither — it can exceed any reasonable tick budget, and the fleet's
   2400s `GARDEN_HANDLER_TIMEOUT` is already the single largest cause of halted
   orchestrations (6 of 13 open halts). Design how a long-running provisioning action is
   started, tracked across ticks, and reported — without the sysop growing a supervisor or
   blocking its own tick. Consider a start/poll split where the op is re-entrant and each
   tick advances or reports state.

2. **Closed model set.** The op must NOT pull an arbitrary tag. `model-tier-inventory.tsv`
   is a deliberately closed inventory ("a model absent from this file is unclassified and
   must not be automatically dispatched"). Define provisioning as "make the host's
   inventory-classified `local` model present" so the message never carries a free-form
   model string an issuer could point anywhere.

3. **Trust gate.** Decide where this sits relative to the existing split: the issuer gate
   (`config/sysop-issuers`) alone, or maintainer attestation (`authorized_by:` on
   `maintainers/allowlist`) as `unit`/`deploy` require. Argue it from consequence — a pull
   consumes tens of GB of disk and egress on a host nobody is watching. Note that disk
   exhaustion on a follower is a fleet-availability event.

4. **Preconditions and guards.** Disk-space headroom check before starting; behavior when
   the model is already present (must be a clean no-op); behavior when `ollama` is not
   installed; interaction with `garden-ollama` being `disabled` by the scaler when
   `hermits: 0`. Decide explicitly whether this op also enables/starts `garden-ollama` or
   whether that stays the existing `unit` op's job — do not silently overlap them.

5. **Idempotence, logging, ack.** Conform to the sysop's existing contract: every op
   idempotent, recorded to `sysop-log/<GARDEN>/<msgid>.md`, and acked so the sender can
   distinguish "done" from "never arrived".

## Constraints

- Ferry and any identity switch remain permanently out of the sysop vocabulary. This op
  must not widen that surface.
- The sysop runs on EVERY host, is not leader-gated, and deliberately still ticks under
  drain. Preserve all three properties; explain why the new op is safe under each.
- The sysop runs NO `claude` and claims no jobs. Keep it deterministic and LLM-free.
- The op must remain host-scoped by construction: each sysop reads only
  `msgs/host/<its-own-GARDEN>` and mutates only its own host.

## Output

A design doc in `designs/` with a Decision section, the op's message shape, the state
machine for the async case, the trust gate with its rationale, and the failure modes.
Name explicitly anything you considered and rejected.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-01T09:16:24Z
