---
title: Body
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "7-12 (§3 Contemporary examples through §5 Conclusion)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix
---

### §3.1 Cross-Site Request Forgery — the compilation attack on the Web

The §3.1 paper opens with the canonical CSRF scenario:

> For example, consider an investment account at a stock broker's Web site. This Web application provides a feature to buy stocks. The resource to make a purchase is located at a URL like: `https://example.com/buy.php`. A POST request sent to this resource provides the stock ticker and number of shares to buy. In the planned legitimate use-case, this resource is invoked from a FORM in an HTML page served by the stock broker's Web site. In an attack scenario, another Web site could serve an HTML page that contains an identical FORM, pre-populated with a ticker symbol and number of shares. Using JavaScript, this FORM can be automatically submitted on page load. Assuming the user is currently logged into the stock broker's Web site, the user's browser will send the POST request to the stock purchase resource and include any cookies, or HTTP authentication credentials, set up with the stock broker's Web site.

Table 3 makes the mapping explicit:

| element | compilation scenario | stock-purchase scenario (CSRF) | stock-sale scenario (clickjacking) |
|---------|---------------------|-------------------------------|------------------------------------|
| Confused Deputy | Compiler | Web browser | Web browser |
| message sender identifier | process UID | HTTP cookie | HTTP cookie |
| victim | Vendor | stock broker application | stock broker application |
| attacker | User | visited HTML page | visited HTML page |
| unexpected object identifier | `"log.txt"` | `https://example.com/buy.php` | `https://example.com/home.php` |
| abused object | log.txt file | stock purchase resource | account summary page |
| operation | write | POST | GET |

The §3.1 mapping makes the CSRF-as-Confused-Deputy reading exact. The Browser is the deputy (just as the Compiler was). The HTTP cookie is the principal identifier (just as the process UID was). The attacker's HTML page provides the *target URL* (just as the User provided the *output filename*). The buy.php endpoint's reference monitor sees the cookie (legitimate-user-shaped) and grants the buy; the attacker's *targeting choice* is invisible to the reference monitor.

The §3.1 paper observes that the CSRF mitigation paper [16] recommends *use of an unguessable token in the HTML FORM served by the stock broker's Web site. The stock purchase resource then checks that a received POST request contains the expected token. The browser's Same Origin Policy prevents an attack page from extracting a token from a legitimate page. This technique has become the most popular defense to CSRF vulnerability.*

The §3.1 paper draws the structural conclusion:

> Although the CSRF article makes no reference to the Confused Deputy attack or to capabilities, the suggested defense is effectively to transition the application away from the ACL model and to the capability model.

The unguessable token *is* a capability: it is an unforgeable secret that the legitimate FORM-served page possesses but the attacker's page does not. Possessing the token = holding the capability = being able to send the message. The Same Origin Policy is the integrity boundary that prevents the attacker from *stealing* the token. The whole defense is structurally a capability-model retrofit.

The §3.1 paper closes with the comparison to the compilation fix:

> Comparing the suggested defense to the capability-based solution for the compilation scenario, and again assuming a Unix-like system: the URL is like the filename; and the unguessable token is like a file descriptor, approximating the unforgeability of a capability with unguessability. A legitimate page from the stock broker's Web site first *opens* the stock purchase resource, receiving an unguessable secret. The legitimate page then uses this unguessable secret when instructing the browser to *write* to the stock purchase resource.

### §3.2 Clickjacking — same diagnosis, different deputy mediation

The §3.2 paper observes that the *GET-request setup phase* of even an unguessable-URL POST request *remains in the ACL model* and is therefore vulnerable:

> In the example of the previous section, the use of an unguessable token transitions the POST request that makes a purchase to the capability model; however, the GET request to set up a purchase remains in the ACL model. Recently, it has been shown how this setup phase remains vulnerable to a Confused Deputy attack.

The clickjacking attack:

> For example, the investment account at a stock broker's Web site also includes a feature to sell owned shares. In the portfolio summary page, beside each holding, is a button labeled "close position". Clicking this button sells the held shares. The corresponding HTML FORM may or may not be protected against CSRF using the previously discussed technique. The portfolio summary page is located at a URL like: `https://example.com/home.php`. An attacker's page, served from another Web site, can include an HTML IFRAME that references the portfolio summary page. An IFRAME creates an inline child window that displays a referenced page. Using Cascading Style Sheets (CSS), the attacker's page can style the IFRAME to have no border and be transparent. To the user, this IFRAME is completely invisible. Underneath the IFRAME, the attacker's page puts content that entices the user to click at a specific location.

The §3.2 paper's structural reading: clickjacking is *the same attack family* as the compilation scenario. The Browser is the Confused Deputy. The targeting (which button the click reaches) is determined by the *attacker*, not by the user-with-intent. The click's effects (selling shares) accrue against the user's session. The user's *intent* (which is presumably "play the click-the-monkey game") is invisible to the reference monitor.

The §3.2 paper notes a subtle point about the attack's mechanics:

> An HTML link is a request for the browser to place named content at a specified on-screen location. When the browser includes cookies in the GET request to fetch the content, it is acting as a Confused Deputy. Like in the compilation scenario, the requestor does not have permission to access the named resource, but can provide the resource's name to the deputy, who will access the resource on the requestor's behalf.

