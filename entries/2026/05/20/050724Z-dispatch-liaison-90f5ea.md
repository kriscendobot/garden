---
ts: 2026-05-20T05:07:24Z
kind: dispatch
role: liaison
project: endo
to: builder
---

# Dispatch: builder transforms ~/spackle.md draft into a tight docs/spackle.md article on endojs/endo@master

Dispatch root: `dispatches/builder--90f5ea/`. Project worktree on `endojs/endo@master` (head `052b0487e`).

Maintainer directive (2026-05-20): *"Please dispatch a builder to take ~/garden/spackle.md and transform it into an article in docs, based on endojs/endo's master branch. Pay close attention to narrative flow, avoid agentic tropes and biases, follow the style guide, do not add fluff, remove any text that is superfluous, and generally make a tight introduction to the Spackle concept and how we are using it."*

The source draft lives at `/home/kris/spackle.md` (~127 lines, prose-only, kriskowal-voice). The actual filename was `spackle.md` directly under `/home/kris/`, not `garden/spackle.md` — verified before dispatch.

## What "spackle" means in this draft (so you can edit, not re-discover)

A **spackle** module both *races* to install a behavior on a shared intrinsic via a registered symbol (polyfill semantics) AND exports an ergonomic ponyfill that calls through to whichever instance won the race. The two endo applications named in the draft are `@endo/harden` and (forthcoming) `@endo/eventual-send`. The harden case has a wrinkle: the spackle's own installed `harden` is a *surface* harden (own properties only, no prototype walk), so hardened modules work outside HardenedJS without effectively pseudo-locking-down the realm; if `lockdown` runs first it installs a *volumetric* harden and spackle defers. Registered symbols (`Symbol.for('harden')`) are used because eval twins of registered symbols are equal — unlike unique symbols or class private fields.

## Where the article lands

`docs/spackle.md` on `endojs/endo@master`. Add the new file to `typedoc.json`'s `projectDocuments` array — without that entry the typedoc build won't pick it up. Insertion point is the maintainer's call; group it with the conceptual docs (after `docs/message-passing.md` and before `docs/reference.md`, since spackle is concept/guide rather than API reference, would be defensible).

## Task

Read `garden/roles/COMMON.md` + `garden/roles/builder/AGENT.md` first. Then read `CONTRIBUTING.md` § Markdown Style Guide (one sentence per line, 80–100 col wrap) and `AGENTS.md` for repo conventions. Skim `docs/message-passing.md` and `docs/lockdown.md` to internalize the existing tone (factual, no marketing voice, tables where they earn their keep, no first-person except in citation contexts).

1. **Read `/home/kris/spackle.md`** (the source draft). Read `packages/harden/README.md` — it already describes the multi-instance race and the `Object[Symbol.for('harden')]` mechanism; the new article should complement that without duplicating, by *defining the pattern abstractly* and pointing to harden as the canonical instance.

