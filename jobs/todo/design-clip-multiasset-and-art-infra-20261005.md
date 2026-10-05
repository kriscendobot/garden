---
role: designer
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---

# Design: multi-asset/multi-page clips, and real image-generation infrastructure (garden repo)

Maintainer (kriskowal, liaison session 2026-10-05), prompted by low-quality
hand-authored SVG illustrations in `kriscendobot/garden-book`:

> We need to obviate the limitation on inline SVG for clips. Clips are
> intended to capture snapshots of a virtual file system and serve
> multi-asset and multi-page web sites. There must be some gap we can close.
> For the same reason, I would hope the garden could be rendered into a
> scroll for each chapter with navigation. We should also dispatch a
> gardener to build out the infrastructure needed to dispatch an image
> generation job, an art supervisor job, and art recognition jobs, so the
> supervisor can verify the work of a generator. My understanding is that
> openai will allow us to use the same subscription to draw from image
> generation APIs; correct the maintainer if wrong.

This lands as a **PR on this repo** (kriscendobot/garden — not bare to
`main2`), explicitly requested, and independently warranted: this design
will carry real `## Open questions` (new credential/cost surface
authorization, raster-vs-vector architecture choice, book restructuring
scope) per `roles/designer/AGENT.md` § Operating norms and the
`## Conventions` carve-out in this repo's own `CLAUDE.md`. Use the
frozen-base-branch mechanics for a bare-garden-repo design PR; mark it
`<!-- garden-design-open-questions -->` in the body.

## Thread 1 — clip capability: verify, don't assume

Prior book-production jobs assumed clips require everything inlined into one
SVG/single-page HTML document. **This assumption looks wrong on inspection,
not confirmed-wrong** — verify it empirically before designing around either
answer:

- `skills/minion-town-clip-publishing/SKILL.md` already documents
  `mcp__minion-town__publish`'s `content` parameter as an **array** of
  `{path, contentType, bytes}` entries (multiple files per clip, already
  used for CSS: "ship a sibling `styles.css` and link it" — the skill notes
  this explicitly contradicts job specs that assumed inline-only). It also
  documents the live CSP as `img-src 'self' data:` — same-origin raster
  images should already be loadable. I confirmed this CSP header live just
  now on a published garden-book clip
  (`content-security-policy: ... img-src 'self' data: ...`) — it is current
  production behavior, not stale documentation, as of 2026-10-05.
- **Your job:** actually publish a small test clip with (a) a separate
  same-origin PNG or JPEG file referenced by a sibling HTML page via a plain
  `<img src="...">`, and (b) at least two linked HTML pages (e.g.
  `ch1.html` linking to `ch2.html`) — i.e., directly test the "scroll per
  chapter with navigation" shape the maintainer asked about. Confirm both
  render and navigate correctly in a real browser check (reuse the
  `tools/browser-check.mjs`-style headless-Chromium pattern from the
  garden-book work if useful), then `unpublish` the test clip.
- If both work (my spot-check says they should): there is **no platform gap
  to close** — the "inline everything" constraint was a self-imposed
  simplification in the book tooling, not a real limitation. Design the
  book's build pipeline to emit separate image files (so raster or SVG art
  can be produced and shipped as sibling files, not forced inline) and a
  genuine multi-page-per-chapter structure with navigation (prev/next,
  a table of contents linking real pages, not anchors into one giant
  document) as the next concrete build job's scope — don't implement it
  yourself here, scope it precisely for a follow-up builder.
- If something genuinely doesn't work as documented: say exactly what broke,
  with the real error, and whether the gap is closable client-side (in
  `publish`'s caller, or the build tooling) or needs an upstream
  minion.town/Endo-daemon change (out of this design's authority to fix,
  but say who/what would need to).

## Thread 2 — real image-generation job infrastructure

Current state (confirmed by the recent book-illumination production): both
the "Claude produces art" and "Codex produces art" paths mean an LLM
hand-authoring SVG markup — there is **no actual text-to-image generation
capability anywhere in this garden's codebase** (I grepped for DALL-E,
`gpt-image`, Stable Diffusion, and found nothing). That's the root cause of
the quality complaint, not a broken model-pin (the pin worked correctly;
checked the reputation-event receipt: `provider: openai`,
`model: gpt-5.6-sol`, genuinely Codex).

