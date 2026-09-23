---
title: What the 2006 CACM revision adds over the 2004 report
source: "Polaris: Virus-Safe Computing for Windows XP"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Tyler Close, Mark S. Miller]
source_year: 2006
source_venue: "Communications of the ACM, Vol. 49, No. 9 (September 2006), pp. 83-88"
source_url: https://cacm.acm.org/research/polaris-2/
source_doi: 10.1145/1151030.1151033
source_content_sha256: 373d4eef7bd0a33242ef3b53ed4c1d4bc2a42a10f8f9ac4f8cdb2921e974b78e
source_fetched_via: wayback
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
---

## Abstract

The September 2006 *Communications of the ACM* article is the published, peer-facing
revision of the team's 2004 HP Labs technical report (HPL-2004-221). The Polaris
design it describes is unchanged in its core — designation-as-authorization, the
PowerBox, the installation endowment, and Pets running in restricted Windows accounts
are all carried over verbatim from the 2004 report and from CapDesk before it — so
this section does **not** re-transcribe that shared mechanism (see the 2004 ingest
`papers--stiegler-polaris-virus-safe-computing-2004` for it). Instead it isolates the
four things the CACM revision *adds*: a fifth author, two years of accumulated pilot
experience, a now-**closed GUI hole**, and a head-to-head comparison against the
about-to-ship Windows Vista. Read this section to learn what changed between the two
Polaris papers; read the sibling sections for the new material in depth.

## The four deltas

**1. A fifth author — Tyler Close.** The 2004 report had four authors (Marc Stiegler,
Alan H. Karp, Ka-Ping Yee, Mark S. Miller). The 2006 article adds **Tyler Close**, a
research scientist in HP Labs' Mobile and Media Systems Laboratory. His addition is
not cosmetic: the single largest new technical result in the revision — closing the
GUI hole — rests on the Windows-API technique from Close, Stiegler, and Karp's Black
Hat USA 2005 talk *Shatter-proofing Windows* (reference [1] of the CACM article).
Close is the same researcher behind Waterken / web-keys and the later *ACLs don't*
argument; his ocap work recurs across this corpus.

**2. Two years of pilot experience (2005–2006).** The 2004 report described a
pre-Alpha/Alpha system. The 2006 article reports a real deployment: an **alpha** in
use since **June 2005** (15 people at HP Labs, 10 at other HP locations, plus some
outside HP), a **beta released June 2006** and still available, and outside pilot
studies at the **School of Public Policy at George Mason University** and the **U.S.
Navy** (responsible for the DoD Horizontal Fusion Project, Monterey, CA). Several
early users were *saved from harm* when viruses ran inside polarized applications, and
users who browsed with a polarized browser reported finding little or no spyware /
adware. One executive ran Polaris for several days without noticing it. (Full account
in the pilot-experience section.)

**3. The GUI hole is now closed.** In 2004 the GUI hole — Windows lets any
application inject GUI events into any window, so a virus could drive the PowerBox —
was an *unblocked residual attack*, framed wryly ("if virus authors are reduced to
attacking the PowerBox, Polaris has already won"). The 2006 **beta closes it**, using
a Windows-API feature identified in the *Shatter-proofing Windows* work, at the cost
of some workarounds (e.g. polarized apps can cut-and-paste bitmaps but not text). This
is the headline new technical content; the GUI-hole section covers it.

**4. A comparison against Windows Vista / User Account Protection.** The 2004 report
predated Vista's details. The 2006 article (Vista was scheduled for early 2007) adds
a critique of Vista's **User Account Protection (UAP)**: developer guidelines plus
registry/filesystem virtualization let users work without administrator privileges,
which protects *system* resources — but does *little to protect user data*. The
article observes that identity thieves aren't after system files, and that ransomware
encrypts user data while demanding payment for the key. POLA-per-application protects
the user data that UAP leaves exposed.

What is **unchanged** and therefore not re-covered here: the excess-authority framing
of the virus problem, the permission-vs-authority distinction (re-stated in 2006 as a
sidebar — see the privilege/permission/authority section), the three CapDesk-derived
mechanisms, the copy-plus-synchronizer rationale for not editing ACLs in place, the
petname visual cues, and the still-unblocked network-exfiltration attack (the article
proposes a custom firewall as a possible fix, as the 2004 report also gestured at).

## See also

- [[polaris]] — the concept page; both the 2004 report and this 2006 revision are filed under it.
- `papers--stiegler-polaris-virus-safe-computing-2004` — the 2004 HPL report this revises; the shared mechanism lives there.
- [[principle-of-least-authority]] — the discipline Polaris retrofits onto Windows XP.

Source: [Polaris: Virus-Safe Computing for Windows XP](https://cacm.acm.org/research/polaris-2/), *Communications of the ACM* 49(9):83–88, Sept. 2006, DOI [10.1145/1151030.1151033](https://doi.org/10.1145/1151030.1151033). Content SHA-256 `373d4eef…e974b78e` over the Internet-Archive `id_` capture of the CACM page.
