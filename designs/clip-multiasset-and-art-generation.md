<!-- garden-design-open-questions -->

# Multi-asset clips and supervised image generation

| Created | 2026-10-05 |
| --- | --- |
| Author | designer |
| Status | Proposed |

The clip platform already serves a virtual file tree. The missing multi-asset and
multi-page behavior is in `garden-book`'s build and publish code, not in
minion.town. Separately, the Codex installation already has real raster image
generation under the garden's existing ChatGPT-plan login. The garden needs job
contracts around that capability, not a new image service for the first version.

This design therefore has two independent build tracks:

1. rebuild `kriscendobot/garden-book` as an index plus one scrolling page per
   chapter, with sibling art files; and
2. add reusable image-generator, art-recognizer, and art-supervisor roles and
   skills to this repository.

## Verified capability baseline

### Clips already support the requested site shape

On 2026-10-05, a disposable clip was published with three content entries:
`ch1.html`, `ch2.html`, and `art.png`. `ch1.html` used a plain
`<img src="art.png">` and linked to `ch2.html`; `ch2.html` linked back to
`ch1.html`. Both HTML and PNG requests returned HTTP 200. The responses carried
the documented CSP, including `img-src 'self' data:`.

A headless-Chromium run made these rendered-DOM observations:

- `art.png` completed decoding from the clip's own origin with natural size
  1 x 1 and rendered size 16 x 16;
- clicking Next loaded `ch2.html` and rendered its `Chapter Two` heading;
- clicking Previous returned to `ch1.html`, where the image remained decoded;
- no page or console errors occurred.

The clip was then unpublished and its inert bootstrap pet name removed. The
platform gap is therefore **not real**. The current book limitation comes from
`assembleBook` writing only `index.html` and `styles.css`, `renderBook` inlining
all SVG art into one document, and `publishBook` hard-coding those two text
files. No minion.town or Endo-daemon change is needed.

### Codex image generation is available through ChatGPT-plan auth

The tested answer to the subscription question is **yes, bundled access is
available**, with an accounting qualification:

- `codex-cli 0.156.0` reported `Logged in using ChatGPT`;
- `OPENAI_API_KEY` was unset;
- `codex features list` reported `image_generation stable true`;
- a fresh, ephemeral `codex exec` session invoked the built-in image-generation
  tool and wrote a real PNG under `$CODEX_HOME/generated_images/...`;
- the image tool response exposed no billing, cost, quota, usage, provider, or
  image-model field.

