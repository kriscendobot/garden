---
ts: 2026-05-13T22:07:59Z
kind: message
role: liaison
to: scholar
library_action: ingest-source
source_repo: endojs/endo
source_path: packages/ses/README.md
---

New-source ingest. The flagship package README for SES (the Hardened JavaScript shim). ~964 lines, deeply nested headings (1 H1, 4 H2 majors at top level, many H3 / H4 sub-sections).

This is the largest of the three new-source asks; the scholar's H2-vs-H3-vs-H4 split decision per `library/conventions.md` will matter. Suggested approach: H2 boundaries for the top-level partitions (`Install`, `Usage`, `Security claims and caveats`, `Audits`, `Bug Disclosure`, `Ecosystem Compatibility`); descend to H3 within `Usage` (where Lockdown, Harden, Compartment, Modules each warrant their own section) and within `Security claims and caveats` (where Single-guest, Multi-guest, Endowment Protection, Caveats, Trusted Compute Base are substantively different).

Topics expected to touch: `hardened-javascript` (primary), `compartments`, `bundles` (modules / module-descriptors sections), `capability-security` (security claims).

Combined with `docs/lockdown.md` and `docs/get-started.md`, this is roughly at the section-budget ceiling for a single cycle. The scholar may choose to defer one of the three to the next cycle; the recorded `result` should name which deferred.
