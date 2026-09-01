---
order: serial
children: kriscendobot-minion-town-pr77-conduct-20260901-review5083753201 build-minion-town-pr77-tool-name-reconciliation-review5083753201
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-09-01T22:42:42Z
---

Serially merge the approved documentation/design reconciliation in
https://github.com/kriscendobot/minion.town/pull/77, then build the approved remaining
implementation. Halt on a failed merge so the builder cannot run against an unmerged
design base. Source: maintainer review 5083753201.
