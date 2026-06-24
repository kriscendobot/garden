---
source: designs/trust-on-first-bind.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 337329bdd0cee6c9f30b6dc593684e8823455e09
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
section_count: 6
status: current
notes: Status: Reference (informational, not an implementation target). Authored by Kriscendo Bot. Cross-cuts heavily with capability-security (the whole point is a capability-policy adapter) and with endoclaw-network-fetch (the originating motivation). The "Pinned-Deny vs Revoked" distinction is non-obvious — both deny new requests, but Revoked came from a Pinned-Allow that was withdrawn, while Pinned-Deny was a fresh refusal.
---

> Abstract: A capability-policy adapter for "what does a confined cap do with a target outside its allowlist?". TOFU specialized to capability-policy bindings: at first attempt to bind a policy slot (origin / path / command), refer the decision to a higher authority and pin the answer. **State machine**: Unknown → Pending → Pinned-Allow / Pinned-Deny (both revocable); Revoked is its own state for "was Allow, now refused". **Four decision modes**: `strict` (default; no prompt; fault on Unknown), `tofu-prompt` (prompt the holder), `tofu-auto` (auto-allow + audit log), `tofu-attenuator` (forward to a supplied attenuator capability). **Policy storage** lives in the same persisted state as the controller's other policy; new control-facet methods listBindings / revokeBinding / unpin / setPolicyMode. **Revocation distinction**: revokeBinding moves a Pinned-Allow to Revoked (holder said "never"); unpin moves to Unknown (holder says "I was wrong, ask me again"). **Audit log** captures every state transition. **Failure modes** call out coalescing concurrent first-requests so the holder gets one prompt, not N. The pattern is a **shared adapter** across HttpClient, Browser, Shell, Git, Mount capabilities.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-state-machine](../sections/endo-but-for-bots--llm-designs-trust-on-first-bind--problem-and-state-machine.md) | capability-security | current |
| [decision-modes-and-who-decides](../sections/endo-but-for-bots--llm-designs-trust-on-first-bind--decision-modes-and-who-decides.md) | capability-security | current |
| [policy-storage-and-revocation](../sections/endo-but-for-bots--llm-designs-trust-on-first-bind--policy-storage-and-revocation.md) | capability-security, exo | current |
| [audit-trail-and-failure-modes](../sections/endo-but-for-bots--llm-designs-trust-on-first-bind--audit-trail-and-failure-modes.md) | capability-security | current |
| [composition-with-httpcontroller](../sections/endo-but-for-bots--llm-designs-trust-on-first-bind--composition-with-httpcontroller.md) | capability-security, tooling | current |
| [alternatives-and-future-work](../sections/endo-but-for-bots--llm-designs-trust-on-first-bind--alternatives-and-future-work.md) | capability-security | current |

## Cross-references

- TOFU pattern lineage: SSH host-key pinning, browser permission prompts, OS package-manager keyrings — same shape, different domain.
- Originating motivation: `endoclaw-network-fetch` (PR #163), `HttpController` design revision (PR #144).
- Expected consumers: `endoclaw-browser`, `daemon-agent-tools` (Shell + Git), `daemon-mount`.
- Prompt UI: `daemon-form-request` in Chat.
- Capability discipline overlap: `endo--docs-message-passing--digital-purse-example` (defensive-receive patterns).

## Source

[designs/trust-on-first-bind.md](https://github.com/endojs/endo-but-for-bots/blob/337329bdd0cee6c9f30b6dc593684e8823455e09/designs/trust-on-first-bind.md) at commit `337329bd` on branch `llm`.
