---
title: "POLA and the Winix excess-authority problem"
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
topics: [capability-theory, capability-security]
status: current
---

## Abstract

CapDesk's statement of the problem: the Principle of Least Authority (POLA) — never grant anyone or anything more authority than they require — and the diagnosis that all conventional "Winix" (Windows and Unix) operating systems disregard it by endowing every launched application with the full authority of the user. This is the CapDesk-era articulation of the ambient-authority critique that the Polaris paper and the later object-capability literature formalize as "no ambient authority".

## Content

The E platform uses capability-based security, "a software architecture for achieving the Principle of Least Authority (POLA) in computer systems. POLA is a simple and timeless principle: never grant anyone or anything more authority than they require." The document gives the principle its everyday names: "Need to Know" in classified venues, the **valet key** for an automobile (authority to drive but not to open the trunk), and "exact change" when buying milk. It observes wryly that "the only people who have trouble understanding POLA are credit card companies (which really do tell you to hand all your credit to the unknown operator of a remote Web site), and computer security experts who tell you to use larger numbers of longer passwords and ever more complicated firewalls."

The core diagnosis — the *excess authority* problem that Polaris would later inherit verbatim:

> All Windows and Unix operating systems (referred to as "Winix" hereafter) utterly disregard the concept of POLA. When you launch any application — be it a $5000 version of AutoCAD fresh from the box or the Elf Bowling game downloaded from an unknown site on the Web — that application is immediately and automatically endowed with all the authority you yourself hold.

Such applications "can plant Trojans as part of your startup profile, read all your email, transmit themselves to everyone in your address book using your name, and can connect via TCP/IP to their remote masters for further instruction. This is, candidly, madness."

This is the same argument the Polaris paper makes — "every program you run can do anything you can do, whether you want it done or not … The problem is the excess authority that every program gets" — and the same argument the object-capability papers in the library formalize as Property D, *No Ambient Authority* (see [papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties](papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md)). CapDesk is the desktop demonstration of the principle; Polaris is its Windows-XP descendant.

Source: [E and CapDesk: POLA for the Distributed Desktop](http://www.combex.com/tech/edesk.html) — captured via the Internet Archive (`source_fetched_via=wayback`) at [web/20260504141905id_/](http://web.archive.org/web/20260504141905id_/http://www.combex.com/tech/edesk.html), content SHA-256 `0cc54052`.
