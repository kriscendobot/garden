---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-10-08T20:38:31Z
job: scholar-ingest-source-awesome-ocap-petnames
claim: 0460faca8ad39357
---
# Result: awesome-ocap PetNames source ingest

Ingested five source documents into five one-section clusters:

- `awesome-ocap--wiki-petnames`, content SHA-256 `397ea27b2e14f1141290e239450b50f8ca629898f4c1a1766abd8fe06ea4c143`.
- `zooko--distributed-secure-human-readable-2001`, Internet Archive original-bytes capture SHA-256 `354d22ccf4c42634a56edeeeedaeb3900b056391fa0caf9a61ae869750fdf7af`.
- `dcms-dev--pet-names-true-names-nicknames-2000`, Internet Archive original-bytes capture SHA-256 `fe40bc82035a9379640dc66bab26a80efefc672ad612e8ee0b802efce608db12`.
- `web--miller-petname-markup-language`, erights.org mirror content SHA-256 `80a06600d8ab517566e6216940fa5b396b308f60032af858e1ececdabb84536a`; derived from Mark S. Miller's public text but not the original.
- `papers--stiegler-petname-systems-2005`, Internet Archive PDF SHA-256 `ac432db20f8bef9fd7dd674978fdc404dea9fa87273cde7b0b4771fb7db4569c`.

Created `library/topics/petnames.md`; updated `identity`, `capability-theory`, and `capability-security`; repaired the keyword route from nonexistent `petname` to `petnames`; updated `sources/README.md`, `topics/README.md`, and `keywords.md`. No concept page was needed because the new topic is the narrow routing layer and existing identity/capability topics carry the cross-cutting concepts.

Findings sent to active job `write-endo-docs-article-petnames-zookos-triangle` through `send-msg.sh`: exact attribution and chronology; Zooko's original property definitions and explicit non-proof; keys versus petnames versus alleged/proposed and edge names; the layered-system versus single-global-namespace distinction; PNML's conflicting “proves him wrong” rhetoric; DNS/CA and E-order critiques; confirmed links; and library paths.

Retrieval notes and skips:

- Confirmed and preclassified the wiki, Zooko archive, Shapiro and Frantz dcms-dev posts, PNML mirror, Stiegler PDF, Spritely paper, and Close paper.
- The live Zooko URL returned a 114-byte redirect stub; the 2001 Internet Archive original-bytes capture supplied the source.
- The Walnut page was not retrievable: the canonical host refused connection and both Wayback indexes were temporarily unavailable (`source_retryable=true`).
- Jev classification was unavailable for every fetched document because `TYPESAFE_API_KEY` was absent. Policy was `proceed_unclassified`; no usage token count exists for unavailable calls. Each ingested source carries the unavailability caveat.

Deferred remainder is durably owned by posted job `scholar-ingest-source-awesome-ocap-petnames-remainder`: Spritely 2022, Close 2005, Frantz's reply, retrying Walnut, the DCF demo, linked Endo changelog material, and disposition of the two issue discussions.

Integrity gate: `library-link-check.sh --source-slug` passed for all five committed source clusters; `regenerate-topics-counts.sh --check` reports current. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both landed their projections and are idempotent at the final committed tip.

Self-improvement: nothing this time.