Thus the current built-in route does not need a separately provisioned Platform
API key and the probe did not use separately metered Images-API credentials. It
does not establish the subscription's internal image quota or marginal cost,
because Codex reports neither. The similarly named OpenAI CLI is a distinct API
route: its official documentation says it reads `OPENAI_API_KEY` and offers
`openai images generate`; that fallback would introduce Platform billing and is
outside the first version ([OpenAI CLI](https://developers.openai.com/api/docs/libraries/openai-cli)).

Image recognition also needs no new runtime. A fresh `codex exec -i <png>` probe
under the same login identified the generated test as a red circle on white with
0.99 confidence. The CLI reported ordinary input/output/reasoning token usage for
that recognition turn. Current Codex models list image input in
`codex debug models`, and existing Claude/GPT workers already inspect local images.

## Garden-book: a real multi-page, multi-asset edition

The follow-up builder job is a substantial `kriscendobot/garden-book` redesign,
not a publishing-API patch. It changes the output contract to this shape:

```text
out/
  index.html
  styles.css
  chapters/
    01-philosophy-history-metamorphosis.html
    ...
    10-inference-tiers-reference.html
  assets/
    art/<source filenames, byte-for-byte>
```

`index.html` becomes the title page and full table of contents. Each chapter file
is one long-form scroll containing that chapter's contents, provenance, text,
figures, and a navigation block at both top and bottom. The block links to the
index and to the preceding and following chapter where they exist. Table-of-
contents and sidebar chapter links use real relative page URLs; section links use
fragments within the corresponding chapter page. Links between roles, skills,
and chapters must resolve to the correct page plus fragment.

`renderBook` should first parse the full corpus into a shared book model (chapter
identity, stable filename, headings, cross-reference index, placements), then
render the index and each chapter from that model. This preserves the existing
fail-closed checks for renamed headings and out-of-section figure placements
without copying rendering logic eleven times.

Art is copied as bytes into `out/assets/art/`. Generated HTML uses ordinary
`<img>` elements with explicit dimensions where known, useful `alt` text or an
empty alt for truly decorative work, and the existing `figure`/`figcaption`
structure. SVG may remain SVG, but it is no longer injected into HTML. Raster
PNG/WebP/JPEG files use the same manifest and placement path. The build rejects a
missing asset, an unsupported extension, an unsafe output path, a duplicate
destination, or a placement without accessibility text. `styles.css` remains a
sibling shared by every page.

The tree adapters must gain byte-oriented reads and writes plus recursive output
directories. `publishBook` must recursively enumerate the built tree, derive MIME
types from a closed extension table, base64-encode the original bytes, and pass
every entry to the existing `publish` content array. It must retain the current
inert-bootstrap guard. It must not special-case only the expected chapter count:
the built tree is the publication unit, and unknown extensions fail closed.

The builder's acceptance criteria are:

- one index and exactly one output page per source chapter, with deterministic
  filenames and byte-identical clean rebuilds;
- every local `href` and `src` resolves in the output tree; every fragment exists
  in its target page; the previous/next graph is complete and acyclic;
- all 34 current art files used by the edition are shipped once as sibling bytes,
  with none embedded as data URLs or inline SVG;
- unit tests cover binary tree I/O, MIME selection, recursive publication,
  traversal rejection, cross-page link rewriting, and first/middle/last navigation;
- a browser test opens the index, a direct chapter deep link, and every navigation
  edge from a local build and from the published clip; it checks image decode,
  404s, overflow, figure clipping/overlap, and contrast at 390 x 844 and
  1440 x 900 in light and dark modes; and
- publication records the new immutable URL and output hashes without removing
  the single-page edition from history.

## Reusable art-production jobs

### Image-generator role

Add `roles/image-generator/AGENT.md` and a repository-owned
`skills/image-generation/SKILL.md`. An image-generation job is pinned to
`provider: openai` and names a project repository, branch, brief, output paths,
asset count, maximum attempts per asset, and review criteria. It uses Codex's
built-in `image_gen` tool, one distinct call per distinct asset. It never selects
the API-key fallback.

The job copies accepted PNG/WebP/JPEG output from `$CODEX_HOME/generated_images/`
into its isolated project worktree, opens a normal draft asset PR, and commits an
art manifest. Each manifest row records the brief identifier, final prompt,
intended placement, dimensions, format, accessibility intent, SHA-256, generator
route (`codex built-in image_gen`), and the explicit fact that the tool disclosed
no image model or per-image cost. It must not invent those fields. Reference
images and generated assets live in the project branch, not in the journal.

The generator checks file signatures, dimensions, alpha expectations, output
paths, and manifest coverage. Those checks establish artifact integrity, not
artistic correctness. It does not approve its own work.

### Art-recognizer role

Add `roles/art-recognizer/AGENT.md` and generalize the useful parts of
`skills/svg-visual-review` into `skills/art-visual-review/SKILL.md`. A recognition
job checks out the exact asset PR head, reads the original brief, and visually
inspects every referenced asset through the worker's native multimodal input. SVG
inputs are rendered first; raster inputs are inspected directly. No new daemon,
API, credential, or attachment transport is required.

The recognizer receives only the brief, files, and manifest, not the generator's
private reasoning. It emits one note per asset covering subject, composition,
style/coherence, required details, forbidden details, legibility at intended size,
and accessibility implications; then a set-level assessment and one verdict:
`accept`, `changes-requested`, or `cannot-assess`. Findings must name the asset and
a bounded correction. File validation alone can never produce `accept`.

Recognition runs in a separate job/session from generation. A different provider
is preferred when available, but separation by job is the required independence
boundary. An ordinary campaign uses an automatic multimodal mentor. A Fable or
other manual-only recognition pass is allowed only when the maintainer explicitly
authorized it and must be posted through the manual-job path; an automatic
supervisor cannot manufacture that authorization.

### Art-supervisor role

Add `roles/art-supervisor/AGENT.md` and `skills/art-production/SKILL.md`. The
supervisor accepts a project-neutral campaign brief and creates one serial garden
orchestration with `halt` on child failure:

1. image generation and a draft asset PR;
2. independent art recognition at the exact generated head; and
3. a supervisor disposition that verifies the child evidence and either accepts
   the asset head or names the bounded revision.

The campaign brief sets an asset count, attempt cap, at most one revision cycle by
default, recognition model policy, integration owner, and stopping condition. If
review requests changes, the disposition posts a new bounded
revision -> recognition -> final-disposition orchestration. It never loops in one
agent session and never silently accepts residual findings. Integration into a
book or application is a separate builder job after acceptance; the supervisor
does not infer project layout policy.

This is the reusable form of the successful
design -> produce -> Fable-coherence-assess -> bounded-revise -> integrate chain
from the 2026-10-04 garden-book illumination production. The reusable version
replaces hand-named successor chains with the existing deterministic orchestration
record and keeps provider/model authorization explicit.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Lifecycle / commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| Codex image tool -> image-generator | Produce raster bytes from a prompt. | The generator chooses prompts and attempts within the campaign cap. | The project asset branch owns accepted bytes and its manifest; `$CODEX_HOME` output is staging only. | The generator may commit candidates and open the draft PR, but cannot accept them. | Image bytes plus tool metadata, named in generator vocabulary. |
| Image-generator -> art-recognizer | Expose an exact PR head, brief, manifest, and image paths. | The recognizer applies the brief without changing files. | The recognizer's durable result is its job report and optional authorized PR review. | The recognizer classifies visual compliance; it cannot merge or integrate. | Per-asset observations and an art-review verdict. |
| Art-recognizer -> art-supervisor | Supply a verdict and bounded findings. | The supervisor decides accept, revise once, or stop within the declared campaign policy. | The orchestration and child reports own campaign history; the project PR owns assets. | The supervisor owns retry/stop and acceptance, not project merge. | A campaign disposition in supervisor vocabulary. |
| Garden-book builder -> minion.town publish | Turn a validated output tree into the existing multi-entry `content` array. | Garden-book decides filenames, MIME allowlist, and which built tree is releasable. | The project commit owns sources; the immutable clip owns published bytes; edition history owns the URL and hashes. | The builder/release job publishes a tested commit; minion.town only registers and serves it. | Path, MIME type, and base64 bytes in clip vocabulary. |

The project repository owns every persistent art byte and build source. The
art-supervisor owns accept/revise/stop for the campaign; the later project release
job owns merge and publication. The garden orchestration engine owns restart and
replay of child dispatch, while each child is idempotent against its named branch
and PR. The recognizer owns artistic execution classification; the supervisor owns
what happens after that classification.

The inner/outer naming check passes: generator results are image artifacts and
recognizer results are art-review verdicts. Neither is called a campaign commit,
release, or publication result; those lifecycle terms remain with the supervisor
and project release layer.

## Garden implementation and tests

The garden-infrastructure builder should add the three roles and three skills,
update the role/skill inventories and model-selection documentation, and add a
non-generating preflight that verifies ChatGPT login plus the stable
`image_generation` feature. A paid generation canary must be an explicit operator
action, since even bundled quota is a cost surface. No credential is copied into a
job, repository, journal entry, or manifest.

Hermetic tests validate job-spec parsing, provider pinning for generation,
asset/attempt caps, refusal of the API fallback without authorization, exact-head
handoff to recognition, manual-only model enforcement, single-revision
termination, and the orchestration failure path. One bounded live canary should
generate a raster, move it into a scratch project worktree, inspect it in a
separate recognition job, and record that the image tool still omits or now
exposes accounting fields.

## Alternatives considered

- Extend minion.town before rebuilding the book: rejected because the live
  multi-file, raster, and navigation experiment already passed.
- Continue hand-authored SVG as the only art route: retained for diagrams and
  deterministic icons, rejected as the illustration default that prompted this
  work.
- Provision `OPENAI_API_KEY` immediately: rejected for the first version because
  bundled generation succeeded and a key creates a separately metered standing
  credential without authorization.
- Let the generator self-review: rejected because integrity checks do not test
  whether an image actually depicts its brief.

## Open questions

- **Credential and cost authorization: should the first version stay on the tested ChatGPT-plan built-in route, or should the maintainer authorize a separately metered `OPENAI_API_KEY` route for explicit model controls and Platform cost accounting?** Recommendation: ship the bundled route first and treat its unreported per-image cost as opaque subscription usage; provision no new credential until explicitly authorized.
- **Raster versus vector for garden-book art: should future thematic illustrations default to generated raster files while deterministic charts, diagrams, glyphs, and logos remain SVG?** Recommendation: yes. This directly addresses the quality failure of LLM-authored SVG while preserving SVG where editability and exact geometry matter.
- **Scope and cost of the garden-book rebuild: should the next builder own the complete index-plus-ten-chapter redesign, binary asset pipeline, link migration, browser matrix, and republish as one dedicated PR, or should asset externalization land before page splitting?** Recommendation: one dedicated builder PR because the shared book model, cross-page link resolver, and recursive publisher must agree atomically; budget it as a redesign and live-publication job, not a small rendering patch.
