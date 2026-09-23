---
title: "CapDesk confinement, authority by designation, and E productivity"
source: http://www.combex.com/tech/edesk.html
source_kind: web
source_url: http://www.combex.com/tech/edesk.html
source_fetched_via: wayback
source_wayback_url: http://web.archive.org/web/20260504141905id_/http://www.combex.com/tech/edesk.html
source_wayback_timestamp: 20260504141905
source_content_sha256: 0cc54052b7b6a07f874bf4a50d55ef0a6a8b964af540744368ce17f7fef07be1
source_authors: [Marc Stiegler, Mark S. Miller]
source_date: 2026-06-28
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security]
status: current
---

## Abstract

How CapDesk delivers POLA in practice: software modules receive no authority by default and acquire it only through ordinary user gestures (the File Open dialog, drag-and-drop), so security is "almost free" with no passwords or authorization lists; and the claim that the E platform delivers this while improving developer productivity. This is the practice the Polaris paper names as combining designation with authorization, the installation endowment, and the PowerBox.

## Content

CapDesk is presented through two screenshots and a set of claims. The first screenshot is a "Side-by-Side comparison of a malicious Web Browser running under CapDesk capability confinement (left), versus the same Browser running with standard Windows/Unix privileges (right). The confined Browser fails in all attempts to suborn the computer; the Winix-enabled Browser takes full control."

The mechanism:

> With the E platform and the CapDesk capability secure desktop, software modules receive no authority by default. Programs [are] started in strict confinement (a level of confinement far stricter than the confinement of the Java applet sandbox). They receive authority only through the actions of the user.

The document confronts the standard objection — that users would spend much of their time granting authorities — and answers it empirically: "Combex has demonstrated with its existing operational prototypes that this does not need to be the case. Actual applications in the field require surprisingly few authorities, and standard software technologies, such as the File Open dialog box and the drag/drop metaphor, make natural vehicles for their conveyance. No passwords are required, no user authorization lists need management or maintenance." A production CapDesk "would look and feel like Windows or KDE, yet would create a secure environment almost for free" — turning on its head the traditional wisdom that "you cannot have security without paying a price in flexibility". (This designation-conveys-authority mechanism is precisely what the Polaris paper carries to Windows XP via the PowerBox; see [papers--stiegler-karp-yee-miller-polaris-2004--using-and-polarizing-an-application](papers--stiegler-karp-yee-miller-polaris-2004--using-and-polarizing-an-application.md).)

A second screenshot shows "CapDesk running on Win2K with file manager windows open on the host OS and on a remote Linux system; the communication with the remote Linux system is capability secure and strongly encrypted." CapDesk "blends functionality of the Microsoft File Explorer, FTP, SSH, and flexible fine grain security options in an integrated fashion not reproduced in any conventional application." The first operational version "was developed by a single programmer over the course of a month of weekends — a remarkable comment on the productivity E provides for secure distributed systems."

The closing claims concern E as a distributed-systems platform: peer-to-peer, B2B, and intranet systems benefit from "E's deadlock-free promise-based distributed computing architecture, and from the way in which all communication is automatically and transparently strongly encrypted without programmer effort." The tutorial application is the **eChat** peer-to-peer capability-secure chat tool, "only five pages of code"; anecdotal evidence suggests E offers "a productivity improvement somewhere between a factor of 3 and a factor of 7 over conventional programming languages such as Java, within the domain of secure distributed applications."

Source: [E and CapDesk: POLA for the Distributed Desktop](http://www.combex.com/tech/edesk.html) — captured via the Internet Archive (`source_fetched_via=wayback`) at [web/20260504141905id_/](http://web.archive.org/web/20260504141905id_/http://www.combex.com/tech/edesk.html), content SHA-256 `0cc54052`.
