---
title: Closing the GUI hole — shatter-proofing Windows
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

The headline new result of the 2006 CACM revision is that the Polaris **beta closed
the GUI hole** — the one residual attack the 2004 report had to leave open. The GUI
hole is Windows' policy that *any* application may send GUI (window) messages to *any*
window on the desktop, letting the receiving process be tricked into executing
commands with **its own** privileges rather than the sender's. Against Polaris this is
fatal in principle: a virus in a low-authority restricted account could send messages
that drive the high-authority PowerBox (or any privileged window) and so escape its
sandbox. The beta blocks this class of attack with a Windows-API feature surfaced by
Close, Stiegler, and Karp's *Shatter-proofing Windows* work, accepting some
workarounds as the price. This is why the 2006 paper can claim Polaris contains
viruses where the 2004 paper could only hope to.

## The attack

Windows allows any application to send GUI events to any window on the desktop. Those
messages "can be used by the receiving application to run commands with the privileges
of the receiving process instead of the privileges of the process sending the
message." Worse, such messages "can even be used to exploit flaws in system services
to gain full control over the machine" (CACM reference [7], Paget, *Click Next to
Continue*, Black Hat 2003). This is the family of attacks known as **Shatter
attacks**: a low-privilege process synthesizes window messages to a higher-privilege
window and rides its authority.

Why it matters for Polaris specifically: Polaris's whole safety argument is that a
polarized application (and any virus inside it) runs in a **restricted user account**
holding only an installation endowment plus the one designated file. The GUI hole
would let that confined process reach *out* of its account by puppeting a privileged
window — most dangerously the **PowerBox**, the trusted broker that holds access to
*all* the user's files. The 2004 report conceded this openly and consoled itself that
an attacker reduced to attacking the PowerBox had already lost most of its leverage.

## The fix and its cost

The beta release "closed the GUI hole." The team "found a feature of the Windows API
that lets Polaris block such attacks" (CACM reference [1] — Close, Stiegler, Karp,
*Shatter-proofing Windows*, Black Hat USA 2005). The fix is not free: "using it
exposes some bugs in Windows that need workarounds. For example, users of polarized
applications can cut and paste bitmaps but not text when using this feature." The team
implemented workarounds for that and for other problems encountered.

The significance for this corpus: closing the GUI hole moves Polaris from "POLA that
mostly works on Windows" to "POLA that contains the in-process adversary on Windows."
It is the difference between a sandbox with a known escape and one without. The
lesson — that an ambient message-passing channel (here, Win32 window messages) can
silently re-confer authority a capability discipline tried to withhold — is the same
hazard a capability runtime watches for in any host with broadcast-style IPC, shared
clipboards, or untamed event buses.

## See also

- [[powerbox]] — the trusted file-broker the GUI-hole attack targets; closing the hole is what makes the PowerBox trustworthy on Windows.
- [[polaris]] — the system.
- `papers--stiegler-polaris-virus-safe-computing-2004` — the 2004 report, where the GUI hole was still an open residual attack.

Source: [Polaris: Virus-Safe Computing for Windows XP](https://cacm.acm.org/research/polaris-2/), *Communications of the ACM* 49(9):83–88, Sept. 2006, DOI [10.1145/1151030.1151033](https://doi.org/10.1145/1151030.1151033). Content SHA-256 `373d4eef…e974b78e` over the Internet-Archive `id_` capture of the CACM page.
