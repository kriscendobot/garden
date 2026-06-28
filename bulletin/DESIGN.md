# Design note: CI-rendered GitHub Pages bulletin

Revised for kriskowal/garden issue #10. The maintainer's directive supersedes the
prior build: **"Committing to main2 is off limits. It should be possible to set
up a CI workflow in main2 that is triggered by changes landed on journal2."** The
first build landed the rendered site as committed content under `docs/` on
`main2` (commit `6454719ec`), which crossed that line. This note re-architects the
bulletin so **no rendered/deployed content is committed to `main2`** — a GitHub
Actions workflow renders the live `journal2` bulletin and publishes it through the
Pages-from-Actions path, committing nothing anywhere.

The auth and reply-routing design from the prior build is unchanged and is
restated in §3–§4; the new decisions are §1 (trigger) and §2 (where the app
source lives). §5 records exactly what was removed from `main2`.

## 1. Trigger mechanics — how a journal2 change rebuilds the site

The real wrinkle: for a `push` event, GitHub runs the workflow file **from the
pushed branch's ref**. A workflow committed only to `main2` will therefore *not*
fire on a push to `journal2` unless the YAML also lives on `journal2`. `journal2`
is a large orphan branch and a live agent workspace; we will not put a workflow
file on it.

The events that always resolve the workflow from the **default branch** — and
`main2` *is* the default branch — are `repository_dispatch`, `workflow_dispatch`,
and `schedule`. So the workflow lives on `main2` (the maintainer explicitly
endorsed a CI *workflow file* on `main2`; only *content* is off limits) and is
triggered by:

- **`repository_dispatch` (`event_type: journal2-updated`)** — the primary path,
  fired by the existing journal2-push machinery. `scripts/jobs/bulletin.sh` is the
  garden's single bulletin-consolidation loop: it already gates on "journal2
  changed since the last reconcile" and re-renders `journal2:README.md` (which
  embeds the maintainer-inbox dashboard) only when the content actually changed.
  Immediately after its **accepted** README push, it now POSTs
  `repos/kriskowal/garden/dispatches` with `event_type=journal2-updated` (the new
  `fire_pages_dispatch` helper in `scripts/jobs/common.sh`, best-effort and
  non-fatal). This is the literal reading of "a CI workflow triggered by changes
  landed on journal2": the dispatch fires exactly when the bulletin content on
  `journal2` moved, and it is naturally debounced by the loop (one dispatch per
  consolidated change, not one per raw push — `journal2` churns many times a
  second under the gardener fleet, so triggering on every raw push would be
  wasteful and rate-limited).
- **`workflow_dispatch`** — manual re-render from the Actions tab.
- **`schedule` (every 6h)** — a low-frequency safety net so a missed dispatch (or
  a change that lands by some path other than the bulletin loop) is reconciled
  within hours regardless.

Firing the dispatch needs a token with `repo`/contents-write scope on the repo;
the bot already pushes `journal2`, so its existing `GH_TOKEN` (scopes `repo`,
`workflow`) suffices. The dispatch carries no journal content — only the event
name — so it is not a prompt-injection surface.

## 2. Where the client-side app source lives

The reply-box HTML/JS/CSS must live somewhere the workflow can assemble into the
Pages artifact. Two options:

- **(A) Keep minimal app *source* on `main2`** under `bulletin/` (not `docs/`),
  and have the workflow copy it into the artifact. It is **build input**, never
  served from the branch — Pages serves only the Actions artifact, so nothing
  under `bulletin/` is ever a deployed-from-branch page.
- **(B) Generate everything inside the workflow** (heredoc the HTML/JS/CSS in the
  YAML).

**Chosen: (A).** The tradeoff, stated plainly so the maintainer can veto: (A)
keeps ~6 small static-asset files versioned and reviewable on `main2` at the cost
of those files physically living on `main2`; (B) keeps `main2` free of any
page-shaped file at the cost of burying a few hundred lines of app source inside
unmaintainable, unreviewable, untestable YAML heredocs. The directive's concern
is *deployed content committed to main2* (a site served straight off the branch),
not *build input*. Versioned, reviewable source that CI compiles into an artifact
is ordinary CI hygiene and is the cleaner reading of the directive. (A) also lets
`build.mjs` be unit-runnable locally (it is — see §6). If the maintainer reads the
directive more strictly, flipping to (B) is mechanical and isolated to the
workflow file.

The app source on `main2`:

