---
title: SES (overview)
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: @endo/ses is the Hardened JavaScript implementation: a shim that installs the SES (Secure ECMAScript) semantics in a regular JS realm via the lockdown() function. Establishes the core verbs (lockdown, harden, Compartment), the security model (frozen intrinsics, opt-in endowments), and the relationship to the broader Endo ecosystem. Foundational reading for anyone deploying SES.

# SES

SES is a [shim][define shim] for [Hardened JavaScript][] as [proposed][SES
proposal] to ECMA TC39.
SES stands for *fearless cooperation*.
Hardened JavaScript is highly compatible with ordinary JavaScript.
Most existing JavaScript libraries can run on Hardened JavaScript.

* **Compartments** Compartments are separate execution contexts: each one has
  its own global object and global lexical scope.
* **Frozen realm** Compartments share their intrinsics to avoid identity
  discontinuity. By freezing the intrinsics, SES protects programs from each
  other. By sharing the intrinsics, programs from separate compartments
  can recognize each other's arrays, data objects, and so on.
* **Strict mode** SES enforces JavaScript strict mode that enhances security,
  for example by changing some silent failures into thrown errors.
* **POLA** (Principle of Least Authority) By default, Compartments receive no
  ambient authority. They are created without host-provided APIs, (for example
  no `fetch`). Compartments can be selectively endowed with powerful arguments,
  globals, or modules.

SES safely executes third-party JavaScript 'strict' mode programs in
compartments that have no excess authority in their global scope.
SES runs atop an ES6-compliant platform, enabling safe interaction of
mutually-suspicious code, using object-capability -style programming.

Agoric and MetaMask rely on Hardened JavaScript and this SES shim as part of
systems that sandbox third-party plugins or smart contracts and mitigate supply
chain attacks for production web applications, web extensions, and build
systems.

[![Agoric Logo](docs/agoric-x100.png)](https://agoric.com/)
[![MetaMask Logo](docs/metamask-x100.png)](https://metamask.io/)

See <https://github.com/Agoric/Jessie> to see how SES fits into the various
flavors of confined JavaScript execution. And visit
<https://ses-demo.agoric.app/demos/> for a demo.

SES starts where the Caja project left off
<https://github.com/google/caja/wiki/SES>, and goes on to introduce compartments
and modernize the permitted JavaScript features.

Please join the conversation on our [Mailing List][SES Strategy Group] and
[Matrix][Endo Matrix].
We record a [weekly conference call][SES Strategy Recordings] with the Hardened
JavaScript engineering community.

*Hardened JavaScript*, Kris Kowal:

[![Primer on Hardened JavaScript](https://img.youtube.com/vi/RZ7bBIU8DRc/0.jpg)](https://www.youtube.com/watch?v=RZ7bBIU8DRc)

*Don't add Security, Remove Insecurity*, Mark Miller:

[![Don't add Security, Remove Insecurity](https://img.youtube.com/vi/u-XETUbxNUU/0.jpg)](https://www.youtube.com/watch?v=u-XETUbxNUU)


Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md) at commit `fe81477b`.
