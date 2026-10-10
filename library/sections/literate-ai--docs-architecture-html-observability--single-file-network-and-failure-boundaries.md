---
title: HTML observability: single-file network boundary and failure semantics
source: docs/architecture/html-observability.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, web-frontend]
status: current
---

> Abstract: Views inline all application CSS/JS and may reference only SRI-pinned HTTPS CDN libraries, with honest readable fallbacks when a library is unavailable or JavaScript is off; labels and excerpts are escaped and graph IDs generated; unknown or unsafe requests return typed refusals rather than partial success, and new JSON surfaces extend the registry without replacing graph derivation.

Application JavaScript and CSS are inline, with no companion asset tree or bundler. The contract permits explicit HTTPS CDN library references with SRI instead of vendoring libraries inline, keeping library bytes independently pinned and visible in provenance. That does not make a CDN-dependent interactive view offline: the renderer must provide an honest readable fallback when the library is unavailable, and the `inline-only` policy refuses the library-dependent DAG view. Library loading is deferred so native content appears first; local catalog filtering, node selection, and source inspection keep working after CDN failure while pan/zoom/layout controls show an explicit unavailable message, and with JavaScript disabled the native disclosures still expose verified previews.

`adapters/html_dag_view.py` owns fixed inline CSS/JS and the exact asset pin. Graph identifiers passed to the library are generated, not untrusted selector strings, and native options and inspector content use text values, not HTML insertion. The library lays out existing edges without deriving another graph: isolated projections use a grid, connected ones seed that grid and use bounded built-in CoSE with randomization disabled. Interactions are local transforms; previews never trigger a browser file or network fetch. Rendering escapes untrusted labels and excerpts, including `</script>` and HTML comment openers inside embedded JSON, and code validates cross-field counts and actual HTML references, not just schema shape. An embedding attestation is a claim to verify, not a sandbox.

Unknown surfaces/views, unavailable input, unsafe output, and incompatible cache or asset policies return typed refusals rather than partial success. A project with no declared artifact skips the staleness gate; missing or malformed provenance in a declared artifact is a finding; verification must not regenerate files. Phase 2 can register more named JSON surfaces without replacing graph derivation: the authority-graph schema gives `literate-ai/authority-graph@2` a catalog URN without changing its discriminator or exporters, and its source adapter calls the existing producer, validates the actual JSON, and binds the existing graph identity (observing the graph, not the CLI wrapper's absolute paths), so relocating an identical project does not change the binding.

Source: [docs/architecture/html-observability.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/html-observability.md) at commit `fcc40bc`.
