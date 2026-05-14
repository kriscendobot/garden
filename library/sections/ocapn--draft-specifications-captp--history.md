---
title: History of OCapN (Actor Model, Joule, E, Cap'N Proto, Agoric/Endo, Spritely)
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn]
status: current
---

> Abstract: Historical context for the OCapN protocol family. 6 H2 sub-sections consolidated: Actor Model, Joule programming language, E programming language, Cap'N Proto, Agoric and Endo, Spritely. The intellectual lineage from Hewlett's actors through modern OCapN, naming the influences and the projects realizing the model today.

# History of OCapN

## Actor Model

The actor model which is foundational in CapTP and underpins the design of
OCapN. The actor model was proposed by Carl Hewitt, Henry Baker, Henry
Lieberman, Will Clinger, Gul Agha, and others at MIT.

## Joule programming language

The Joule programming language is a capability secure programming language,
designed for building distributed applications. It was developed by Dean
Tribble, Mark Miller, Norm Hardy and others while at Agorics. Joule was
primarily true to being a distributed object capability style language with an
emphasis on actor model type purely asynchronous interactions. The designs of
promises and promise pipelining are derived from those of Joule, and have been
influential on the appearance of promises in languages such as Javascript.

## E programming language

The E programming language is continuing the ideas of Joule, and is a capability
secure programming language, designed for building distributed applications. It
was developed by Mark Miller, Dan Bornstein, Douglas Crockford, Chip
Morningstar, Randy Farmer, Bill Frantz, Jamie Fenton, and others while at
Electric Communities.

E developed the vat model of computation (distributed objects within
communicating event loops, the conceptual model behind most distributed OCapN
systems today) and the distributed networking protocol abstractions at the core
of CapTP and VatTP (called "netlayers" in OCapN).

## Cap'N Proto

Cap'N Proto implemented a unique variant of CapTP which was based on statically
typed interface structures shared between multiple communicating
implementations. Because of this, Cap'N Proto managed to bring many of the
powerful ideas of CapTP to many new audiences while also providing a
high-performance API. While the statically typed interface description layer
approach of Cap'N Proto is not the same as the more dynamic approach taken by
OCapN's CapTP, the excellent documentation of Cap'N Proto's descriptions of its
implementation of CapTP's ideas were key to the development of OCapN.

## Agoric and Endo

Agoric carried forward the designs of E into the land of Javascript, including
bringing forward CapTP and promise pipelining. Agoric did much of the research
and development of what later became Endo, a secure JavaScript platform for
secure communication. An analysis of Agoric/Endo's implementation of
[CapTP](https://github.com/endojs/endo/tree/master/packages/captp) was
instrumental to the design of the version of CapTP seen in OCapN.

While at Agoric, Mark S. Miller also provided the re-conceptualization of
promise pipelining in CapTP as using "handoff tables", which later formed the
conceptual basis of the "gifting" mechanism implemented in OCapN's CapTP.

## Spritely

The Spritely Project and Spritely Networked Communities Institute developed
Spritely Goblins, in many ways a combination of the ideas of E and Scheme.
Goblins implemented the particular flavor of CapTP which from which much of
OCapN's CapTP was derived, including the certificate-based third party handoffs.
Spritely Goblins' CapTP was implemented by Christine Lemmer-Webber and Jessica
Tallon. Goblins also introduced the abstractions for OCapN's "netlayers"
interface (an analogue to E's "VatTP").


Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
