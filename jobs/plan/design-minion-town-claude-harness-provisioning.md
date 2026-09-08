---
gate: orchestrated
orchestrated_by: claude-on-minion-town-designs
priority: normal
posted_by: producer
posted_at: 2026-09-08T18:52:54Z
---

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: provisioning and upgrading the Claude Code harness inside minion.town's container

Repo: `kriscendobot/minion.town`. Child of arc https://github.com/kriscendobot/garden/issues/89 (item 1).

Nothing designed for this yet. Create `designs/claude-harness-provisioning.md`.

Every other item in the arc presumes a Claude Code harness is present locally in the
minion.town Docker container. Today it is not. Design how it gets there and how it
stays current without a human babysitting it.

Cover at least:
- **Install.** How the harness lands in the image (build step, layer, cache behavior),
  and what the image does when the install fails. Consider install size and cold
  `docker build` time; the deployment is on AWS and the build is already long.
- **Pinning.** The exact version the image pins, where that pin is recorded so a
  reader can see it without reading a Dockerfile, and how a rebuild is reproducible.
- **The standing upgrade obligation.** This is the part that matters and the part the
  maintainer flagged. Propose a concrete upgrade cadence and mechanism: who notices a
  new harness release, what validates it before the pin moves, what the rollback target
  is, and what evidence a successful upgrade must produce. The garden already has
  precedent for cadence-gated dependency work (see `roles/botanist/AGENT.md` and the
  dependabot watchers) and for attested host operations (see `designs/sysop.md`); reuse
  rather than invent where the shapes fit.
- **Credential separation.** The harness in the image must carry no credential. State
  plainly where credentials enter at runtime and why the image is safe to publish.
- **Interaction with `ENDO_CLAUDE_ENABLED`.** The Claude-agents wiring is already gated
  behind that flag (https://github.com/kriscendobot/minion.town/pull/87). Say whether
  harness presence is gated by the same flag or is unconditional, and why.

Deliverable: one design document landed per the garden's design conventions, with an
`## Open questions` section only if there are genuinely maintainer-facing forks. Do not
build anything.
