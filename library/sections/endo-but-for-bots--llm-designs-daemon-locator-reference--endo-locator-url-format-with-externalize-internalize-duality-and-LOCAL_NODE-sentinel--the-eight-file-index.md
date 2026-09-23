---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §eight-file index
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §Files table names where each piece of locator machinery
lives:

| File | Key exports |
|------|-------------|
| `locator.js` | `parseLocator`, `formatLocator`, `formatLocatorForSharing`, `externalizeId`, `internalizeLocator`, `idFromLocator`, `addressesFromLocator`, `LOCAL_NODE` |
| `formula-identifier.js` | `parseId`, `formatId`, `isValidNumber` |
| `formula-type.js` | `isValidFormulaType`, `assertValidFormulaType` |
| `directory.js` | `makeDirectoryMaker` (provides `locate`, `writeLocator`, etc.) |
| `host.js` | `makeHostMaker` (carries up directory methods) |
| `guest.js` | `makeGuestMaker` (carries up directory methods) |
| `mail.js` | `makeMailboxMaker` (externalizes message identifiers to locators) |
| `daemon.js` | `makeInvitation` (constructs invitation locators) |

The §three-layered-decomposition: *parsing/formatting primitives*
(locator.js, formula-identifier.js, formula-type.js) →
*directory-level method-providers* (directory.js) →
*host/guest method-carriers* (host.js, guest.js, mail.js) →
*invitation-specific construction* (daemon.js).