2. **Author `docs/spackle.md`** with frontmatter:
   ```yaml
   ---
   title: spackle
   group: Documents
   category: Guides
   ---
   ```
   Recommended outline (you have authorial discretion; this is the narrative spine the maintainer's draft implies, ordered for flow rather than chronologically as the draft is):

   1. **What spackle is** — one-paragraph definition: a module that combines polyfill (races to install on a shared intrinsic via a registered symbol) with ponyfill (ergonomic import that calls through to whichever instance won). Lead with the definition; don't make the reader scroll past prototype.js history to find it.
   2. **Why a new pattern** — the eval-twins problem briefly stated. Eval twins of unique symbols are not equal; eval twins of registered symbols are. The same applies to private fields and `instanceof`. For libraries that need multiple instances in one realm to agree on shared state (not just convention), the polyfill+ponyfill combination is what works.
   3. **Contrast with shim, polyfill, ponyfill** — define each in one line. Spackle = polyfill (installs on intrinsic) + ponyfill (ergonomic export) + race-discipline (first-writer-wins via registered symbol). This is where the prototype.js / es5-shim history *might* belong, but only if it serves the contrast; cut if it doesn't earn its space.
   4. **How `@endo/harden` uses spackle** — the surface-vs-volumetric harden distinction, the lockdown coordination (lockdown wins if it ran first; spackle defers; if spackle ran first, lockdown throws because the environment is corrupted). Link to `packages/harden/README.md` for the package-level detail.
   5. **Forthcoming: `@endo/eventual-send`** — single short paragraph. Eventual send needs realm-wide identity for marked promises (correctness, not just performance); cannot tolerate eval twins.
   6. **Language-evolution note** — registered symbols give language designers room to land `Object.harden` later or to introduce `Symbol.harden` as a well-known symbol; brief.

3. **Style discipline** (this is what the maintainer flagged):
   - **No agentic tropes**: no "Let's explore", "we'll dive into", "It's worth noting that", "Importantly,", "In essence,", "Furthermore,". No bullet lists where prose carries the meaning more naturally. No "comprehensive guide" framing.
   - **Cut the draft's hedges**: the source says things like "(I believe, please cite)" and "[citation needed]" — these are author notes, not content. Either ground the claim (Remy Sharp coined "polyfill" — confirm or remove the attribution) or drop the claim.
   - **Remove the first-person aside about es5-shim** unless it earns its place. The maintainer is the eventual author; this article is about the pattern, not the author's biography.
   - **Tighten**: the draft repeats itself (the harden surface-vs-volumetric explanation appears across multiple paragraphs). Consolidate.
   - **One sentence per line**, 80–100 col wrap, per `CONTRIBUTING.md`.
   - **Code examples** kept (the `Object[Symbol.for('harden')]` example and the ergonomic `import harden from '@endo/harden'` example are load-bearing — keep both, juxtaposed).
   - **Fix typos in the source** as you go: "rasons" → "reasons", "polfill" → "polyfill", "precences" → "presences", "Object.for" → "Symbol.for", "inimitable" is fine but "the language designers an inimitable symbol category" is awkward — recast. The line "There is not wide consensus in the JavaScript community about shim and polyfill" is unclear (consensus about what? the names? the distinction?); recast or cut.
   - **Tone match**: read `docs/message-passing.md`'s introduction for the target register. Factual, building from definition to example, no marketing.

4. **Wire into typedoc**. Edit `typedoc.json` and add `"docs/spackle.md"` to `projectDocuments`. Suggested position: between `docs/message-passing.md` and `docs/reference.md`. Verify the JSON still parses (`node -e "JSON.parse(require('fs').readFileSync('typedoc.json'))"`) and that `yarn docs` (or at minimum `yarn workspaces foreach --all --topological exec true` — your judgment which validation is fast and load-bearing) succeeds without breaking the typedoc build.

5. **Pre-PR**. Run `yarn lint:prettier --check docs/spackle.md typedoc.json` (or whatever the repo's prettier targets are; ESLint typically doesn't lint .md). If a markdownlint config exists, run it. Confirm `yarn docs` regenerates without warnings about the new file.

6. **PR shape**:
   - Branch: `docs-spackle` on `kriskowalbot/endo` (your fork — actually, your dispatch's project worktree pushes back to its origin: the bot's fork. The garden's convention: builder operates on the bot's fork, the boatman later ferries upstream).
   - Title: `docs: introduce spackle — a polyfill+ponyfill race pattern for shared intrinsics`.
   - Body: one-paragraph summary, screenshot/preview of the rendered docs page if you can produce one, link to the source draft (don't paste it inline), note the typedoc.json change, list any open questions the maintainer might want to weigh in on (e.g., whether to keep the prototype.js historical framing).
   - Open as DRAFT.

## Per-action authorization

Standing on endo-but-for-bots-equivalent paths is broad-comment, but this dispatch targets `endojs/endo` upstream — wait, the maintainer's directive says "based on endojs/endo's master branch" which is the *source of truth for the article's content*, but the **PR opens against `endojs/endo` directly** via the bot fork's mirror. Verify the project worktree's origin: if it's the kriskowal/endo bot fork, push there and open the PR cross-fork against `endojs/endo:master`; if it's `endojs/endo` directly, push to a feature branch on origin and open the PR against `master`. Mirror this in the project worktree's `git remote -v` output before pushing.

READ-ONLY otherwise on `endojs/endo`. No comment posting beyond the new PR's body.

## Out of scope

- No edits to `packages/harden/README.md` (the article should *complement* it, not duplicate or rewrite it).
- No edits to other `docs/*.md` files unless cross-linking demands it (e.g., one inbound link from `docs/guide.md` or `docs/message-passing.md` is acceptable if narratively appropriate; not required).
- No package-level changes; this is documentation only.
- No un-draft of the PR — it's a docs PR with editorial calls the maintainer wants to weigh in on.

## Report

≤ 400 words: PR URL + head SHA, the docs/spackle.md final length (lines), what you cut from the source draft and why (bullet list, 3–5 items), what you kept verbatim and why, any phrasing decisions the maintainer might want to revisit, typedoc.json position chosen, `yarn docs` outcome (warnings? clean?), one-line `Self-improvement: ...`.
