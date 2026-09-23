---
source: designs/gateway-package.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/design/gateway-package/designs/gateway-package.md
source_path: designs/gateway-package.md
source_branch: design/gateway-package
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 174
lane: designs
status: current
title: §Formula-identifier-as-bearer-token-reuse (Decision 4)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *The 256-bit hex identifier already represents authority
> over the formula it identifies; the Git endpoint and the
> Chat endpoint use the same tokens for the same authority
> semantics.*

§Reuse-existing-credential-not-new-credential. §Cycle-49's-
daemon-256-bit-identifiers + §gateway-bearer-token-auth
already establish this; the new gateway extends the use.

§Same-token-different-resource: Chat fetch and Git HTTP
both consume the 256-bit hex. §No-new-token-vocabulary.

§HTTP-Basic-with-empty-username-and-token-as-password is
the §de-facto-Git-convention; §HTTP-Bearer is the
alternative; §the-gateway-accepts-both.
