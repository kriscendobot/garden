---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: The §`endo` manifest key — four resource directories with
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

auto-discovery defaults

The §Manifest subsection shows the shape:

```json
{
  "name": "my-endo-package",
  "keywords": ["endo-package", "endo-skill"],
  "endo": {
    "guests": ["./guests"],
    "skills": ["./skills"],
    "prompts": ["./prompts"],
    "providers": ["./providers"]
  }
}
```

The §auto-discovery-defaults discipline: if the `endo` key is
absent, the installer scans for directories named `guests/`,
`skills/`, `prompts/`, `providers/`. *Convention over
configuration* — packages that follow the default layout don't
need the manifest at all.

The §forward-compatibility discipline: *`themes` and other
resource kinds are added as new types emerge; the manifest is
extensible without breaking older readers* — unknown keys are
ignored. The §Out of scope reinforces: *backwards-incompatible
manifest changes... we never need a v2 manifest*.
