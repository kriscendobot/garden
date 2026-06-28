---
title: "How Polaris works: restricted accounts, RunAs, status, and remaining attacks"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark Miller]
source_year: 2004
source_venue: HP Laboratories Palo Alto Technical Report HPL-2004-221
source_url: http://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
source_fetched_via: wayback
source_wayback_timestamp: 20220423221140
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security]
status: superseded
superseded_by: papers--stiegler-polaris-virus-safe-computing-2004--polarizing-applications-pets-restricted-accounts-and-visual-cues
superseded_on: 2026-06-28
superseded_reason: |
  Duplicate ingest of the same report. The 2004 HP Labs report HPL-2004-221 was
  ingested twice by two gardeners racing the same cycle, under two source slugs with
  the identical source_pdf_sha256 6c95faf19fef (9 pages, four authors). The canonical
  cluster is papers--stiegler-polaris-virus-safe-computing-2004, cross-referenced by
  the concepts/polaris.md and concepts/powerbox.md concept pages. The restricted-
  account / RunAs / copy+synchronizer mechanism is covered by the canonical
  polarizing-applications section; the pilot status and residual network/GUI-hole
  attacks by the canonical status-limits-and-residual-attacks section. Kept, not
  deleted: the journal is append-only.
---

## Abstract

Polaris's implementation, deployment status, and honest accounting of what it does *not* yet defend. It changes neither the OS nor the applications — only how applications are launched: a polarized application runs in a restricted Windows user account via a `RunAs` variant, with the document copied into the account and a synchronizer keeping copy and original consistent. The paper explains why copy-plus-synchronize beats editing in place (temporary files; and the authority-vs-permission distinction that lets authority be revoked when the synchronizer stops), reports pilot deployment at HP Labs and elsewhere, and frankly lists unsolved attacks — notably the Windows "GUI hole".

## Content

**Mechanism.** "Polaris doesn't change the operating system or the applications; all that changes is the way applications are launched. Instead of starting the application in the logged in user's account, a polarized application is launched in a restricted user account that has very few permissions. This procedure uses the operating system's security mechanisms to limit what the software, including any viruses it contains, can do." In steps: Polaris copies the file to a folder accessible to the restricted account, sets up a synchronizer to keep the copy and the original consistent, and launches the application under the restricted account "using a variant of the Windows RunAs command."

"If a virus runs in the restricted account, the only thing it can damage is the file it's in. It has no ability to modify the user's startup folder, nor can it read other files looking for secrets. If the browser has been polarized, malicious scripts can't plant executable spyware and adware … A number of users in our pilot study who have visited web pages containing viruses can attest to this last claim."

**Why not edit in place.** Two reasons. First, many applications (e.g. Microsoft Word) create temporary files in the document's directory, which would force granting read/write to the whole directory and greatly increase what a virus could damage. Second, "the difference between permission and authority" (see the [permission/privilege/authority sidebar](papers--stiegler-karp-yee-miller-polaris-2004--permission-privilege-and-authority.md)): the restricted account "has the authority to effect changes to the original file, but it never gets permission. The advantage is that the authority is revoked when the synchronizer is stopped, for example when the machine crashes. By properly distinguishing authority from permission, Polaris doesn't leave any dangling permissions to be cleaned up later."

**Status.** The pre-Alpha version had been used by about 20 people at HP Labs, some for six months or more, mostly unaware of its presence — "one executive used Polaris with no problems for several days before we had a chance to tell him what we'd done to his machine." The Alpha release was under controlled roll-out, with pilots at the School of Public Policy at George Mason University and a US Navy group.

**Future work and unsolved attacks (stated candidly).** Launching applications is "somewhat slow"; linked files (e.g. cross-referencing spreadsheets) are handled poorly; Java applications shut down after a brief period; Direct 3D is incompatible with Polaris's security machinery, so "over half of all game software is incompatible"; PGP won't run polarized; and parts of the Cygwin shell modify ACLs incompatibly. Unblocked attacks: the current release "does nothing about limiting network access", so a virus could exfiltrate the document being edited (a Beta solution was planned). The hardest is the **GUI hole**: "Due to a fundamental design flaw in Windows, any application can read GUI events sent to any window on the screen" (exploited by keyboard sniffers) and "send GUI events to any window", so a virus "could send requests for additional authorities to the PowerBox, and select any file on the system." The authors note wryly that if Polaris is adopted widely enough that virus writers attack the PowerBox, "we'll have achieved our goal of making the world far safer from viruses than it is today."

**Summary.** "By applying the Principle of Least Authority to individual programs, Polaris provides effective protection against viruses while simultaneously improving usability and functionality … Parts of the system that viruses attack, such as the Windows directory, the user's startup folder, and most of the Windows registry, are safe."

Source: Polaris: Virus Safe Computing for Windows XP, HP Laboratories technical report HPL-2004-221 (December 2004); PDF fetched via the Internet Archive original-bytes capture (`source_fetched_via=wayback`, [web/20220423221140id_/](http://web.archive.org/web/20220423221140id_/http://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf)), PDF SHA-256 `6c95faf1`.
