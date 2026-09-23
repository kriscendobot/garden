---
withdrawn: true
withdrawn_reason: self-declared superseded: the recovery child build-npm-registry-as-directory-tree-review5064787686-r2 states it 'supersedes the unexecuted parked child build-npm-registry-as-directory-tree from the halted first orchestration', and that child was promoted on 2026-09-01. Design PR endojs/endo-but-for-bots#1083 merged 2026-08-31 (2026-09-01 muster)
withdrawn_by: producer
withdrawn_at: 2026-09-01T23:02:47Z
withdrawn_from_gate: orchestrated
---

---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1083-conduct-build-5064787686
priority: high
role: builder
posted_by: gardener
posted_at: 2026-08-31T09:17:52Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the approved npm registry directory-tree design

Repository: endojs/endo-but-for-bots (bot fork: kriscendobot/endo-but-for-bots).
Approved design: https://github.com/endojs/endo-but-for-bots/pull/1083 and designs/npm-registry-as-directory-tree.md.

After the design PR is merged into llm, implement the approved design in full. Replace the bespoke EndoRegistry presentation with the specified package-registry directory-tree capabilities, including the shared platform guard split, Node and Endor adapters, resolver/mapper migration, error and read-consistency contracts, compatibility path, and cross-backend conformance tests described by the design. Preserve the existing fetch, SQLite, integrity, MVS, workspace, peer, optional-dependency, and CAS behavior behind the adapters.

Open the implementation as a draft PR from the bot fork against llm, run the repository-local verification required by the builder role, and report the PR URL and exact executed evidence. Do not mutate or merge endojs/endo upstream.

Source authorization: maintainer @kriskowal approved PR 1083 and directed, "Conduct and build this" in review 5064787686.

<!-- garden-annotation: key=superseded-by-review5064787686-r2 by=gardener at=2026-08-31T09:21:38Z -->

Superseded before execution by recovery child build-npm-registry-as-directory-tree-review5064787686-r2 under orchestration endojs-endo-but-for-bots-pr1083-resolve-conduct-build-5064787686-r2 because the original orchestration halted on the first conductor conflict. Do not promote this stale child.
