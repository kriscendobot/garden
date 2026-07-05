# FastMail Masked Email for bot persona multiplexing

| Created | 2026-07-05 |
| Author  | gardener (researcher + designer) |
| Status  | Proposed (investigation only) |

Feasibility study for the plan *investigate-fastmail-masked-email-api-for-bot-personas*.
The **counter-plan** — running bot email on a bot-controlled domain instead — is
[`bot-email-dedicated-domain.md`](bot-email-dedicated-domain.md); read both together, and
see *When to prefer which* at the end.

**Scope: investigation only.** No account is created, no API token is minted, no persona or
signup is performed in this job. Every command below is a *recipe*, not an executed step.
Actual persona/account creation is a separate, authorization-gated follow-on.

## The question

Can an agent multiplex a **single** bot-controlled FastMail account into many addresses,
programmatically, as a cheap base for hosted-bot personas — for service signups, 2FA /
account-recovery receipt, email verification, and a base identity for OAuth to online
services (one persona per address)?

## Verdict

**Technically: yes, and cleanly.** FastMail's Masked Email is a first-class, documented JMAP
data type (`MaskedEmail`) behind the capability `https://www.fastmail.com/dev/maskedemail`,
authenticated with an ordinary FastMail **API token** over the same JMAP session an agent
uses to read mail. An agent can **mint**, **enable/disable/delete**, and **read mail at**
masked addresses with a handful of JSON-RPC calls. The lead hypothesis in the plan is
**confirmed** against current FastMail docs (verified 2026-07-05).

**Strategically: use it narrowly, and not as the abuse engine the plan's framing hints at.**
Three hard limits shape where it fits:

1. **Receive/forward only — you cannot send *as* a masked address.** Masked Email is a
   receiving alias that drops mail into your inbox; it is **not** a sending identity. Any
   service that requires the persona to *reply from* the exact address it signed up with is
   not served by masking (see *Sending*).
2. **One mailbox, one account credential — maximal blast-radius.** Every persona's 2FA codes
   and recovery mail land in the **same** FastMail mailbox behind **one** login. Compromise
   of that one account seizes **every** persona (see *Blast-radius*).
3. **ToS / anti-abuse exposure on both ends.** Automated/bulk signups violate many services'
   terms; some 2FA/recovery senders reject or downrank known masked/relay domains
   (`*.fastmail.com`, `*.fastmail.de`, `*.mm.st`, etc.); and FastMail itself rate-limits
   masked-address creation and forbids abuse in its API developer policy (see *ToS / abuse*).

So: **excellent for low-volume, receive-only, per-persona inbound** (catch a verification
link, catch a 2FA code) on a legitimately-used account; **poor** as a bulk identity factory.

## How it works (confirmed)

- **Protocol.** JMAP (RFC 8620). Session bootstrap at `https://api.fastmail.com/jmap/session`
  with header `Authorization: Bearer <API-TOKEN>`. The session response advertises the
  `https://www.fastmail.com/dev/maskedemail` capability and gives you `accountId`
  (`session.primaryAccounts["urn:ietf:params:jmap:mail"]`).
- **`MaskedEmail` object** (server-set unless noted): `id`, `email` (the generated address —
  both immutable), `state`, `forDomain`, `description`, `url`, `lastMessageAt`, `createdAt`,
  `createdBy`, and the create-only `emailPrefix` (≤64 chars, `a-z0-9_`, otherwise the server
  picks a random corpus word).
- **`state` lifecycle** (this is the whole enable/disable/delete surface):
  - `pending` — initial state; auto-promotes to `enabled` on first received message; the
    server **deletes a still-pending address 24h after creation** (so mint-then-use promptly).
  - `enabled` — receives mail normally into the inbox.
  - `disabled` — still a live address but **incoming mail goes straight to trash** (soft off).
  - `deleted` — inactive; **incoming mail is bounced** (hard off).
- **Methods.** Standard JMAP `MaskedEmail/get` (pass `"ids": null` to list all) and
  `MaskedEmail/set` (create / update-state / delete). `MaskedEmail/query` is **not**
  documented as supported — enumerate with `get`+`ids:null`, not `query`.
