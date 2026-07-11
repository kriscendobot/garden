---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-11T03:20:59Z
---
# Scholar cycle — habitat-chronicles.com "What Are Capabilities?" (Morningstar 2017)

Job `scholar-ingest-source-habitat-chronicles-2` (follow-on to
`scholar-ingest-source-habitat-chronicles`, which ingested The Unum Pattern).
Ingested Chip Morningstar's canonical plain-language object-capability explainer
**What Are Capabilities?** (https://habitat-chronicles.com/2017/05/what-are-capabilities/,
2017-05-07). Fetched live via `scripts/jobs/fetch-source.sh`
(`source_fetched_via=direct`, content SHA-256
`e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f`; the
"stub-suspect" warning was a false positive — Morningstar's prose contains "to be
written"). ~77k chars, H3 structure preserved.

## Source ingested (1 source, 7 sections)

`sources/habitat-chronicles--what-are-capabilities.md` (`source_kind: web-essay`), sections:

- `--overview` — preliminary remarks; the confusing term, the "ocap" contraction, the controversy.
- `--designation-and-authority-the-idea` — "don't separate designation from authority"; the Word/Save ACL flaw; **Hardy's Confused Deputy** (the FORTRAN-compiler billing story); ambient authority; 5–8 of the OWASP top 10.
- `--what-a-capability-is` — precise definition; transferable → delegation; unforgeable; **creation / transfer / endowment**; ocap = OOP + strictness.
- `--capability-patterns` — modulation (**revoker**), attenuation, abstraction (**POLA**), combination (the signed-camera example).
- `--embedded-and-compartmentalized-computation` — KeyKOS, seL4; virtualization; **Frozen Realms** (the direct ancestor of Endo SES/lockdown).
- `--distributed-services-and-engineering-practices` — the **service-chaining** problem, Mint, Karp's Zebra Copy, OAuth2 bearer tokens; the **three rules for taming Java**; taming; fewer bugs.
- `--conclusion` — capabilities as computer security's **germ theory**; why "who are you?" is incoherent; acknowledgements (names Norm Hardy, Alan Karp, Mark Miller, Kevin Reid, **Kris Kowal**).

## Concept pages

- **New:** `concepts/confused-deputy.md` — filled a genuine gap: `confused deputy` had multiple keyword entries but no concept page (they dangled to a section-redirect). This essay is the canonical plain-language telling (Hardy's FORTRAN story). Repointed the dangling keywords to it and added a back-link from `object-capability`.
- **Section rows added** (via `insert-sections-table-row.sh`) to: `object-capability` (2), `caretaker-pattern` (1), `principle-of-least-authority` (2), `granovetter-operator` (1), `habitat-unum` (1, the Electric-Communities/E cross-link).

## Topic pages touched (section rows via inserter)

`capability-theory` (4), `capability-security` (5), `patterns` (1), `hardened-javascript` (2). No new topics (all pre-existed).

## Indexes

`sources/README.md` (+1 row under Web essays and surveys), `concepts/README.md`
(+`confused-deputy` row), `keywords.md` (+44 lines, incl. repointed
confused-deputy keywords and this essay's terms). `sections/README.md` and
`topics/README.md` Sections-count column regenerated as the final landing step.

## Integrity gate (step 8)

- `library-link-check.sh --changed` → **exit 0** (every checked link resolves to a committed file).
- `regenerate-topics-counts.sh --check` → exit 1 STALE (informational: my added rows made counts stale; no missing topic page). Reconciled to current by `--land` in step 9; post-land `--check` → **exit 0**.
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both landed current.

## Follow-on

Posted `scholar-ingest-source-habitat-chronicles-3` (plan/, gate=deferred
priority=low) for the remaining germane essays: A Slightly Skeptical Perspective
on REST, The Tripartite Identity Pattern, Adventures in LLM Land.

Self-improvement: this cycle used the `web-essay` schema, the `habitat-chronicles--`
thematic prefix, and every deterministic helper (fetch-source, insert-sections-table-row,
library-link-check, land-journal-edit, regenerate-*) without friction — no library-convention
gap surfaced worth routing to the mentor. The one reusable observation: when an essay is
the canonical plain-language telling of a term that already has dangling keyword redirects
(here `confused deputy` → a section), promoting it to a real concept page and repointing the
keywords is high-value index-on-the-fly work that fits squarely in a single ingest cycle.
