---
title: Endo (top-level README overview)
source: README.md
source_repo: endojs/endo
source_commit: 30d556b73acf8e12d52f5d6efc1960223e98ec17
source_date: 2025-12-19
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, getting-started, capability-security]
status: current
---

> Abstract: The repository's top-level README. Sets up the umbrella: Endo is the family of packages that brings ocap discipline to JavaScript, building on SES (HardenedJS). Includes a package map by category and pointers to deeper reading. Recent (2025-12-19); reflects the post-1.0 landscape.

---
title: readme
group: Documents
category: Guides
---

# Endo

[![contributing][contributing-svg]][contributing-url]
[![license][license-image]][license-url]
[![CI status](https://github.com/endojs/endo/actions/workflows/ci.yml/badge.svg)](https://github.com/endojs/endo/actions/workflows/ci.yml)
[![Mutable.ai Auto Wiki](https://img.shields.io/badge/Auto_Wiki-Mutable.ai-blue)](https://wiki.mutable.ai/endojs/endo)

Endo is a framework for powerful JavaScript plugin systems and supply chain
attack resistance.
Endo includes tools for _confinement_, _communication_, and _concurrency_.
With Endo’s [SES][] implementation of [HardenedJS][], we can opt-in to a more
tamper-resistant mode of JavaScript.
With Endo’s [Eventual Send][E], we have a safe, transport-agnostic abstraction
for pipelining messages to remote procedures, and concrete transports like
[Endo CapTP][CapTP] and, soon, [OCapN](https://ocapn.org).

[Agoric][] and [MetaMask][] rely on Hardened JavaScript and the [SES shim][SES]
as part of systems that sandbox third-party plugins or smart contracts and
mitigate supply chain attacks for production web applications, web extensions,
and build systems.

[![Agoric Logo](https://github.com/endojs/endo/raw/master/packages/ses/docs/agoric-x100.png)][Agoric]
[![MetaMask Logo](https://github.com/endojs/endo/raw/master/packages/ses/docs/metamask-x100.png)][MetaMask]

[Agoric]: https://agoric.com/
[MetaMask]: https://metamask.io/

Endo protects program integrity both in-process and in distributed systems.
Hardened JavaScript protects local integrity, defending an application against
[supply chain attacks][]: hacks that enter through upgrades to third-party
dependencies.
Endo does this by encouraging the [Principle of Least Authority][] and
providing foundations for the [Object-capability Model][].

The _Principle of Least Authority_ states that a software component should only
have access to data and resources that enable it to do its legitimate work.
The _Object-capability Model_ gives programmers a place to reason, by
construction, about how permission flows through a program using
well-understood mechanisms like [Encapsulation][].

For distributed systems, Endo stretches object oriented programming over
networks using asynchronous message passing to remote objects with
_Capability Transport Protocols_ like [OCapN][] and a portable abstraction
for safely sending messages to remote objects called _Eventual Send_.

**Security:** Security-conscious JavaScript applications can use these
components to improve the integrity and auditability of their own applications,
improve the economics of vetting third-party dependencies, and mitigate runtime
prototype pollution attacks.

**Workers and Networks:** Performance-conscious JavaScript applications can use
these components to improve the ergonomics of message-passing between
components in separate workers.
Endo's _Eventual Send_ and _Capability Transport Protocols_ stretch
asynchronous method invocation acrosses processes and networks.

**Plugins:** JavaScript platforms on the web and blockchains can rely on Endo to safely
enable third-party plugins or smart contracts.
Endo provides tooling for bundling and safely executing arbitrary programs in
the presence of hardened platform objects.

Since most JavaScript libraries receive powerful capabilities from global
objects like `fetch` or modules like `net`, [LavaMoat][] generates reviewable
policies that determine what capabilities will be distributed to third party
dependencies according to evident need, and enforces those policies at runtime
with Endo.

For distributed systems, Endo stretches object oriented programming over
networks using asynchronous message passing to remote objects with the
[Handled Promise][] API and a [Capability Transfer Protocol][CapTP].

Between remote objects and Hardened JavaScript compartments, Endo makes
distributed programs easy to program, and easy to reason about integrity.
CapTP frees the programmer from needing to create bespoke communication
protocols over message ports or byte streams.

Endo combines these components to demonstrate their use for a confined plugin
system in the [Endo Pet-name Dæmon](packages/daemon) and its
[CLI](packages/cli).

Please join the conversation on our [Mailing List][SES Strategy Group] and
[Matrix][Endo Matrix].
Reach out if you would like an ivitation to our **meetings**:

- We record a weekly [Endo Sync video call][Endo Sync] .
- We recorded a weekly [SES video call][SES Strategy Recordings] with the
  Hardened JavaScript engineering community.
- We now meet weekly with [ECMA TC-39 ECMAScript Technical Committee TG-3
  Security Working Group][TG3].


Source: [README.md](https://github.com/endojs/endo/blob/30d556b73acf8e12d52f5d6efc1960223e98ec17/README.md) at commit `30d556b7`.
