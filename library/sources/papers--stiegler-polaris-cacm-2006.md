---
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Tyler Close, Mark S. Miller]
source_title: "Polaris: Virus-Safe Computing for Windows XP"
source_year: 2006
source_venue: "Communications of the ACM, Vol. 49, No. 9 (September 2006), pp. 83-88"
source_url: https://cacm.acm.org/research/polaris-2/
source_doi: 10.1145/1151030.1151033
source_content_sha256: 373d4eef7bd0a33242ef3b53ed4c1d4bc2a42a10f8f9ac4f8cdb2921e974b78e
source_fetched_via: wayback
source_wayback_timestamp: 20251016191707
source_snapshot: http://web.archive.org/web/20251016191707id_/https://cacm.acm.org/research/polaris-2/
source_bytes: 153271
ingested: 2026-06-28
ingested_by: scholar
section_count: 4
status: current
notes: |
  The published CACM revision of the 2004 HP Labs report HPL-2004-221
  (`papers--stiegler-polaris-virus-safe-computing-2004`). This ingest deliberately
  covers only what the 2006 article ADDS over the 2004 report — the fifth author
  (Tyler Close), two years of pilot experience, the now-closed GUI hole, and the
  Vista/UAP comparison — rather than re-transcribing the shared mechanism.

  IDEMPOTENCY ANCHOR is `source_content_sha256`, NOT `source_pdf_sha256`: there is no
  reachable PDF for this article. The ACM Digital Library copy (DOI
  10.1145/1151030.1151033) is paywalled, the HP Labs site has no PDF for the CACM
  revision, and Alan Karp's mirror was not needed because the CACM research page
  carries the full article text. The bytes hashed are the **HTML** of the CACM page
  `https://cacm.acm.org/research/polaris-2/`, fetched via the Internet Archive
  original-bytes (`id_`) capture at Wayback timestamp 20251016191707 because a direct
  fetch of cacm.acm.org returned HTTP 403 from the bot sandbox
  (`scripts/jobs/fetch-source.sh`). The full body — Introduction, Polarizing
  Applications, How It Works, Conclusion, References, and both sidebars (Viruses and
  Worms; Privilege, Permission, and Authority) — was present and was verified against
  the venue/author line (CACM 49(9):83-88, Sept 1 2006, five authors incl. Tyler
  Close, DOI 10.1145/1151030.1151033) before ingest.
---

The September 2006 *Communications of the ACM* article is the published, peer-facing
revision of the team's December 2004 HP Labs technical report on **Polaris**, the
package that retrofits the **Principle of Least Authority** onto unmodified Windows XP
by changing only how applications are *launched*. The core design — designation
treated as authorization, the PowerBox file-broker, the per-application installation
endowment, and **Pets** running in restricted Windows user accounts — is carried over
unchanged from the 2004 report (and from CapDesk before it), so this source index and
its section files isolate what the CACM revision *adds*: a fifth author (Tyler Close),
two years of accumulated alpha/beta pilot experience with reported real-world virus
saves, the **closing of the GUI hole** (the one residual attack the 2004 report left
open, blocked in the beta via the *Shatter-proofing Windows* Windows-API technique),
and a comparison against Windows Vista's User Account Protection (which protects
system resources but does little to protect user data). For the shared mechanism, see
the 2004 ingest `papers--stiegler-polaris-virus-safe-computing-2004`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [what-the-2006-cacm-revision-adds](../sections/papers--stiegler-polaris-cacm-2006--what-the-2006-cacm-revision-adds.md) | capability-security, capability-theory | current |
| [closing-the-gui-hole-shatter-proofing-windows](../sections/papers--stiegler-polaris-cacm-2006--closing-the-gui-hole-shatter-proofing-windows.md) | capability-security | current |
| [two-years-of-pilot-experience-and-residual-limits](../sections/papers--stiegler-polaris-cacm-2006--two-years-of-pilot-experience-and-residual-limits.md) | capability-security | current |
| [privilege-permission-and-authority](../sections/papers--stiegler-polaris-cacm-2006--privilege-permission-and-authority.md) | capability-security, capability-theory | current |

## See also

- [papers--stiegler-polaris-virus-safe-computing-2004](papers--stiegler-polaris-virus-safe-computing-2004.md) — the 2004 HPL-2004-221 report this revises; the shared mechanism (designation=authorization, PowerBox, installation endowment, Pets, copy+synchronizer, visual cues) lives there and is **not** re-transcribed here.
- [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md) — the market-history survey that places Polaris in the first wave of working object-capability systems; this article is a primary source behind that survey's Polaris narrative.
- [papers--miller-shapiro-paradigm-regained-2003](papers--miller-shapiro-paradigm-regained-2003.md) — source of the permission-vs-authority distinction the 2006 article packages as a sidebar.

## Provenance

- Ingested by a gardener wearing the scholar role on 2026-06-28, completing job `scholar-ingest-source-polaris-cacm-2006` (the second of the Polaris pair; the first was `papers--stiegler-polaris-virus-safe-computing-2004`, HPL-2004-221).
- The posting job's report numbers `HPL-2004-116` and `HPL-2006-116` were **both wrong** for "the second Polaris": `HPL-2004-116` is an unrelated HP Labs Bristol café-game paper, and `HPL-2006-116` is *How Emily Tamed the Caml* (Stiegler & Miller, a separate ingest candidate). The genuine "second Polaris" is this 2006 CACM article, confirmed against its venue/author line before ingest.
- Source bytes: HTML of the CACM research page, content SHA-256 `373d4eef7bd0a33242ef3b53ed4c1d4bc2a42a10f8f9ac4f8cdb2921e974b78e` (153,271 bytes), fetched via the Internet-Archive `id_` capture `http://web.archive.org/web/20251016191707id_/https://cacm.acm.org/research/polaris-2/` (cacm.acm.org returned HTTP 403 to a direct fetch).
