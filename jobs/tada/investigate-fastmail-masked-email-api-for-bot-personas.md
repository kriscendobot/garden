Empty inbox, work committed and pushed. Done.

---

**Completion report**

**Job:** Investigate FastMail's masked-email API as a base for multiplexing one bot-controlled account into many bot personas. Investigation/design only — no account, token, persona, or signup was created.

**What I did:** Researched FastMail's Masked Email against current (2026-07-05) docs and working client references, confirming the plan's lead hypothesis, then wrote a feasibility design doc.

**What changed (pushed to `main2`, commit `f9f00d9d6`):**
- **New:** `designs/fastmail-masked-email-bot-personas.md` — the feasibility study.
- **Edited:** `designs/bot-email-dedicated-domain.md` — added a concrete file cross-link back to the new study (the counter-plan already referenced it by name only).

**Findings (all axes the plan required, verified):**
- **Confirmed:** Masked Email is a first-class JMAP data type (`MaskedEmail`, capability `https://www.fastmail.com/dev/maskedemail`), authed with a Bearer **API token** over the standard JMAP session. An agent can **mint / enable / disable / delete** addresses (`MaskedEmail/set`), retrieve the server-generated address, and set `description`/`forDomain`. State lifecycle: `pending`→`enabled` (inbox), `disabled` (→trash), `deleted` (→bounce); a still-`pending` address is auto-deleted after 24h.
- **Receiving:** yes — mail lands in the inbox, read via `Email/query` filtered by `to:<masked address>` + `Email/get` (ordinary JMAP; bodies/attachments/threading). This is how one shared mailbox separates per-persona mail.
- **Sending:** **No** — masked addresses are receive/forward-only, not a `From:` identity. Rarely bites the plan's receive-only use cases.
- **Limits/cost:** included on all personal plans (~$5/mo Individual), ~1,000-address cap + create-rate limit (`rateLimit` SetError); the 30-day trial is unsuitable (5 addresses, 120 msgs/day). ~fractions of a cent per persona-address.
- **Auth scope:** tokens are scope-selectable — least privilege = **Masked Email + Email read-only**, omit Email-submission/Contacts. Caveat: read scope is whole-mailbox (no masked-only read scope).
- Included the required **blast-radius** assessment (one account credential = master key to every persona; strictly worse concentration) and **ToS/abuse** assessment (bulk-signup prohibitions, masked-domain rejection breaking 2FA/recovery delivery, FastMail's own anti-abuse), plus a thin agent-facing JMAP recipe (mint / read / disable) and the **counter-plan pointer** with a when-to-prefer-which recommendation (incl. a Cloudflare→FastMail hybrid).

**Verdict delivered:** technically clean for a *few* receive-only, legitimately-used personas; use narrowly, not as a bulk identity mint. For scale / non-masking identity / any outbound, prefer the dedicated-domain counter-plan or the hybrid.

**Follow-ups:** none required by this job. Any actual account creation, token minting, or persona standup is a separate authorization-gated step (explicitly out of scope here).
