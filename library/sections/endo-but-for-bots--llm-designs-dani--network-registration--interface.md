---
title: Interface
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, ocapn, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-dani--network-registration
---

```typescript
interface EndoNetwork {
  // ... existing methods ...
  registerAgentKey(
    publicKey: string,
    agentId: FormulaIdentifier
  ): Promise<void>;
  unregisterAgentKey(publicKey: string): Promise<void>;
}
```

The interface is **additive**:

> *Networks that do not support multi-key registration simply ignore
> the calls. The daemon root keypair is always registered as the
> default.*

This shape — *new capability optional, old default preserved* — is the
same backward-compatible-extension pattern that
[[endo-but-for-bots--llm-designs-dlt--method-additions]] uses: never
break existing method signatures; layer new affordances on as
non-required extensions.
