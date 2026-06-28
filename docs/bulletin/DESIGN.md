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
`kriskowal/garden` repository with **Contents: Read and write** (nothing else).

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
The bulletin lands at `https://kriskowal.github.io/garden/bulletin/`. The page
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
the push is a compare-and-swap just like the bus's own pushes.

## What is not solved here

The PAT path needs the maintainer to mint a token (a one-time human step,
documented in SETUP.md). The OAuth-via-worker upgrade needs the maintainer to
register a GitHub App and deploy the shim. Neither can be automated from a bot,
so both are click-by-click in SETUP.md and the issue carries the same note.
