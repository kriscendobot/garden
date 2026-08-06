---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 132
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-08-06T06:10:00Z
last_appended_at: 2026-08-06T06:10:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#132

Created from the real-browser verification pass on PR #132 (`feat(space-chat): per-message render mode toggle (md/raw/pre)`), 2026-08-06. Not panel-derived: this is one latent base-wide CSS defect the browser run surfaced while checking this PR's own `pre` mode, deliberately left out of #132 to keep that PR single-purpose.

## Items

- [ ] **`--font-mono` is not defined anywhere in the repository, so every bare `var(--font-mono)` silently renders proportional.**
  **Source**: real-browser (headless Chromium) verification of PR #132's `pre` render mode, which computed `font-family` as the inherited `-apple-system, ...` sans stack rather than a monospace one.
  **Round**: n/a (verification finding).
  **Evidence**: `grep -rn -- '--font-mono\s*:' --include='*.css' --include='*.js' --include='*.html' --include='*.ts'` over the repo returns **no declaration**; only `var(--font-mono)` *uses*. A custom property that never resolves makes the declaration invalid at computed-value time, so `font-family` falls back to the inherited value instead of a monospace face.
  **Current state**: `packages/chat/index.css` has 12 `var(--font-mono)` use sites. Five already carry the literal fallback (`var(--font-mono, monospace)`, at roughly lines 1326, 5395, 9978, 9996, 10119) and are therefore correct by accident. PR #132 fixed its own site (`.md-preformatted`) the same way. The remaining bare sites (roughly lines 2541, 2640 outside the toggle block, 4223, 4592, 4623, 5652) are still silently non-monospace on screen.
  **Recommended action**: either declare `--font-mono` once in the `:root` token block alongside `--accent-primary` / `--radius-sm` / `--text-muted` (the cleaner fix, since the token is clearly *intended* to exist and every site then inherits it), or add the `, monospace` fallback to each remaining bare site. Prefer declaring the token; the fallback-per-site pattern is what let the gap hide this long.
  **Verification note**: this class of defect is invisible to the package's happy-dom component tests, which have no CSS cascade. It needs a real browser (`getComputedStyle(...).fontFamily`), so whoever takes it should verify the same way.
  Rule: `skills/css-design-tokens-and-theming/SKILL.md`; `roles/COMMON.md` § Reporting (UI criteria need a real browser run).
