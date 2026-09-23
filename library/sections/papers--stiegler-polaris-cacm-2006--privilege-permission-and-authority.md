---
title: Privilege, permission, and authority (sidebar)
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

The 2006 CACM revision packages the **permission-vs-authority distinction** — present
as prose in the 2004 report — into a standalone sidebar, *Privilege, Permission, and
Authority*. The distinction is the conceptual hinge of the whole Polaris design and is
drawn directly from Miller & Shapiro's *Paradigm Regained* (cited in the sidebar). It
is worth its own section because the same distinction recurs throughout capability
theory and is exactly the distinction Endo invokes when it argues that a capability
bound into a bundle is *authority* the holder can wield, not merely a *permission*
recorded somewhere.

## The distinction

The security community cites the **Principle of Least Privilege**, "though exactly
what constitutes a privilege isn't clear, even to these experts." Miller & Shapiro's
clarification introduces two sharper terms:

- **Permission** — "the set of rules written down in, say, an access control list."
  Permission is *static and local*: an ACL entry either exists or it doesn't.
- **Authority** — "the set of consequences a process can cause to happen." Authority
  "combines the set of permissions with the behavior of parties having these
  permissions." Authority is *dynamic and transitive*: it follows what a process can
  actually bring about, directly or by inducing other processes to act.

## The web-server example

The sidebar's worked example: a Web server process "has permission to read the files
of the Web site; there is a specific entry in the ACL for each file. Someone visiting
the Web site has no entry in the ACL but still can read the contents of the file
because the server presents the information. Hence, the Web surfer has authority to
read the files, even though no explicit permission grants such access." Permission and
authority come apart: the surfer has *authority* without *permission*.

The consequence the sidebar draws: "Security analysis that considers only permission
is incomplete. Security analysis that includes authority is necessarily constrained by
the ability to understand the behavior of programs. Fortunately, it is often possible
to get a usable bound on the authority available to any process." Bounding *authority*
(not merely auditing permissions) is the right goal; capability discipline makes that
bound tractable because authority travels only along references that are themselves
authority.

This is the distinction that justifies one of Polaris's central engineering choices —
*copy-plus-synchronizer instead of editing the ACL in place* (covered in the 2004
ingest's mechanism section): the restricted account is given the *authority* to change
the original file (the synchronizer copies updates back using its own permission) but
never the *permission* to change it directly, so the authority is revoked simply by
stopping the synchronizer — no dangling permissions to clean up after a crash.

## Translation (paper idiom → Endo)

| Sidebar term | Endo / ocap equivalent |
|---|---|
| permission (ACL entry) | the static access-control record; *not* how Endo grants access — Endo grants by reference, not by recording an entry in a table |
| authority (set of consequences) | what holding a capability (a reference to a Far object / a hardened powers object) actually lets you cause; the quantity Endo's least-authority discipline minimizes |
| "bound on the authority available to a process" | the reachable-authority bound a capability graph makes analyzable: a subject can only affect what it can name |
| Web-server-grants-the-surfer-authority | the confused-deputy / transitive-authority shape: authority flows through the behavior of intermediaries, which is why Endo passes capability *handles*, not ambient names |

## See also

- [[principle-of-least-authority]] — POLA is stated over *authority*, precisely because of this distinction.
- `papers--miller-shapiro-paradigm-regained-2003` — the source of the permission-vs-authority clarification the sidebar cites.
- [[powerbox]] — the PowerBox grants narrow *authority* (one designated file) without widening *permission*.
- [[polaris]] — the system whose copy+synchronizer choice this distinction justifies.

Source: [Polaris: Virus-Safe Computing for Windows XP](https://cacm.acm.org/research/polaris-2/), *Communications of the ACM* 49(9):83–88, Sept. 2006, DOI [10.1145/1151030.1151033](https://doi.org/10.1145/1151030.1151033). Content SHA-256 `373d4eef…e974b78e` over the Internet-Archive `id_` capture of the CACM page. The sidebar text quoted here is from the *Privilege, Permission, and Authority* sidebar (the article also carries a *Viruses and Worms* sidebar with virus/worm definitions, not transcribed).
