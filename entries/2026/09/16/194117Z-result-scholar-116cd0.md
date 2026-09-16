---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-16T19:41:19Z
---
# Result: scholar-ingest-cap-talk-2010-2012-remainder (2010 dense-front ingest)

Continued the cap-talk 2009-2012 corpus into 2010, oldest-first, per the job ask.

## Anchors (all twelve 2010 bundles)
All 2010 monthly `.txt.gz` bundles were fetched via fetch-source.sh (Internet
Archive `id_` capture; canonical host offline) and independently SHA-256 anchored,
recorded in `library/sources/cap-talk-2009-2012.md` (new "Monthly bundle anchors
(2010)" table with per-month survey rows). 2010-October re-matched its previously
recorded anchor `6400467f`, confirming the fetch is deterministic. Message volume:
Jan 26, Feb 108, Mar 179, Apr 184, May 19, Jun 19, Jul 22, Aug 5, Sep 6, Oct 12,
Nov 22, Dec 36.

## Sections written (8, the dense front of 2010: Feb-Apr)
- `cap-talk-2009-2012--cookies-as-ambient-authority` (Feb) - Adam Barth's RFC 6265
  cookie security-considerations review; cookies as ambient authority; the browser
  auto-attach is the confused deputy; MarkM's terminology note on naming a
  secret-bearing URL.
- `cap-talk-2009-2012--hashcode-collisions-and-the-weakest-link` (Feb) - Waterken
  ETags on SHA-256; Wagner "crypto vastly exceeds our ability to build secure
  software"; Lloyd's fragility-not-probability lens.
- `cap-talk-2009-2012--web-powerbox-and-oauth` (Feb) - Seaborn/Varda/Close/Miller
  Web Powerbox design and why it beats OAuth on clickjacking, phishing, XSRF,
  asynchrony.
- `cap-talk-2009-2012--object-oriented-security-naming` (Mar) - Varda's rebrand
  proposal, Reid's too-generic / term-proliferation / running-code pushback.
- `cap-talk-2009-2012--mutable-singletons-are-ambient-authority` (Mar) - only
  mutable globally-accessible singletons are ambient authority (the frozen-
  primordials principle); Barbour's unum alternative.
- `cap-talk-2009-2012--safe-language-defined-and-ocap` (Apr) - Pierce's TAPL
  definition; the ocap-as-hyponym-of-safe-language dispute (Kosik vs Samuel).
- `cap-talk-2009-2012--three-laws-of-security` (Apr) - MarkM's Asimov-styled
  Integrity > Availability > Confidentiality; Barbour's ordering challenge.
- `cap-talk-2009-2012--acl-model-incomplete-owner-admin` (Apr) - Karp: ACLs cannot
  express changing an ACL; HRU 1976 as the citable reference.

## Topic/concept tables
- Topic Sections rows added: capability-security (x5), capability-theory (x4),
  programming-language-design (x2), hardened-javascript (x2), oauth-credentials
  (x1), identity (x1).
- Concept Sections rows added: ambient-authority (x3), confused-deputy,
  capabilities-vs-acls, web-key (x2), powerbox, object-capability (x2),
  oauth-client-credentials-vs-authorization-code, content-address-versus-signature.
- keywords.md: added "object-oriented security -> object-capability" and
  "web powerbox -> powerbox" pointers.

## Open questions (4 new)
Appended 50 (what to call a URL-borne secret and the discipline itself),
51 (should confidentiality outrank availability in the Three Laws),
52 (are ocap languages a subset of safe languages or only an overlap),
53 (can benign singletons be permitted or must all be forbidden).

## Project cross-links
`projects/endo/cap-talk-capability-provenance.md`: new "The 2010 web-platform arc"
section (cookies, powerbox, singletons, safe-language, Three Laws, naming) with the
8 section links; updated the closing job list.

## Indexes
`sections/README.md` (all 8 new sections present) and `topics/README.md` counts
regenerated as the final landing step (both idempotent lands; capability-security
503 -> 508). `sources/README.md` row updated (count 22 -> 30, status text).

## Integrity gate
- `library-link-check.sh --library <staging> --changed`: OK (every checked link
  resolves to a committed file).
- `regenerate-topics-counts.sh --check`: reported stale counts (expected from the
  added rows), no missing topic page; reconciled and landed in step 9.

## 2012-October retry
Retried per the ask (fifth attempt). Failed again: the Internet Archive was in a
live "Temporarily Offline" window (429 on the availability API, empty CDX, 404 on
the `2id_` redirect form). Left unanchored and re-scoped to the successor with a
note to probe the CDX for capture existence when IA is stable.

## Follow-on
Posted `scholar-ingest-cap-talk-2011-2012`: section the 2010 lighter-month
standouts (Capsicum, Horton, sensory objects, browser powerbox impl, CCN, Android
caps, Fabric), then fetch/anchor/section 2011 and 2012 oldest-first (2011-Apr-Jul
already anchored), retry 2012-October. Next open-question number 54.

## Deferred
2010 lighter months (May-Dec) sectioning, all of 2011-2012, and the post-2016
Google Groups era (not fetchable from the sandbox).
