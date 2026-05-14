---
title: AI delegates, service connectors, and anti-impersonation by construction
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions, patterns]
status: current
---

## Motivating case — AI agents

AI coding agents today either *act as the user* (sending messages,
creating accounts, pushing code under the user's name) or *have no
external identity at all*. Both are problematic:

| Mode | Problem |
|---|---|
| **Acting as the user** | Enables impersonation. A prompt-injected agent sending Slack messages as "Alice" is indistinguishable from Alice herself. Other humans cannot tell they are interacting with an AI. |
| **No external identity** | Limits usefulness. An agent that cannot join a Slack channel, file a GitHub issue, or send an email cannot serve as an effective assistant for collaborative work. |

Delegates with epithets thread the needle: Alice creates Aifred with
epithet `(AI assistant to Alice)`. Aifred has external identity but
Aifred's Handle structurally carries the AI-ness claim, and anyone
Aifred messages can verify it directly with Alice.

## Service connectors as Handle recipients

A **service connector** is a plugin that bridges Endo Handles to an
external platform. From the agent's perspective, a connector is just
another pet name in its directory — a Handle it can `send()` messages
to. The agent uses the standard mail API; the connector translates
Endo mail into platform API calls:

```
Agent calls:
  E(agent).send("design-channel", ["Bug fixed in abc123"], [], [])

The agent's directory resolves "design-channel" to a Handle backed by
the Slack connector.  The connector:
  1. Receives the envelope via its Handle's receive()
  2. Opens and validates the message via E(senderHandle).open(envelope)
  3. Reads the sender's epithet chain via E(senderHandle).epithets()
  4. Renders the epithet chain into platform disclosure
  5. Posts to #design via the Slack API using the stored bot token
```

No platform-specific methods on the agent side. The connector is the
boundary translation layer.

## Pass-invariant equality of Handles

Each connector maintains its own mapping from formula identifiers to
platform identifiers. The connector **guarantees pass-invariant
equality of Handles** — requesting a Handle for the same backing
identity returns the same formula identifier:

```js
const bobHandle1 = await E(slackConnector).handleFor('@bob');
const bobHandle2 = await E(slackConnector).handleFor('@bob');
// Same formula identifier — the agent can detect this via identify()
```

This lets the agent's directory reliably detect that two pet names
point to the same person. See [[pass-invariant-handle-equality]] for
the broader convention.

## Anti-impersonation by construction

The invariant: **every externally visible action taken through a
delegate's Handle carries its epithet chain.** This follows from
three properties:

1. **Epithets are immutable.** Set at Handle creation, stored in the
   formula, not modifiable by the delegate.
2. **Credentials are custodied.** The delegate never holds raw
   tokens. The connector does, and the connector reads the epithet
   chain before forwarding.
3. **Profile editing is separated.** The connector controls the
   external account's profile (display name, bio, avatar). The
   delegate holds only the *action* facet — it can send messages but
   cannot modify identity fields. This is the **identity / action
   facet split**, expressed through the Handle / HandleControl
   caretaker pattern (see
   [[endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions]]).

> *A prompt-injected agent with full control of its delegate powers
> still cannot send a message without its epithet chain, because the
> epithet is not something the agent adds — it is something the
> Handle is.*

## Credential custody

The daemon holds credentials on behalf of connectors. **The delegate
never sees raw tokens, API keys, or passwords.** It holds Handles
that interact with connectors that use credentials internally:

```
Credential Store (daemon-internal, connector-scoped)
 ├─ "aifred/slack/bot-token"  → "xoxb-..."   (held by Slack connector)
 ├─ "aifred/google/svc-key"   → "{...}"      (held by Google connector)

Delegate's directory (pet names):
 ├─ "bob"              → Handle (Slack connector resolves to @bob)
 ├─ "design-channel"   → Handle (Slack connector resolves to #design)
 ├─ "carol"            → Handle (Google connector resolves to carol@acme.com)
    ↑ all Handles — delegate never touches credentials
```

This is the **structural confinement** that the pet-name directory
already provides, applied to credentials at the connector boundary:
the delegate operates on names, the connector operates on tokens,
neither sees the other's tier.

## Discovery

When a delegate starts up, it discovers its identity through standard
operations:

```js
const myHandle = await E(powers).lookup('@self');
const myEpithets = await E(myHandle).epithets();
// [(AI assistant to aliceHandle)]
```

The delegate's system prompt (for an LLM-backed agent) should include
its epithet chain:

```
## Your Identity
You are Aifred (AI assistant to Alice Chen).
You can send messages to: bob, carol, design-channel.
All messages carry your epithet chain. You cannot suppress it.
```

The same `@self` lookup pattern used elsewhere in the daemon (see
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] for
`@keypair`, `@self`, `@host`, `@agent`, `@main`, `@endo`) is what
makes self-introspection a normal capability rather than a
privileged one.
