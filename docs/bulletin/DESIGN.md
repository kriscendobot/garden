# Design note: GitHub Pages bulletin with client-side maintainer reply

One page resolving the three hard constraints the job flagged, then the
implementation follows it. Authored for kriskowal/garden issue #10.

## 1. Auth without a backend

GitHub's standard OAuth web flow exchanges the authorization `code` for a token
at `https://github.com/login/oauth/access_token`, and that exchange requires the
app's `client_secret`. A secret cannot be kept secret in pure client-side
JavaScript, so the web flow is out. The device flow (which needs no secret) is
also out for a pure browser page: its two endpoints live on `github.com`
(`/login/device/code` and `/login/oauth/access_token`), and `github.com` does
not return `Access-Control-Allow-Origin`, so a browser `fetch` to poll for the
token is blocked by CORS. GitHub OAuth Apps do not support PKCE either, so there
is no no-secret browser-only OAuth path. Every no-secret OAuth variant needs
either a server or a CORS proxy, which reintroduces a backend.

**Chosen primary path: a fine-grained Personal Access Token the maintainer
pastes once.** This is the only genuinely pure-client-side, no-backend,
no-secret-we-hold option, and the maintainer listed it as an acceptable
documented path. `https://api.github.com` *does* send permissive CORS headers,
so once the page holds a token it can read and write through the REST + Git Data
APIs entirely from the browser. The token is stored in `localStorage` on the
maintainer's own machine and never leaves it except as the `Authorization`
header to `api.github.com`. Minimal scope: a fine-grained PAT limited to the
`kriscendobot/garden` repository with **Contents: Read and write** (nothing
else).

**Optional OAuth upgrade (documented, not the default):** the device flow can be
made to work if the maintainer deploys a tiny stateless token-exchange shim (for
example a Cloudflare Worker) that holds the App's `client_id`/`client_secret`
and proxies the two `github.com` calls with CORS headers added. The auth module
is written against a small `Provider` interface so this can be slotted in by
filling `config.deviceFlow` without touching the rest of the app. It is
secondary because it is no longer strictly "pure client side" (it needs the
worker), and the PAT path already delivers the full feature with zero backend.
See SETUP.md for both.

## 2. Pages source vs. the orphan `journal2` branch

`journal2` is a large orphan branch and a live agent workspace; it must not be
the Pages source. The static site is committed to **`main2` under `docs/`** and
served by GitHub Pages "Deploy from a branch" → branch `main2`, folder `/docs`.
The bulletin lands at `https://kriscendobot.github.io/garden/bulletin/`
(`https://<owner>.github.io/<repo>/bulletin/` in general — the URL is
owner-derived and does **not** redirect across a repo transfer). The page
holds no bulletin content of its own: at load it pulls the live
`journal2:README.md` and the live `inbox/maintainer/unread/` listing through the
GitHub Contents API (`?ref=journal2`), so "automatically posted" is satisfied
with no republish step. The garden repo is public, so reads work even before the
maintainer signs in; the token is needed only to write the reply commit.

## 3. Reply routing — bus-compatible, reconciled with the CLI

The maintainer described the reply as "addressed to the liaison ... adds a reply
to the liaison's inbox." The existing CLI (`scripts/jobs/maintainer-reply.sh`)
instead routes to the *originating doer* named by the replied-to message's
`reply_to:` frontmatter, delivers `inbox/<doer>/unread/<ts-id>.md` with
`from: maintainer`, and archives the original (`unread/` → `read/`) in the same
breath. The client reproduces the CLI's bus semantics exactly and reconciles the
two framings by routing order:

1. If the message carries `reply_to: <doer>` and `inbox/<doer>/` still exists on
   `journal2`, deliver there (the live agent waiting on the answer). This is the
   CLI behavior, byte-for-byte on the file format.
2. Otherwise, if `inbox/liaison/` exists, deliver to the liaison — honoring the
   maintainer's "liaison's inbox" phrasing for messages that name no doer (the
   `liaison:follow-up` message in the current inbox has no `reply_to`).
3. Otherwise dead-letter to `inbox/dead/<id>.md` carrying `to:` and
   `dead_lettered_at:`, exactly as `inbox-send.sh` does when a doer's inbox is
   gone, so `garden-deadmail` can promote the intent into a fresh job. The reply
   is never dropped.

The delivered file matches `inbox-send.sh` output for a maintainer reply with no
leading frontmatter fence: `from_host`, `from: maintainer`, `sent_at`, `---`,
body. The archive and the reply are one commit, built through the Git Data API
(blob → tree on `base_tree` with the `read/` add and the `unread/` delete via
`sha: null` → commit → fast-forward ref update), retried against a moved ref so
the push is a compare-and-swap just like the bus's own pushes. The retry mirrors
the shell push protocol (`scripts/jobs/common.sh`): on a 422 "not a fast forward"
it re-reads the moved head, reconstructs the change on the fresh tree, and retries
up to 50 times with **exponential backoff and full jitter** between attempts —
each retry sleeps a fresh uniform draw in `[0, min(2000ms, 50ms·2^attempt)]`. The
backoff is load-bearing — `journal2` is advanced constantly by the ~100-gardener
fleet, so the prior backoff-free 6-attempt loop re-collided on the same instant
and surfaced the raw 422 to the maintainer. Full jitter (a new random span every
attempt, not a fixed band) is what actually decorrelates contending writers, so
the CAS drains instead of re-colliding in lockstep (kriskowal #10).

## 4. New thread to the liaison

A composer at the top of the page lets the maintainer open a *new* thread (not a
reply to an inbox item). It commits one new file to
`inbox/liaison/unread/<id>.md` on `journal2` — the same liaison routing target
and `from_host: github-pages` / `from: maintainer` / `sent_at` file format the
reply path already uses, minus the archive step (there is no original to move).
It reuses `GH.commitReply` with only `replyPath`/`replyBody` set, so the
compare-and-swap ref update is shared. Writing needs a token; the no-token
fallback is the adjacent **open a GitHub issue** link
(`https://github.com/<owner>/<repo>/issues/new`), which the issue-inbox watcher
already turns into garden work for allowlisted maintainers.

## What is not solved here

The PAT path needs the maintainer to mint a token (a one-time human step,
documented in SETUP.md). The OAuth-via-worker upgrade needs the maintainer to
register a GitHub App and deploy the shim. Neither can be automated from a bot,
so both are click-by-click in SETUP.md and the issue carries the same note.

## 5. Favicon

The browser-tab icon is the carrot emoji 🥕 (kriskowal/garden issue #13),
rendered with the asset-free [emoji-favicon](../../skills/emoji-favicon/SKILL.md)
technique: a single static `<link rel="icon">` in `index.html` whose `href` is an
inline (not base64) `image/svg+xml` data URI holding one `<text>` node —
`viewBox="0 0 10 10"`, `<text y="8" font-size="8">`, inner quotes encoded as
`%22`. No asset file, no build step, no second request. This covers the browser
tab only; per the skill it does not satisfy `apple-touch-icon` or a PWA manifest
(both want raster PNGs), and the glyph is painted by the viewer's emoji font so
it looks different across platforms — both acceptable for this internal bulletin.
