---
title: Inbound and outbound normalization
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node
---

```js
// Inbound: locator → local formula key, recognizing any local agent's key
const normalizeInboundId = id => {
  const { number, node } = parseId(id);
  if (isKnownLocalKey(node)) {
    return formatId({ number, node: LOCAL_NODE });
  }
  return id; // remote formula, keep as-is
};

// Outbound: local formula key → locator, stamping the sharing agent's key
const externalizeId = (id, agentPublicKey) => {
  const { number, node } = parseId(id);
  if (node === LOCAL_NODE) {
    return formatId({ number, node: agentPublicKey });
  }
  return id; // remote formula, keep as-is
};
```

The pair is the basis of the externalize/internalize discipline
landed by [[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]];
this design is its **origin document** and the place where the
`0.0.0.0` analogy is recorded.
