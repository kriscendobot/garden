---
ts: 2026-06-11T05:24:22Z
kind: result
role: journalist
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/11/045739Z-result-scout-8f5fb7.md
  - entries/2026/06/11/dispatch-liaison-dd5978.md
---

# Result: essay B4 — the host's pitch (O2)

Draft path: `projects/endo/drafts/hosts-pitch-2026-06.md`
(status: draft-for-maintainer-triage).

Abstract: B4 addresses the person who already runs something for a
community (Mastodon admin, Discord owner, homelab operator) and pitches
operating an Endo hub as the same node one runs for oneself, extended to
serve members ISP-style (relaying/NAT traversal, mail, anonymisation,
curation, always-online capabilities) on attenuated per-member
capabilities rather than ambient authority. Candor is the persuasive
register: the essay states plainly that the capability model shrinks the
technical attack surface while the human burdens (moderation, legal
liability) mostly remain, and it carries an explicit shipped / designed /
named-gap accounting so the audience is not asked to run a community on a
roadmap. It closes by asking only that the operator try the single-user
node and hold the project to the named gap list before standing up a hub.

Open problems acknowledged by name (all from the scout gap inventory):
member OAuth sign-in (gap, M5); member account/key recovery (gap, M5);
first-boot ceremony (undesigned); state custody backup/restore/migration
(undesigned); always-online upgrade channel (undesigned); operator
observability-vs-surveillance tension (undesigned); O2 multi-tenancy
(member isolation, hub economics, member-vs-operator billing, abuse
handling, moderation posture — undesigned); operator legal liability
(stated structurally, not resolved).

Sources cited: canon "A Choice of Giants" overview
(`library/sections/kriskowal-com--giants--overview.md`); operator-burden
research (`library/sections/mastodon-docs--operator-burden-and-liability.md`)
for the four-level/three-level moderation surface, the legal-exposure
structure, and the finer-grained-controls positive case; scout
reconnaissance (`entries/2026/06/11/045739Z-result-scout-8f5fb7.md`) for
the O2 entrainment map and gap statuses; the ledger
(`project/designs/README.md`) for status labels.

Status discipline: shipped claims limited to ledger-Complete items
(OCapN-Noise network PR #137; daemon / content-store / check-in-checkout /
XS-worker metering). `endo-gateway` and the networking, invitation, and
app-sharing designs are labelled Proposed/In Progress/Not Started; the
named gaps are labelled undesigned. Nothing Proposed/In Progress was
claimed shipped.

Canon discrepancies (reported, not resolved, per brief §6; both already
logged by the scout, repeated here as they bear on this essay's status
claims): (1) `daemon-agent-network-identity` is "Not Started" in the
README summary table but "In Progress" with items 1–2 Done in the design
file — the essay names it only as substrate and makes no shipped claim on
it, sidestepping the conflict; (2) the M5 gateway-package /
packaging-ci / aws-deployment / aws-attuned designs are listed Proposed
in the ledger but their files are absent from `llm` (they live on
unmerged PR #356/#343) — the essay treats the hosted gateway as
Proposed-and-partly-on-unmerged-branches rather than citing those files
as extant designs.

Self-improvement: nothing this time. The essay-authoring role-stretch
worked cleanly within the journalist's style and journal-sync disciplines;
no structural lesson warrants a role or skill change.
