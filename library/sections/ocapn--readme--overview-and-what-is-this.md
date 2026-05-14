---
title: OCapN network suite (overview and what is this)
source: README.md
source_repo: kriscendobot/ocapn
source_commit: 482d9cc9845a6580840711e518d71b4e27a2dcaf
source_date: 2025-07-10
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, capability-security]
status: current
---

> Abstract: Top-level introduction to the upstream protocol suite: what it is (a network-protocol family for distributed capability-secure communication), the components (Model, Notation, Locators, Netlayers, CapTP), and what implementations exist.

# OCapN network suite

## What is this?

OCapN stands for "Object Capability Network".
OCapN provides:

 - An implementation of the
   [CapTP](http://erights.org/elib/distrib/captp/index.html)
   "Capability Transport Protocol" abstract protocol, as the shining
   heart of OCapN.
   This protocol allows for networked programming which, with the
   appropriate tooling, has the convenience of programming against
   "networked objects" which are little different from any other
   asynchronous programming in the host language.

 - A generalized "netlayer" interface and specifications of compatible
   implementations.
   OCapN's CapTP can be run over different "netlayer" implementations
   ranging from [Tor Onion Services](https://2019.www.torproject.org/docs/onion-services.html.en)
   to [IBC](https://ibcprotocol.org/)
   to [I2P](https://geti2p.net/)
   to [libp2p](https://libp2p.io/)
   to perhaps carrier pigeons with backpacks full of encrypted microsd
   cards.

 - A URI structure for addressing machines and specific objects on machines.

 - Not [one](https://www.poetryfoundation.org/poems/45474/o-captain-my-captain),
   but [two](https://www.merriam-webster.com/dictionary/netlayer)
   nautical naming puns (with some [formidable imagery](https://en.wikipedia.org/wiki/Net_laying_ship#/media/File:The_Royal_Navy_during_the_Second_World_War_A16583.jpg)
   at that)!

OCapN is still pre-specification, and will likely be the output of
examining to what extent the
[Agoric](https://agoric.com/), [Spritely](https://spritelyproject.org/),
and potentially [Cap'N Proto](https://capnproto.org/) implementations
can be unified (with significant help and review from the
[Metamask](https://metamask.io/) team).

The OCapN group has as its goal to have the OCapN specifications be fast and
easy to implement.

(See also: [this Spritely and Agoric CapTP interop issue](https://github.com/Agoric/agoric-sdk/issues/1827) for some more on current developments.)


Source: `README.md` at commit `482d9cc9` (held at kriscendobot/ocapn).