- **Delivery.** Mail to a masked address is **delivered into the FastMail inbox** (marked with
  a masked-email icon and the address's label), so it is fully readable over JMAP `Email/*`.
  It is *not* a blind forward to elsewhere.

## Thin agent-facing API recipe

Setup (once): create an **API token** in FastMail *Settings → Privacy & Security → API
tokens* with least-privilege scopes (see *Auth scope*). Store it as a fleet secret.

**1. Bootstrap the session** (once per process; cache `apiUrl` + `accountId`):

```
GET https://api.fastmail.com/jmap/session
Authorization: Bearer $FASTMAIL_TOKEN
→ session.apiUrl, session.primaryAccounts["urn:ietf:params:jmap:mail"] = ACCOUNT_ID
```

**2. Mint a masked address** (POST the JMAP request to `session.apiUrl`):

```json
{
  "using": ["urn:ietf:params:jmap:core", "https://www.fastmail.com/dev/maskedemail"],
  "methodCalls": [[ "MaskedEmail/set", {
    "accountId": "ACCOUNT_ID",
    "create": {
      "persona-42": {
        "state": "enabled",
        "description": "persona-42 :: github signup",
        "forDomain": "https://github.com",
        "emailPrefix": "persona42"
      }
    }
  }, "0" ]]
}
```

Read the generated address from the response at
`methodResponses[0][1].created["persona-42"].email` (e.g. `persona42.abc123@fastmail.com`).
Keep the returned `id` — you need it to disable/delete later.

**3. Read mail delivered to address X** (`Email/query` + `Email/get`, mail-read scope):

```json
{
  "using": ["urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail"],
  "methodCalls": [
    [ "Email/query", { "accountId": "ACCOUNT_ID",
      "filter": { "to": "persona42.abc123@fastmail.com" },
      "sort": [{ "property": "receivedAt", "isAscending": false }], "limit": 20 }, "0" ],
    [ "Email/get", { "accountId": "ACCOUNT_ID",
      "#ids": { "resultOf": "0", "name": "Email/query", "path": "/ids" },
      "properties": ["subject","receivedAt","preview","from","bodyValues","textBody","attachments"],
      "fetchTextBodyValues": true }, "1" ]
  ]
}
```

Filtering `Email/query` by `to: <the masked address>` is how one shared mailbox separates
per-persona mail. Extract verification links / 2FA codes from `textBody`/`bodyValues` (and
`attachments` when a code arrives as one). Poll on a short interval, or use JMAP push
(EventSource / `StateChange`) to wake on delivery.

**4. Disable or delete address X** (by its `id`):

```json
{ "using": ["urn:ietf:params:jmap:core", "https://www.fastmail.com/dev/maskedemail"],
  "methodCalls": [[ "MaskedEmail/set", {
    "accountId": "ACCOUNT_ID",
    "update": { "MASKED_ID": { "state": "disabled" } }
  }, "0" ]] }
```

Use `"state": "disabled"` to soft-off (mail → trash, address preserved/auditable) or
`"deleted"` to hard-off (mail bounced). A JMAP `rateLimit` `SetError` on create means you hit
FastMail's anti-abuse throttle — back off, don't hammer.

## Answers to the plan's specific questions

- **Create / enable / disable / delete + retrieve the string + set description/forDomain** —
  all supported via `MaskedEmail/set` as above; the address string is server-generated and
  returned in the create response. ✅
- **Receiving / reading (essential for verification + 2FA/recovery)** — yes; mail lands in the
  inbox and is read via `Email/query`+`Email/get`, filtered by the `to` address. Threading,
  bodies, and attachments are ordinary JMAP `Email` — nothing masked-specific to parse. ✅
- **Sending as a masked address** — **No.** Masked Email is receive/forward-only; it is not an
  identity you can put in `From:`. If a persona must *send* or *reply from* its address, you
  need a real FastMail **alias** (a different feature, and aliases are not randomized/
  disposable) or the counter-plan's dedicated domain (any `persona@minion.town` can send).
  For the plan's stated needs — subscriptions, 2FA/recovery receipt, verification links, OAuth
  base identity — **inbound is all that's required**, so this limit rarely bites. It bites only
  when a service demands an outbound confirmation *from the address itself*. ⚠️
- **Limits & cost** — Masked Email is included on **all FastMail personal plans** (Individual
  ~$5/user/mo, Duo, Family) and business plans; it is *not* a paid add-on. There is a **cap on
  total masked addresses** (reported ≈1,000 on Individual) and a **create-rate limit**
  (surfaced as a `rateLimit` `SetError`). The **30-day free trial is unsuitable** for personas:
  trials are capped at **5 addresses** and **120 sent msgs/day**. Economics: **one ~$5/mo
  account → up to ~1,000 addresses** ≈ fractions of a cent per persona-address — genuinely
  cheap *for the address*, but see blast-radius and ToS before treating cheapness as the
  deciding factor. 💲
- **Auth scope (least privilege)** — FastMail API tokens are **scope-selectable** at creation.
  For a bot, grant **Masked Email** (see/create/manage masked addresses) **+ Email as
  read-only** (to read incoming verification/2FA mail), and **omit Email submission** (no
  send) **and Contacts**. Caveat: the read scope is **whole-mailbox** — there is no scope that
  restricts reads to *only* masked-addressed mail, so a leaked read-token exposes the entire
  inbox, not just persona mail. Rotate tokens; treat them as fleet-critical secrets. 🔒

## Blast-radius / security assessment

**This is the dominant risk and the reason to keep the pattern narrow.** One base account →
many personas means:

- **Single point of total compromise.** Every persona's 2FA codes and account-recovery mail
  land in **one** mailbox behind **one** FastMail login. Whoever holds that login (or a
  read-scoped API token) can read **every** persona's inbound and therefore **seize every
  account** those personas hold across every service. This is *strictly worse* concentration
  than one provider (or one address) per persona — identical in shape to the counter-plan's
  one-domain blast-radius, but here the account credential *is* the master key, not just DNS.
- **Token sprawl.** Any read-scoped token is a whole-mailbox key (scope caveat above). A
  masked-only token can still enumerate/disable every persona address.
- **Recovery-loop concentration.** Using the same base account as the **2FA / recovery**
  channel for many services means the account is itself the highest-value target and its *own*
  recovery path (FastMail login, its 2FA, its recovery email) must be hardened above everything
  it protects — otherwise you've built a lower-security root for higher-security leaves.

**Mitigations if adopted:** strong unique password + hardware-key 2FA on the FastMail login;
minimum-scope, individually-rotatable API tokens (never one god-token); the account's *own*
recovery locked down and monitored; and a hard ceiling on how sensitive an account you're
willing to gate behind a shared-mailbox persona (e.g. **never** put a persona that controls
money, production infra, or the fleet's own credentials behind it). The convenience of "one
account, ~1,000 addresses" **is** the risk.

## ToS / abuse-risk assessment (REQUIRED)

Three distinct exposures, any one of which can break the use case or get accounts banned:

- **Target-service ToS: bulk/automated account creation is widely prohibited.** Many services'
  terms forbid creating accounts by automated means or at scale. Using masked addresses to mint
  many identities for signups can violate those terms and get the **created accounts banned** —
  and repeated abuse from one masking domain can get the *pattern* flagged. Masking the address
  does **not** launder the ToS violation. Use only within each target service's terms; this is
  **not** a license for bulk or abusive signups.
- **Deliverability: masked/disposable-domain rejection breaks the core flow.** Some
  registration, 2FA, and account-recovery senders **reject or downrank known masking/relay
  domains**, and FastMail's masked hosts (`*.fastmail.com` and siblings) are recognizable. When
  a sender blocks the masked domain, the verification link or recovery code **never arrives** —
  breaking exactly the flow the plan wants. This is per-service and must be tested per intended
  target, not assumed. Where a service blocks masked domains, prefer the counter-plan's plain
  vanity domain (which reads as an ordinary company domain).
- **FastMail's own anti-abuse.** FastMail **rate-limits masked-address creation** (JMAP
  `rateLimit` `SetError`) and its **API Developer Policy** prohibits abusive automation;
  driving the API hard to fan out disposable identities risks the **base FastMail account**
  itself. Because that base account is the root of every persona (blast-radius above), losing it
  is catastrophic, not merely inconvenient. Stay well under the create-rate limit and within the
  address cap; don't treat the API as a bulk mint.

**Net:** safe and within-bounds for a **modest number of legitimately-used personas** doing
receive-only inbound on services whose ToS permit the account. **Unsafe / likely-to-get-banned**
as a high-volume identity factory, or against services that prohibit automated signup or block
masked domains, or for gating high-value (money/infra/credential) accounts behind a shared
mailbox.

## When to prefer masked email vs a dedicated domain

Paired with the counter-plan [`bot-email-dedicated-domain.md`](bot-email-dedicated-domain.md):

- **Prefer FastMail Masked Email when** you want **zero infrastructure** and a **real,
  human-usable mailbox** today: no DNS, no MX, no server, no provisioning — an API token and a
  handful of JMAP calls. Per-address **disable/delete** and a built-in label/`forDomain` audit
  trail are nicer than a bare catch-all. Best for a **small** set of personas doing receive-only
  inbound where the ~$5/mo account is already justified.
- **Prefer the dedicated domain (Cloudflare Email Routing) when** you need **free unlimited
  addressing with no per-address API call** (`any@minion.town` is instantly live via
  catch-all), a domain that **doesn't read as a masking service** (avoids the deliverability
  rejection above), or an eventual **outbound** path. It costs DNS/setup but wins on scale,
  control, and not-looking-disposable.
