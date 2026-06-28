---
title: Two years of pilot experience and residual limits (2005-2006)
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
topics: [capability-security]
status: current
---

## Abstract

Where the 2004 report described a pre-Alpha/Alpha prototype, the 2006 CACM revision
reports a system with **two years of real-world pilot use**. This is the revision's
empirical content: who ran Polaris, what it caught, what still broke, and which
attacks remained unblocked as of mid-2006. The headline is qualitative but real —
several pilot users were *saved from harm* when viruses ran inside polarized
applications, and polarized-browser users found little or no spyware on their
machines. The residual-limits list is updated from 2004: the GUI hole is now closed
(covered separately), but network exfiltration, Direct3D/games, PGP, Cygwin, and
linked files remain open problems.

## The pilot deployment

- **Alpha, since June 2005.** "15 people in Hewlett-Packard Labs, 10 at other
  Hewlett-Packard locations, and some not associated with Hewlett-Packard" ran the
  alpha. "For the most part they are unaware of its presence. In fact, one executive
  used Polaris with no problems for several days before we told him what we'd done to
  his machine."
- **Beta, released June 2006**, still available at press time. Four new HP Labs users
  were added with the beta rollout, with a plan to add 10–20 more after resolving the
  group's issues.
- **Outside pilots.** Studies at the **School of Public Policy, George Mason
  University** (Fairfax, VA) and at the **U.S. Navy** (responsible for the DoD
  Horizontal Fusion Project, Monterey, CA), with plans to expand outside testing.
- **HP had no plans to turn Polaris into a product** at press time.

## What it caught

The article's evidence is observational rather than benchmarked: "A number of users at
Hewlett-Packard in the pilot study we have been running since 2005 who have visited
Web pages containing viruses can attest to the protection provided by Polaris. Any
damage these users have reported is limited to the pet account." And: "Several of
these early users have been saved from harm when viruses ran in polarized
applications. Users who consistently surf with a polarized browser report finding
little or no spyware or adware on their machines." The mechanism behind the claim is
the restricted account: a virus running in a Pet can damage only the file being edited
and the pet account's own slice of the registry; it cannot touch the user's startup
folder, read other files for secrets, or plant spyware outside the restricted
account, and any registry changes it makes "are easily undone by polarizing the
application again."

## Residual limits as of 2006

The revision is candid about what still does not work — a shorter list than 2004
because the GUI hole moved to the "solved" column:

- **Network exfiltration — still open.** "The beta version does nothing about limiting
  network access, meaning that a virus could send the contents of the document being
  edited to a competitor. We believe we have identified a possible solution to this
  problem by using a custom firewall." (Same residual as 2004, same proposed
  direction.)
- **Incompatible software.** "Direct 3D is incompatible with the security machinery
  inside Polaris. Hence, many games don't work if polarized. PGP won't run polarized.
  And some operations of the Cygwin command shell modify access control lists in a
  manner that is incompatible with Polaris."
- **Linked files.** "The beta version does not handle linked files (such as
  spreadsheets containing references to other spreadsheets) very well." The team
  reports having solutions that did not make the beta.
- **GUI hole — now CLOSED** (the one item that left this list since 2004; see the
  GUI-hole section).

## Why this matters for the library

The pilot record is the closest thing the ocap-history corpus has to *field evidence*
that POLA-per-application meaningfully reduces virus harm on a commodity ambient-
authority OS — not a proof, but lived deployment over two years with reported saves.
It is the empirical anchor under the market-history survey's narrative that Polaris
was a *technical success* even though it never shipped as a product (the survey's
"technical success, adoption failure" pattern). For an Endo reader it is a reminder
that the value of least-authority is measured in the blast radius of the breach that
does happen, not only in the breaches prevented.

## See also

- [[polaris]] — the system.
- [ocap-history--e-capdesk-polaris-market-history--the-pattern-technical-success-adoption-failure](../sections/ocap-history--e-capdesk-polaris-market-history--the-pattern-technical-success-adoption-failure.md) — the survey's "technical success, adoption failure" framing this pilot record sits under.
- `papers--stiegler-polaris-virus-safe-computing-2004` — the 2004 report's status/limits section, which this updates.

Source: [Polaris: Virus-Safe Computing for Windows XP](https://cacm.acm.org/research/polaris-2/), *Communications of the ACM* 49(9):83–88, Sept. 2006, DOI [10.1145/1151030.1151033](https://doi.org/10.1145/1151030.1151033). Content SHA-256 `373d4eef…e974b78e` over the Internet-Archive `id_` capture of the CACM page.
