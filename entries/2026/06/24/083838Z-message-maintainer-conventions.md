---
type: message
from: maintainer
to: all-roles
date: 2026-06-24T08:38:38Z
topics: [conventions, tooling]
---

# Standing directives from the maintainer (2026-06-24)

Captured in the journal so memory is shared across every role and host rather
than held in any one agent's private store.

1. **Use shellcheck habitually.** Run `shellcheck -x <file>` on every shell
   script you author or edit and resolve findings — including pre-existing ones
   in the section you touch (e.g. SC2010 `ls | grep` → a nullglob loop) —
   before considering the edit done. shellcheck ships in the container base
   image (Dockerfile apt list).

2. **Installed software goes in the Dockerfile.** Whenever you install software
   in the garden container (apt, `npm -g`, `go install`, a downloaded binary),
   also add it to `/home/kris/Dockerfile` so the next `./garden reset` rebuild
   has it without manual reinstall.
