---
title: "Capsicum: practical capabilities for UNIX (USENIX Security 2010 announcement)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-August/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-August.txt.gz
source_content_sha256: 46aebf6e6a3ad99a8057b846c15b9326ec2c1eff13be42b5464bf1fe127a5e13
source_authors: [lists at notatla.org.uk, John Carlson, Robert N. M. Watson (quoted)]
source_date: 2010-08-12
thread_subject: "Capsicum: practical capabilities for UNIX"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, sandbox-platforms]
status: current
notes: |
  Derived summary. A light four-message August thread whose substance is the
  announcement it forwards; the paper itself (Watson, Anderson, Laurie,
  Kennaway, USENIX Security 2010) is the primary artifact, not the list
  discussion, which is a pointer plus a "what about the desktop?" question.
---

Abstract: On August 12, 2010 the list carried the announcement — forwarded from Robert Watson's Light Blue Touchpaper post — that Watson, Jonathan Anderson, Ben Laurie, and Kris Kennaway had that day presented *Capsicum: practical capabilities for UNIX* at the 19th USENIX Security Symposium. The announcement's one-line thesis is the reason the paper matters to this list: "capability design principles fill a gap" left by conventional UNIX access control. Capsicum is a *hybrid* capability model retrofitted onto a commodity operating system (FreeBSD): it adds a **capability mode** (`cap_enter()`) that irreversibly drops a process's ambient authority — no global namespaces, no open of new paths by name — leaving it able to act only through **capabilities**, which Capsicum implements as refined, rights-masked file descriptors. It is the landmark demonstration that object-capability discipline can be delivered inside a mainstream UNIX kernel without rewriting userland, and it went on to ship in FreeBSD and to underpin sandboxing in Chromium and other applications. The list thread itself is thin — a forward of the announcement and John Carlson asking what capability model exists for the *desktop* (windows, passing desktop privileges) — so this section records the announcement and Capsicum's significance to the ocap lineage rather than a substantive on-list debate.

## What the announcement carried

The forwarded text is short: "Today, Jonathan Anderson, Ben Laurie, Kris Kennaway, and I presented Capsicum: practical capabilities for UNIX at the 19th USENIX Security Symposium in Washington, DC; the slides can be found on the Capsicum web site. We argue that capability design principles fill a gap...." with pointers to the Cambridge Computer Laboratory Capsicum page. The single substantive question in reply came from John Carlson — "What kind of capabilities do you have for the desktop? ... Who can open, read, change, close a window? Can I pass desktop privileges to other desktops?" — followed by his own note that Chromium already uses the sandbox approach ("Ah, now I see the chromium thing"). No further design discussion followed on the list; the thread is a pointer to the paper.

## Why Capsicum belongs in the ocap lineage

Capsicum is the practical counterpart to the microkernel-capability systems (KeyKOS, EROS, seL4) discussed elsewhere in this archive and to the language-capability systems (E, Joe-E, the Caja/SES line). Where those either build a capability OS from scratch or enforce capabilities inside a managed language, Capsicum's contribution is *retrofit*: a capability mode and capability-refined descriptors added to an existing, widely-deployed monolithic UNIX so that unmodified-enough programs (with targeted changes) can be compartmentalized under least authority. Ben Laurie's presence on the author list ties it directly to the same community — he is a recurring cap-talk participant — and the "fill a gap" framing is the capability argument these threads make repeatedly: discretionary access control on ambient authority is the confused-deputy substrate, and capabilities are the fix. It is the ancestor of the sandbox-descriptor discussions this archive carries (compare the [cap-talk-2009-2012--nacl-descriptors-confinement-not-capabilities](cap-talk-2009-2012--nacl-descriptors-confinement-not-capabilities.md) thread on when a confinement descriptor is actually a capability).

## Bearing on Endo

Capsicum is the OS-layer analogue of what Endo does at the language layer: strip ambient authority, then re-grant only through unforgeable, attenuable handles. `cap_enter()` is the kernel's `lockdown()` — an irreversible transition into a world with no ambient namespaces, where a process holds exactly the descriptor-capabilities it was passed. The parallel is exact enough that Capsicum is the standard citation when explaining why the object-capability discipline is not merely a language curiosity but a systems-security result. See the [[object-capability]] and [[principle-of-least-authority]] concepts.

Source: [cap-talk 2010-August archive](http://www.eros-os.org/pipermail/cap-talk/2010-August/) (Internet Archive original-bytes `id_` snapshot of `2010-August.txt.gz`, sha256 `46aebf6e`), thread "Capsicum: practical capabilities for UNIX", 2010-08-12.
