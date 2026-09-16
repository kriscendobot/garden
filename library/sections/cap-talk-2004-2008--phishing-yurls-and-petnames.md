---
title: "Phishing with YURLs and petnames"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2006-February/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2006-February.txt.gz
source_content_sha256: 5db995156d3255130a0eabaa8377f266417c6c509c6ede82bf29f60165ae191d
source_authors: [Toby Murray, Tyler Close, Alan H. Karp, Eric Jacobs, Ian Grigg, Sandro Magi, Jed Donnelley, Ka-Ping Yee, Marc Stiegler]
source_date: 2006-02-13 to 2006-02-16
thread_subject: "Phishing with YURLs and Petnames"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The YURL/phishing thread tests whether an unguessable capability URL plus a petname UI prevents the attacks that survive HTTPS. A YURL securely designates an endpoint or resource; the petname records the user's local relationship with it. Together they prevent an attacker from acquiring the same trusted label merely by choosing a similar global name. They do not prevent every social-engineering path or a trusted endpoint from behaving badly.

The discussion distinguishes a secure channel from a trusted channel. Cryptography can show that this is the same endpoint reached before. Only user-controlled naming or an explicit introduction explains what that endpoint means to this user. Global certificate names and attacker-controlled page content are hints, not equivalent substitutes.

The thread also exposes lifecycle questions: moving a relationship to a new key, importing a petname, and receiving a capability from another party require trusted UI and an introduction story. Web-key security is therefore not only a random-URL construction. It is a reference plus a path by which the user can recognize and manage that reference.

Source: [cap-talk 2006-February archive](http://www.eros-os.org/pipermail/cap-talk/2006-February/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2006-February.txt.gz`, sha256 `5db99515`), messages dated 2006-02-13 to 2006-02-16.
