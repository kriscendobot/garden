---
title: The HardenedJS story
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, capability-security]
status: current
---

> Abstract: Historical narrative for HardenedJS: motivations from the original E and Joe-E work, the JavaScript Realms proposal, why SES was built as a shim rather than a language extension, the path from research through standardization to production deployment in MetaMask and Agoric. Background reading for context, not for direct API use.

## The HardenedJS story

JavaScript was created to let web surfers safely run programs from strangers.
Web pages put JavaScript programs in a *sandbox* that restricts their abilities
while maximizing utility.

This worked well until web applications started inviting multiple strangers
into the same sandbox. But they continued to depend on a security model where
every stranger had their own sandbox.

Meanwhile, server-side JavaScript applications imbued their sandbox with unbounded
abilities and ran programs written by strangers. They were vulnerable
to both their dependencies *and* also the rarely reviewed dependencies of their dependencies.

HardenedJS uses a finer grain security model, *Object Capabilities* or *OCaps*.
With OCaps, many strangers can collaborate in a single sandbox, without risking them
frustrating, interfering, or conspiring with or against the user or each other.

To do this, the Lockdown function *hardens* the entire surface of the
JavaScript environment.
*The only way a program can subvert or communicate with another program is to
have been expressly granted a reference to an object provided by that other program.*

Any programming environment fitting the OCaps model satisfies three requirements:
- Any program can protect its invariants by hiding its own data and capabilities.
- Power can only be exercised over something by having a reference to the
  object providing that power, for example, a file system object. A
  reference to a powerful object is a *capability*.
- The only way to get a capability is by being given one. For example, by receiving
  one as an argument of a constructor or method.

Ordinary JavaScript does not fully qualify as an OCaps language due to the pervasive
mutability of shared objects. You can construct a JavaScript subset with a
transitively immutable environment without any unintended capabilities. Starting
in 2007 with ECMAScript 5, Agoric engineers and the OCap community have influenced
JavaScript’s evolution so a program can transform its own environment into
this safe JavaScript environment.

As of February 2021, HardenedJS (under the name SES) is making its way
through JavaScript standards committees.
It is expected to become official JavaScript when the standards process
is completed.
Meanwhile, Agoric provides its own SES *shim* (a library providing
the needed HardenedJS features) for writing secure smart contracts in
JavaScript.
Several Agoric engineers are on the relevant standards committees
and are responsible for aspects of HardenedJS, so our SES should be
very close to the eventual standards.


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
