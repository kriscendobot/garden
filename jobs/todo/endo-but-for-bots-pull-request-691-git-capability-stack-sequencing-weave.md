---
role: weaver
---

Weave (rebase) `endojs/endo-but-for-bots` PR #691 ("design: accept and sequence the git-capability stack for the version-controlled-filesystem loop", M3) onto its base branch `llm` to clear its CONFLICTING merge state; the sequencing design is otherwise ready and green (5/5 checks) but stale against base, and resolving the conflict is the prerequisite that lets the maintainer accept and order the live git-capability stack (#705/#706 green, #707 built).
