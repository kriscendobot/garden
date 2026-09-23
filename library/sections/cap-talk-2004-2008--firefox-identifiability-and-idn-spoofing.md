---
title: "Firefox identifiability and IDN spoofing"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2005-February/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2005-February.txt.gz
source_content_sha256: 7df3d075ad7abf606d149c95308b9912d33763b6995524ebaaaf444c66551d4d
source_authors: [Ka-Ping Yee, Alan H. Karp, Ian Grigg, Mark S. Miller, Tyler Close, Bill Frantz, Ben Laurie, Norman Hardy, Jed Donnelley, David Wagner, Zooko Wilcox-O'Hearn, Marc Stiegler, David Hopwood, Sandro Magi]
source_date: 2005-02-07 to 2005-02-12
thread_subject: "Firefox breaks the principle of identifiability"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Ka-Ping Yee uses Firefox's Unicode domain-name display to show a direct violation of secure-interaction identifiability: a Cyrillic character can make an attacker-controlled domain look indistinguishable from `paypal.com`, even over HTTPS. Cryptographic channel authentication does not help when the browser renders the authenticated identifier as somebody else's name. The discussion separates secure transport from a user interface that lets the user recognize the relationship they intended.

Several responses defend certificate-authority branding or meaningful domain names. The capability-oriented response removes semantic weight from the global identifier. A URL or public key establishes connectivity; the user assigns a local petname after an introduction or successful interaction. Marc Stiegler's thought experiment makes the point vivid: if URLs were visibly random strings, everyone would see that meaning must be supplied outside the string.

The thread does not claim petnames eliminate every phishing attack. It establishes the design rule that a trusted relationship label must be under the user's control, rendered through a trusted path, and bound to the actual cryptographic endpoint rather than inferred from attacker-chosen text.

Source: [cap-talk 2005-February archive](http://www.eros-os.org/pipermail/cap-talk/2005-February/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2005-February.txt.gz`, sha256 `7df3d075`), messages dated 2005-02-07 to 2005-02-12.
