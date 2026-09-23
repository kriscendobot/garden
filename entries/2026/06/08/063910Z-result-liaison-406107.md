---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T06:39:10Z
dispatch_root: /home/kris/garden/dispatches/liaison--406107
---

# Librarian cycle 217 (chat-lane) — @endo/errors ingested

Cycle 217 alternates back to chat-lane after cycle 216's designs-lane (lal-transcript-memory-management). §Fifty-first consecutive designs-chat alternation cycle.

## Source

`endojs/endo packages/errors/{index.js, rejector.js, README.md}` — 155 source lines (132 index + 23 rejector) + ~15 README. The public-API-surface for SES's `assert` substrate; the canonical home for `hideAndHardenFunction` and the `Rejector` typedef used throughout @endo and consumers.

## What landed

- **Section file**: `library/sections/endo--packages-errors--public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home.md` — full source ingest covering index.js + rejector.js + README.
- **Source page**: `library/sources/endo--packages-errors.md`.
- **Sources/README.md**: new row inserted above the cycle 216 lal-transcript-memory-management row.
- **Sections/README.md**: new section entry + Total bumped to "723 sections from 264 source documents".
- **keywords.md**: ~36 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-217`.

## Borrowable patterns

- §Strict-fail-on-load-if-missing-prerequisite with §error-message-tells-the-user-what-to-do.
- §Enumerate-required-methods-and-tolerate-missing-ones — §load-bearing-comment-out-lines + §named-tolerance-for-a-specific-runtime-environment.
- §Rename-utilities-split-from-assertions via destructure + rest-spread — §when-a-substrate-API-mixes-two-different-shapes, §split-them-in-the-public-API.
- §Destructure-with-underscore-prefix-to-deliberately-discard.
- §Honest-fallback-policy with §named-runtime-compat-fallback.
- §Conventional-abbreviations + §named-aliases — §when-a-function-is-used-both-in-templates-and-in-prose, §export-it-under-two-names.
- §`__HIDE_`-prefix-protocol — §protocol-via-name-prefix is the §lightweight-cross-module-coordination-shape (string-prefix convention, no shared symbol or registry).
- §The-Rejector-three-line-idiom — §`cond || reject && reject\`...\`` with §three-cases.
- §The-dual-mode-pattern — one function serves as both predicate and assertion via §parameter-controlled-error-vs-silent-failure.
- §Tests-as-illustrative-examples — §the-test-file-is-the-second-half-of-the-documentation.
- §Two-channels-for-two-audiences (thrown-error redacted + console-log full) — §security-vs-diagnostic-tension resolved by §two-channels-with-different-trust-levels.

## Meta-observations

- §The-canonical-home-for-Rejector-and-hideAndHardenFunction finally ingested after many consumers. Cycles 102, 104, 110, 115, 120, 123, 125, 127, 150 all use one or both — now there's a single section to point at for the §portable-disciplines.
- §Four-different-runtime-version-or-environment-compat-hacks family now four members: cycle 199 (nat Apps-Script bigint-literal) + cycle 205 (evasive-transform Babel-traverse) + cycle 213 (stream-node Node-14) + cycle 217 (errors pre-1.13.0 SES Agoric bootstrap vat).
- §Twenty-seventh-member of §small-files-with-large-knowledge-density family.
- §Fifty-first consecutive designs-chat alternation, cycles 166-217.
- §Library-reaches-723-sections at cycle 217.
- Papers-lane blocked 111+ consecutive cycles.

## Next

Cycle 218 will be designs-lane (alternating from cycle 217's chat-lane). ScheduleWakeup for ~25 min.
