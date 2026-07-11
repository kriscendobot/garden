---
title: Account Identifier (DB Key) — the permanent, inert, capability-free anchor
source_kind: web-essay
source_url: https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/
source_content_sha256: c2c4d69629704c6520e18dc730aa871acf17ff3be0e240d6f7a26d791d24006b
source_author: Randy Farmer
source_date: 2008-10-17
ingested: 2026-07-11
ingested_by: scholar
topics: [identity, capability-security]
status: current
---

## Abstract

The first leg of the tripartite model: the **account identifier** is the single database
key — the one way to access a user's record, refer to them in cookies, and potentially in
URLs. In a real sense it is "the closest thing the company has to a user": **required to be
unique and permanent**, typically a very large random number, and **not under the user's
control in any way**. Its defining discipline is that from the user's point of view it
should be **invisible or at the very least inert** — there should be **no inherent public
capabilities associated with this identifier**. Concretely, it should *not* be an e-mail
address, *not* accepted as a login name, *not* displayed as a public name, and *not* an
instant-messenger address. This is a plain-language statement of the object-capability
discipline applied to identity: the durable anchor of the account carries **no ambient
authority** and grants nothing on presentation — capability-bearing identifiers (email,
readable URLs, phone numbers) are kept out of the anchor and handled separately.

## Content

From an engineering point of view there is always one database key — one way to access a
user's record, one way to refer to them in cookies and potentially in URLs. In a real sense
the **account identifier is the closest thing the company has to a user**. It is required
to be **unique and permanent**. Typically this is represented by a **very large random
number** and is **not under the user's control in any way**.

In fact, from the user's point of view this identifier should be **invisible, or at the
very least inert**: there should be **no inherent public capabilities associated with this
identifier**. For example, it should **not** be an e-mail address, **not** accepted as a
login name, **not** displayed as a public name, and **not** an instant-messenger address.

The account identifier's permanence is what buys the rest of the model its flexibility:
because the account key need never change, the login identifiers and public identifiers
that *do* change over a user's lifetime can be re-pointed at it without data-migration pain
(see [Login Identifier(s)](habitat-chronicles--tripartite-identity-pattern--login-identifier.md)).
The inert, capability-free character of the anchor is the identity-side statement of the
principle of least authority: the value that *names* the account confers no authority by
being seen, so leaking it (in a cookie, a URL) does not leak a way to reach or spam the
user.

Source: [The Tripartite Identity Pattern](https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/) by Randy Farmer, 2008-10-17 (content sha256 `c2c4d696`).
