---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
endojs/endo-but-for-bots (Ironhorse/XS engine): add `WeakMap.prototype.getOrInsert`/`getOrInsertComputed` (the upsert proposal covers Map+WeakMap; a `built-ins/WeakMap/prototype/getOrInsert` test262 slice already exists). Cheap — weak-key validation only, no key canonicalization needed.
