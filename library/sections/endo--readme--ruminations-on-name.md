---
title: Ruminations on the Name
source: README.md
source_repo: endojs/endo
source_commit: 30d556b73acf8e12d52f5d6efc1960223e98ec17
source_date: 2025-12-19
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Etymology and naming history for 'Endo'. Notes the play on 'inside the perimeter' (endogenous), the connection to E (the language Mark Miller co-designed), and how the name was chosen for the family of packages. Background reading, not API surface.

## Ruminations on the Name

* In Greek, "endo-" means "internal" or "within".
  This is fitting because Endo runs Node _within_ a safe sandbox.
  This is fitting in turn because Endo is built on the legacy of Google Caja.
  In Spanish, "caja" means "box" and is related to the Latin word "capsum" and
  English "capsule", as in "encapsulate".
* Endo is an anagram of Node and Deno.
  That is to say, we are not Done yet.
* The `endo` command, like the `sudo` command, is a "do" command.
  However, instead of escalating privilege, it attenuates privilege.
* Endo lets applications endow packages with limited powerful objects and
  modules.  As they say, you can't spell "endow" without "endo"!
* So, "E.N.Do" forms the acronym "Encapsulated Node Do".

So, just as "soo-doo" (super user do) and "soo-doh" (like "pseudo") are valid
pronunciations of `sudo`, "en-doh" and "en-doo" are both valid pronunciations of
`endo`.

<a name="§pola"></a>
### Principle of Least Authority

The Principle of Least Authority [(Wikipedia)][Principle of Least Authority]
states that a software component should only have access to data and resources
that enable it to do its legitimate work.

**PoLA explained in 3 minutes:**
_Opening Statement on SOSP 50th Anniversary Panel_, Mark Miller:

[![Video presentation explaining PoLA in 3 minutes](https://img.youtube.com/vi/br9DwtjqmVI/0.jpg)](https://www.youtube.com/watch?v=br9DwtjqmVI)

**PoLA explained in 15 minutes:**
_Navigating the Attack Surface to achieve a multiplicative reduction in risk_,
Mark Miller:

[![Video presentation explaining PoLA in 15 minutes](https://img.youtube.com/vi/wW9-KuezPp8/0.jpg)](https://www.youtube.com/watch?v=wW9-KuezPp8&t=664s)

### Bug Disclosure

Please help us practice coordinated security bug disclosure, by using the
instructions in our [security guide](./packages/ses/SECURITY.md) to report
security-sensitive bugs privately.

For non-security bugs, please use the [regular Issues
page](https://github.com/Agoric/SES-shim/issues).

### License

Endo and its components are [Apache 2.0 licensed][license-url].

[CapTP]: packages/captp/README.md#endocaptp
[E]: https://github.com/endojs/endo/tree/master/packages/eventual-send#eventual-send
[Encapsulation]: https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)
[Endo Matrix]: https://matrix.to/#/#endojs:matrix.org
[Endo Sync]: https://www.youtube.com/watch?v=tM5NyB7xxYM&list=PLzDw4TTug5O0eUj81Vnkp-mFuI4O0rBnc
[Handled Promise]: packages/eventual-send/README.md
[HardenedJS]: https://hardenedjs.org
[LavaMoat]: https://github.com/LavaMoat/LavaMoat
[OCapN]: https://ocapn.org
[Object-capability Model]: https://en.wikipedia.org/wiki/Object-capability_model
[Petname system]: https://en.wikipedia.org/wiki/Petname
[Principle of Least Authority]: https://en.wikipedia.org/wiki/Principle_of_least_privilege
[SES Proposal]: https://github.com/tc39/proposal-ses
[SES Strategy Group]: https://groups.google.com/g/ses-strategy
[SES Strategy Recordings]: https://www.youtube.com/playlist?list=PLzDw4TTug5O1jzKodRDp3qec8zl88oxGd
[SES]: packages/ses/README.md
[TG3]: https://github.com/tc39/tg3
[contributing-svg]: https://img.shields.io/badge/PRs-welcome-brightgreen.svg
[contributing-url]: ./CONTRIBUTING.md
[license-image]: https://img.shields.io/badge/License-Apache%202.0-blue.svg
[license-url]: ./LICENSE
[supply chain attacks]: https://en.wikipedia.org/wiki/Supply_chain_attack

Source: [README.md](https://github.com/endojs/endo/blob/30d556b73acf8e12d52f5d6efc1960223e98ec17/README.md) at commit `30d556b7`.
