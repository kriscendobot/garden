# Redirect #539: drop endor-syscall/FinReg sturdyref retention; design enliven-on-demand via OCapN cap

Maintainer directive (kriskowal, on #539 — https://github.com/endojs/endo-but-for-bots/pull/539#issuecomment-4806519248):
*"It was not my intention that this design branch land at all. Please reuse this pull request,
rewriting the title, description, and content, and remove the design file. We will not pursue
FinalizationRegistry release of sturdyrefs or retain/release syscalls for sturdyrefs or presences
at this time. We will pursue sturdyrefs that can be enlivened on demand by the closely-held ocapn
network capability."*

Wear the **designer** role. Bot repo `endojs/endo-but-for-bots`, **reuse PR #539** (bot identity).

## What to do

1. **Reuse #539** — rewrite its **title, description, and content**, and **remove the design file**
   it currently carries (the endor-syscall continuation, `designs/sturdy-refs-endor-syscall*.md` /
   the continuation doc). #539 becomes the vehicle for the NEW direction below.
2. **Abandon both prior retention approaches** (explicitly, for now): **no FinalizationRegistry
   release** of sturdyrefs (the deferred #511 approach) and **no retain/release syscalls** for
   sturdyrefs or presences (the #510 endor-syscall approach). Drop the retention-management framing
   entirely.
3. **Design the new direction: sturdyrefs enlivened on demand by the closely-held OCapN network
   capability.** A SturdyRef is an inert, opaque data box (a locator); there is **no retention to
   manage**. When a holder needs the live reference, the **closely-held OCapN network capability
   enlivens the sturdyref on demand** — resolving it to a live presence/reference via the OCapN
   network (the same closely-held cap that associates a sturdyref with its locator / reveals the
   locator). Once enlivened, the live reference's lifetime follows normal CapTP/GC; the sturdyref
   itself is just persistable data. Spell out: the enliven API on the OCapN network cap, how a
   confined guest holds an inert sturdyref and asks the network cap to enliven it, and how this
   preserves user agency (the user's revocation acts on the live reference / the network cap, not
   on a tracked worker retention root). Align with #521 (pass-style sturdyref; OCapN defers to it).

## Cascade to coordinate (flag, do not silently break)

- The endor-syscall design **already landed on live `llm`** (via the earlier weave,
  `designs/sturdy-refs-endor-syscall.md`). Since the maintainer says it should not have landed,
  **supersede/remove it** as part of this redirect (a PR against live `llm` removing it, or fold
  the removal into the new design's landing). State the mechanism.
- **#541** (`feat(daemon): SturdyRef read-side threading + endor-syscall retention edges`) builds
  the now-abandoned endor-syscall retention — **flag it for hold/close** pending the new design;
  do not let it land the abandoned approach. **#511** stays deferred/abandoned.

## Definition of done

#539 reused for the new "enliven-on-demand via the closely-held OCapN network capability" design
(old design file removed, title/description/content rewritten), both retention approaches dropped,
the landed endor-syscall design superseded/removed from live `llm`, and #541 flagged for hold —
with a top-level summary comment on #539. Report the new #539 state and how #541 / the live-llm
design file are handled.

Posted by the liaison on behalf of the maintainer (design pivot on #539).
