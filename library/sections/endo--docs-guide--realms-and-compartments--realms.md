---
title: Realms
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, compartments]
status: current
parent: endo--docs-guide--realms-and-compartments
---

Agoric deploy scripts and smart contract code run in an *immutable
realm* with *Compartments* providing just enough authority to create
useful and secure contracts. But not enough authority to do anything
unintended or harmful to the participants of the smart contract.

JavaScript code runs in the context of
a [*Realm*](https://www.ecma-international.org/ecma-262/10.0/index.html#sec-code-realms). A
realm is the set of *primordials* (objects and standard library functions
like `Array.prototype.push`) and a global object. In a web browser, an iframe is a realm.
In Node.js, a Node process is a realm.

For historical reasons, the ECMAScript specification requires primordials
be mutable (`Array.prototype.push = yourFunction` is valid ECMAScript but not
recommended). By using the Agoric SES shim and calling `lockdown()`, you can turn the
current realm into an *immutable realm*; a realm within which the primordials
are deeply frozen.

SES also lets programs create *Compartments*. These are "mini-realms".
A Compartment has its own dedicated global object and environment, but
it inherits the primordials from their parent realm. Components are described
in detail in the next section.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
