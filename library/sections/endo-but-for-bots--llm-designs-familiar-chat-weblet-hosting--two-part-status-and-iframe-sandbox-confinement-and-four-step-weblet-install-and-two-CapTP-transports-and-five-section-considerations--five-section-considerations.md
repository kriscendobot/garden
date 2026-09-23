---
title: §Five-section-considerations
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
---

The design has §five-distinct-Considerations-sections:

1. **Security Considerations** (six bullet items): iframe-sandboxed; can't access Chat's DOM; capabilities-only-by-explicit-grant; `localhttp://`-origin-isolation; can't navigate top-level window.
2. **Scaling Considerations** (two bullet items): renderer-process-per-iframe → memory; daemon-worker-lifecycle-already-managed.
3. **Test Plan** (five bullets): install + verify guest powers + CapTP + isolation + UI test.
4. **Compatibility Considerations**: existing functionality preserved; per-port weblets work in unified-server without changes.
5. **Upgrade Considerations**: pre-existing CLI-installed weblets need reinstall to get guest-profile affordances.

§Five-section-considerations-shape — §a-rich-design-document-pattern. §Borrowable-pattern: §each-Considerations-section-names-a-different-concern + §a-design-with-multiple-stakeholders-needs-multiple-sections.

§The-Upgrade-Considerations-section is particularly notable:

> Weblets installed before this change (via CLI) won't have guest profiles. They'll appear as regular capabilities in the inventory without the weblet affordances. Users can reinstall them through Chat to get the full experience.

§Borrowable-pattern: §when-a-new-design-creates-a-new-shape-for-old-data, §name-the-migration-path-explicitly. §`Upgrade-Considerations`-as-a-distinct-section-from-`Compatibility-Considerations`: compatibility names §what-keeps-working; upgrade names §what-the-user-needs-to-do-to-get-the-new-features.