- **Hybrid (cheapest robust shape).** Cloudflare owns `minion.town`'s address space (free
  catch-all, non-masking domain, full control) and **forwards into the FastMail mailbox** this
  plan already reads over JMAP. You get the dedicated-domain deliverability and control *plus*
  FastMail as the clean programmatic read store — one reader, one API. If the maintainer wants
  both, wire them this way; the two plans are **complementary, not exclusive**.

**Recommendation:** for a *few* receive-only personas, FastMail Masked Email is the lowest-effort
start and is fine to green-light for a small, non-abusive trial. For scale, non-masking identity,
or any outbound, go dedicated-domain (or the hybrid). In **all** cases the blast-radius and ToS
caveats above are load-bearing — this is a capability to use narrowly, not a bulk identity mint.
Any actual account creation / token minting / persona standup remains an **authorization-gated
follow-on**.

## Sources

Verified 2026-07-05:

- FastMail Masked Email JMAP data type, capability `https://www.fastmail.com/dev/maskedemail`,
  `MaskedEmail/get`+`/set`, object properties, `state` semantics (pending/enabled/disabled/
  deleted) — <https://www.fastmail.com/for-developers/masked-email/>,
  <https://www.fastmail.com/blog/how-and-why-we-built-masked-email-with-jmap-an-open-api-standard/>
- JMAP session endpoint, `Authorization: Bearer` token auth, API-token scopes (Email /
  Email submission / Contacts / Masked Email; read-only toggle) —
  <https://www.fastmail.com/for-developers/integrating-with-fastmail/>,
  <https://www.fastmail.help/hc/en-us/articles/5254602856719-API-tokens>
- Masked-email delivery-to-inbox, per-address disable, plan availability, address/rate limits —
  <https://www.fastmail.com/features/masked-email/>,
  <https://www.fastmail.help/hc/en-us/articles/1500000277382-Account-limits>
- Trial limits (5 addresses, 120 msgs/day) —
  <https://www.fastmail.help/hc/en-us/articles/1500000277442-Trial-accounts>
- API developer / abuse policy — <https://www.fastmail.com/policies/api-developer-policy/>
- Working client references for the concrete JMAP calls —
  <https://github.com/ajyey/fastmail-masked-email>, <https://github.com/kensmith/fastmask>,
  <https://gist.github.com/jvns/738eda48bff8c4dd2a5e349b8df7c7a8>
- Counter-plan (dedicated domain) — [`bot-email-dedicated-domain.md`](bot-email-dedicated-domain.md)
</content>
</invoke>
