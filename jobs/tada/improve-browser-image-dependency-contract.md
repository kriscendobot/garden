I've completed the deliverable I can verify and land safely, and handed the maintainer a decision-ready recommendation for the part that requires a fleet-wide image rebuild.

## Completion report

**What the job asked:** *"Make image freshness include the Dockerfile's browser-runtime dependency contract."*

**What I found:** The `garden` launcher's image guard was **absent-only** — `ensure_container` built the image when *missing* but never detected a **stale** image (one whose Dockerfile, or a file it `COPY`s, changed since the build). So a Dockerfile change — including to a browser-runtime dependency layer — would land in source but be silently reused from the old image. There was no image-freshness mechanism at all, and the Dockerfile currently declares **no** browser-runtime deps (no firefox/chromium/playwright/system libs anywhere in the tree).

**What I shipped** (pushed to `main2`, `b875ed04e4`):
- **`garden` launcher — image-freshness guard keyed on the Dockerfile build contract.** `cmd_build` now stamps a `garden.build-contract-sha` label (sha256 of `Dockerfile` + `entrypoint.sh` + the api-key-handoff seed) into the image. A bare `./garden` **warns** on a stale image at bring-up (warn-only — an auto-rebuild mid-bring-up would surprise a live host, and the running container is unaffected until recreated). New **`./garden check`** subcommand reports fresh/stale, exiting non-zero only on a definite mismatch, so a Dockerfile-affecting deploy can gate on a rebuild. Because freshness keys on the *whole* Dockerfile, the browser-runtime dependency contract that lives there is included **by construction**.
- **`context/operations/deploy.md`** — documents that `deploy-garden.sh` merges the checkout but does **not** rebuild the image, and how `./garden check` + `build` + `reset` close that per-host gap.

**Verified** host-side with a stubbed `docker` (no live container touched): `bash -n` clean; `check` correct across absent / pre-label / fresh / stale (exit 0/0/0/1); `build` passes the `--label`; stale image warns at bring-up, fresh is silent.

**Deliberately not landed — flagged to the maintainer:** the substantive browser-runtime **dependency layer** itself (the apt libraries + a build-time assertion — the actual "contract" gardeners need for real Playwright/UI browser runs). It's an unverifiable, fleet-wide image change requiring a `docker build` I can't run here plus a drained deploy + rebuild per host, and the design doc's "the container has none" made scope non-obvious. I messaged the maintainer a ready-to-apply Dockerfile patch (Playwright `install-deps` + `libnss3`/`libgbm` assertion) and asked for a go-ahead / engine-scope / pin-vs-`@latest` decision.

**Follow-up:** on maintainer approval, add the browser-runtime dependency layer to the Dockerfile (the freshness guard already covers it once present) — as a separate job that can be built-and-deployed with eyes open.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-browser-image-dependency-contract.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (3796188 cached reads)
- Output: 40475 tokens
- Cost: $3.8714230000000005
- Wall-clock: 668s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
