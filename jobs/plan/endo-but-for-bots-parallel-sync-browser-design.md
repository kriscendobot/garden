---
gate: deferred
priority: low
roadmap: endo-showcase
posted_by: liaison
posted_at: 2026-06-27T05:08:12Z
---

# Design: parallel cis/trans file-tree browser with CapTP direct-sync (Endo showcase)

Map: **design** → dispatch a designer. Target repo: `endojs/endo-but-for-bots`.
Deliverable is a DESIGN DOC under `designs/`. This is a showcase demo for Endo's
value proposition; design only, no implementation in this job.

Vision (from the maintainer): a two-panel ("cis" left / "trans" right) parallel
file-tree browsing space. You mount a file system on each panel and orchestrate
synchronization between them:
- A **lock in the middle**: when engaged, every navigation to another directory
  on either panel is mirrored on the other (locked, parallel traversal).
- **Arrows in the middle**: synchronize the selection from one side to the other
  in the preferred direction — unidirectional (cis→trans or trans→cis) or
  bidirectional.
- Like an FTP client, support the full set of useful synchronization settings
  (newer-wins, size/mtime compare, mirror vs. update, delete-extraneous, dry-run
  preview, conflict handling, include/exclude filters, etc.).
- UNLIKE an FTP client and its core showcase point: using **CapTP and locators**,
  the orchestrator induces the two mounted parties to synchronize **directly**
  with each other (peer-to-peer) rather than relaying bytes through the
  orchestrator. The design should make this third-party-rendezvous the headline
  capability — how locators are exchanged, how the direct CapTP channel is
  established, and how the orchestrator hands off so the transfer never passes
  through it.

The design should: survey where this best lives (Endo's existing UI/weblet/
petstore/daemon surfaces) and what "mount a file system" means in terms of Endo
powers/petnames; specify the panel/lock/arrow UX and the sync-settings model;
and detail the CapTP + locator handshake that achieves direct party-to-party
sync. Call out open questions for the maintainer where the framing is ambiguous.
