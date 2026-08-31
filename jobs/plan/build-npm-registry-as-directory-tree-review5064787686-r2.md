---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1083-resolve-conduct-build-5064787686-r2
priority: high
role: builder
posted_by: gardener
posted_at: 2026-08-31T09:21:43Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the approved npm registry directory-tree design (halt recovery)

Repository: endojs/endo-but-for-bots (bot fork: kriscendobot/endo-but-for-bots).
Approved design: https://github.com/endojs/endo-but-for-bots/pull/1083 and designs/npm-registry-as-directory-tree.md.

This recovery child supersedes the unexecuted parked child build-npm-registry-as-directory-tree from the halted first orchestration. Run only after the preceding weaver and conductor have merged the design PR into llm.

Implement the approved design in full. Replace the bespoke EndoRegistry presentation with the specified package-registry directory-tree capabilities, including the shared platform guard split, Node and Endor adapters, resolver/mapper migration, error and read-consistency contracts, compatibility path, and cross-backend conformance tests described by the design. Preserve the existing fetch, SQLite, integrity, MVS, workspace, peer, optional-dependency, and CAS behavior behind the adapters.

Open the implementation as a draft PR from the bot fork against llm, run the repository-local verification required by the builder role, and report the PR URL and exact executed evidence. Do not mutate or merge endojs/endo upstream.

Source authorization: maintainer @kriskowal approved PR 1083 and directed, "Conduct and build this" in review 5064787686.
