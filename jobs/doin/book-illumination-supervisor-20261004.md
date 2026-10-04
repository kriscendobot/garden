---
role: orchestrator
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-04T04:28:03Z cleared=none -->

---
role: orchestrator
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Supervise production 1: per-chapter/section illuminated illustrations (kriscendobot/garden-book)

Maintainer (kriskowal, liaison 2026-10-04), continuing the book's iteration after
the first illustrated/retooled edition published (PRs #1-#6 merged, live at
https://g2d5d5z6x25qmf43fhv5tm4zmv4ozbxgk5gtke3mkrydrojehaea.ocap.site/):

> I don't think the background image adds much. I would ideally have an image
> for every chapter if not every section that espouses a central theme. Let
> Claude jobs design the thematic images and let Codex produce the images.
> Have Fable assess the coherence of the images, thematically. Codex is
> responsible for anchoring the color scheme. I would like the style to be
> ornate, illuminated with a theme of gardening. Incorporating natural scenes
> involving wizard towers with beacons would be a fun nod, but should be
> subtle. Hanging gardens would be nice. The images should break up the dense
> narrative.

You own this production end to end, mirroring the authority and self-chaining
pattern `garden-book-supervisor-20261003*` used successfully for the first
edition (read its `jobs/tada/` trail if you want the precedent). One claim
cannot span the whole chain: before your claim ends with work remaining, post
a dated successor supervisor job with the same body plus updated state (what's
done, what you're blocked on) so supervision continues unbroken.

**This job is child 1 of a serial orchestration** (`book-illumination-and-data-orch-20261004`);
a sibling production (data/equilibrium chapter) is parked behind you and will
not start until you reach a terminal `tada/` report. Declare the production
done (not just one PR merged) before you let this claim end for good.

## The pipeline — four roles, in order, each a separate posted job

Do not do all four steps in one claim/session — each step below is a *distinct*
job so the right model/provider actually does the work the maintainer named,
not a Claude agent play-acting as "Codex" or "Fable" in its own head. Chain
them with `blocked_on` / successor-job handoffs the same way the prior book
chain did. Use the exact pin mechanics below; they're already proven in this
repo's own job history, don't improvise different ones.

**1. DESIGN (Claude, automatic).** Post a job, `role: web-designer`,
`tier: mentor`, `fallback-tier: minion`, `dispatch: automatic` (plain
`post-job.sh`). Brief: read every chapter in the current merged book (and its
section headers) and write one thematic image brief per chapter — per
*section* too, wherever a section's content is distinct enough from its
chapter's to earn its own image; use judgment, the maintainer said "if not
every section," not "mechanically one per section." Each brief states: the
chapter/section's central theme in plain words, and a concrete visual
description grounded in that theme — ornate, **illuminated-manuscript**
style, a gardening motif throughout. Two specific, *subtle* motifs to work in
where they fit naturally (not forced into every image): a wizard tower with a
beacon, glimpsed in a natural scene rather than foregrounded; and hanging
gardens. Explicitly recommend what happens to the existing flat background
image from PR #4/#5 — the maintainer said it doesn't add much; the brief
should say keep, drop, or repurpose (e.g. as a title-page-only treatment) and
why. Deliverable: a brief doc in the repo (e.g. `art/chapter-illustrations-brief.md`),
one entry per image, each tagged with its target chapter/section anchor.
**Do not specify exact hex colors or lock a palette here** — say "anchoring
the color scheme is the next step's job" in the brief itself, so the next
step knows that's its explicit responsibility, not an afterthought.

**2. PRODUCE (Codex).** Once the design brief lands, post a job pinned to
Codex: `role: builder`, `provider: openai`, `tier: mentor`,
`fallback-tier: minion`, `dispatch: automatic` (see
`journal/jobs/tada/.../book-codex-illustrations.md`'s original frontmatter
for the exact precedent pin if you want to check it). Brief: produce one
illuminated-style SVG image per entry in the design brief, following its
theme/description. **You (Codex) own anchoring one consistent color palette
across every image in this set** — pick it, document it (a manifest file
alongside the assets, same shape as the existing `art/MANIFEST.md`), and hold
every image to it. Keep the ornate/illuminated/gardening aesthetic, the
wizard-tower-beacon and hanging-garden motifs subtle wherever the brief calls
for them. Inline-safe SVG only (no external fetches, unique ids, CSP-safe —
same constraints the first illustration PR already satisfied). Open a draft
PR.

**3. ASSESS (Fable, manual).** Once the production PR is open, post a job via
`scripts/jobs/post-manual-job.sh` (NOT `post-job.sh` — mentat/Fable is
manual-dispatch only) with body frontmatter `role: gardener`,
`provider: anthropic`, `model: claude-fable-5` (the explicit model pin matters:
plain `tier: mentat` alone is claimable by either Fable or GPT-6 Astra, and
the maintainer asked for Fable specifically). Brief: this is a **thematic
coherence review, not a code review** — assess the full image set against the
design brief: does each image actually read as its chapter/section's theme;
is the illuminated-manuscript-gardening aesthetic consistent across the set;
are the wizard-tower-beacon/hanging-garden motifs present where used and
appropriately subtle (flag any that feel forced or too prominent); is the
anchored color palette actually held consistent image-to-image. Deliverable:
a structured verdict (per-image note + one overall coherence verdict) posted
as a PR review on the production PR.

**4. RECONCILE.** Read Fable's verdict yourself (you're Claude/mentor-tier
here, this call is yours). If it's clean, proceed to integration. If it finds
real problems, post **one** bounded revision job back to Codex (same pin as
step 2) addressing Fable's specific findings — don't loop indefinitely; one
revision round, then proceed with whatever's left outstanding noted
honestly in your completion report rather than stalling the whole production
on a perfect result.

**5. INTEGRATE (Claude, automatic).** Post a job, `role: web-designer`,
`tier: mentor`, `dispatch: automatic`. Brief: weave the approved per-chapter/
section images into the actual generator — this repo's build is now the
JavaScript retool from PR #6 (`build/build.mjs` or equivalent; read
`build/README.md` for current state), not the old Python one. Resolve the
background-image question per the design brief's recommendation from step 1.
Each image breaks up its chapter/section's narrative — place it where it
actually helps pacing, not mechanically at the top of every section. Verify:
phone-width layout, light/dark mode, text-over-image contrast/readability
(same bar the first illustration integration already met), and a reproducible
build. Merge, then run the publish steps and record the new edition in
`build/README.md`'s history (keep prior editions listed). Send one maintainer
message with the new edition URL.

## Scope and authority

Same as the precedent supervisor: `kriscendobot/garden-book` only, no upstream
repos, no garden fleet/budget config changes. You may rebase, restack,
re-order, withdraw, or add sub-jobs, and merge into `main` yourself. Run a
gauntlet at your discretion if you judge a step warrants one (e.g. the
generator-touching integration step); it is not required by default. Ask the
maintainer only for a decision you genuinely cannot make yourself.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-04T04:28:16Z
