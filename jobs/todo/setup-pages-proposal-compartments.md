# Set up GitHub Pages with the rendered ecmarkup for kriscendobot/proposal-compartments

Follow-up to `bootstrap-proposal-compartments-fork` (done). The fork
`kriscendobot/proposal-compartments` (default branch `main`) carries the TC39 template's
Pages workflows (`.github/workflows/publish-main.yml`, `publish-pr.yml`, `render-pr.yml`)
and a building `spec.emu` (verified: `npm run build` renders `build/index.html`, title
`Compartments`). **Pages is NOT enabled yet** (`gh api repos/.../pages` → 404). Get the
rendered spec published and reachable. Reference `skills/pages-build-shepherd` for the
deploy-flake-vs-build-error classification and `skills/local-verify`. All work stays on the
bot-owned fork; no upstream interaction. Tracker: kriskowal/garden#61.

## Do

1. **Enable Actions on the fork** if disabled (forks often ship with Actions off, so the
   Pages workflow never runs): `gh api --method PUT repos/kriscendobot/proposal-compartments/actions/permissions -f enabled=true` (and allowed_actions=all if needed).
2. **Read `publish-main.yml`** to determine the deploy mechanism, then enable Pages to match:
   - If it deploys via `actions/upload-pages-artifact` + `actions/deploy-pages` (Pages
     "GitHub Actions" build type): `gh api --method POST repos/kriscendobot/proposal-compartments/pages -f build_type=workflow`.
   - If it pushes rendered output to a **`gh-pages`** branch (e.g. `peaceiris/actions-gh-pages`):
     let the workflow create/populate `gh-pages`, then enable Pages with source =
     `gh-pages` branch, path `/`: `gh api --method POST repos/kriscendobot/proposal-compartments/pages -f 'source[branch]=gh-pages' -f 'source[path]=/'`.
   (The maintainer asked for "gh-pages"; if the template uses the Actions build type instead,
   that is the template's current mechanism — use whichever the workflow actually implements
   and note it in the report.)
3. **Publish `main`.** Trigger/confirm the publish workflow for the current `main` HEAD
   (`gh workflow run publish-main.yml --ref main`, or re-run the latest), and drive the Pages
   `pages-build-deployment` to GREEN — classify and fix a red per `skills/pages-build-shepherd`
   (deploy flake → re-run; build/content error → fix the docs source, verifying locally first).
4. **Verify the live site** (real-execution evidence): `curl -fsSI` the Pages URL for a 200 and
   `curl -fsS` it for `<title>Compartments</title>` (the rendered ecmarkup landing). Cite the URL
   and the observed output — do not claim "published" without fetching it.

## Record + done

- Add the rendered-spec Pages URL to the charter README
  (`journal2:projects/proposal-compartments/README.md`, via `scripts/jobs/land-journal-edit.sh`)
  under the fork/machinery section.
- Comment the live URL on kriskowal/garden#61.
- Report: Pages build_type/source used, the deploy run URL, the live Pages URL, and the verified
  200 + title evidence. If Actions/Pages could not be enabled (a token-permission gap on the
  fork), STOP and surface the exact gap via `scripts/jobs/message-user.sh <your-base>` rather than
  reporting success.
