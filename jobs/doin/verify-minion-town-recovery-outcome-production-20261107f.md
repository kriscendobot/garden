---
posted_at: 2026-11-07T21:21:55Z
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---
Continue and finish the production acceptance gate for kriscendobot/minion.town PR 254, head branch `fix/recovery-outcome-screen`, carried by `verify-minion-town-recovery-outcome-production-20261107b`, `-20261107c`, `-20261107d`, then `-20261107e`.

Status at 2026-11-07T21:25Z: the staged gauntlet (`jobs/gauntlet/kriscendobot-minion.town-pr254-gauntlet.md`) finished fix-2 (head 27ff5fb8 -> f9db0f80 ~20:14Z), ran panel-3 (20:05Z, still must-fix), and is now on **fix iteration 3** (child `kriscendobot-minion.town-pr254-gauntlet-fix-3`, posted 20:11Z; head still f9db0f80; all PR checks were green on 27ff5fb8). `-20261107e` polled 19:58–21:25Z without reaching un-draft. The PR is still OPEN and draft. Do not bypass review or merge policy. Monitor the gauntlet through un-draft and the repository's delegated merge. Poll in foreground chunks under 600s; never end your turn to wait.

After merge, wait for `deploy (continuous deployment)` and its triggered `prod probe (primary-phase objectives)` workflow to succeed. A skipped or failed deploy/probe is not acceptance. Confirm the probe summary records `wait-list-store-accepts-signup` passing.

Then verify https://minion.town/ in an actual Playwright Chromium run, using request interception for GET `/account/guest-recovery` to return a synthetic 404 with `identityProvider: GitHub` (never mutate a maintainer account or guest). Confirm exact copy `We signed you in with GitHub, but no minion.town guest is attached to that sign-in.`, cleared query/fragment, focused `recovery-unavailable-title`, `role=status` and `aria-live=polite`, one reload persistence followed by consumption on the next reload, the working alternate-provider link, and the wait-list action opening/focusing the form.

Submit the dedicated fixed address `prod-probe@minion.town` twice to the production `/api/waitlist`. Accept only HTTP 202 and the exact privacy-preserving body `{ "ok": true, "message": "Thanks. You are on the list; we will write when a spot opens." }`; the repeated response must be identical and disclose neither the address nor whether the row was new.

Save desktop/mobile production screenshots as durable evidence (a commit on the already-merged PR head branch is acceptable evidence without changing deployed `main`). Update PR 254's phase/evidence ledger from `orchestrated-slice` to `deliverable`, adding merge/deploy/probe run URLs and observations, then post one concise top-level completion comment with the evidence. This continuation explicitly authorizes those PR edits/comments.

If the bounded claim still cannot reach production, re-arm exactly one further continuation before handing off.

Sandbox notes from -c/-d: `ensure-project-worktree.sh` failed (bare clone read-only); `git clone` the branch into `$TMPDIR` instead. `npm i` needs `npm_config_cache=$TMPDIR/npmcache`; `npm i playwright@1.64.1` in a scratch dir under `$TMPDIR` works with the cached chromium-1248. Prepared check script (ran against pre-deploy prod and correctly timed out waiting for `#recovery-unavailable`); run as `OUT=<evidence dir> node prod-check.mjs` from the playwright dir:

```js
import assert from "node:assert/strict";
import { chromium } from "playwright";
const base = process.env.BASE ?? "https://minion.town";
const out = process.env.OUT;
const copy = "We signed you in with GitHub, but no minion.town guest is attached to that sign-in.";
const browser = await chromium.launch({ headless: true });
const obs = [];
const intercept = async (ctx) => {
  let hits = 0;
  await ctx.route("**/account/guest-recovery", async (route) => {
    if (route.request().method() !== "GET") return route.abort();
    hits++;
    await route.fulfill({ status: 404, contentType: "application/json",
      body: JSON.stringify({ error: "no recovery bond", identityProvider: "GitHub" }) });
  });
  // never let a probe touch real guest state
  await ctx.route("**/api/guest**", (route) => route.abort());
  return () => hits;
};
const focused = (p) => p.evaluate(() => document.activeElement?.id);
const card = async (p) => {
  await p.locator("#recovery-unavailable").waitFor({ state: "visible", timeout: 20000 });
  assert.equal((await p.locator("#recovery-unavailable h1").textContent()).trim(), "No guest is attached to this sign-in");
  assert.equal(await focused(p), "recovery-unavailable-title");
};
try {
  for (const [name, viewport] of [["desktop", { width: 1280, height: 800 }], ["mobile", { width: 390, height: 844 }]]) {
    const ctx = await browser.newContext({ viewport, isMobile: name === "mobile" });
    const hits = await intercept(ctx);
    const p = await ctx.newPage();
    await p.goto(`${base}/?prod-probe=1#recover=1`);
    await card(p);
    const u = new URL(p.url());
    assert.equal(u.search, ""); assert.equal(u.hash, ""); assert.equal(u.pathname, "/");
    const msg = p.locator("#recovery-unavailable-message");
    assert.equal(await msg.textContent(), copy);
    assert.equal(await msg.getAttribute("role"), "status");
    assert.equal(await msg.getAttribute("aria-live"), "polite");
    assert.ok(hits() >= 1, "interception served");
    if (out) await p.screenshot({ path: `${out}/recovery-outcome-production-chromium-${name}.png`, fullPage: true });
    obs.push(`${name}: card visible, focus=recovery-unavailable-title, url=${p.url()}, copy exact, role=status aria-live=polite`);
    if (name === "desktop") {
      await p.reload(); await card(p);
      assert.equal(await msg.textContent(), copy);
      obs.push("reload 1: card persisted with exact copy and focus");
      await p.reload();
      await p.locator("#splash").waitFor({ state: "visible", timeout: 20000 });
      assert.equal(await p.locator("#recovery-unavailable").isHidden(), true);
      obs.push("reload 2: outcome consumed, splash shown");
      // alternate provider link
      await p.goto(`${base}/#recover=1`); await card(p);
      const link = p.getByRole("link", { name: "Try another sign-in provider" });
      const href = await link.getAttribute("href");
      assert.equal(href, "/oauth2/sign_in?rd=/%23recover=1");
      const r = await ctx.request.get(new URL(href, base).toString(), { maxRedirects: 0 });
      assert.ok(r.status() < 400, `sign-in link status ${r.status()}`);
      obs.push(`alternate-provider link href=${href} -> HTTP ${r.status()}${r.headers().location ? " location=" + r.headers().location.replace(/\?.*/, "?…") : ""}`);
      await Promise.all([p.waitForURL((x) => x.pathname.startsWith("/oauth2") || x.host !== new URL(base).host, { timeout: 20000 }), link.click()]);
      obs.push(`alternate-provider click navigated to ${new URL(p.url()).origin}${new URL(p.url()).pathname}`);
      // wait-list action
      await p.goto(`${base}/#recover=1`); await card(p);
      await p.getByRole("button", { name: "Join the wait list" }).click();
      await p.locator("#waitlist-form").waitFor({ state: "visible" });
      assert.equal(await focused(p), "waitlist-email");
      assert.equal(await p.locator("#recovery-unavailable").isHidden(), true);
      obs.push("wait-list button: card hidden, #waitlist-form visible, focus=waitlist-email");
    }
    await ctx.close();
  }
} finally { await browser.close(); }
console.log(obs.join("\n"));
console.log("PRODUCTION PLAYWRIGHT CHECK PASSED");
```

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-07T21:24:37Z
