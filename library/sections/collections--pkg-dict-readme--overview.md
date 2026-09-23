---
title: Dict structure
source: packages/dict/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/dict` is a dictionary, a map whose keys are strings. JavaScript objects are themselves dictionaries but with restrictions on the key domain; Dict harnesses a single JavaScript object while fully opening the domain of expressible keys (escaping the reserved/`__proto__`-style hazards), implementing the full map-like collection interface over it. Based on Domenic Denicola's `dict` implementation.

Dict is a dictionary, a map with strings for keys. JavaScript objects are dictionaries with some limitations on the domain of keys. The dictionary implementation harnesses a single JavaScript object and fully opens the domain of expressible keys, implementing the gamut of map-like collection methods.

```
npm install @collections/dict
```

Based on the [dict implementation by Domenic Denicola](https://github.com/domenic/dict).

Source: [packages/dict/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/dict/README.md) at commit `4688abad`.
