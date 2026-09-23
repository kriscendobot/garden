---
title: "Programming with capabilities without exclusive ownership"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-October/
source_snapshot: http://web.archive.org/web/20160730015229id_/http://www.eros-os.org/pipermail/cap-talk/2003-October.txt.gz
source_content_sha256: 5c3eea510fe625cf0629554a05b5b9e770b6bb912af6d60d4c4f26d19ead7806
source_authors: [Rickey Braddam, Mark S. Miller, Charles Landau]
source_date: 2003-10-20 to 2003-10-22
thread_subject: "Programming with capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, patterns]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A proposed capability desktop tries to organize every object under one exclusive owner. Miller and Landau answer that "ownership" is either inert metadata or a bundle of authorities that should remain explicit capabilities. Creation can initially give one object exclusive reachability, but subsequent delegation makes a permanent single-owner relation misleading. Reclamation, representation-level debugging, and maintenance operations are distinct authorities: a space bank supplies destruction authority, while an object-specific maintenance facet supplies privileged application operations without special kernel support.

## Creation is not a permanent authority hierarchy

An object creator may initially hold the only customer capability, then share or attenuate it. Lower-level allocators can independently retain reclamation or debugging authority. Calling all of these relationships ownership obscures which effect each holder can actually cause and suggests exclusivity that delegation deliberately removes.

## Model the verb as a facet

If ordinary customers should invoke one interface and an administrator should perform maintenance, give them different facets. If a resource bank must reclaim a subtree, represent that with the bank's destruction capability. Capability-oriented programming replaces a universal owner relation with narrow references whose interfaces say what can be done.

## A secure kernel does not repair ambient software

The exchange also cautions that placing an ambient-authority desktop on a capability kernel does not automatically improve the desktop's security. The programs and user environment must expose and pass narrow capabilities; isolation in the substrate is useful only when the layer above preserves it.

Source: [cap-talk 2003-October archive](http://www.eros-os.org/pipermail/cap-talk/2003-October/) (Internet Archive original-bytes snapshot `web/20160730015229id_/.../2003-October.txt.gz`, sha256 `5c3eea51`), messages dated 2003-10-20 to 2003-10-22.
