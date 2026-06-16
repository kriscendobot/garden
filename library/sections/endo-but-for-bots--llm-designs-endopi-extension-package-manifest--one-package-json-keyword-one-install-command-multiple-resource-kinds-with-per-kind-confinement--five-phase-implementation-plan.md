---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: Five-phase implementation plan
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

The §Phased implementation lists five phases:

1. **Manifest read + skill installs.** `endo install` recognizes
   `endo.skills`, drops content into the discovery path.
2. **Prompt + provider kinds.** Same shape, more directories.
3. **`endo list packages` + `endo remove`.** Lifecycle.
4. **`endo config` for enable/disable.** Disable a package
   without uninstalling.
5. **Pinning + updates.** `endo install npm:@foo/bar@1.2.3`
   semantics, `endo update`.

Phase 1 is *skills-only* because cycle 112's skills format is
already designed; the rest of the family follows. The
§incremental-adds-one-kind-at-a-time discipline lets each phase
ship independently.