```
bulletin/
  index.html      app shell; loads config.js, data.js, markdown.js, github.js, app.js
  app.js          renders the CI-baked snapshot; client-side reply (write) path
  github.js       pure client-side GitHub access (reads for the write path + the
                  atomic reply commit via the Git Data API) — verbatim from prior build
  markdown.js     dependency-free Markdown renderer — verbatim from prior build
  config.js       per-instance config (owner/repo/journalBranch, optional OAuth)
  style.css       styling
  build.mjs       the CI renderer (Node, no deps) — reads journal2, emits the site
  DESIGN.md       this note
  SETUP.md        the one-time human setup (Pages source, token)
```

The workflow assembles the artifact as `_site/bulletin/<assets> + _site/bulletin/data.js`
plus a root `_site/index.html` redirect to `bulletin/` and a `_site/.nojekyll`,
so the bulletin keeps serving at `https://kriskowal.github.io/garden/bulletin/`.

### Render at CI time, not live-fetch

Because the trigger exists to rebuild on journal2 change, the workflow **bakes**
the content at deploy time: `build.mjs` reads `journal2:README.md` and the unread
maintainer-inbox messages from a sparse `journal2` checkout and writes
`data.js` (`window.GARDEN_BULLETIN_DATA = { renderedAt, readme, messages }`). The
page renders that baked snapshot instantly (no unauthenticated live API reads on
load, so no rate-limit exposure, and the page shows a "Rendered from journal2 at
…" freshness line). This is what makes the journal2→dispatch→redeploy loop
meaningful: content is current as of the last deploy, and a journal2 change
redeploys it.

## 3. Auth without a backend (unchanged)

No pure-client-side, no-secret OAuth path to `github.com` exists (the web flow
needs a `client_secret`; the device flow's `github.com` endpoints send no CORS
headers; OAuth Apps have no PKCE). The default is therefore a **fine-grained
Personal Access Token the maintainer pastes once** — the only genuinely
zero-backend write path. `api.github.com` sends permissive CORS, so once the page
holds the token it commits the reply entirely from the browser. The token lives in
`localStorage` on the maintainer's machine; minimal scope is `kriskowal/garden`
with **Contents: Read and write**. An optional OAuth device-flow upgrade (needing
a maintainer-deployed CORS shim) remains slot-in via `config.deviceFlow`; see
SETUP.md.

## 4. Reply routing — bus-compatible (unchanged), now re-reading live state

Each maintainer-inbox message gets a reply box. On submit the page reproduces
`scripts/jobs/maintainer-reply.sh` bus semantics exactly: route to the originating
doer named by the message's `reply_to:` if `inbox/<doer>/` still exists on
`journal2`; else to `inbox/liaison/`; else dead-letter to `inbox/dead/`. The reply
and the archive (move `inbox/maintainer/unread/<id>` → `read/`) are one commit
built through the Git Data API (blob → tree on `base_tree` → commit → CAS ref
update, retried against a moved ref).

One change from the prior build forced by baking: the displayed message snapshot
is from deploy time, so before committing, `submitReply` **re-reads the live
unread file** to get its current blob sha (a 404 means it was archived since
deploy → the page says so and declines). The write path is thus correct even when
the page is minutes stale; only *display* is snapshotted. After a successful
reply the card marks itself done; the next journal2 push redeploys the page with
the message gone.

## 5. What was removed from `main2` vs. repurposed

Removed (the superseded committed/deployed-from-branch content under `docs/`):

- `docs/index.html` (redirect), `docs/.nojekyll` — Pages-from-branch scaffolding;
  the workflow now emits both into the artifact instead.
- `docs/bulletin/index.html`, `docs/bulletin/app.js`, `docs/bulletin/DESIGN.md`,
  `docs/bulletin/SETUP.md` — replaced by the `bulletin/` source (app.js reworked
  to render the baked snapshot; DESIGN/SETUP revised for this architecture).

Repurposed (moved verbatim from `docs/bulletin/` to `bulletin/` as build input):

- `github.js`, `markdown.js`, `config.js`, `style.css`.

Net: `main2` no longer carries any rendered site or any page served straight off
the branch — only the workflow file and the reviewable app source CI compiles.

## 6. What still needs a human (cannot be botted)

- **Settings → Pages → Source = "GitHub Actions"** — the bot has only `push`
  permission, not admin, so it cannot flip the Pages source from the current
  "Deploy from a branch" to the Actions path. One-time click by the maintainer.
- **Mint the fine-grained PAT** to enable replies (per SETUP.md), and optionally
  deploy the OAuth CORS shim.

`build.mjs` is locally runnable for validation:
`node bulletin/build.mjs bulletin <journal2-content-dir> /tmp/site` against a
checkout of `journal2` reproduces the artifact the workflow uploads.
