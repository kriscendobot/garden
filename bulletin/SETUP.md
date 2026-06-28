# Setup: the CI-rendered GitHub Pages bulletin and its reply control

The bulletin is rendered and published by the `bulletin` GitHub Actions workflow
(`.github/workflows/bulletin.yml`), which reads the live `journal2` branch and
deploys a static site through the Pages-from-Actions path. **Nothing is committed
to any branch** — not to `main2`, not to `journal2`. The design rationale is in
DESIGN.md. Two one-time human steps are required (flip the Pages source, mint a
token); a third optional step swaps the pasted token for a click-based OAuth
sign-in.

## 1. Set the Pages source to "GitHub Actions" (one-time, requires admin)

The repo currently serves Pages "Deploy from a branch" (`main2` `/docs`). This
re-architecture removes `docs/`, so that legacy source must be switched to the
Actions deployment:

1. GitHub → **Settings → Pages**.
2. **Build and deployment → Source:** select **"GitHub Actions"**.
3. Save. (No branch/folder to choose — the `bulletin` workflow's
   `deploy-pages` step is now the source.)

The bot account has only `push` permission, so it cannot do this; it is a
one-time click by a repo admin.

After this, every run of the `bulletin` workflow deploys the rendered site to
**`https://kriskowal.github.io/garden/bulletin/`** (the root
`https://kriskowal.github.io/garden/` redirects there).

## 2. How the workflow is triggered (no setup — already wired)

The workflow lives on the default branch (`main2`) and fires on:

- **`repository_dispatch` `journal2-updated`** — fired automatically by the
  garden's bulletin loop (`scripts/jobs/bulletin.sh`) right after it pushes a
  bulletin change to `journal2`. This is the "triggered by changes landed on
  journal2" path. It uses the bot's existing `GH_TOKEN` (no new credential).
- **`workflow_dispatch`** — run it manually from the repo's **Actions → bulletin
  → Run workflow** any time.
- **`schedule`** — every 6 hours as a safety net.

To force a render immediately (for example right after step 1), open
**Actions → bulletin → Run workflow**, or push any bulletin-changing edit to
`journal2`.

## 3. Mint a fine-grained token (the pure-client-side reply path)

This is the default, no-backend reply path. The token stays in your browser's
`localStorage` on your own machine and is sent only to `api.github.com`.

1. GitHub → **Settings → Developer settings → Personal access tokens →
   Fine-grained tokens → Generate new token**.
2. **Resource owner:** `kriskowal`. **Repository access:** "Only select
   repositories" → `kriskowal/garden`.
3. **Permissions → Repository permissions → Contents: Read and write.** Leave
   everything else at "No access". (Contents write is what lets the page commit
   the reply to `journal2`.)
4. Set a short expiry. Generate, copy the token.
5. Open the bulletin page, paste the token into the field at the top, **Save
   token**. The reply boxes activate. Use **sign out** to clear it.

The page now renders the CI-baked bulletin snapshot and each maintainer-inbox
message gets a reply box; a reply commits to `journal2` (delivering to the
originating doer's inbox, or the liaison's, and archiving the original message) in
one commit. Because the page is a deploy-time snapshot, after you reply the card
marks itself done and the bulletin redeploys shortly (the reply's push to
`journal2` fires the dispatch).

## 4. Optional: click-based OAuth instead of pasting a token

GitHub's no-secret OAuth (the device flow) cannot run from a pure browser page:
its token endpoints are on `github.com`, which sends no CORS headers, so the
browser blocks the call. To get a "Sign in with GitHub" button you must deploy a
tiny stateless token-exchange shim that adds CORS headers. This is the only part
that is not strictly pure-client-side, which is why it is optional.

1. **Register a GitHub App** (Settings → Developer settings → GitHub Apps → New).
   Give it **Contents: Read and write** on `kriskowal/garden` and enable
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
   Worker URL), commit to `main2`, and let the workflow redeploy. The page then
   shows **Sign in with GitHub**; it opens the verification page, you enter the
   code, and the page polls the shim for the token. No pasting.

If you do not deploy the shim, leave `deviceFlow.proxyBase` empty and use the
pasted token from step 3.

## Validating

After steps 1 and 3: open the page, confirm the bulletin renders and the
maintainer messages list (with a "Rendered from journal2 at …" line). Paste a
token, write a one-word reply on any message, click **Reply & acknowledge**.
Confirm a new commit appears on `journal2` that adds
`inbox/<doer-or-liaison>/unread/<id>.md` and moves the original from
`inbox/maintainer/unread/` to `inbox/maintainer/read/`. The bulletin redeploys
within a moment (the reply push fires `journal2-updated`).

To validate the renderer locally without a deploy: check out `journal2` into a
directory and run `node bulletin/build.mjs bulletin <that-dir> /tmp/site`, then
open `/tmp/site/bulletin/index.html`.
