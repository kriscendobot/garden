---
title: §Synthesis target — slot machine library
source-slug: endo--packages-exo-src-get-interface
source-url: https://github.com/endojs/endo/blob/master/packages/exo/src/get-interface.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/exo/src/get-interface.js
total-lines: 28
ingest-cycle: 239
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat
---

For a slot machine library:

- §The-named-constant-string-IS-the-game-protocol-name (e.g., `GET_GAME_RULES_GUARD = '__getGameRulesGuard__'`).
- §Double-underscore-wrap for §game-engine-meta-method-naming-convention.
- §The-warning-IS-the-game-protocol-contract — when game rules can be updated across versions, name the staleness condition.
- §The-`Beware`-prefix-marks-actionable-warnings-in-game-rule-docs (not passive notes).
- §The-computed-property-key-uses-the-constant for §game-engine-meta-method-typedefs.
- §Defense-by-construction-via-computed-property-key — game-rule names and game-rule types stay aligned by construction.
- §The-optional-property-marker on meta-methods — some game engines expose introspection, some do not.
- §Template-with-constraint for §game-engine-method-record-types.
- §The-PR-discussion-link as named provenance for §game-engine-naming-decisions.
- §Twenty-eight-lines-as-a-complete-protocol-artifact for §game-engine-meta-method-name-files.
