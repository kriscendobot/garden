---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: One `package.json` keyword, one install command, multiple resource kinds with per-kind confinement
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

> *The gap is not the daemon-side substrate (which is already
> strong) but the *packaging convention* that lets one author ship
> a coordinated set of resources.*
>
> — `designs/endopi-extension-package-manifest.md` §Motivation

`endopi-extension-package-manifest.md` (149 lines, *Proposed*
status, created 2026-05-15) is the eighth endopi-* design ingested
and the sixth spinout from cycle 121's family keystone. Parent:
`endopi.md`. The design closes the §Extension model gap surfaced
by cycle 121's keystone: *Pi extensions can ship both code and
resources (skills, prompts, themes) under one keyword in
`package.json`, and a single `pi install` command resolves them
all. Endo's `endo install` is single-purpose.*

This design is the *cross-referenced family unifier* — it
consumes four prior endopi-* designs through its `endo`
manifest key: `guests` (Endo native), `skills` (cycle 112),
`prompts` (cycle 129 - prompt-templates, still unindexed), and
`providers` (cycle 128).
