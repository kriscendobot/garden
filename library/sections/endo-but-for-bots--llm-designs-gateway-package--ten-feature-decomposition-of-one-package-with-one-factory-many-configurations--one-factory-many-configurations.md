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
title: §One-factory-many-configurations
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

```ts
import { make } from '@endo/gateway';

const gateway = await make({
  powers, config, hostAgent, trustedProxy,
});
await E(gateway).start();
```

§Single-entry-point. §The-config-record-decides-the-deployment-
shape. §Same-code-different-feature-set.

§Cycle-172-@endo/bytes had §per-helper-surface-no-barrel;
this design has §single-factory-many-feature-toggles. §Two-
different-extraction-shapes:

- §Leaf-utility (cycle 172): per-helper imports, no
  configuration; the user picks helpers à la carte.
- §Subsystem-package (this): single factory, runtime
  configuration; the user gets the whole subsystem with
  features gated.

§Both-are-valid-extraction-shapes; §the-choice-depends-on-
what-the-package-does.
