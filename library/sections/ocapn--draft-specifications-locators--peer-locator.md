---
title: peer Locator (Syrup + URI serialization)
source: draft-specifications/Locators.md
source_repo: kriscendobot/ocapn
source_commit: f7005c122a7b8050d927c6358d4856d9b5475136
source_date: 2025-12-03
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: Maps to Endo's connection-establishment layer in CapTP; the Syrup serialization is referenced in the @endo/syrups and @endo/syrup-frame packages.
---

> Abstract: The peer locator: how a peer is named for incoming connection establishment. Two serializations: Syrup (for use within OCapN protocol traffic) and URI (for use in human-typed addresses, configuration, etc.). The peer locator identifies the peer; CapTP messages flow over a connection that the locator establishes.

# [peer Locator](#ocapn-peer)

This identifies an OCapN peer, not a specific object. This includes enough
information to specify which netlayer and provide that netlayer with all of the
information needed to create a  bidirectional channel to that peer.

The peer locator include the following pieces of information (more details
below):

- **Designator**: Usually representing the key, however can be any value
  determined by the netlayer
- **Transport**: A unique identifier to specify a netlayer
- **Hints**: A hashmap of additional connection information.

When comparing two peer locators, the designator and transport are the only
pieces of information which need to match. Two peer locators can have the same
designator and transport but  different hints and be considered to be the same
peer.

## [Syrup Serialization](#peer-syrup-serialization)

It's encoded as a record with the label `ocapn-peer` (symbol) and three
arguments:

```
<ocapn-peer transport   ; symbol (cannot contain ".")
            designator  ; string
            hints>      ; struct | false
```

### Hints

The hints are a [struct](https://github.com/ocapn/ocapn/wiki/Abstract-Syntax#struct-json)
which encode additional connection information that the netlayer might need to
reach the peer. There can be any number of hints, including none at all. If no
hints are used this field can be set to false.

## URI Serialization

The URI serialization is a URI form designed to be provided to users to be given
out of band to bootstrap a CapTP session.

The URI format is as follows:
```
;; Without hints (i.e. hints are set to false)
ocapn://<designator>.<transport>

;; With hints
ocapn://<designator>.<transport>?hint1=value1&hint2=value2
```

This is a URI with the scheme `ocapn` followed by the designator, a `.` and then
the transport name. If any  hints exist they're added as part of the query
parameters, otherwise emitted. 

Note that the designator permits `.` to be used within it, however the final `.`
should designate the separator  between the designator segment and the transport
identifier.


Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
