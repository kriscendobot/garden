---
title: "Reducing ambient user authority: an install-time authority manifest and a console-free OS"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-December/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-December.txt.gz
source_content_sha256: e30d2d0b6139e606a9e5c68e17831ac062950deeea9ea226218d37f83c77a40f
source_authors: [Peter Ryan, Alan Karp, David-Sarah Hopwood, Sandro Magi, Bill Frantz]
source_date: 2009-12-01 to 2009-12-22
thread_subject: "Reducing Ambient user authority in a Type Safe / Memory Safe OS"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. Attribution by role in the thread; the design proposer is the OS author seeking review."
---

Abstract: The densest thread of December 2009 is a design review of a type-safe / memory-safe operating system whose author wants to eliminate user ambient authority. Two design moves anchor the proposal, and both anticipate patterns now mainstream. First, **an install-time authority manifest**: "when an application installs it provides a concise list of access it needs which the user can approve or deny" (recommended to be a minimum list) — the same shape as modern mobile-app permission manifests, a decade early. Second, **removing the command line entirely**: with no console, the OS "no longer need[s] to convert arbitrary string values into file names and into capabilities," so applications "directly pass references (Object capabilities) to each other" — the document a user clicks in a file browser is handed to the word processor *as a FileCapability reference*, not as a path string to be re-resolved under ambient user authority. Missing authority triggers a bounded escalation ladder — Application → User → Group → Everyone/Machine — where a match below "Everyone" prompts the user ("is this ok, and always allow?") and, if approved, copies the capability into the application's keyring; "Everyone(Machine)" is granted silently. The reviewers (Karp, Hopwood, and others) probe where "reduce" falls short of "eliminate": the escalation prompts reintroduce a decision surface that can be trained-through, and per-user application settings still carry an identity-indexed ambient component.

## The two design moves

**Install-time manifest of requested authority.** Authority is negotiated at installation, not scattered through runtime: "The emphasis for security is on the application installation process ... it provides a concise list of access it needs which the user can approve or deny; it is recommended that this list be a minimum list." Home (per-user) installs are still supported. This front-loads the POLA decision to a single reviewable moment and is structurally the Android/iOS permission-manifest model.

**No command line ⇒ references, not strings.** The proposer's sharpest claim is that the console is a security liability because it is the machine that turns *arbitrary strings* into filenames into capabilities under the user's ambient authority — the classic path-designator confused-deputy surface. Remove it and "applications directly pass references (Object capabilities) to each other whether via a GUI browser or a batch context." The worked example: file-browser ("explorer") holds a *directory-browse* capability; when the user clicks a document, "this file with browse capability is passed to the wordprocessor," and if that specific request lacks sufficient authority "the system will start looking for escalatable capabilities of the same Type (eg FileCapability)." Designation replaces re-resolution: the authority travels *with* the click, rather than the click naming a string the callee re-interprets.

## The escalation ladder

When an application lacks a needed capability, authority is sought up a fixed ladder:

> Application → User → Group → Everyone/Machine

A hit anywhere except "Everyone" prompts the user — "whether it's ok and whether to always allow this" — and on "always allow" the capability is copied into the application's keyring capability store (or granted temporarily, e.g. one-time editor access to a system config file). "Everyone(Machine) is always approved silently." Lower-security deployments can permit App→User→Group escalation without prompts; an administrator can conversely forbid an application from escalating at all. The stated payoff: "even if a browser breaks the sandbox there is not much they can do," because the browser's own manifest bounds what it can escalate to.

## Why it is an open question ("reduce" vs "eliminate")

The thread's title says *reduce*, and the review pressure is exactly on the gap to *eliminate*. The escalation prompt is a human decision surface, and "always allow" trains users to grant — the same habituation failure that undermines every consent dialog; a prompt that is clicked-through is ambient authority with extra steps. Per-user application settings keep an identity-indexed component (authority that follows *the user*, not a designated reference), which is ambient by the designation criterion the June [defining-ambient-authority](cap-talk-2009-2012--defining-ambient-authority.md) thread settled on. Whether an install-manifest-plus-escalation model genuinely removes ambient user authority or merely relocates and rations it is left unresolved.

## Bearing on Endo

The install-time manifest and the "pass the FileCapability, not the path" move are both native Endo patterns. Endo's `package.json` `powers`/endowment declarations are exactly a manifest of the authority a package requests, reviewed and granted at wiring time rather than assumed at runtime; the console-free "hand the callee a reference, never a string it re-resolves" discipline is the object-capability answer to the path-designator confused deputy (see [confused-deputies-in-capability-systems](cap-talk-2009-2012--confused-deputies-in-capability-systems.md)). The thread's unresolved worry — that consent prompts habituate users into re-granting ambient authority — is the caution behind preferring *statically wired, designated* endowments over runtime authority-escalation dialogs in Endo application design. See the [[ambient-authority]] and [[powerbox]] concepts.

Source: [cap-talk 2009-December archive](http://www.eros-os.org/pipermail/cap-talk/2009-December/) (Internet Archive original-bytes `id_` snapshot of `2009-December.txt.gz`, sha256 `e30d2d0b`), thread "Reducing Ambient user authority in a Type Safe / Memory Safe OS", 2009-12-01 to 2009-12-22.
