---
title: "Retained library bindings: bundle delivery, public commands, and gate policy"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [tooling, capability-security]
status: current
---

> Abstract: `RetainedBundleDelivery` fetches explicit local files (descriptor-walked, no links) or fixed-origin HTTPS CAS blobs with mandatory TLS, exact headers, explicit bearer auth, no redirects or fallback, and secret-free errors; `project retained-cargo check|materialize|admit` verifies, exclusively publishes, and (with reviewed test-inventory/retirement documents and acknowledgements) admits under full custody, never deleting source; `RetainedLibraryGatePolicy` binds ordered commands, measured tools, and declared external-input variables.

`adapters/retained_bundle_delivery.py::RetainedBundleDelivery` supplies explicit file
and HTTPS retrieval with caller-selected offline policy and finite byte/entry limits.
A local input must be an exact-sized regular file with safe ancestors. POSIX reads
walk directory descriptors without following links; all reads compare the opened
file and final path metadata and verify the pinned bytes before decoding the archive.
A changed input is refused; no cleanup touches a foreign replacement.

HTTPS reuses `HttpsEvidenceStore`'s fixed-origin CAS protocol: the configured base URL
is followed by `/blobs/sha256/<first-two-digest-characters>/<digest>`. This first
transport supports those explicit CAS endpoints, not arbitrary redirecting download
pages. TLS hostname/certificate verification, exact media/size headers and bounded
reads are mandatory. Bearer authentication is explicit local/CI configuration;
there is no ambient authentication or proxy discovery. Redirects, encoding changes,
wrong bytes and unavailable objects fail without fallback. Offline mode refuses
HTTPS before constructing a transport. Errors contain no URL, path, token or content.
The inherited timeout is per network I/O, not a whole-operation elapsed-time bound.

Both methods return the existing immutable `DirectoryExportFile` records only after
canonical archive validation. They do not extract files, publish artifacts, locate
an ambient cache, invoke tools/models, or admit provider qualification.

The public `project retained-cargo check|materialize|admit` commands accept an explicit
local qualification archive or HTTPS CAS base URL. Qualification archives use
`HttpsEvidenceStore` to read the binding's exact `BlobRef`, then reopen their
qualification closure through the current-provider archive verifier. This differs
from decoding a standalone directory export with `RetainedBundleDelivery`; a
directory export alone cannot replace the qualification archive. Local archives
stay under pinned file custody. HTTPS credentials are read only from an explicitly
selected environment variable. Offline HTTPS selection fails before provider
discovery and transport. Checks do not provision packages; materialization verifies
and exclusively publishes or reuses exact package trees. Admission additionally
requires independently reviewed test-inventory and source-retirement documents,
explicit host-execution and retirement acknowledgements, and an absent retired root.
It runs the ordered consumer gates plus attributable tests under the same current
package, source, external-input and measured-tool custody, then emits a canonical
receipt binding every command observation. It never performs source deletion.

Reviewed `RetainedLibraryGatePolicy` records bind the importing project, ordered
commands and measured tool identities. They do not bind a repository source lock.
Each execution separately captures mutable consumer inputs, so source edits
invalidate consumer receipts without changing provider qualification or policy.
Policy review does not by itself prove complete gate coverage.

Gate policy can declare `external_input_variables`: sorted, unique environment names
whose execution-time values select complete external input directories. The field
is omitted when empty, preserving existing policy identities. Host-specific paths
remain outside committed policy. Input capture with that policy requires present,
safe directories disjoint from the project, Cargo home and one another, and applies
the existing entry and byte limits to every captured file. Execution compares the
captured policy identity and rejects tool/command overlays selecting another root.
External source edits invalidate the consumer capture without requalifying the
provider. Declaration is the maintainer's input-coverage review, not automatic
inference of every path an arbitrary script might read.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 429–481).
