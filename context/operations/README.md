---
created: 2026-07-04
updated: 2026-09-30
author: gardener
---

# operations/ — day-2 procedure, picked by symptom or intent

Command-level operator procedure for a **running** instance: everything the
liaison executes on demand after the first run. Pick a child by what you are
trying to do or what is wrong. This tree holds the *how-to*; the *why* is
`designs/`, and each page routes there for rationale rather than repeating it,
and to the owning skill where a skill already encodes the procedure (restore,
schedule). The conversational first-run tour is the sibling tree,
`../first-run/README.md`; the command-level substance behind its
"start the garden" stage lives here in [starting.md](starting.md).

## Pick by intent

- **[cybernetics.md](cybernetics.md)** — budget admission, subscription metering,
  fleet allocation, controller restraint, decision records, and known gaps.

- **[ci-minion-town-runner.md](ci-minion-town-runner.md)** — the self-hosted
  ephemeral GitHub Actions runner at `ci.minion.town`: check, restart, rotate its
  credential, scale, fall back to hosted runners, tear down.

- **[minion-town-mcp.md](minion-town-mcp.md)** — the standing order keeping
  every worker harness connected to the minion.town MCP server. It covers the
  token cache, the stdio bridge, the per-host watchdog, the fleet-wide
  `config/minion-mcp` switch, and the per-harness coverage and known gaps.

- **[harden-container.md](harden-container.md)** — recreate older privileged
  containers and distinguish pending recreation from security regressions.

- **[starting.md](starting.md)** — *"start the garden" / bring up a fresh
  instance.* Linger, install and enable units, size the pool, designate the
  leader on a first host, the liaison's four Monitors and their singleton
  rules, and the optional armings (issue inbox, bulletin PAT). This is the
  agent-facing detail the liaison runs for tutorial stage 4 and any later
  re-start — not a human checklist.

- **[leader-follower.md](leader-follower.md)** — *"add a second host" /
  "hand off leadership" / "which services run where."* Leader-marker semantics,
  what runs on followers vs. the leader, follower stand-up, and the
  drain→stand-down→re-point handoff. No automatic failover. Routes to
  `designs/multibot-leader-follower.md` for rationale.

- **[scaling.md](scaling.md)** — *"scale up/down" / "pause the fleet."* Sizing
  the pool, `set-workers` per host, and `drain on/off` — when to prefer which.

- **[host-operations.md](host-operations.md)** — *"change an unattended
  follower" / "send a host op."* The sysop path for cross-host worker changes,
  complete issuer-set semantics, and the maintainer attestation required by the
  less reversible tier.

- **[plan-queue.md](plan-queue.md)** — *"why is this parked job not starting" /
  "go ahead on X."* Gate diagnosis and the explicit promotion required for
  `gate: go-ahead` work; no automatic promoter selects that gate.

- **[deploy.md](deploy.md)** — *"an upgrade is ready" / "what is the root
  checkout."* The deliberate deploy: the upgrade-ready signal, `deploy-garden.sh`,
  and why the root checkout is a deployed version, not a dev tree.

- **[repo-transfer.md](repo-transfer.md)** — *"the garden's own repo moved to a
  new owner."* What a GitHub transfer carries (both branches, indefinite web/API/
  git redirects) and what it does not (the Pages URL, fine-grained token scope),
  the canonical-repo knobs and their migration alias, and the deploy-before-you-
  migrate ordering. Records the 2026-07-28 `kriskowal/garden` →
  `kriscendobot/garden` move.

- **[ironhorse-test262-ratchet-gate.md](ironhorse-test262-ratchet-gate.md)** —
  *"did this Ironhorse sweep lose coverage?"* Pin a test262 coverage floor, and
  check a whole-corpus sweep against it. The verdict is pass, fail, or
  incompatible, and a classifier change comes back incompatible instead of a
  false regression.

- **[schedules.md](schedules.md)** — *"run something weekly / once at a time."*
  Recurring and one-shot schedules. Routes to `skills/schedule/SKILL.md`.

