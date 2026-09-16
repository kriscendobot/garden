---
title: "Re-authentication and time-limited capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-June/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-June.txt.gz
source_content_sha256: 8cbb4cb659ac9deb86d73395a2ef63dc0462094c805a3a7d6730c8ae515e8072
source_authors: [Dirk Pranke, David Barbour, David Wagner, James Donald]
source_date: 2011-06-10 to 2011-06-11
thread_subject: "capabilities and re-authentication"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Dirk Pranke of Chromium asked how a capability design handles a common web interaction: services offer at least three trust levels (anonymous, authenticated-at-some-point-but-not-recently, and authenticated-recently), and step up to the highest for sensitive actions like checkout. Given the community's "authorize, not authenticate" slogan, how does an object-capability system model the transition, and would it even want to? David Barbour answered with the powerbox as the user model: the powerbox issues several capabilities of differing lifetimes (one long-lived, one lasting a reasonable session, one very short) and revokes them when the user is done, with sensitive authorities carrying time and use limits before expiry, and purchases modeled through the powerbox as a kind of anonymous e-purse. James Donald restated the same three-lifetime picture. Pranke pushed back that he did not want three simultaneous capabilities of differing lifetimes; he wanted the powerbox to issue *one of two* capabilities carrying different authority at different times, depending on whether he was in a browsing or a buying mode. David Wagner questioned the premise, asking whether we even understand why Amazon re-prompts for a password at checkout, and observing that if the goal is defending against a malicious roommate, the re-prompt is largely defeated by browser password managers, so he knew of no good solution to that threat suitable for e-commerce beyond requiring some password at checkout.

## Re-authentication as fresh, narrowly scoped authority

The reframing the thread performs is from "prove who you are again" to "acquire the right authority for this action, now." Barbour's powerbox model turns the three trust levels into three capabilities distinguished by lifetime and scope rather than into three authentication states: the long-lived one for identification-grade access, a session-scoped one, and a short-lived one for the sensitive step, all revocable and all time or use bounded. Pranke's refinement is important: he does not want a bundle of concurrent capabilities, he wants a mode switch, where entering "buying" mints a capability carrying the elevated, short-lived authority and leaving it drops back. That is re-authentication recast as minting a fresh, tightly scoped, expiring capability on demand. Wagner's contribution is the reality check on the threat model. Before designing the mechanism, be sure what it defends against: the Amazon checkout re-prompt, if aimed at a malicious roommate reusing a logged-in session, is undercut by the browser remembering the password, so the mechanism may not achieve its imagined goal. He knew no clean solution for that threat in an e-commerce setting other than demanding a password at the sensitive moment, itself weakened by password managers.

## Bearing on Endo

Pranke's mode switch is exactly the Endo powerbox pattern: sensitive actions are performed by acquiring a fresh, narrow, expiring capability at the moment of use, not by carrying a long-lived elevated session. Endo's revocable and attenuable references give this directly, with time and use limits enforced by the granting object rather than by re-checking an identity. The "authorize, not authenticate" slogan is Endo's default, and this thread is the worked example of applying it to the step-up interaction the whole web relies on. Wagner's caution carries over unchanged: an Endo surface that mints a step-up capability must be honest about which threat the step-up actually addresses, because a fresh capability minted in a compromised session inherits the compromise, just as a re-entered password does behind a password manager. The e-purse framing (modeling a purchase as spending through the powerbox) is an ancestor of treating payment authority as a spendable, bounded capability rather than as account access.

Source: [cap-talk 2011-June archive](http://www.eros-os.org/pipermail/cap-talk/2011-June/) (Internet Archive original-bytes `id_` snapshot of `2011-June.txt.gz`, sha256 `8cbb4cb6`), thread "capabilities and re-authentication", 2011-06-10 to 2011-06-11.
