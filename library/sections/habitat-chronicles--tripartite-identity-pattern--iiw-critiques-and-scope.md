---
title: Presentation at the Internet Identity Workshop — the key insight, three critiques, and capability-based identifiers as out of scope
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

The essay's 2008-11-12 update, recording the model's presentation at the **Internet Identity
Workshop** as an answer to much of the confusion around making the distributed-identity
experience easier for users. The **key insight** stated there is load-bearing for the
garden's ocap access-control lineage: **no publicly shared identifier is required — or even
desirable — for session authentication**; requiring the user to enter one on a relying-party
(RP) website is "an unnecessary security risk." A relying party should see **only the Public
ID and some unique key for the session that grants permission-bound access to the user's
account** — a plain-language statement of the capability discipline (the session key is the
authority, scoped and permission-bound, not an ambient public name). Three workshop critiques
are recorded: (1) **scope confusion** — are Account IDs global? (no — the context is *local*,
a single context/site/RP); (2) the term **"Public Identity" already collides** with iCards'
incompatible usage (Farmer invites an alternative term); and (3) **publicly-sharable
capability-based identifiers** (e-mail addresses, easy-to-read URLs, cell-phone numbers) are
**deliberately out of scope** — generating them and the policies for sharing them belong to
the context/site/RP, and an interested party might adopt the tripartite pattern as a
*sub-pattern* of a bigger sea of identifiers. The goal was not to be all-encompassing but to
demonstrate that **only three identifiers are required** for sites with user-generated content
and that **no public capability-bound ID exchange is required**.

## Content

**Update, 11/12/2008.** This model was presented at the **Internet Identity Workshop** as an
answer to much of the confusion surrounding making the distributed-identity experience easier
for users. **The key insight this model provides is that no publicly shared identifier is
required (or even desirable) to be used for session authentication** — in fact, requiring the
user to enter one on an RP website is an unnecessary security risk.

Three main critiques of the model were raised that should be addressed in a wider forum:

- **Scope of the model — are the Account IDs global?** There was some confusion here. The
  answer is that the context is **local** — a single context/site/RP. (Farmer hand-modified
  the diagram to add an encompassing circle showing this locality.)
- **The term "Public Identity" is already in use by iCards** to mean something incompatible
  with this model. Farmer is open to an alternative term that captures the concept.
- **Publicly-sharable capability-based identifiers are not included in this model.** These
  include e-mail addresses, easy-to-read URLs, cell-phone numbers, and the like. There was
  much controversy on this point. To Farmer, these **capability-based identifiers are outside
  the scope of the model**; generating them and the policies for sharing them are within the
  scope of the context/site/RP. Perhaps an interested party might adopt the tripartite pattern
  as a **sub-pattern** of a bigger sea of identifiers.

The goal was **not to be all-encompassing**, but to demonstrate that **only three identifiers
are required** for sites that have user-generated content, and that **no public
capability-bound ID exchange is required**. RPs should only see the **Public ID** and **some
unique key for the session that grants permission-bound access to the user's account**.

Source: [The Tripartite Identity Pattern](https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/) by Randy Farmer, 2008-10-17 (content sha256 `c2c4d696`).
