---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: §Out of scope — *centralized registry* declined
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

The §Out of scope paragraph names two declines:

- **Centralized registry.** *Pi browses npm with a keyword
  search. Endo follows the same npm convention (`keywords:
  ["endo-package"]`); a registry is unnecessary and would add a
  moderation surface Endo does not want to operate.* The
  §no-moderation-surface discipline: maintaining a moderation
  surface is a non-trivial operational commitment; *unnecessary*
  here because the npm keyword convention already gives the
  searchability.

- **Backwards-incompatible manifest changes.** The manifest is
  forward-compatible by design (unknown keys ignored), so *we
  never need a v2 manifest*. The §forever-v1 discipline keeps
  the convention stable across future additions.
