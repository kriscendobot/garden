---
title: HTML observability: CLI publication and cache behavior
source: docs/architecture/html-observability.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: litai render html returns typed refusals as nonzero exits and uses the existing object cache under OBJ_DIR, where a hit must reproduce the exact current artifact; read-only mode creates nothing; publication replaces only files that reconstruct exactly from the known template, rechecks sources before an atomic replace, and never treats cooperative locks as OS isolation.

`litai render html` wraps the typed result in the existing CLI envelope and returns nonzero on a typed refusal. The service uses the existing object-cache ownership marker, CAS, and reference index beneath resolved `OBJ_DIR`. A cache hit must reproduce the exact current artifact at its retained observation time; correct CAS hashes alone do not validate a hit. Reusing a hit at another output path preserves its bytes and changes only the enclosing path field. Off/write-only modes observe the current UTC clock (whole-second precision, so two observations in one second may produce identical bytes). Read-only mode may publish the requested HTML but creates no cache directories, markers, blobs, aliases, or lock files. Output publication always uses the existing project lifecycle lock, outside the object cache.

Publication rejects repository-metadata paths, indirect paths, non-regular files, and output inside the HTML cache. A bounded existing file must reconstruct exactly from the supported template and its embedded observations before it can be replaced; borrowed provenance does not admit edited visible content. This recognizes derived output, not source currency: stale inputs may be regenerated, but foreign or edited files and unrecognized-template artifacts need a new destination. The service rechecks source bytes and the installed binding immediately before publication; temporary bytes are flushed before an atomic replacement, new destinations use a no-clobber link, detected destination changes refuse, and cleanup preserves a foreign replacement at the temporary path. These cooperative-lock and snapshot checks are not same-user OS isolation. Cache failure publishes no output; failed later publication may retain immutable cache objects for a verified observation but never a success claim.

Local CLI, cache, and publication regressions exercise the real graph producer and emitter with explicitly synthetic installation discovery, and a separate real non-editable-wheel run qualifies the CLI/cache behavior; the update/browser journey and hosted integration remain separate gates.

Source: [docs/architecture/html-observability.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/html-observability.md) at commit `fcc40bc`.
