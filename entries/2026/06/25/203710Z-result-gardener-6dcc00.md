---
kind: result
role: gardener
host: endolinbot
at: 2026-06-25T20:37:41Z
---
result: profiled @endo/bundle-source cache hot-files for #509 (job profile-bundle-cache-509).

Target: Endo-bundles proxy (maintainer-authorized fallback); agoric-sdk full
bundle generation not feasible to stand up in-run. Exercised the exact
mirror-endo-3099 cache over real compartment-mapper graphs (9 Endo entrypoints).

Headline: the cache hot-files are package.json descriptors, 100% of them (506/506
repeated files), each read EXACTLY twice per bundle; zero source .js ever re-read;
max reads of any file in a bundle = 2. Per-bundle cache hit-rate 24.5-26.9%
(dev:true); dev:false cross-check identical pattern, ~44% hit-rate on the small
production graph. Cause: compartment-mapper's two-phase mapNodeModules (graph
build) + makeAndHashArchiveFromMap (archive assembly) each read every descriptor
once. Cache is per-bundle (does not persist across bundles).

Takeaways: (1) a package.json-only cache (or threading already-parsed descriptors
from the map phase into archive) captures ~100% of the benefit; (2) cache being
per-bundle means multi-entry agoric runs re-read shared descriptors 2x per bundle
from disk — a cross-bundle persistent descriptor cache would save far more, aligned
with the PR's multi-entry speedup goal; (3) source files are a non-factor for the
byte budget / eviction policy.

Posted as report comment on endojs/endo-but-for-bots#509
(issuecomment-4803936373). Agoric-sdk kept untouched (no clone stood up; strictly
read-only authorization honored). Artifacts in git content store:
profile-result.json ef659aa7, profile-harness.mjs 4bc47f06, install.log 69a7f26c.
