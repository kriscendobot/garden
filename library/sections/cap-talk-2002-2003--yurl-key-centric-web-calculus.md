---
title: "YURL and the key-centric web calculus"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-September/
source_snapshot: http://web.archive.org/web/20160730010609id_/http://www.eros-os.org/pipermail/cap-talk/2003-September.txt.gz
source_content_sha256: 5fb31ec62affbe3433b9434885bee48621e4c91a8457cc32b739c14592165e02
source_authors: [Mark S. Miller, Tyler Close, David Wagner, Hal Finney, Ben Laurie, David Hopwood, Norman Hardy, Alan Karp]
source_date: 2003-08-31 to 2003-09-29
thread_subject: "[web-calculus] YURL FAQ"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, decentralized-identifiers, identity]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The YURL discussion contrasts name-centric HTTPS with a key-centric secure-reference mechanism. A YURL embeds a server-key fingerprint so the party passing the link also passes the cryptographic designation. This removes the later certificate authority from the introduction: the recipient may still distrust the introducer's claim about the target, but reaches the same target the introducer meant. The thread also records the costs and limits: key rollover and revocation need explicit indirection, human speech still needs names, the integrity of the surrounding document remains separate, and neither HTTPS nor YURL can repair a link replaced before the browser receives it.

## Introduction rather than universal identity

In the name-centric example, an introducer says that Carol has some property, then a certificate authority separately maps the name "Carol" to a key. Bob depends on both parties agreeing about which Carol was meant. In the key-centric version, the introducer supplies Carol's key with the claim. A naming path can still resolve a spoken name, but its assertion is local: "the entity NBC meant by Coca Cola," not "the one true Coca Cola." This turns a socially contested global identity claim into a statement about who said what.

## Secure reference, not trustworthy content

The `httpsy` proposal uses existing public-key certificates but changes what the URL designates. Its fingerprint protects the link-to-server binding after Bob receives the link. It does not prove that the server is honest, that its content is stable, or that an unprotected email containing the YURL was not rewritten. Search engines also become introducers rather than neutral identity oracles: pinning the key seen during a crawl ensures only that the reader reaches that same key holder.

## Costs and layering

Names remain useful for human conversation, memorable brands, and key rollover. The key-centric response is to layer pet names, local directories, and stable redirection objects over cryptographic pointers rather than require every machine-to-machine reference to traverse a global namespace. Critics press the operational cost of bootstrapping those pointers and replacing compromised permanent keys. The narrower agreement is that cryptographic pointing is valuable where software already passes references, while human naming and reputation remain higher layers.

Source: [cap-talk 2003-September archive](http://www.eros-os.org/pipermail/cap-talk/2003-September/) (Internet Archive original-bytes snapshot `web/20160730010609id_/.../2003-September.txt.gz`, sha256 `5fb31ec6`), messages dated 2003-08-31 to 2003-09-29.
