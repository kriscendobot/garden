---
title: Alternatives considered
source: designs/trust-on-first-bind.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 337329bdd0cee6c9f30b6dc593684e8823455e09
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: The "auto-add as the only mode" critique is the load-bearing argument against `tofu-auto` as a default — it converts the allowlist from a host-controlled artifact into a write-once side-effect log, defeating the protection against agent compromise. The default-allow-with-deny-list inversion is explicitly out of scope; the capabilities under discussion are default-deny by taste.
parent: endo-but-for-bots--llm-designs-trust-on-first-bind--alternatives-and-future-work
---

### Refuse and document

Ship only `'strict'` mode (PR #144's behaviour) and require the holder to mutate the allowlist out of band. This is the do-nothing alternative and it is the right default. The argument for trust-on-first-bind as an opt-in is that interactive agent development is the primary use case for these caps in the near term, and a strict-only cap means the developer alt-tabs to a CLI for every new origin they discover.

### Auto-add with audit log

Always auto-add and log; rely on the holder to review the audit log. This is `'tofu-auto'` as the only mode. Rejected as a default because it converts the allowlist from a host-controlled artifact into a write-once side-effect log; the allowlist no longer protects against agent compromise (a compromised agent can extend its own reach by attempting requests). Acceptable as opt-in for environments where the agent is trusted but the allowlist's role is operational accounting.

### Per-request prompts (no pinning)

Prompt every time, never pin. Rejected because the prompt cost dominates: a chat agent fetching five pages from `api.example.com` would issue five identical prompts. TOFU pins the answer; that is the whole point.

### TLS certificate pinning

A different problem: TOFU on a server's TLS public key, not its allowlist membership. Adjacent and useful but out of scope for the policy-binding question here; documented as future work below.

Source: [designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
