---
posted_at: 2026-11-05T08:21:41Z
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Replace the PR body of endojs/endo-but-for-bots#1652

Host oros-studio's PAT gets a 403 on updatePullRequest, so this edit is pinned to endolin.
Panel-1 (pruner) asked for the padding in the Documentation and Testing Considerations sections to be removed, and the Security section still says "authenticated manifest", superseded by commit c5f67c7c7c.

Replace the body of https://github.com/endojs/endo-but-for-bots/pull/1652 with exactly the text between the markers, using `gh pr edit 1652 -R endojs/endo-but-for-bots --body-file <file>`. If the body has since changed by another hand, apply only these three section edits rather than overwriting. Change nothing else: no commits, no un-draft.

----- BODY -----
## Description

This draft consolidates Endo's pet-name, mount, platform filesystem, storage, and agent-editing designs into one normative virtual-filesystem contract and first user-documentation draft. It distinguishes implemented, designed, and proposed behavior; specifies the view algebra, opaque content-equivalence CAS, bounded read/search/edit/diff/patch/merge surfaces, reference-level splicing, capability-link archive format, and ownership boundaries; and records inconsistencies with recommended resolutions. The live design roadmap now indexes the design in M3, its dependency graph, and its estimates without double-counting existing filesystem work. Requested by kriskowal on 2026-11-05.

### Security Considerations

The design keeps authority on held CapTP references, separates client and mutability-controller facets, makes attenuations monotonic, and treats serialized locators as bearer secrets. Review should attend particularly to snapshot comparison across providers and to the signed manifest, verified against the restorer's trusted signers, as the only classifier of capability links.

### Scaling Considerations

The proposed size-limited reader facet, streaming or paged searches and diffs, range reads, and reference-level transforms prevent large values from being materialized in agent context. The build is phased so bounded reads and search can land before controller and archive work.

### Documentation Considerations

The design is itself the first draft of the user documentation.

### Testing Considerations

Documentation only. Implementation PRs carry the design's shared conformance suite.

### Compatibility Considerations

No runtime behavior changes in this PR. The proposed common interface preserves current spellings behind adapters while migrating public correctness checks from exposed hashes to opaque identities.

### Upgrade Considerations

No deployment upgrade is required for this design PR. The ten-rung build ladder isolates future compatibility changes and retires aliases only after daemon, platform, exo-git, CLI, Chat, endopi, and agent-tool consumers migrate.

<!-- garden-job: design-endo-unified-virtual-filesystem-20261105 -->


----- END BODY -----
