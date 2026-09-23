---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-07T22:04:00Z
---
project: endo-but-for-bots

Ingested Apple's EndpointSecurity reference `es_new_descendants_client(_:_:)` (macOS 27.0.0+) and assessed its relevance to the garden's projects. New domain: macOS EndpointSecurity / OS-level process-and-descendant monitoring — added two new cross-cutting topics rather than bending the endo-centric taxonomy.

## Library ingest (source web--apple-es-new-descendants-client, 3 sections)

- Fetched via `fetch-source.sh`; the canonical HTML page is JS-rendered, so the idempotency anchor is content SHA-256 `fc069413` over the machine-readable `.md` rendering (recorded in `source_snapshot`). source_kind: web.
- Sections: `client-creation-and-signature` (signature/params/return), `descendant-monitoring-semantics` (notify for the caller, auth+notify for the recursively forked/exec'd descendant tree, all else invisible), `muting-and-client-requirements` (process muting unavailable → ES_RETURN_ERROR, path muting works; client entitlement but no root and no TCC).
- New topics: `endpoint-security` (the ES framework) and `process-monitoring` (cross-cutting OS-level process+descendant observation/bounding). Both filed with abstracts and Sections tables; cross-linked to `daemon` and `capability-security`.
- New concepts: `es-descendants-client` and `auth-vs-notify-events`, with 19 keyword lines added to `keywords.md`.
- Indexes updated: `topics/README.md` (2 rows), `concepts/README.md` (2 bullets), `sources/README.md` (1 web row). `sections/README.md` regenerated (+3 rows landed); `topics/README.md` counts regenerated (already current).

## Relevance analysis

Genuine, concrete fit found in ONE project: **endo-but-for-bots**. Its OS-sandbox design lineage (`daemon-os-sandbox-plugin` → `endo-posix-sandbox`, already in the library) confines/observes the process subtrees the daemon spawns for native-program tools, and the superseded parent design *explicitly named the Endpoint Security framework* (alongside user-space FUSE) as a future macOS backend should Apple retire `sandbox-exec`/SBPL. `es_new_descendants_client` is precisely that primitive — descendant-tree-scoped, auth-events give allow/deny enforcement, low deployment friction (no root, no TCC). Wrote `projects/endo-but-for-bots/os-sandbox-endpoint-security.md` recording the fit AND its honest limits: it is a named-but-not-chosen path (the live `endo-posix-sandbox` chose lima + Apple Containerization for macOS, i.e. namespace confinement, not ES monitoring), and OS sandboxing is framed throughout as defense-in-depth, not the authoritative boundary (CapTP/ocap discipline remains primary). Analysis, not advocacy.

Fit assessed and found **weak/absent** for the others, stated plainly in the note: the garden's own gardener fleet is systemd-on-Linux (ES is macOS-only); endo / ocapn / cosgov / agoric-sdk carry no OS-level process-monitoring surface (confinement is ocap/SES or chain-level). No connection manufactured.

## Integrity gate

`library-link-check.sh --changed` → OK; `regenerate-topics-counts.sh --check` → current. Re-verified `--source-slug web--apple-es-new-descendants-client` against the landed tip: OK. All 14 content files landed via `land-journal-edit.sh` through the producer clone; sections index and topics counts regenerated as the final landing step.

## Follow-ups

None. Single compact source, fully ingested in one cycle; no deferred remainder, no follow-on job needed.

Self-improvement: the strongest signal of a "genuine fit" was already in the library — a superseded design section literally naming "Endpoint Security framework" as a future path. Grepping the existing corpus (`grep -ri EndpointSecurity library/`) for the ingested subject BEFORE writing the relevance analysis turned a plausible-but-weak "adjacent to sandboxing" story into a concrete, cited one. Worth doing on every relevance-analysis job: the projects/library may already have named the very API you are ingesting.
