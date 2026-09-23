---
source_kind: source
source_repo: endojs/endo
source_path: packages/cli/test/demo/names-in-transit.js
source_line_range: 1-27
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 374 chat-lane ingest paired to cycle 373 designs-lane
  @endo/cli README. 27-line test demo that operationally
  demonstrates capability-passing-with-petname-substitution-
  in-transit — the social-network model the competitive
  analysis identifies as endo-but-for-bots' strongest
  differentiator. Twenty-second AUTHORED conformant single-
  body section doc in post-refactor era. Sixty-four consecutive
  non-garden sources after the pivot (310-374). §sixty-four-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  petname-substitution-in-transit — line 7 sends the message
  `"Please enjoy this @counter:doubler."` but line 10's
  inbox regex expects `"HOST" sent "Please enjoy this
  @counter."` The embedded capability reference `@counter:
  doubler` becomes `@counter.` in the recipient's view. The
  capability carries the sender's intent ("doubler") out and
  the recipient's local name ("counter") in; the wire shows
  one identifier, each endpoint sees the name local to them.
  §the-named-petname-as-receiver-local-name-not-sender-
  global-name as tier-3 meta-pattern. This is the Miller-
  Stiegler petname model (public knowledge in capability-
  security literature) made operational in user-facing CLI
  behavior.

  §The-named-Granovetter-operator-as-message-payload — the
  HOST holds a capability called `doubler` (or `counter`
  locally). The HOST sends alice a message containing that
  capability reference embedded in human-readable text.
  Alice now holds the capability (via the next step,
  adoption). Mark Miller's Granovetter introduction model
  (Alice can pass Bob to Carol via reference-in-message)
  realized in concrete CLI flow. §the-named-introduction-by-
  reference-in-message as tier-3 meta-pattern.

  §The-named-adopt-as-explicit-naming-action — line 12:
  `endo adopt --as alice-agent 1 counter --name redoubler`.
  Alice ADOPTS the capability from message 1, calling it
  "redoubler" in her local namespace. The capability she now
  holds has THREE names: HOST's "doubler" (the original),
  the wire's "counter" (the host's exposed name in the
  message), alice's "redoubler" (her chosen local name).
  §the-named-three-names-per-capability-in-distributed-naming
  as tier-3 meta-pattern. Each principal names the same
  underlying object differently for their own purposes; no
  global directory exists.

  §The-named-message-and-capability-separate-lifecycles —
  line 16: `endo dismiss --as alice-agent 1`. Alice
  dismisses the INBOX MESSAGE numbered 1, but the
  capability she adopted PERSISTS (line 14 confirms
  `redoubler` is still listed after dismissal). §the-named-
  envelope-vs-cargo-distinction as tier-3 meta-pattern: the
  message is the envelope (transient, dismissible); the
  capability is the cargo (persists under the adopted name
  in the recipient's namespace).

  §The-named-named-recipient-via-as-flag — `--as alice-agent`
  lets the CLI act as a different principal than the
  default. The same physical CLI session can act on behalf
  of HOST (default) and alice-agent (via --as). §the-named-
  multi-principal-from-single-CLI as tier-3 meta-pattern;
  the CLI is a thin shell over the underlying multi-vat
  daemon, and identity-switching is per-command.

  §The-named-host-as-default-identity — line 10 shows the
  unqualified `endo send` acted as HOST (`"HOST" sent`).
  HOST is the default identity for unqualified commands;
  alice-agent is a separate principal. §the-named-default-
  principal-as-named-HOST as tier-3 meta-pattern.

  §The-named-twenty-seven-line-demo-of-social-network — the
  demo shows the *entire* peer-to-peer capability-passing
  flow (HOST → message → alice-agent → adopt → list →
  dismiss) in 27 lines. The social-network model is not
  speculative; it ships in test/demo as a tested user-facing
  workflow today. §the-named-social-network-already-shipping
  as session-level observation.

  §The-named-counter-and-doubler-as-named-capabilities — the
  example capabilities are `counter` and `doubler`. Generic
  examples (not Slack/Gmail integrations). The capability
  surface is whatever the host has exposed by name;
  arbitrary user-facing capabilities can be passed by this
  same mechanism.

  Closes seven citation arcs: cycle 373 (1, adjacent forward
  pair cli README → cli demo; the demo operationally
  realizes the README's user-interface-as-thin-controller
  framing) + cycle 369 (1, daemon README's bootstrap-
  provides-user-agent-API and facets-for-other-agents made
  concrete; the agent IS alice-agent, the facet IS the
  doubler reference passed in the message) + cycle 368 (1,
  exo taxonomy's bad-message-not-bad-input vocabulary lives
  here — these are MESSAGES between principals, not API
  calls) + cycle 367 (1, exo README's mint-purse-payment-as-
  canonical-OCAP-example is the same pattern; counter and
  doubler are degenerate single-facet exos for demo
  purposes) + cycle 321 (9, @endo/eventual-send promise-
  pipelining is what enables async-send between principals;
  competition.txt's social-network angle finds its
  substrate citation arc) + cycle 326 (47, pure-naming-as-
  discipline; this entire demo IS naming-as-discipline) +
  cycle 322 (48, @endo/errors not used in demo; the social
  flow is too small to need error decoration). Pushes
  citation-arc-closures-in-pivot to TWO-HUNDRED-NINETY (283
  + 7 net new).
---

27-line CLI test demo operationally demonstrating capability-passing-with-petname-substitution-in-transit between HOST and alice-agent principals. Chat-lane after cycle 373 designs-lane cli README. §the-named-petname-substitution-in-transit (single most structurally interesting move — capability reference `@counter:doubler` on wire becomes `@counter.` in recipient view; sender intent out, receiver local name in). §the-named-Granovetter-operator-as-message-payload (HOST passes capability to alice via message). §the-named-adopt-as-explicit-naming-action (three names per capability across distributed naming). §the-named-message-and-capability-separate-lifecycles (envelope vs cargo). §the-named-named-recipient-via-as-flag (multi-principal from single CLI). §the-named-host-as-default-identity. §the-named-twenty-seven-line-demo-of-social-network (social-network model not speculative; ships in test/demo today). Seven citation arcs closed. **Directly substantiates the competitive analysis's social-network hypothesis with a tested, shipping user-facing flow.**
