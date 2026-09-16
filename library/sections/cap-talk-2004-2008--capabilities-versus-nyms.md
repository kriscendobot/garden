---
title: "Capabilities versus cryptographic nyms"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2004-May/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2004-May.txt.gz
source_content_sha256: 6e2fd2dc0f65aea7abf28ea3025fe513ac39c56276874cde06f41c9454f7f30e
source_authors: [Ian Grigg, Alan H. Karp, Jed Donnelley, Tyler Close, David Hopwood, Valerio Bellizzomi]
source_date: 2004-05-06 to 2004-05-15
thread_subject: "Caps v. Nyms (Jed's definition and SOX)"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, identity]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Ian Grigg compares password capabilities with a nymous protocol whose persistent handle is a public key and whose requests are signed by the corresponding private key. A nym resists casual copying from logs or memory dumps because the private key need not appear in the request representation, but it naturally identifies a continuing principal. A password capability is easier to delegate by copying and directly designates one authority, but the same property makes accidental disclosure an authority transfer.

The list rejects a simple winner. Public-key capabilities can preserve the designation-by-possession shape while changing the transfer and introduction costs. Password capabilities can be protected locally by proxying them through an execution environment, destroying proxies on failure, or scrubbing dumps. Those mitigations do not change the protocol primitive, but they do make the local environment security-critical.

The deeper distinction is purpose: a nym answers which key signed a request, while a capability answers which authority the request carries. A system can combine them, but substituting persistent identity for designation recreates the ambient-principal assumptions object capabilities are meant to avoid.

Source: [cap-talk 2004-May archive](http://www.eros-os.org/pipermail/cap-talk/2004-May/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2004-May.txt.gz`, sha256 `6e2fd2dc`), messages dated 2004-05-06 to 2004-05-15.
