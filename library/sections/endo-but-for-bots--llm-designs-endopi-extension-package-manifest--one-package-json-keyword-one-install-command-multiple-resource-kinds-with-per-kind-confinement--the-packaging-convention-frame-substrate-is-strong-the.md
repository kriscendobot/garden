---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: The §packaging-convention frame — *substrate is strong; the
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

convention is missing*

The §Motivation paragraph names the asymmetry:

> *The gap is not the daemon-side substrate (which is already
> strong) but the *packaging convention* that lets one author
> ship a coordinated set of resources.*

The discipline: Endo already has all the resource-kind
substrates (guests = SES + capabilities; skills = cycle 112's
markdown format; prompts = cycle 129's prompt templates;
providers = cycle 128's registry). What's missing is the
*authoring + distribution surface* that lets one npm package
ship a *coordinated set*.

Pi solves this with a `pi` keyword in `package.json` + `pi
install` resolving all four resource kinds. The author manages
one distribution channel; the consumer runs one install command.
