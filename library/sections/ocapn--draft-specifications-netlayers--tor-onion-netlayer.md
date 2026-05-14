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
---

> Abstract: A worked example netlayer: how to implement OCapN over Tor onion services. Demonstrates the netlayer abstraction with a concrete realization that provides anonymity in addition to the required properties.

# Tor Onion Netlayer

This is a netlayer which uses the [Tor Onion](https://www.torproject.org/)
network to provide a connection. The tor network provides the following
properties:

- Strong encryption
- Strong anonymity
- Routing to any peer hosting a hidden service on the network

These properties can be very useful for a lot of applications, however it should
be noted that the tor onion netlayer can suffer from several drawbacks such as
speed so might not be suitable for all applications.

## Implementing the netlayer

The implementation of the tor network is out of scope for this document. This
document relies upon the functionality provided by an underlying Tor Onion
services implementation.

When creating and decoding the OCapN locator, the following information is used:

- **designator**: The Service ID that is provided when generating the hidden
service.
- **transport**: The symbol `onion`
- **hints**: Hints are not used, so this may be set to false/omitted.

The "hidden service" facility is used to create a CapTP peer. The hidden service
should be hosted on the port `9045` and using "ED25519-V3" for the key type.
Upon creation of a hidden service tor provides the "Service-ID", this must be
supplied as the "designator" in the OCapN peer Locator.


Source: `draft-specifications/Netlayers.md` at commit `d05a6d3e` (held at kriscendobot/ocapn).
