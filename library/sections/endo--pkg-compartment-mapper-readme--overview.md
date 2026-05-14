---
title: @endo/compartment-mapper (overview)
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments]
status: current
---

> Abstract: @endo/compartment-mapper packages a module graph into Compartments suitable for evaluation or archival. Three main flows: evaluate from filesystem (resolve imports against a local layout), write an application archive (serialize a module graph for distribution), evaluate from archive (deserialize and run). Plus a Language Extensions sub-section covering supported source-language flavors.

# Compartment mapper

The compartment mapper builds _compartment maps_ for Node.js style
applications, finding their dependencies and describing how to create
[Compartments][] for each package in the application.

Creating a compartment map for a Node.js application allows us to harness
the SES module loader to encapsulate each dependency and grant the least
necessary authority to each third-party package, mitigating prototype pollution
attacks and some supply chain attacks.
Since most Node.js packages do not modify objects in global scope,
many libraries and applications work in Compartments without modification.


Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
