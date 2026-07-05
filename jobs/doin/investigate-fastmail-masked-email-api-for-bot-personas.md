<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-05T21:54:04Z -->

# PLAN (low priority, investigate): FastMail masked-email API for bot persona multiplexing

Map: **research/design** → researcher then designer. Deliverable is a feasibility writeup
(design doc). Investigation only — NO account creation or external-service signups in this
job; actual persona/account creation is a separate, authorization-gated step.

## Question
Can an agent multiplex a SINGLE bot-controlled FastMail account into many addresses,
programmatically, to serve as a cheap base for hosted-bot personas? Concretely, whether
FastMail exposes an API to **create/manage masked email addresses** an agent can mint and
read, for:
- obtaining account subscriptions / signups on other services,
- acting as a second factor for account recovery (receiving recovery mail),
- email-address verification (receiving verification links),
- a base identity for OAuth to various online services (one persona per masked address).

## Lead hypothesis to CONFIRM (do not assume — verify against current FastMail docs)
FastMail's Masked Email is exposed over its **JMAP** API
(`urn:ietf:params:jmap:maskedemail` + standard JMAP Email/Mailbox), authenticated with a
FastMail **API token**. The investigation must confirm and document:
- **Create / enable / disable / delete** a masked address programmatically; retrieve the
  generated address string; set a per-address description/forDomain.
- **Receiving:** can the bot READ mail delivered to a masked address via JMAP
  Email/query+get (essential for verification + 2FA/recovery), and how (which mailbox,
  threading, attachments/links extraction)?
- **Sending:** can the bot send AS a masked address if a service requires a reply, or are
  masked addresses receive/forward only?
- **Limits & cost:** how many masked addresses per account, on which plan tier, any rate
  limits; the per-address and per-account economics ("cheaply create personas").
- **Auth scope:** can an API token be scoped to masked-email + mail-read only (least
  privilege for the bot)?

## Deliverable
- A feasibility verdict + a thin agent-facing API recipe: "mint a masked address," "read
  mail at address X," "disable address X" — the exact JMAP calls + token setup.
- A blast-radius / security assessment: one base account → many personas means compromise
  of the FastMail account exposes ALL personas and their recovery flows; weigh this.
- A **ToS / abuse-risk assessment (REQUIRED):** many services prohibit automated/bulk
  account creation and reject masked/disposable-email domains; some 2FA/recovery senders
  block known-masking domains, which would break the very use case. Assess per intended
  use; flag where this approach is unsafe or likely to get accounts/the FastMail account
  banned.
- A pointer to the counter-plan (`bot-email-dedicated-domain-counter-plan-aws-hetzner`)
  and a recommendation on when to prefer masked-email vs a dedicated domain.

## Constraints
Investigation only. The bot-controlled FastMail account is SEPARATE from the maintainer's
personal FastMail. No persona/account creation, no OAuth flows executed in this job —
those are authorization-gated follow-ons if the maintainer green-lights the approach.

---
claim:
  host: endolinbot
  gardener: 3
  claimed_at: 2026-07-05T21:54:08Z
