---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: §Listing + removal + config — Pi-mirrored lifecycle
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

The §Listing and removal subsection adds three commands:

```sh
endo list packages
endo remove npm:@foo/bar
endo config           # Plus enable/disable mirroring Pi's pi config
```

The §pi-mirrored discipline: *mirroring Pi's `pi config`* names
the existing-tool-pattern this design follows. The §enable/disable
without uninstalling is the *temporary-deactivation* feature that
makes opt-in/out cheap.