**On the maintainer's billing question — correct what's actually known, flag
what isn't:**

- **Confirmed:** the garden's Codex workers authenticate via a **ChatGPT-plan
  OAuth login** (`~/.codex/auth.json`), not a metered `OPENAI_API_KEY` — see
  `designs/cleric-worker-bid-auction-reputation.md` ("Auth. Via
  `~/.codex/auth.json` (ChatGPT-plan login...)") and
  `designs/subscription-budget-model.md`'s "shared Codex subscription."
  `designs/provider-model-catalog.md` itself already flags "Codex dollar
  cost is unresolved under ChatGPT-plan auth" as an open question in this
  repo.
- **NOT confirmed either way, and the liaison should not have guessed:**
  whether that same ChatGPT-plan login entitles the Codex CLI session to any
  bundled image-generation capability, or whether generating an image from
  this fleet would hit OpenAI's separately-metered Platform Images API
  regardless of the ChatGPT-plan login (these are genuinely different
  products/billing surfaces at OpenAI in general, but this specific harness's
  actual behavior needs a real test, not an assumption from general
  knowledge). **Test this directly**: from a Codex CLI session using the
  garden's existing credential, attempt to invoke whatever image-generation
  tool/capability the installed Codex CLI version actually exposes (check
  `codex debug models` / the CLI's own tool catalog the way
  `designs/provider-model-catalog.md` already does for text models), see
  whether it succeeds, and if so what it reports costing/billing against.
  Report the real, tested answer — "yes, bundled," "no, separately billed,"
  or "the CLI doesn't expose this at all and we'd need a different credential
  entirely" — rather than confirming or denying the maintainer's belief from
  memory.
- If a genuinely new credential/cost surface is needed (a standalone
  `OPENAI_API_KEY` with Images-API billing, say), that is new standing cost
  exposure and needs explicit maintainer authorization before anything is
  provisioned — put it in `## Open questions`, don't provision it yourself.

**Design the three job/role shapes the maintainer named, reusing the just-
completed illumination production as your direct precedent** (its
design→produce→Fable-coherence-assess chain already proved a similar shape
for hand-authored SVG; adapt it rather than starting from nothing):

1. **Image-generation job**: produces art via whatever real capability
   Thread 2's test actually confirms exists (or recommends against building
   this at all if nothing viable turns up — a correct "this isn't feasible
   yet, here's why" is a complete deliverable).
2. **Art-supervisor job/role**: a reusable version of the
   `book-illumination-supervisor` pattern — generic enough to dispatch
   generation + review for art in *any* project, not re-derived per book.
3. **Art-recognition jobs**: the supervisor's verification step — checking a
   generated image against its brief. Note that existing multimodal Claude/
   GPT models can already *look at* an image and judge it against a brief
   with no new infrastructure beyond a job that passes the image file in;
   confirm explicitly whether this needs any new tooling at all, or just a
   well-specified job role (don't invent infrastructure the fleet doesn't
   actually need).

## Deliverable

One design doc (e.g. `designs/clip-multiasset-and-art-generation.md`) covering
both threads, landed as a PR per the carve-out mechanics above, with a real
`## Open questions` section for: any new credential/cost authorization needed;
the raster-vs-vector call for book art; and the scope/cost of rebuilding
garden-book's single-page structure into a multi-page scroll-per-chapter site
(a real redesign, not a small follow-up).

## Report back

In your completion report AND via `scripts/jobs/message-user.sh
design-clip-multiasset-and-art-infra-20261005`, state plainly: whether the
clip "gap" is real or not (Thread 1's test result), and the tested (not
assumed) answer to the maintainer's subscription/billing question (Thread
2).
