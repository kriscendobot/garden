---
title: Login Identifier(s) (Session Authentication) — federated capability-based logins and the separation payoff
source_kind: web-essay
source_url: https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/
source_content_sha256: c2c4d69629704c6520e18dc730aa871acf17ff3be0e240d6f7a26d791d24006b
source_author: Randy Farmer
source_date: 2008-10-17
ingested: 2026-07-11
ingested_by: scholar
topics: [identity, oauth-credentials, capability-security]
status: current
---

## Abstract

The second leg: **login identifiers** exist to create valid sessions associated with an
account identifier — the user's method of granting access to their privileged information
on the service. Historically these are unique, validated **name/password pairs**, but the
service **need not generate its own namespace** for them: it may **adopt identifiers from
other providers** (e.g. accepting external e-mail addresses after verifying the user
controls the address), and — increasingly, as of 2008 — accept **more sophisticated
capability-based identities from services such as OpenID, OAuth, and Facebook Connect**,
which provide login credentials without repeatedly asking the user for a name and password.
This federated-login recognition is the essay's direct tie to the garden's ocap
access-control lineage: a login credential minted by an external identity provider and
presented to a relying party is a delegated capability to establish a session, not a
password to be re-typed. **Separating** the login identifier from the account identifier
buys four things: (1) the login can be customized as the user's situation changes; (2) with
a permanent account identifier underneath, **data-migration issues are mitigated**; (3)
separating login from *public* identifiers **protects the user from account cracking**; and
(4) a service may attach **multiple login identifiers to one account**, aggregating
information gathered from multiple identity suppliers.

## Content

**Login identifiers** are necessary to create valid sessions associated with an account
identifier. They are the user's method of granting access to their privileged information
on the service. Historically these are represented by **unique and validated name/password
pairs**.

Note that the service **need not generate its own unique namespace** for login identifiers;
it may **adopt identifiers from other providers**. For example, many services accept
external **e-mail addresses** as login identifiers, usually after verifying that the user is
in control of that address. Increasingly, more sophisticated **capability-based identities**
are accepted from services such as **OpenID, OAuth, and Facebook Connect**; these provide
login credentials without constantly asking a user for their name and password.

Separating the login identifier from the account identifier delivers several payoffs:

- **Customization.** It is much easier to allow the user to change their login as the
  situation changes.
- **Migration.** Since the account identifier need never change, **data-migration issues
  are mitigated** even as logins churn.
- **Protection.** Separating the login identifier from *public* identifiers **protects the
  user from those who would crack their accounts** — the handle a stranger can see is not
  the credential that authenticates a session.
- **Aggregation.** A service could attach **multiple different login identifiers to a
  single account**, allowing it to aggregate information gathered from multiple identity
  suppliers.

Source: [The Tripartite Identity Pattern](https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/) by Randy Farmer, 2008-10-17 (content sha256 `c2c4d696`).
