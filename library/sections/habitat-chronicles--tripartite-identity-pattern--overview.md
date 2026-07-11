---
title: The Tripartite Identity Pattern — the problem and the three-component thesis
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

The framing of Randy Farmer's canonical identity-decomposition pattern: user identity
management is "one of the most misunderstood patterns in social media design" because
product designers **conflate the many different roles required by various user
identifiers**. The confusion is compounded by treating older engineering-centric services
(Yahoo!, eBay, America Online) as canonical references — their identity models were
established on engineering requirements (establishing sessions, retrieving database
records) long before we had a subtle understanding of *user* requirements for
recognizability and self-expression, and by **conjoining the engineering requirements with
the user's requirements**, many older models actively *discourage participation*. Farmer's
motivating datum: Yahoo! found that users listed **fear of spammers farming their e-mail
address** as the number-one reason for abandoning the creation of user-generated content
(restaurant reviews, message-board postings) — an identity conflation so costly it drove a
radical, expensive re-engineering of the Yahoo identity model underway since 2006. The
thesis is that a **tripartite identity model** — separating the *account identifier*, the
*login identifier*, and the *public identifier* — best fits most online services and is
forward-compatible with current identity-sharing methods and future proposals.

## Content

One of the most misunderstood patterns in social-media design is that of **user identity
management**. Product designers often confuse the many different roles required by various
user identifiers. This confusion is compounded by using older online services — Yahoo!,
eBay, America Online — as canonical references. Those services established their identity
models on **engineering-centric requirements** (establishing sessions, retrieving database
records, and the like) long before there was a more subtle understanding of user
requirements for **recognizability and self-expression**.

By conjoining the requirements of engineering with the users' requirements, many older
identity models actually **discourage user participation**. The worked example: Yahoo!
found that users consistently listed the **fear of spammers farming their e-mail address**
as the number-one reason they gave for abandoning the creation of user-created content,
such as restaurant reviews and message-board postings. This ultimately led to a very
expensive and radical **re-engineering of the Yahoo identity model** that had been underway
since 2006.

Consistently, Farmer found that a **tripartite identity model** best fits most online
services and should be forward-compatible with current identity-sharing methods and future
proposals. The three components of user identity are: **the account identifier, the login
identifier, and the public identifier.** Each is treated in its own section below; the
separation is the whole point — the same conflation that made e-mail double as login and as
public handle is precisely what farmed the spam and drove users away.

Source: [The Tripartite Identity Pattern](https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/) by Randy Farmer, 2008-10-17 (content sha256 `c2c4d696`).
