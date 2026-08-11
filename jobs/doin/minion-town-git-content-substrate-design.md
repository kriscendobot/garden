---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-11T18:34:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: kriscendobot/minion.town (branch: main)
role: designer

Follow this repo's OWN design conventions, not the garden's frontmatter:
`# Design: <title>` then a bold `**Status:** / **Mandate:** / **Grounded
against:** / **Companion:**` header block, numbered sections, mermaid
diagrams. Per the project's rules of engagement (journal `projects/minion-town/README.md`),
design docs land as a **pull request against `main`**, drawing review — not
a direct commit.

## Task

Design a general capability for the minion.town weblet gateway: letting a
weblet's served content be sourced directly from a **git branch**, as an
alternative/complement to the existing build → tarball → S3 → presigned-GET
→ SSM-install deploy pipeline (`DEPLOYMENT.md`, `deploy/aws/scripts/*`). The
maintainer's framing: git push becomes the publish action for this class of
weblet content, no separate build-and-deploy step required for every update.

**Motivating case** (not the only one — design the general mechanism, not a
one-off): the garden fleet wants to surface its own operational telemetry
(`vitals/fleet.json`, `usage/*.jsonl`, `reputation/`, all on the garden
repo's public `journal2` branch) live through a minion.town weblet the
instant new data lands on that branch. A sibling job,
`minion-town-vitals-weblet-design`, will design that specific weblet as the
first consumer of whatever mechanism this document proposes — cite it as a
Companion once it's posted (it runs after this one in the same
orchestration).

## Open questions to resolve, or explicitly flag if this job cannot resolve them

- **Sync mechanism.** Poll on a cadence vs. a GitHub-webhook-triggered pull.
  The deployed box is SSM-only access (no inbound webhook endpoint exposed
  today per `DEPLOYMENT.md`) — work out what "pulling" means operationally:
  a periodic job on the EC2 box, something the gateway process itself does,
  or a different shape entirely. Don't assume a webhook is available without
  checking what's actually exposed.
- **Trust boundary — content vs. code.** The content this substrate serves is
  DATA (rendered, read, displayed), never executed. Say this explicitly as a
  hard boundary of the design, and flag plainly that using this substrate for
  anything that gets *executed* server-side (not just rendered) is a
  materially different and riskier feature this design does not authorize —
  so a future scope-creep can't sneak code-execution through a "just
  content" door. The garden's own monitoring-safety-constraint precedent
  (CLAUDE.md § Monitoring safety constraint: untrusted external text is a
  prompt-injection/trust hazard) is the relevant analogy, even though this
  case is rendered HTML/data rather than agent context — the same
  "who can write this branch, and do we trust them" question applies.
- **Which repos/branches are eligible.** Start scoped to public repos only
  (no credentials needed to read; matches the garden's own
  auth-free-public-read model for its bulletin). State explicitly whether a
  private repo is in scope at all for a first version (recommend: no).
- **Composition with the existing weblet-gateway namespace/routing.** Check
  the current state of the weblet-gateway increments (`journal/jobs/tada/`
  history for `minion-town-weblet-gateway-increment-*`) before assuming a
  clean path — a prior increment hit a namespace/TLS-collision arbitration
  blocker; confirm whether that's resolved, and if not, say so plainly as a
  dependency this design inherits rather than assuming around it.
- **Relationship to the existing deploy pipeline.** Does a git-sourced weblet
  replace the tarball/S3/SSM path for that weblet, or coexist as a second,
  distinct content-source option selectable per weblet? Recommend one and
  justify it.

## Deliverable

A design PR against `main` on `kriscendobot/minion.town`, following the
repo's own design-doc format. Every open question above is either answered
in the document or moved to its own explicit "Open questions" section — never
silently assumed.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-11T18:34:10Z