Stripping clickjacking to its essentials: *the attacker can cause mischief using only the authority to link to a private page*. No iframe, no transparency, no JavaScript needed in the minimal form — just a link. The visual trickery is the *user-facing* attack vector; the *structural* problem is the same Confused Deputy issue.

### §3.2.1 web-key — capabilities by reference for the Web

The §3.2.1 paper introduces the canonical Web-side fix:

> A surprising number of the problems with today's Web are directly attributable to the use of the ACL model. The web-key paper [4] explains many of these problems and also describes how best to use unguessable URLs to address these problems and move the Web to the capability model. No changes to Web protocols, formats, user agents or server-side infrastructure are required to make this transition. The required changes are limited to the URL namespace defined by a Web application.

The *web-key* concept: replace URLs that *identify resources publicly* with URLs that contain *unguessable secrets*. The unguessable secret is the capability — possessing the URL = possessing the right to interact with the resource. The Same Origin Policy + the unguessability of the secret + HTTPS together provide the integrity boundary.

The §3.2.1 framing's load-bearing claim: *no changes to Web protocols, formats, user agents or server-side infrastructure are required*. The migration is *application-local* — the Web application changes its URL namespace, and the rest of the Web stack is unchanged. This is a *deployable* path to capability-Web, not a clean-slate research proposal.

In the clickjacking case, the fix is structural:

> In the capability model, the rendering tricks used in the clickjacking attacks are not dangerous and so need not be restricted. For example, there's no need to place restrictions on the creation of IFRAMEs or opacity styling. If an attacker doesn't know the unguessable URL for a victim page, he is unable to load the page and so is unable to trick the user into interacting with the page. If a legitimate site does know the unguessable URL for a page at a partner site, it can load the page and customize its presentation. Such customization isn't trickery, since there's no need for trickery. The legitimate site can already send any request it likes using the unguessable URL; interaction from the user isn't needed.

The §3.2.1 reading inverts the *trickery is dangerous* security posture: in a capability-Web, trickery is harmless because the attacker cannot *load* the page in the first place without the unguessable URL.

### §3.3 Click fraud — another client-authentication-misled access decision

The §3.3 paper extends the diagnosis to online advertising:

> Both the Cross-Site Request Forgery and clickjacking attacks target the misuse of client authentication as an input to an access decision. As discussed earlier in section 2.5, other message recipient routines may also rely on client authentication for purposes for which it is unreliable. ... For example, in pay-per-click online advertising, an advertiser pays a publisher each time an advertisement is clicked. A click is registered as a GET request to some URL. Various client identifiers attached to the GET request are checked to ensure clicks are coming from distinct clients. In click fraud, an attacker entices users to visit an attack page. This page generates a GET request to the advertisement URL, without any interaction from the user. Consequently, the advertiser pays for advertisements that were never seen.

The §3.3 paper concludes: *Once again, it should be emphasized that little can be reliably concluded based on client authentication. Knowledge of the principal that sent a request is most often misleading information.* Knowing *who* clicked tells you nothing about *whether the click was intended*. The Confused-Deputy diagnosis extends to any system that uses client authentication as a proxy for client intent.

### §4 Related Work — the lineage

The §4 paper acknowledges the lineage:

> All of the attacks described in this paper are presented in prior works. The Confused Deputy attack was originally described by Norm Hardy in 1988 [8]. The term "Cross-Site Request Forgery" was coined in a blog post by Chris Shiflett in 2004. In 2000, a page on the Zope web site described a similar attack, naming it a "Client Side Trojan" [19]. ... The realization that these attacks are not an artifact of any particular implementation but rather arise from a defect in the ACL model itself was implicit in the original Confused Deputy paper. This aspect of the problem was further elaborated upon in a paper by Miller et al in 2003 [11].

The §4 paper names the *core contribution* of this paper:

> The core contribution of this paper is the description of the Confused Deputy problem in the terminology of the access matrix. This description clarifies how the ACL and capability models produce contradictory access decisions, thus providing a more exact characterization of the Confused Deputy problem. This precision enables a better description of the caused problems and the possible remedies, as well as a better understanding of how contemporary systems, like the Web, suffer from the problem. Better understanding of the inability of the ACL model to correctly control access in multi-party scenarios may help prevent the continued recurrence of these attacks.

The §4 framing positions the paper as the *access-matrix-formalization* of the Confused Deputy critique — the contribution is *precision* about an existing problem, not the discovery of the problem.

### §5 Conclusion — the migration claim

The §5 paper closes with the deployability claim:

> In messaging scenarios involving more than two principals, the ACL model fails to retain enough information to enable correct access decisions. These errors in the model are manifested in all systems that use the ACL model for access control in multi-party scenarios. For example, these errors are the underlying flaw exploited by both the CSRF and clickjacking attacks on the Web. The capability model does not have these logic errors and can effectively control access in multi-party scenarios. Some systems, such as the Web, can be converted from the ACL model to the capability model without change to their infrastructure and with relatively minor changes to applications.

The §5 claim's structure: (a) ACL fails *in all multi-party-scenario systems*; (b) capability succeeds *in all multi-party-scenario systems*; (c) the migration *is feasible* — at least for the Web, the migration requires *no infrastructure change*, only application-local URL-namespace changes.

The §5 framing's significance for contemporary work: the *no-infrastructure-change* claim is the bridge between *capability theory* and *capability deployment*. Web-keys are the canonical worked example; the migration path for non-Web systems is *implicit* — replace public-name access tables with unguessable-token access protocols.
