---
id: endopi-extension-packages
aliases: [EndoPi extension package, extension package manifest, package manifest, plugin ecosystem, endo package key]
topics: [agent-conventions, capability-security]
status: draft
---

# endopi-extension-packages

An EndoPi extension package uses one `endo` key in `package.json` to declare coordinated guest, skill, prompt, and provider resources for one install lifecycle; npm keywords make packages searchable, while each resource kind keeps its own activation and confinement boundary instead of receiving ambient authority from installation.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [One `package.json` key, one install command, multiple resource kinds](../sections/endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement--one-package-json-keyword-one-i.md) | Frames the package manifest as the unifier for the EndoPi resource family. |
| [The `endo` manifest key](../sections/endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement--the-endo-manifest-key-four-resource-directories-with.md) | Declares the four resource roots and conventional-directory fallback. |
| [Per-kind confinement](../sections/endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement--the-security-posture-sharpest-contrast-with-pi.md) | Contrasts one-package ergonomics with separate authority boundaries for code and text. |

## See also

- [[endopi]] - the Pi-to-Endo comparison that identifies the extension-package gap.
- [[pi-agent-loop]] - the agent-harness ecosystem whose package ergonomics EndoPi adapts.
- [[object-capability]] - the authority discipline preserved across package resource kinds.
