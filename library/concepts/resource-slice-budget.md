---
id: resource-slice-budget
aliases: [resource-slice budget, systemd resource quota, quota-profile, CPUQuota MemoryMax TasksMax, user slice override, light medium heavy quota, host resource budget, non-token agent budget, alter account quota, make user quota]
topics: [coding-agent-economics, agent-fleet-orchestration]
---

# resource-slice-budget

The **host-resource** budget for an autonomous agent — a different budget kind than the token/compute [[cost-ledger]], which bounds what an agent spends *at the model* but says nothing about what its process consumes *on the host*. jcorbin's unum applies a systemd **resource-slice quota** per least-privilege "alter" account an invoker runs under: a `user-<uid>.slice` override written from a named profile — `light` (CPUQuota 200% / MemoryMax 2 G / TasksMax 1024), `medium` (400% / 4 G / 2048, the default), `heavy` (800% / 8 G / 4096) — with individual knobs overriding the profile and a **host-resource overcommit check** that refuses a quota the box can't back (bypassable with `--force`). The provisioning is plan-then-apply (pure `BuildPlan` → diff-friendly preview → confirm → `Apply` threading a `Runner` seam), with no auto-rollback and error-typed cleanup hints. The transferable pattern: **an agent account gets a declared resource envelope, sized by tier and validated against host capacity before it is applied** — the host-side analogue of a per-run spend cap, and the second axis (alongside token spend) of bounding a fleet.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--make-user-host-resource-quota](../sections/unum--make-user-host-resource-quota.md) | The `make user`/`make host` provisioning tree: the light/medium/heavy slice quota profiles, plan-then-apply discipline, and the host-hardening knob registry. |

## See also

- [[cost-ledger]] — the *token/compute* budget axis this complements; together they bound spend-at-the-model and consume-on-the-host.
- [[vigil-charge]] — a third budget kind: a health-gated rate limit on *proactive* invocations.
- [[model-routing]] — per-persona model tiers, the price/capability axis of the same economics topic.
