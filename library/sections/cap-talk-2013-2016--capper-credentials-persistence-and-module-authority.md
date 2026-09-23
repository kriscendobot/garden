---
title: "Capper: credential facets, upgradeable persistence, and module authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2016-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2016-January.txt.gz
source_content_sha256: 506e6bfcc7289a1e2ac255d90759690f5d061e8c2aa81ffc68a29d635e06882e
source_authors: [Dan Connolly, Marc Stiegler, Kenton Varda]
source_date: 2016-01-02 to 2016-01-07
thread_subject: "fun with Capper and OFX financial transaction fetching"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, persistence, compartments]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Connolly's Capper experiment assembles an OFX banking application from webkeys: a broad desktop secret-store capability is attenuated to one credential entry, which is then combined with an institution facet to mint an account object. This removes plaintext passwords from `capper.db` and makes the access graph visible in the construction sequence. His remaining wish is an authority-neutral module loader so ordinary npm libraries can receive explicit HTTP and storage powers instead of importing ambient ones.

Stiegler explains Capper's persistence tradeoff: explicit `context.state` is less pleasant than closure-shaped objects, but makes schema-changing upgrades practical, whereas Waterken's transparent closure persistence made some instance-variable and closure upgrades painful or impossible. Varda notes a platform boundary: Sandstorm prefers to own sharing, audit, and revocation, although an application can expose multiple logical webkeys. Two independently useful capability layers can conflict if both assume they are the authority manager.

## Bearing on Endo

The experiment is a compact Endo application recipe: keep secrets in a dedicated service, derive the narrow credential facet needed by one account, make modules accept explicit powers, and separate durable state representation from live closure structure so upgrades remain tractable.

Source: [cap-talk 2016-January archive](http://www.eros-os.org/pipermail/cap-talk/2016-January/) (Internet Archive original-bytes `id_` snapshot of `2016-January.txt.gz`, sha256 `506e6bfc`), thread "fun with Capper and OFX financial transaction fetching", 2016-01-02 to 2016-01-07.
