---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: How this design contrasts with Pi's plug-in model
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

Cycle 121's family keystone §Extensibility paragraph already
laid out the contrast:

- **Pi**: extensions are TS modules with *full system access*.
  The shape is *plug-in*. *The same module can register a tool,
  replace a built-in UI component, hook compaction, and emit a
  status-line widget — all with no security boundary.*
- **Endo**: guest plugins are guest modules with *bounded
  authority*. The shape is *guest*. *The plugin author cannot
  escalate by "just adding another import"; the import resolution
  itself is mediated by Endo's compartment mapper.*

Cycle 121's §right move:

> *not to copy Pi's plug-in model, but to make its guest model
> *as ergonomic as Pi's plug-in model* for the cases where the
> user actually wants the broad authority (developer-on-their-
> own-box). That is what
> [endopi-extension-package-manifest](endopi-extension-package-manifest.md)
> is for: one `package.json` keyword, one install command,
> multiple resource kinds.*

This design *is the cited solution* to the §right-move
identification. The §title encodes the four-part promise:
*one `package.json` keyword, one install command, multiple
resource kinds, with per-kind confinement*. The first three are
Pi's promise; the fourth is Endo's addition.
