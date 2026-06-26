# Continue #510 (sturdyref + endor-syscall retention) per maintainer decision; defer #511

Maintainer decision on the sturdyref competing pair: **continue development on #510**
(`design: sturdy-refs in pass-style + endor-syscall-based retention`) and **defer #511**
(FinalizationRegistry-tracked worker retention — "the branch pertaining to workers retaining
ephemeral references"). Wear the **designer** role. Bot repo, `endojs/endo-but-for-bots`, PR
**#510**, bot identity. Align with **#521** (`feat(pass-style): first-class 'sturdyref'`).

## Fold in the maintainer's review on #510 (and the general corrections)

- **#510 inline (designs/sturdy-refs-endor-syscall.md:254):** clarify that a **pass-style
  SturdyRef is specific to an OCapN instance (or other CapTP)** — a SturdyRef produced by one OCapN
  is not valid in another; make the locator/instance binding explicit.
- **General inert-data-box framing (from the #511 review, applies here too):** SturdyRefs are
  **inert, opaque data boxes — NOT references; they cannot receive eventual messages.** Ensure
  #510's framing is consistent (no stale `E(sturdyRef)`/HandledPromise-as-target language).
- Use a flexible **`type`** field (formula type or other hint for remote sturdy refs), per the
  maintainer's note.

## Fold in the design-panel synthesis grafts (recommended; #510 is the spine)

The two-juror panel recommended #510 (endor retain/release syscall; daemon owns retention,
authoritative per-handle revocation edges, no new FinalizationRegistry) as the spine, plus: (1)
**promote #510's deferred proactive per-turn `deleteExport` to a requirement** so retention is
GC-timing-independent; (2) keep FinalizationRegistry **only as an optional, off-by-default
leak-detector** (not a retention mechanism); (3) adopt the **local-only-at-the-boundary** rule.
Fold these into #510.

## Defer #511

Post a brief note on #511 that it is **deferred** per the maintainer's decision (continue #510);
do not develop it further. (Its FinalizationRegistry idea survives only as #510's optional
leak-detector.)

## Definition of done

#510 advanced to incorporate the maintainer's OCapN-instance-specificity + inert-data-box
clarifications, the `type` field, and the synthesis grafts (required proactive deleteExport,
optional FinReg leak-detector, local-only-at-boundary), aligned with #521; #511 marked deferred.
Push to #510 with a top-level summary comment. Report the head SHA. Surface the
`getStudyRefLocator`→`getSturdyRefLocator` typo on #521 for the maintainer (their PR).
