---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-08T18:56:04Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a `bot` property on the guest formula, and incarnation on message arrival

Repo: `endojs/endo-but-for-bots`. Base: `llm`. Child of arc
https://github.com/kriscendobot/garden/issues/89 (item 6).

Nothing designed for this yet. This is a change to the **Endo daemon proper**, not to
minion.town configuration, so it belongs in `@endo/*` and must be designed as a general
primitive rather than a minion.town affordance.

The requirement, in the maintainer's words: ensure the Claude instance for a particular
guest remains lively in the face of system restarts. A guest can be provisioned with an
associated **bot**, and whenever the guest receives a message, the daemon ensures the bot
has been incarnated or reincarnated. Shape: an optional `bot` property on the guest (or
host) formula, plus the associated machinery in the mailbox.

Cover at least:
- **Formula shape.** What the `bot` property holds: a formula identifier for a worker, a
  caplet reference, a full spawn descriptor. Whether it lives on the guest formula, the
  host formula, or both, and why. Formulas are persistent and content-addressed; say what
  changing a bot binding means for identity.
- **The incarnation trigger.** "Whenever the guest receives a message" is the stated hook.
  Specify precisely where in the mailbox path it fires, whether it is synchronous with
  delivery, and how a message that arrives during incarnation is handled. Messages must
  not be lost or double-delivered.
- **Reincarnation after restart.** What the daemon does at startup: eagerly incarnate every
  bot-bound guest, or lazily on first message. Argue the choice against restart cost and
  against the arc's liveness requirement.
- **Failure and thrash.** A bot that crashes on every incarnation must not become a hot
  loop. Propose a backoff or a circuit breaker, and say how an operator sees that state.
  Relate it to the credential-expiry path of arc item 3, since an expired credential is a
  likely repeated-failure cause and must not be mistaken for a crash loop.
- **Interaction with retained children and quotas.** `designs/claude-agents-capability.md`
  (kriscendobot/minion.town) already defines a per-user retained-child quota. An automatic
  reincarnation path must not silently defeat it.
- **Scope discipline.** This touches Endo's persistence and mailbox core. State explicitly
  what is in scope for a first increment and what is deliberately deferred.

Deliverable: one design document. Do not build.
