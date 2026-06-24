---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: Endo locator URL format with externalize↔internalize duality and LOCAL_NODE sentinel
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

> *An **endo locator** is a URL that identifies a formula on the
> Endo network. Locators are the external representation of
> formula identifiers, suitable for sharing between agents and
> across network boundaries. Internally, the daemon stores
> **formula identifiers** (compact `{number}:{node}` strings);
> locators are produced on demand by combining identifiers with
> type information and optional connection hints.*
>
> — `designs/daemon-locator-reference.md` §Overview

`daemon-locator-reference.md` (213 lines, *Current* status,
created 2026-03-18 by Kris Kowal in commit `f1d88c71`) is the
*canonical reference* for the Endo locator URL format. Pairs
with cycle 49's `daemon-locator-terminology` design which
specified the *rename* (Node Number → Peer Key, Formula Number →
Formula Address, Formula Identifier → Formula Key); this design
is the concrete *what the format actually is* document.
