#!/usr/bin/env bash
# chromium-smoke.sh — the unprivileged Chromium launch smoke test, run INSIDE a
# throwaway container off the freshly built garden image (invoked by provision.sh
# after the bake). It proves the property browser-verification jobs depend on: a
# fresh image can launch a headless Chromium WITHOUT hitting a missing shared
# library (the historical failure was `libnspr4.so` and friends — see
# skills/mermaid-validation/SKILL.md and roles/web-{builder,designer}/AGENT.md).
#
# It is deliberately representative, not synthetic: it downloads puppeteer's own
# Chromium build (the same shape as the Chromium a project's toolchain fetches)
# and launches it, so a regression in the image's package set fails HERE, in the
# bake, rather than at a browser job's first use after a container recreation.
#
# Two container facts this test must respect (both bit real runs):
#   1. It runs as the UNPRIVILEGED bot user, launched with `--no-sandbox`. The
#      failure this guards is a MISSING LIBRARY at process launch, which happens
#      regardless of the sandbox; --no-sandbox keeps the test about libraries, not
#      about whether unprivileged user namespaces are enabled in the kernel.
#   2. The garden container mounts /tmp as a `noexec` tmpfs, so a Chromium binary
#      unpacked under /tmp cannot be exec'd (EACCES). The browser cache therefore
#      lives under $HOME (an exec-capable filesystem); real browser jobs must do
#      the same.
set -euo pipefail

WORK="${HOME:?}/.chromium-smoke"
rm -rf "$WORK"
mkdir -p "$WORK"
cd "$WORK"
export PUPPETEER_CACHE_DIR="$WORK/cache"   # off the noexec /tmp, under $HOME

echo "== chromium-smoke: installing puppeteer (downloads a Chromium build) =="
# Write package.json directly rather than `npm init` — npm derives the package name
# from the cwd basename and rejects a dot-leading dir like `.chromium-smoke`.
printf '{"name":"chromium-smoke","version":"0.0.0","private":true}\n' > package.json
for attempt in 1 2 3; do
  if npm install puppeteer >install.log 2>&1; then break; fi
  if [[ "$attempt" -eq 3 ]]; then
    echo "chromium-smoke: npm install puppeteer FAILED"; tail -20 install.log; exit 1
  fi
  echo "npm install failed (attempt $attempt); retrying..." >&2
  sleep "$attempt"
done

echo "== chromium-smoke: launching headless Chromium (unprivileged, --no-sandbox) =="
node -e '
const puppeteer = require("puppeteer");
(async () => {
  const browser = await puppeteer.launch({
    headless: "new",
    args: ["--no-sandbox", "--disable-dev-shm-usage"],
  });
  const page = await browser.newPage();
  await page.setContent("<h1>ok</h1>");
  const text = await page.evaluate(() => document.querySelector("h1").textContent);
  await browser.close();
  if (text !== "ok") throw new Error("Chromium rendered unexpected content: " + text);
  console.log("CHROMIUM-LAUNCH-OK");
})().catch((e) => {
  console.error("CHROMIUM-LAUNCH-FAIL", e && e.message ? e.message : e);
  process.exit(1);
});
'

cd "$HOME"
rm -rf "$WORK"
