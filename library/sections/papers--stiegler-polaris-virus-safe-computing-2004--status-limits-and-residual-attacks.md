---
title: "Status, limits, and residual attacks: network exfiltration and the Windows GUI hole"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark S. Miller]
source_year: 2004
source_venue: "HP Laboratories Technical Report HPL-2004-221"
source_url: https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security]
status: current
---

## Abstract

The report's candid self-assessment of a pre-Alpha/Alpha system. **Status:** ~20 HP
Labs users (some for six months), an Alpha controlled roll-out adding pilots at George
Mason University's School of Public Policy and a US Navy group; most users were unaware
of Polaris's presence (one executive ran it for days before being told). **Known
limits:** slow launch, poor handling of linked files, Java apps shutting down, and hard
incompatibilities — Direct3D (and thus over half of all games), PGP, and some Cygwin
operations that modify ACLs. **Residual attacks not yet blocked:** network access is
unrestricted (a virus could exfiltrate the document being edited), and the **GUI hole**
— a fundamental Windows design flaw letting any application read and inject GUI events
to any window, so a virus could drive the PowerBox to grant itself authority over any
file. The report's closing wry note: if virus writers are reduced to attacking the
PowerBox, Polaris has already made the world far safer.

## Body

**Status.** The pre-Alpha had been used by about 20 people at HP Labs, some for six
months or more, with significant shortcomings (most notably when adding authority to a
running program) yet largely invisible in daily use — "one executive used Polaris with
no problems for several days before we had a chance to tell him what we'd done to his
machine." The Alpha was on a controlled roll-out: more HP Labs users plus pilots at the
School of Public Policy at George Mason University and in a US Navy group, with test
sites deliberately limited for the time being.

**Known limits and incompatibilities.** Launching applications is "somewhat slow."
Linked files (e.g. spreadsheets referencing other spreadsheets) are not handled well.
Java applications shut down after a brief period under Polaris. These the team expected
to fix in Beta. Some problems they did not know how to solve: **Direct3D** is
incompatible with Polaris's security machinery, making "over half of all game software"
incompatible; **PGP** will not run polarized; and some **Cygwin** shell operations
modify ACLs in a way Polaris cannot accommodate.

**Residual attacks.** Two unblocked attack classes. (1) **Network exfiltration:** the
release does nothing to limit network access, so a virus could send the document being
edited to a competitor — the team had a planned Beta solution. (2) **The GUI hole:** a
fundamental Windows design flaw lets *any* application read GUI events sent to *any*
window (the basis of keyboard sniffers) and send GUI events to any window. A virus
could therefore drive the **PowerBox** — sending it synthetic events to select any file
on the system and thereby grant itself authority the user never intended. The report
has no fix, but frames it as a victory condition: "if Polaris gets adopted widely enough
that virus writers are attacking the PowerBox, we'll have achieved our goal of making
the world far safer from viruses than it is today."

**Summary claim.** By applying POLA to individual programs, Polaris protects against
viruses while *improving* usability and functionality: virus-attacked regions (the
Windows directory, the startup folder, most of the registry) become safe, so users can
finally use macro languages, email programs to each other, and web scripting "all
without opening up our systems to attack."

## See also

- [[principle-of-least-authority]] — the discipline whose limits this section maps.
- [[powerbox]] — the broker the GUI hole lets a virus drive.
- [[confused-deputy]] — the GUI-hole attack is a confused-deputy against the PowerBox.
- [ocap-history--e-capdesk-polaris](../sources/ocap-history--e-capdesk-polaris.md) — the adoption-failure narrative this status section is primary evidence for.

## Common confusions

- **"Polaris stops all viruses."** No. It contains what a virus can damage to the one
  document, but the 2004 release leaves network exfiltration and the GUI hole open —
  the report says so explicitly. The claim is *least authority bounds the blast radius*,
  not *immunity*.
- **"The GUI hole is a Polaris bug."** It is a Windows platform flaw (any app can
  read/inject GUI events to any window) that Polaris inherits; it is the structural
  limit of retrofitting POLA onto an OS you are not allowed to change.

Source: [Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)](https://www.hpl.hp.com/techreports/2004/HPL-2004-221.html), "Status," "Future Work," and "Summary." PDF SHA-256 `6c95faf1…`.
