---
title: Audits
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, security-disclosure]
status: current
---

> Abstract: Inventory of security audits SES has undergone, with dates, auditors, and links to reports. Important for downstream consumers evaluating whether SES is suitable for their threat model.

## Audits

In June 2021, `ses` underwent formal third party vulnerability assessment over a
period of 4 weeks with 3 engineers and a dedicated project manager that
surfaced no unknown security issues or vulnerabilities within the code. As a
result of this assessment, [a single code change was
made](https://github.com/endojs/endo/issues/126) to set a flag to disable the
domain module in Node.js to mitigate a known issue identified in the code.  The
code will be the subject of another round of intense application security
review mid-2022 by a reputable application security firm renowned for their
results in security reviews.

In July 2021, `ses` was the target of an intensive collaborative bug hunt lead by
the MetaMask team.
No critical flaws in the code surfaced during the review.
As a result of the search for flaws, deficiencies, and weaknesses in the code,
a series of small code changes and documentation improvements were made. There
is a report available on the
[Agoric blog](https://agoric.com/blog/technology/purple-teaming-how-metamask-and-agoric-hunted-bugs-to-harden-javascript)
that includes links to recordings of code walk-throughs and technical
discussion, and issues are tagged
[audit-SEStival](https://github.com/endojs/endo/issues?q=label%3Aaudit-sestival).
The [video recordings of the MetaMask and Agoric collaborative
review](https://www.youtube.com/playlist?list=PLzDw4TTug5O2d1XOdB7VNCZbIxRZu3gov).
provide useful background for future audits, reviews, and for learning more
about how the `ses` shim constructs a Hardened JavaScript environment.

In addition to vulnerability assessments, active efforts to [formally verify
the Agoric kernel](https://agoric.com/blog/technology/the-path-to-verified-blds-how-informal-systems-and-agoric-are-using-formal)
have found the object capability model that `ses` provides to be sound.

Hardened JavaScript is also within the scope of the [Agoric bug bounty
program](https://hackerone.com/agoric), which rewards researchers for surfacing valid
bugs in our code. We welcome the opportunity to cooperate with researchers,
whose efforts will undoubtedly yield stronger, more resilient code.


Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md) at commit `fe81477b`.
