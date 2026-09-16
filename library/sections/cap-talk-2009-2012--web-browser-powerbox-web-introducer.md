---
title: "Tyler Close's Web Introducer: an ultra-lightweight in-page powerbox for the browser"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-December/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-December.txt.gz
source_content_sha256: 2bd28144799d0127f73ed4ba1d5c3bdd263211138e9d5f03c30eb44d24758f4a
source_authors: [Tyler Close, Raoul Duke]
source_date: 2010-12-14
thread_subject: "Web browser Powerbox implementation"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns]
status: current
notes: "Derived summary, not the original messages. Announces Tyler Close's 'Web Introducer' / web-send.org powerbox prototype."
---

Abstract: In December 2010 Tyler Close announced a working **powerbox for the web browser** — the "Web Introducer" (web-send.org) — that lets a visited page request use of permissions the user was granted by *other* web pages, i.e. cross-origin rights amplification under user control. Its design contribution over prior powerboxes (CapDesk's file-dialog powerbox) is a deliberately **ultra-lightweight UX**: "Instead of a popup window, like a file dialog, the rights amplification happens with a single click on a drop-down menu in the page that is requesting access." Close's argument is that this lightness is what makes fine-grained delegation *practical*: "I think this lightweight UX makes it feasible to use the Powerbox for even the tiniest delegation, thus making it pleasant for a user to do fine grained permission management." The prototype was built "using only HTML5 and JavaScript, so it runs in the current generation of browsers, without any extensions/plugins," with a native Chrome implementation also underway. The only on-list response was Raoul Duke's accessibility note that the features page's coloring didn't work for inverse-video screens or red/green color blindness, which Close fixed. The thread is short, but the artifact is significant: it is the concrete, extension-free, in-browser powerbox — the direct lineage of the powerbox pattern that reappears in SES/Endo.

## What the Web Introducer does

A **powerbox** is the trusted UI intermediary that mediates a user's grant of a capability to an application: the app *requests* access (to a file, a service, a permission), the powerbox *presents* the user's available grants, and on the user's designation it *hands the app exactly that capability* — the app never sees the ambient authority behind the grant, only the specific reference. CapDesk's powerbox was a file-open dialog; the classic critique is that a heavyweight modal dialog is too expensive to invoke for small or frequent delegations, so users route around it. Close's Web Introducer attacks that cost directly:

- **Cross-page rights amplification.** A page can request "use of permissions you've been given by other web pages" — the browser becomes the meeting point where authority the user holds from site X can be designated to site Y, under an explicit user gesture, without either site forging the other's authority.
- **In-page, single-click grant.** The rights amplification is a "single click on a drop-down menu in the page that is requesting access," not a separate popup window — the powerbox is inlined into the requesting page's flow.
- **Feasible fine-grained delegation.** Because the gesture is cheap, the powerbox becomes usable "for even the tiniest delegation," making genuine least-authority permission management "pleasant" rather than a chore users disable.
- **No extensions.** The prototype is pure HTML5 + JavaScript, running in stock browsers, with a native Chrome build in progress — a deliberate deployability choice so the pattern needs no platform buy-in to try.

## Bearing on Endo

The Web Introducer is a canonical instance of the **powerbox** pattern that Endo and the SES ecosystem carry forward: the trusted mediator that turns a user's designation into a specific capability handed to an application, so the app receives *exactly* the authority the user pointed at and nothing ambient. Close's core insight — that the *cost of the granting gesture* determines whether fine-grained least authority is actually practiced, so the powerbox UX must be light enough to invoke for the smallest delegation — is a usability principle that applies directly to any Endo-hosted app surface where a user grants capabilities to guest code. The "cross-page/cross-origin rights amplification at an explicit user gesture" shape is the browser-era ancestor of powerbox-mediated capability grant between mutually suspicious parties. See the [[powerbox]] concept and the neighboring [cap-talk-2009-2012--web-powerbox-and-oauth](cap-talk-2009-2012--web-powerbox-and-oauth.md) section on why a powerbox beats OAuth for delegated access.

Source: [cap-talk 2010-December archive](http://www.eros-os.org/pipermail/cap-talk/2010-December/) (Internet Archive original-bytes `id_` snapshot of `2010-December.txt.gz`, sha256 `2bd28144`), thread "Web browser Powerbox implementation", 2010-12-14.
