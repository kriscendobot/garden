---
title: "Executive summary: the capability-confined renderer and the E Language Machine"
source: http://www.combex.com/tech/darpaBrowser.html
source_kind: web
source_url: http://www.combex.com/tech/darpaBrowser.html
source_fetched_via: wayback
source_wayback_url: http://web.archive.org/web/20260504023216id_/http://www.combex.com/tech/darpaBrowser.html
source_wayback_timestamp: 20260504023216
source_content_sha256: 3a68fd803bbbddc03fa419d5351ee7a03ac1df9620d96e51257c6862858f86bd
source_authors: [Combex, Inc.]
source_date: 2026-06-28
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
---

## Abstract

The DarpaBrowser's central design: a capability-confined HTML rendering engine that cannot compromise any other part of the system, including the URL display field, paired with a deliberately adversarial "Malicious Renderer" that attempts to escape confinement and report its results. Both run on an "E Language Machine" — a Sanitized Linux stripped to the trusted computing base that executes only E caplets. This is the canonical worked example of capability confinement of an untrusted component of "moderate complexity".

## Content

The document opens by noting it "is the document accepted by Darpa, and is presented as is for historical interest. Current terminology and screen shots have changed since then."

The executive summary:

> Using the capability-secure open-source E programming language, and the Combex-proprietary Capability Windowing Toolkit (capWT), Combex will develop a capability secure Web browser: the HTML rendering engine for the browser will be capability confined so that it may not compromise any part of the system, not even the field in the browser which displays the URL.

The browser runs on an **E Language Machine**: "a capability secure, trustworthy platform, built on a Sanitized Linux: a Linux from which everything has been stripped that is not needed to support the E Language Machine." All services normally associated with Linux (terminal services, network services above the TCP/IP stack) are removed to eliminate compromise risk. "The E Language Machine will be a fully functional computing system, but, besides the TCB, only programs written in E and confined as caplets (capability-secured applications) will be permitted to execute."

The defining red-team device: Combex supplies **two rendering engines**. "A Benign Renderer will underpin the web browser for traditional browsing purposes. A Malicious Renderer will, when loaded, relentlessly attempt to escape from its capability confinement, reporting on its results as it makes attacks." This pairing — a real component and an adversary component held in the same confinement box — is the demonstration's evidentiary core: confinement is shown to hold by running an attacker inside it.

The capability model is contrasted with access control lists: "Access Control Lists may be thought of as systems of ID badges, with each badge granted a span of powers … capabilities may be thought of as keys, one for each resource, which may be granted and reclaimed during processing, so that a program might, over the course of a computation, hold dozens of keys, but never actually hold more than a few at a time." The objective is fine-grained control where "the allocation of each specific resource [is] a separate granting of authority" — and the concrete goal is "a capability secure Web browser in which an incorrect page rendering module (made incorrect either by the presence of bugs or by malicious code) cannot compromise any other aspect of the computer or the display, up to and including the presentation of the URL from which the page was fetched."

Source: [The DarpaBrowser](http://www.combex.com/tech/darpaBrowser.html) — captured via the Internet Archive (`source_fetched_via=wayback`) at [web/20260504023216id_/](http://web.archive.org/web/20260504023216id_/http://www.combex.com/tech/darpaBrowser.html), content SHA-256 `3a68fd80`.
