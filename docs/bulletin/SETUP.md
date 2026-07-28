# Setup: the GitHub Pages bulletin and its reply control

This is the "repository plugin" setup the bulletin needs. Two one-time steps are
required (enable Pages, mint a token); a third optional step swaps the pasted
token for a click-based OAuth sign-in. The design rationale is in DESIGN.md.

## 1. Enable GitHub Pages (serves the static page from `main2`)

The page lives on the `main2` branch under `docs/`. The orphan `journal2` branch
is never the Pages source; the page pulls `journal2` content at runtime.

1. Push this `docs/` tree to `main2` (already done by the build job).
2. On GitHub: **Settings → Pages**.
3. **Build and deployment → Source:** "Deploy from a branch".
4. **Branch:** `main2`, **folder:** `/docs`. Save.
5. Wait for the first build. The bulletin is then live at
   **`https://kriscendobot.github.io/garden/bulletin/`**
   (`https://<owner>.github.io/<repo>/bulletin/` in general).

Reads work immediately and unauthenticated, because the garden repo is public.
You only need a token to post a reply.

## 2. Mint a fine-grained token (the pure-client-side reply path)

This is the default, no-backend path. The token stays in your browser's
`localStorage` on your own machine and is sent only to `api.github.com`.

1. GitHub → **Settings → Developer settings → Personal access tokens →
   Fine-grained tokens → Generate new token**.
2. **Resource owner:** `kriscendobot`. **Repository access:** "Only select
   repositories" → `kriscendobot/garden`.

   > The repo was **transferred** `kriskowal/garden` → `kriscendobot/garden` on
   > 2026-07-28. A fine-grained token is scoped to a **resource owner**, and that
   > scope does not follow a transfer, so a token minted under `kriskowal` can no
   > longer write here even though the old URL redirects. Re-mint under
   > `kriscendobot` — the account must grant the token, so this is a maintainer
   > action, not something the fleet can do.
3. **Permissions → Repository permissions → Contents: Read and write.** Leave
   everything else at "No access". (Contents write is what lets the page commit
   the reply to `journal2`.)
4. Set a short expiry. Generate, copy the token.
5. Open the bulletin page, paste the token into the field at the top, **Save
   token**. The reply boxes activate. Use **sign out** to clear it.

That is the whole setup for the feature the maintainer asked for. The page now
renders the live bulletin and each maintainer-inbox message gets a reply box; a
reply commits to `journal2` (delivering to the originating doer's inbox, or the
liaison's, and archiving the original message) in one commit.

## 3. Optional: click-based OAuth instead of pasting a token

GitHub's no-secret OAuth (the device flow) cannot run from a pure browser page:
its token endpoints are on `github.com`, which sends no CORS headers, so the
browser blocks the call. To get a "Sign in with GitHub" button you must deploy a
tiny stateless token-exchange shim that adds CORS headers. This is the only part
that is not strictly pure-client-side, which is why it is optional.

1. **Register a GitHub App** (Settings → Developer settings → GitHub Apps → New).
   Give it **Contents: Read and write** on `kriscendobot/garden` and enable
   **Device Flow**. Note the **Client ID** and generate a **Client secret**.
2. **Deploy the CORS shim** (for example a Cloudflare Worker). It exposes two
   POST routes and forwards to GitHub with `Access-Control-Allow-Origin` set to
   the Pages origin:
   - `POST /device/code` → forwards `{client_id, scope}` to
     `https://github.com/login/device/code`, returns the JSON verbatim.
   - `POST /device/token` → forwards
     `{client_id, device_code, grant_type: urn:ietf:params:oauth:grant-type:device_code}`
     (adding the secret server-side) to
     `https://github.com/login/oauth/access_token`, returns the JSON verbatim
     (`{access_token}` or `{error: "authorization_pending"}`).
   The secret lives only in the Worker, never in the page.
3. In `config.js` set `deviceFlow.clientId` and `deviceFlow.proxyBase` (the
   Worker URL). The page then shows **Sign in with GitHub**; it opens the
   verification page, you enter the code, and the page polls the shim for the
   token. No pasting.

If you do not deploy the shim, leave `deviceFlow.proxyBase` empty and use the
pasted token from step 2.

## Validating

After steps 1 and 2: open the page, confirm the bulletin renders and the
maintainer messages list. Paste a token, write a one-word reply on any message,
click **Reply & acknowledge**. Confirm a new commit appears on `journal2` that
adds `inbox/<doer-or-liaison>/unread/<id>.md` and moves the original from
`inbox/maintainer/unread/` to `inbox/maintainer/read/`.
