---
role: builder
---

Build the `snapshot-mapper` design (Mapper layer of the import-from-mount stack, M3) in `endojs/endo-but-for-bots`: implement `mapSnapshot`/`makeMountReadPowers` producing the `{ compartmentMap, resolution, readPowers }` trio in the compartment-mapper archive layout, consuming the `EndoRegistry` resolution (registry-capability) and the mvs-resolver algorithm just built, stacked on that work.
