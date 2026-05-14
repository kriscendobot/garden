---
title: Verification protocol, Handle extensions, and the caretaker for verification policy
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns, agent-conventions]
status: current
---

## Verification protocol — direct, not through the delegate

Bob holds a Handle for Aifred, whose epithet chain is
`[(assistant to Alice)]`. Bob wants to verify the claim:

```
1. Bob inspects Aifred's Handle to read its epithet chain.
   → [(assistant to Alice)]
   → The epithet includes a reference to Alice's Handle.

2. Bob asks Alice's Handle: "Do you confirm that this Handle
   stands in the 'assistant' relationship to you?"
   → E(aliceHandle).verify(aifredHandle, "assistant")

3. Alice's Handle responds:
   → true:    "Yes, I created this delegate as my assistant."
   → false:   "No, I deny this relationship."
   → silence: "I decline to answer."
```

For chains, each link is verified separately and with a different
principal:

```
Jarvis's epithets: [(majordomo of Aifred), (assistant to Alice)]

Bob verifies link 1: E(aifredHandle).verify(jarvisHandle, "majordomo")
Bob verifies link 2: E(aliceHandle).verify(aifredHandle, "assistant")
```

A break at any link means the chain is not fully verified from that
point onward.

## Handle interface extensions

```js
// Reading epithets (anyone holding the Handle can do this)
epithets: M.call().returns(M.arrayOf(EpithetShape)),

// Verification (anyone holding the Handle can ask)
verify: M.call(M.remotable('Handle'), M.string())
  .returns(M.promise(M.boolean())),
```

`epithets()` returns the chain. **Epithets are public to anyone who
holds the Handle** — they are claims, not secrets. Their value comes
from verifiability, not from concealment.

`verify(subordinateHandle, relationship)` asks the Handle's owner *did
you create this Handle as your [relationship]?* The response is at the
owner's discretion.

## The caretaker for verification policy

The Host (or delegate-creator) may want to control verification
policy separately from the Handle itself. The **caretaker pattern**
applies (see [[caretaker-pattern]]):

| Facet | Holder | What it does |
|---|---|---|
| **Handle** | Delegate-held, publicly reachable | Carries epithets; supports `verify()` with whatever policy the creator set. |
| **HandleControl** | Creator-held | Updates verification policy (`confirm-all` / `deny-all` / `selective`); revokes the Handle entirely. |

The delegate holds its Handle but cannot influence how its principal's
Handle responds to verification queries about it. **Alice controls
whether she confirms Aifred's epithet, not Aifred.**

The split is the same identity/action facet split that connectors
rely on for credential custody (see
[[endo-but-for-bots--llm-designs-dcp--ai-delegates-connectors-and-anti-impersonation]]).
The delegate has the *action* facet (send messages); the principal
has the *identity* facet (decide what's confirmable).

## Revocation as chain break

When the principal revokes a delegate's Handle (via HandleControl),
the chain at that link **breaks cleanly**:

> *All of Aifred's subordinates' epithet chains become unverifiable
> at the Aifred link. Bob verifying Jarvis's chain would find that
> the "(majordomo of Aifred)" link fails because Aifred's Handle is
> revoked.*

This is the same revocation-by-withdrawal mechanism described in
[[revocation-by-withdrawal]] — a Handle whose formula is removed
becomes structurally unreachable; the chain detection above is just
that property surfaced at the epithet-verification layer.

## Open questions

The design lists several questions not yet settled, of which two are
worth surfacing for downstream design conversations:

- Should `epithets()` and `verify()` join `HandleInterface` directly,
  or live in a separate optional facet (`EpithetInterface`)? Adding
  to Handle is simpler; a separate facet avoids changing the existing
  interface for Handles that do not participate in delegation.
- How does verification work across OCapN node boundaries? The
  verifier needs to reach the principal's Handle, which may be on a
  remote node. The cross-node story interacts with the per-agent
  keypair work ([[per-agent-keypair]]) and per-agent NETS work
  ([[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]).
