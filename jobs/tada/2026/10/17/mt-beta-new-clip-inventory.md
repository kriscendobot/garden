# Completion report: mt-beta-new-clip-inventory

I opened draft PR **kriscendobot/minion.town#201**. The shell's `+` button now creates a New Clip: a blank clip that can turn itself into a pet-name inventory browser. It keeps the same clip id before and after, and it was tested in a real browser against a real guest.

**What it does**
- **Creating a clip:** the shell's `+` calls a new gated route, `POST /account/clips/new`. It creates the clip in the user's own guest through the normal billed publish path, then selects it in the gutter. Cross-site requests are refused. Failures show a reason and select nothing.
- **How the clip is built:** its `back` is a durable "clip power" in the guest that can reach only the clip's own directory (a `form` entry plus an `inventory` directory). Turning into the inventory just rewrites `form`. The front and the `back` binding never change, so the clip id stays the same (as #189 § 3.4 requires). No publish `upgrade` is needed, which the live path can't do yet.
- **Inventory browser:** lists names with the kind of each value, opens directories, previews text, and removes with a two-step confirm. The big `+` offers five ways to add an entry:
  - new directory
  - new text
  - import by `endo://` locator
  - accept an invitation
  - a nested New Clip opened in place

  Adding a new kind of entry or a new form is one record in `clips/new-clip/model.js`. Flows follow the Endo Chat inventory, but no upstream code is imported.
- **Failure and framing:** nothing is clickable until the clip power answers. A lost connection or a 10 s timeout shows an error with "Try again". An unknown clip id gets a 404 and no connection. Framing headers are unchanged, so only the Minion Town shell can frame it (#194). It works inside the #189 sandbox. I caught and fixed one problem there: that sandbox has no `allow-forms`, so normal form submission silently does nothing, and the creators now use plain button handlers.

**Evidence**
- **Unit tests:** `test/new-clip.test.ts`, 13 pass. The full `npm test` run has 1182 passing and one failure. That failure is caused by this host's `git` wrapper on PATH; the same file passes 41/41 without it.
- **Real-daemon test:** `test/new-clip-daemon.test.ts` passes locally and in CI's `test` job (new step "Test live-daemon New Clip acceptance"). It creates a clip through the route, then from the clip's own origin turns it into the inventory, runs every creator, and accepts a second guest's real invitation. It also checks that out-of-bounds paths are refused and that the form survives a new session.
- **Browser run:** `dev/new-clip-browser-demo.mjs` passes 18/18 checks in Chromium:
  - the shell `+` creates and selects the clip;
  - the clip is served with the real isolation headers;
  - blank → inventory keeps the same URL, and it is still the inventory after a reload;
  - all five creators work, along with opening directories, the nested app, and remove;
  - framed from a stand-in `https://minion.town` page with the #189 sandbox, the `+` works inside the frame;
  - a dropped connection shows the error view, and "Try again" recovers;
  - an unknown id returns 404, and a page on another origin cannot frame the clip.

  One limitation: the framing check disables Chromium's local-network blocking, because the test clip is on `http://*.localhost` and Chromium otherwise refuses even a frame with no headers.

**Other changes:** `designs/new-clip.md` (new), and § 6 of `designs/clip-shell-framework.md` updated. The Caddy `@guestSelf` matcher includes the new path. `npm run build` now also bundles the clip with esbuild, now an explicit devDependency. The Dockerfile was fixed in a second commit after CI's harness image build failed with "Cannot find module tools/build-new-clip.mjs".

**Decision for you:** the inventory browses only the clip's own directory, not your guest's whole pet-name directory. Anyone with a clip URL gets the clip's power, so browsing the full directory would hand your guest's whole authority to anyone with the link. That needs a credential other than the clip id (the #88 session locator). The clip's directory is a regular name in your guest, so you can reach the same values over MCP.

**Still open**
- CI on the Dockerfile fix (commit a61dc66) is still queued: the runners are backed up behind a `main` run. I checked the fix by reproducing the Docker build stage locally; the gauntlet will see the CI result.
- Live framing inside the shell arrives with #197; until then the shell shows its inert card with "Open in new tab".
- Publishing a nested app as its own gutter clip would need a minting capability the clip doesn't hold.
- No production admission setting was changed. Production already runs the live publish path, so the route goes live when this deploys.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mt-beta-new-clip-inventory.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 282 tokens (29844764 cached reads)
- Output: 120279 tokens
- Cost: $10.8174688
- Wall-clock: 3836s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
