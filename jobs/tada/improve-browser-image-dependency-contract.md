Done. Work committed and pushed to `main2` (`59fbf0bbe6`).

## Completion report

**Job:** Add an unprivileged Chromium launch smoke test after the turnkey image build, and update the Dockerfile's package set so a fresh image passes it — so browser-verification jobs stop failing on missing shared libraries after a container recreation.

**Root cause confirmed:** The garden image ships **no** Chromium binary — browser-verification jobs (web-builder / web-designer, mermaid/SVG/data-URI rendering) launch a Chromium their project's own toolchain downloads (puppeteer/playwright). The image only needs the shared libraries that binary dynamically links; those were not declared in the Dockerfile, which is exactly the historical `libnspr4.so`-and-friends failure documented in `skills/mermaid-validation/SKILL.md`.

**Changes (3 files, +126):**
- **`Dockerfile`** — added the Ubuntu 24.04 (noble, `t64`) puppeteer/playwright shared-library set (`libnss3`, `libnspr4`, `libatk*t64`, `libgbm1`, `libasound2t64`, `fonts-liberation`, …) as a **late** layer so it never invalidates the expensive node/go/CLI layers; all 22 package names verified resolvable on 24.04.
- **`scripts/aws/turnkey/chromium-smoke.sh`** (new) — unprivileged headless Chromium launch smoke test: `npm install puppeteer` (with retries), then a `--no-sandbox` headless launch that renders and asserts a marker.
- **`scripts/aws/turnkey/provision.sh`** — runs the smoke **inside a throwaway container off the freshly built image** as the bot user (fed over stdin, no bind mount), failing the bake on a missing-library regression rather than at a browser job's first use.

**Two container facts baked into the design (both hit during validation):**
1. The garden's `/tmp` is a **`noexec` tmpfs** — a Chromium unpacked there gets `EACCES` on spawn. The smoke keeps its browser cache under `$HOME` (exec-capable); real browser jobs must do the same.
2. `npm init` rejects a dot-leading cwd basename ("Invalid name") — the script writes `package.json` directly instead.

**Verification:** ran the smoke script end-to-end in-container → `CHROMIUM-LAUNCH-OK`, exit 0. Both scripts pass `bash -n` and `shellcheck` (only a pre-existing unrelated SC1091 info in provision.sh). Pushed via rebase-CAS to `origin/main2`.

**Follow-ups / notes:**
- The full assertion only exercises on a real AMI bake (a live `provision.sh` run on the builder instance) — the in-container proxy run confirmed the smoke logic and library set, but the throwaway-container `docker run` path itself is exercised at next bake.
- Worth surfacing to browser-job roles: the `/tmp` noexec constraint means any Chromium cache/download must target `$HOME`, not `/tmp` — currently only implicit in this smoke's comments.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-browser-image-dependency-contract.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 159 tokens (5615829 cached reads)
- Output: 64124 tokens
- Cost: $5.988155500000001
- Wall-clock: 1207s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
