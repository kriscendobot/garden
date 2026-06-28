---
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark Miller]
source_title: "Polaris: Virus Safe Computing for Windows XP"
source_year: 2004
source_venue: HP Laboratories Palo Alto Technical Report HPL-2004-221
source_url: http://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_url: http://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf
source_fetched_via: wayback
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
source_wayback_url: http://web.archive.org/web/20220423221140id_/http://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf
source_wayback_timestamp: 20220423221140
source_pdf_pages: 9
ingested: 2026-06-28
ingested_by: scholar
section_count: 4
status: current
notes: |
  The Polaris primary. The CapDesk/Polaris recon for this ingest established that
  Polaris is not on the erights.github.io mirror and not linked from combex.com's
  CapDesk index; its primary documentation is the HP Labs technical report
  HPL-2004-221, reachable through the Internet Archive original-bytes PDF capture
  (source_fetched_via=wayback). Polaris carries CapDesk's installation endowment,
  PowerBox, and designation-as-authorization (citing combex--edesk as ref [7]) to
  unmodified Windows XP via restricted user accounts and RunAs.
---

## Abstract

"Polaris: Virus Safe Computing for Windows XP" (HP Laboratories technical report HPL-2004-221, December 2004) by Marc Stiegler, Alan H. Karp, Ka-Ping Yee, and Mark Miller. Polaris is the Windows-XP descendant of CapDesk: a package that lets users configure applications to launch "polarized" — in a restricted user account with only the authority needed for the job — so that viruses running inside them can do little harm, while making nearly all security decisions disappear into ordinary use (double-clicking a file is treated as both designation *and* authorization, and a PowerBox replaces the File Open dialog to grant exactly the selected file). It runs on stock Windows XP without modifying the OS or the applications, using restricted accounts plus a variant of `RunAs`, and demonstrates that a system can be simultaneously more secure, more functional, and easier to use by applying the Principle of Least Authority to individual programs. The paper is the Polaris primary the library's secondary-source survey synthesizes around.

This is the canonical Polaris citation: the descendant of CapDesk's PowerBox / installation-endowment / designation-as-authorization ideas (citing [E and CapDesk](combex--edesk.md) as reference [7]) ported to an unmodified mainstream operating system. It carries two conceptual sidebars the library should index: the **virus / worm** distinction and the **privilege / permission / authority** distinction (the latter the same distinction the [Paradigm Regained](papers--miller-shapiro-paradigm-regained-2003.md) and [Structure of Authority](papers--miller-tulloh-shapiro-structure-of-authority-2004.md) papers formalize).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [abstract-and-the-excess-authority-problem](../sections/papers--stiegler-karp-yee-miller-polaris-2004--abstract-and-the-excess-authority-problem.md) | capability-theory, capability-security | current |
| [using-and-polarizing-an-application](../sections/papers--stiegler-karp-yee-miller-polaris-2004--using-and-polarizing-an-application.md) | capability-security | current |
| [how-polaris-works](../sections/papers--stiegler-karp-yee-miller-polaris-2004--how-polaris-works.md) | capability-security | current |
| [permission-privilege-and-authority](../sections/papers--stiegler-karp-yee-miller-polaris-2004--permission-privilege-and-authority.md) | capability-theory | current |

## See also

- [combex--edesk](combex--edesk.md) — "E and CapDesk", cited by this paper (reference [7]) as the source of the installation endowment, the PowerBox, and combining designation with authorization.
- [papers--miller-shapiro-paradigm-regained-2003](papers--miller-shapiro-paradigm-regained-2003.md) and [papers--miller-tulloh-shapiro-structure-of-authority-2004](papers--miller-tulloh-shapiro-structure-of-authority-2004.md) — the formal treatments of the permission-vs-authority distinction Polaris's sidebar uses.
- [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md) — the secondary-source market-history survey that names Polaris as a worked example; this paper is its primary source.
