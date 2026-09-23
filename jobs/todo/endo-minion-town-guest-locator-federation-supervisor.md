---
tier: mentat
dispatch: manual
---
handler-timeout: 12600

# Supervisor: minion.town guest-locator federation (endo M4 exit criterion)

Maintainer directive (kriskowal, 2026-09-23), explicit priority over M3's
currently-stated top item. Wear the [orchestrator](../roles/orchestrator/AGENT.md)
role: ground yourself, decompose the remaining real work into child jobs, park
them, and record the orchestration per skills/orchestration/SKILL.md. You are
the ONE-TIME planner/launcher; the deterministic `garden-orchestrate` watcher
is the actual long-running supervisor that drives the children to completion
over however long it takes — you are not expected to babysit this in one
session.

## Goal

A local Endo daemon must be able to connect to a capability on minion.town
identified by its formula identifier, using any CapTP/OCapN dialect both ends
support.

## Acceptance criterion (verbatim from the maintainer)

A user controlling a local daemon and a remote minion.town account must be
able to:
1. Browse to and authenticate on minion.town.
2. From there, obtain a suitable locator for either their own guest formula
   identifier (start here) or some specified object in their grasp.
3. Use the **endo CLI** to adopt that locator, negotiating whatever network
   layers are necessary to bridge, supported by both ends.

## Ground yourself before decomposing — do not work from secondhand summaries

This maps onto the **endo milestone ledger's Milestone 4 (Networking)** exit
criterion ("Two Endo daemons can connect securely over OCapN-Noise. Locator
format supports node identification via agent keypairs.") — read
`designs/README.md` on `endojs/endo-but-for-bots@llm` in full (M4 section,
plus the "Execution lead: Minion Town federation experiment" roadmap table)
for the authoritative, current state before doing anything else. As of this
writing the table shows:

- `daemon-ocapn-external-connectivity` — In Progress, PRs #340, #684, #688,
  #693 (daemon-to-daemon OCapN peer edge, replacing the bespoke
  EndoNetwork/EndoGreeter/RemoteControl stack).
- `ocapn-network-transport-separation`, `slots-ocapn-op-lanes` — In Progress.
- `daemon-agent-network-identity` (per-agent keypairs for network identity),
  `ocapn-noise-cryptographic-review`, `ocapn-tcp-for-test-extraction`,
  `ocapn-tcp-syrup-framing` — Not Started.
- `captp-error-identification`, `daemon-locator-reference` — named as the
  CapTP identity/locator semantics companions.
- `designs/ocapn-nonce-locator.md` (2026-08-31, not yet in the milestone
  table — check its current implementation status directly) specifies the
  server side of exactly what's needed: present a daemon formula identifier
  to the public OCapN bootstrap's `fetch` and receive that formula's
  capability, over `/.well-known/ocapn-cbor-np` / `-syrup-np`.

Re-verify every PR number above against live state (`gh pr view`, or a fresh
`git log`/`git diff` read if `gh` is rate-limited — it was earlier today)
before counting anything as done. Do not trust this list once you've checked;
trust what you find.

On the minion.town side, read `designs/mcp-endo-guest.md` (the gated
Claude-then-Endo-guest chain) in `kriscendobot/minion.town` and the
**guest-formula-id reveal** work (check the repo directly — prior garden
records describe a reveal endpoint as shipped, but verify against the live
repo rather than trusting that description) to find how much of "browse,
authenticate, obtain your guest formula identifier's locator" already exists.

Check the **endo CLI** (`packages/cli`) for whatever "adopt a locator" surface
already exists or is nearest to it — the maintainer's framing ("all of the
parts necessary to build this are present in Endo") means this is very
plausibly an integration/wiring gap across already-built pieces, not new
protocol work. Confirm or correct that assumption with actual code reading.

## Decompose and launch

Once grounded, write the plan as either an update to the relevant design(s)
(prefer editing `daemon-locator-reference.md` / `ocapn-nonce-locator.md` /
opening a fresh integration design if the gap is genuinely new — follow
`roles/designer/AGENT.md` conventions and the frozen-base-branch discipline
for `endojs/endo-but-for-bots@llm`) or, if the remaining work is narrow enough
that a design doc would just restate a short list, put the plan directly in
your completion report. Then decompose into child jobs (design/build/deploy/
validate as appropriate — likely spans both `endojs/endo-but-for-bots` and
`kriscendobot/minion.town`) and set them up as a **serial-by-default**
orchestration per `skills/orchestration/SKILL.md`
(`post-plan.sh --orchestrated --orchestrated-by <this-base>`, then
`post-orchestration.sh`). Use parallel stages only where genuinely
independent.

**Update `designs/README.md`'s roadmap** to record this as a deliberate
maintainer re-prioritization ahead of M3's stated "first priority" client-side
bridge work (2026-09-03 groom pass) — a short, dated note, not a rewrite of
the milestone structure. The ledger is the garden's single source of truth for
priority ordering; don't let it silently diverge from what's actually
happening.

## Guardrails — do not shortcut existing review/deploy discipline

- `endojs/endo-but-for-bots` work follows the garden's manual-gauntlet-trigger
  regime: child build jobs land as **draft** PRs; do not un-draft or bypass
  panel review to move faster.
- `kriscendobot/minion.town` design changes land as **PR review** (maintainer
  directive 2026-07-10); build/config changes may land as direct commits to
  `main` only where that repo's own conventions already permit it (see that
  project's `journal/projects/minion-town/README.md` § Rules of engagement).
- Production deployment to minion.town uses the existing SSM-driven,
  idempotent deploy scripts (`deploy/aws/scripts/*`) — do not invent a new
  deploy path.
- This is real production infrastructure serving real accounts. The final
  validation step (an actual local daemon connecting to a real minion.town
  guest formula over the negotiated transport) is the acceptance test — do
  not report done on a partial/mocked demonstration.

## Report

Your completion report is the plan: what's already done (with re-verified
evidence, not assumption), what you're launching as child jobs and in what
order/parallelism, the orchestration base name, and any open questions for
the maintainer (e.g., if the acceptance criterion turns out to need a design
decision only the maintainer can make).
