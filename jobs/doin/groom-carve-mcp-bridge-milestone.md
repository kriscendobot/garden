---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Groom job: carve out a milestone for the two client-side-bridge capabilities
identified this session, position it as the first unfinished milestone in the
endo roadmap, bump the rest of the roadmap down accordingly, and get the
bulletin to reflect the new priorities.

## Background (grounding — read before touching anything)

A liaison session tonight (2026-09-02/03) hit a concrete, reproducible pain
point building a live counter on a minion.town clip: getting an artifact
across the MCP/CapTP bridge required either (a) hand-typing tens of thousands
of base64 characters into a tool call — which actually corrupted mid-copy and
had to be discarded — or (b) reverse-engineering the CapTP wire protocol from
source to hand-write a ~10KB client narrow enough to transcribe reliably. Both
are real, present-day bottlenecks, and both already have a name and a design
home:

1. **`designs/git-remote-capability.md`** (kriscendobot/minion.town PR #41,
   merged 2026-08-11, "design: the capability-addressed git remote" — spec
   only, no live change). Maintainer-mandated (@kriskowal, 2026-08-11):
   Minion Town HTTP as a git remote per guest, capability-URL addressed,
   authorizing read/write into a CAS partition — `git push` becomes the way
   to get an artifact into an Endo directory, no MCP-tool-call byte
   marshaling. § 12 says the follow-on implementation in
   `endojs/endo-but-for-bots` is "named but not actioned." Companions named
   in the design: `designs/git-content-substrate.md` (#39, merged, the
   read-side projector this supersedes in framing), `designs/vitals-clip.md`
   (#40, a consumer needing reconciliation), `designs/clip-gateway.md`,
   `designs/ocap-site-clip-isolation.md`, `designs/mcp-endo-guest.md` /
   `designs/mcp-daemon-guest-tools.md` (the guest/grant-site/inventory this
   authorizes through).
2. **`@endo/claude confinement core`** (endojs/endo-but-for-bots PR #1015,
   open draft) and **`design(claude): provision Claude-backed child guests`**
   (PR #1102, open draft). This is the other half: an agent running *inside*
   a guest, acting with normal tools directly on the daemon side, instead of
   an external agent marshaling everything across the bridge by value.

Both are already-designed, not-yet-built. Tonight's session is fresh,
concrete evidence for prioritizing them; the maintainer has not yet been
asked to choose between them, and this job does not choose either — it makes
sure both (and anything that genuinely depends on or blocks them) sit at the
top of the roadmap together, since they solve two halves of the same
bottleneck class ("get code/state across the MCP-daemon boundary without an
external LLM hand-marshaling bytes").

## What "the roadmap" is here

The authoritative numbered-milestone ledger is `designs/README.md` on
`endojs/endo-but-for-bots@llm` (M1..M11 as of the last groom pass,
2026-07-02 — re-fetch current state, do not trust that number). minion.town
has no equivalent in-repo ledger (confirmed: no `designs/README.md` on
`kriscendobot/minion.town@main`) — its design corpus is tracked loosely in
`journal/projects/minion-town/README.md` on this garden's `journal2`. The
maintainer has already directed that minion.town's Endo-touching work grows
`@endo/gateway`/`@endo/mcp` organically as part of the *same* endo direction
(closing endojs/endo-but-for-bots#134, 2026-07-09) — so folding a
minion.town design into the endo milestone ledger is consistent with
standing direction, not a stretch you need to invent.

The bulletin's own roadmap-relevance signal (`roadmap_index` in
`scripts/jobs/bulletin.sh`) reads `journal2:plan/designs/**/*.md`
frontmatter (`pr:`, `repository:`/`repo:`, `roadmap_relevance:` 0-100 or
`priority:`, `milestone:`). Today that tree only has an
`endo-but-for-bots/` subdirectory — no `minion-town/` subdirectory exists
yet.

## Do this

1. **Fetch current state, don't trust anything above as still-accurate**:
   the endo ledger (`designs/README.md` @ `llm`, current tip), the current
   `journal2:plan/designs/endo-but-for-bots/` frontmatter for every design,
   and the current status of PR #41 (minion.town), #1015 and #1102
   (endo-but-for-bots) — confirm none have landed or changed status since
   this brief was written.

2. **Find the first unfinished milestone** in the endo ledger (lowest
   M-number not marked Complete).

3. **Judgment call, and document your reasoning for it**: does the
   git-remote capability + the Claude-confinement work genuinely belong
   *inside* that first unfinished milestone's scope (re-word its
   description/exit-criteria to name them), or are they enough of a
   distinct concern that they need their own new milestone spliced in
   *ahead* of it (renumbering/resequencing what follows)? Either way, the
   result must read as **the first unfinished milestone now names both
   capabilities plus their directly-dependent companions** (the ones listed
   above under each PR, plus anything else you find that clearly blocks or
   is blocked by them — check both PRs' own descriptions and any linked
   issues for a "depends on" / "blocks" relationship before including
   something as "related").

4. **Bump the rest of the roadmap down**: every other milestone's relative
   order/priority in the ledger reflects that this carved milestone now
   comes first. Do not silently drop or delete anything — a lowered
   priority, not a removal.

5. **Land the ledger edit the way the last roadmap groom did it** (see
   `journal2:jobs/tada/groom-refine-endo-roadmap.md` for the precedent and
   its stated reason): a v2 gardener job is constrained to the journal
   lander for `projects/` edits and cannot push straight to the fork's
   `llm` branch, so the *authoritative* ledger edit on
   `endo-but-for-bots@llm:designs/README.md` needs a real PR against that
   repo (design-doc PR conventions apply — "spec only" framing if this is
   pure resequencing prose, per each repo's own documented design-doc
   shape). Open it.

6. **Mirror the reprioritization into the journal's own tracking** so the
   bulletin picks it up automatically:
   - Update or create `plan/designs/endo-but-for-bots/*.md` frontmatter
     (`milestone:`, `roadmap_relevance:`/`priority:`) for the confinement
     designs (#1015, #1102) so they score at the top.
   - Create `plan/designs/minion-town/` (new — does not exist yet) with an
     entry for the git-remote-capability design (#41), same frontmatter
     shape, `repository: kriscendobot/minion.town`, `pr: 41`.
   - Lower the `roadmap_relevance:`/`priority:` on whatever previously sat
     in the now-demoted milestones' designs, consistent with step 4.
   - Add a `## Roadmap` pointer section to `journal2:projects/minion-town/
     README.md` (mirroring what `projects/endo/README.md` got from the last
     roadmap groom) linking to the carved milestone and to PR #41.

7. **Confirm the bulletin actually reflects it** — your own commits above
   are a `journal2` push that moves the plan/design set, which is exactly
   what triggers `bulletin.sh`'s dashboard recompute (its push-gate/cost-gate
   are documented at the top of that file). Don't hand-edit
   `journal/README.md` yourself — it's journalist-regenerated. Instead,
   after your pushes land, check back (the bulletin loop is continuous) that
   the "Parked for maintainer feedback" ranking and the "deferred (top by
   priority)" plan-queue section on the regenerated bulletin now surface
   this milestone's items at/near the top. If it hasn't re-rendered within a
   reasonable wait, say so in your report rather than declaring success
   unverified.

## Report

State plainly: which milestone you carved (existing-reworded vs.
newly-inserted, and why), the PR you opened against `endo-but-for-bots` with
its URL, the journal-side files you touched, and whether you verified the
bulletin re-rendered with the new priorities on top.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T21:04:56Z
