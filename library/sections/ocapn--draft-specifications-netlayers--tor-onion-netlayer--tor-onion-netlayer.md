---
title: Tor Onion Netlayer
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
parent: ocapn--draft-specifications-netlayers--tor-onion-netlayer
---

This is a netlayer which uses the [Tor Onion](https://www.torproject.org/)
network to provide a connection. The tor network provides the following
properties:

- Strong encryption
- Strong anonymity
- Routing to any peer hosting a hidden service on the network

These properties can be very useful for a lot of applications, however it should
be noted that the tor onion netlayer can suffer from several drawbacks such as
speed so might not be suitable for all applications.

Source: `draft-specifications/Netlayers.md` at commit `d05a6d3e` (held at kriscendobot/ocapn).