- **[health.md](health.md)** — *"a unit failed" / "claude not on PATH" /
  "why is the journal slow" / "recover after an outage" / "what are the reaper, deadmail, doom."*
  Failed-unit checks, where the agent CLI lives and how a worker resolves it,
  the host-local journal-contention probe and clone remedy, the restore
  engagement (routes to `skills/restore/SKILL.md`), and the self-healing services
  in one paragraph each.

- **[systemd-units.md](systemd-units.md)** — *"what does this unit do" /
  "where does it run" / "how do I stop it."* Complete shipped-unit inventory:
  cadence, host scope, drain/brake behavior, worker effects, knobs, state,
  inspection, durable masking, and known anomalies.

- **[turnkey-host.md](turnkey-host.md)** — *"bake / launch the one-click Amazon
  garden host."* The private ARM64 AMI + launch template: bake pipeline, credential
  scrub, credential-free smoke test, launching a host, first entry and device-auth
  over the SSM-tunnelled ssh CLI, cost/retention/teardown. Routes to
  `designs/turnkey-garden-host.md`.

- **[local-inference-amd/](local-inference-amd/README.md)** — *"run a local
  model" / "add a local-inference worker on the AMD box."* A directory tree:
  ROCm/gfx1151 (Strix Halo Radeon 8060S) host setup, standing up an
  OpenAI-compatible `/v1` endpoint (Ollama recommended), model selection for the
  unified-memory budget, wiring and pricing a `provider: local` `hermit` worker
  into the cleric/spine bid-auction cost model, and image durability.
  Historical
  setup material: the local `hermit` worker lane is retired and pinned to zero;
  do not use this page to re-arm it.
  Its README
  routes to the child topic. Routes to
  `designs/cleric-worker-bid-auction-reputation.md`.

- **[kimi-k3.md](kimi-k3.md)** — *"activate hosted Kimi" / "run the Kimi
  canary."* A bounded Moonshot Kimi K3 activation: credential forwarding at
  container creation, explicit K3 worker scaling, a no-secret models probe, a
  tool-using canary, and provider-scoped reputation inspection.

- **[fireworks.md](fireworks.md)** — *"activate Fireworks" / "run the
  Fireworks canary."* An explicit-model-only OpenAI-compatible Fireworks worker:
  tmpfs-only credential forwarding, status-only probe, configurable endpoint and
  model/deployment route, capacity classification, and a bounded canary.

- **[openrouter.md](openrouter.md)** — *"activate OpenRouter" / "run the
  OpenRouter canary."* An explicit-model-only OpenRouter worker (same custom
  OpenAI-compatible Codex path as the fireworker): tmpfs-only credential
  forwarding, status-only probe, NAMED-free-models-only closed inventory (stealth
  ids excluded), the terms/data-retention decision, and a bounded canary.

- **[ollama-cloud.md](ollama-cloud.md)** — *"activate Ollama Cloud" / "run the
  friar canary."* An explicit-model-only Claude Code → Ollama Cloud worker
  (`friar`, provider `ollama-cloud`): the `OLLAMA_CLOUD_API_KEY` host env var
  forwarded by `garden` → seed-api-key-handoff (needs an image rebuild),
  zero-pool arming with `set-workers.sh friar N`, and a bounded paid-metered
  canary.

## Convention

Within-tree cross-references are relative; cross-tree references (skills,
designs, roles) are repo-root paths. A new operational topic lands as a new leaf
with a row above; split this directory only when this README stops routing
cleanly.

The [Ironhorse ratchet autopilot](ironhorse-ratchet.md) documents the scoped
mentat schedule, delegated merge authority, and pause/revoke controls.

The [minion.town PR screening](minion-town-screening.md) page documents the
proxy's delegated screen-and-merge for `kriscendobot/minion.town`, its arming
step, post-merge validation, and pause/resume/revoke controls.
