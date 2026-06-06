---
kind: result
role: liaison
host: endolin
refid: 797d08
dispatched_at: 2026-06-05T05:38:00Z
completed_at: 2026-06-05T05:49:44Z
cycle: 193
lane: chat
---

# Cycle 193 — chat-lane: `@endo/import-bundle/src/compartment-wrapper.js`

Ingested 137-line source + co-located markdown design doc.

## §First-pivot-this-session

Initially started with `@endo/captp/src/loopback.js` — but
discovered cycle 158 already covered it comprehensively
("two-CapTP-instances-cross-wired with shared bootstrap and
synchronous trap-bridge"). Deleted the draft and pivoted to
`compartment-wrapper.js` (fresh).

## Section file (cohesion-honest single section)

- `endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments.md`
  (~620 lines)
- Headline: **Inescapable Compartment wrapper with dual-
  signature compatibility, propagate-the-wrapper-to-child-
  compartments, and prototype-preserving for instanceof**

## Topics worked

- `compartments` (primary; added new row)
- `hardened-javascript`
- `bundles`

## Tier-1 borrowings worth re-noting

- §inescapable-compartment-wrapper-pattern (three named
  requirements: wrap-constructor + merge-options-in-order +
  propagate-wrapper)
- §`__options__`-sigil for §dual-signature-compatibility-
  during-migration (positional → options-bag)
- §preserve-.name-via-function-name-while-binding-to-different-
  local (lint-friendly shadowing)
- §`new.target===undefined`-throw for constructor-only-
  discipline
- §`Reflect.construct(target, args, new.target)` for §subclass-
  forwarding (sibling to cycle 181 base64's `Reflect.apply`
  capture)
- §propagate-the-wrapper-via-`c.globalThis.Compartment`-
  reassignment (transitive confinement)
- §prototype-aliasing-for-instanceof-preserving
- §SECURITY-NOTE-prefix for §greppable-security-disclosure-
  comments
- §`Reflect.ownKeys`-not-`Object.keys` for §full-key-
  enumeration
- §named-TODO-with-shape-of-future-fix-sketched
- §co-located-design-doc-pattern (compartment-wrapper.md
  alongside compartment-wrapper.js) — §package-level variant
  of cycle 190's §source-mirror-to-PLAN

## §honest-discipline-gaps named in source

The §SECURITY-NOTE comment names the non-SES leak:
"if this were used outside of SES, this might leave
c.prototype.constructor pointing at the original (untamed)
Compartment, which would allow a breach. Kris says this will
be hard to fix until he rewrites the compartment shim,
possibly as a plain function instead of a class. Under SES,
OldCompartment.prototype.constructor is tamed."

The §"Kris says" attribution + §"hard-to-fix-until-rewrite"
deferral are sibling to cycle 183-init's §named-hole-with-
named-mitigation ("For now we are resigned to leave this
hole open").

## Library counts after cycle 193

- 698 sections from 239 source documents.
- §designs-chat-alternation maintained 27 cycles (166–193).
- §papers-lane blocked 87+ consecutive cycles.

## Self-pacing

Cycle 194 wakeup scheduled in 1500s. Pattern: cycle 194
should be designs-lane (alternating from cycle 193's chat-
lane).
