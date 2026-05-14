---
title: OCapN Netlayers (overview)
source: draft-specifications/Netlayers.md
source_repo: kriscendobot/ocapn
source_commit: d05a6d3efd749540358e72aaa5c1201e118c8d95
source_date: 2024-10-01
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn]
status: current
notes: Draft spec. The Endo netstring + noise + stream packages collectively implement what this spec calls a netlayer.
---

> Abstract: Netlayers abstract over the transport beneath OCapN: they provide message-stream connectivity with specific properties (reliability, ordering, integrity, optional confidentiality). Section is the warning + additional-documents pointer.

# Warning: This is a draft specification likely to undergo significant change

This draft specification has been initially written based on Spritely Goblin's
implementation as a base for the [OCapN pre-standardization
group](https://ocapn.org) to work from. Over time this document will change,
likely significantly as the group converges on the design of OCapN. If you're
interested in being part of that work, please join!

Authors: Jessica Tallon, Christine Lemmer-Webber & The OCapN Pre-standardization
Group.

# Additional Documents

- [OCapN Locators](): Representation of object references for both in-band and
  out-of-band usage.


Source: `draft-specifications/Netlayers.md` at commit `d05a6d3e` (held at kriscendobot/ocapn).
