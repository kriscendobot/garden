---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §exhaustive-mechanical-inventory discipline
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

The §Rename Inventory section is *exhaustive enough that a
builder can execute it mechanically*:

- **File renames**: 13 files in `packages/daemon/src/` (table).
- **Identifier renames**: per-file enumeration with line
  numbers (`makeDaemon` at line 5427; `makeDaemonCore` at line
  294; etc.).
- **Consumer updates**: workspace search with concrete grep
  recipe.

The §grep-recipe-as-source-of-truth provision:

```sh
grep -rlE '\b(makeDaemon|DaemonCore|DaemonFacet|DaemonInterface|
DaemonDatabase|DaemonicPowers|DaemonicPersistencePowers|
DaemonicControlPowers|DaemonicGoPowers|WorkerDaemonFacet|
DaemonFacetForWorker|DaemonWorkerFacet|DaemonNode|DaemonProcess|
MignonicPowers)\b' packages/
```

is named as the *builder's authoritative source of truth*. The
§automate-the-find-step discipline: the design doesn't claim its
own enumeration is complete; it names the *command* a builder
should run.
