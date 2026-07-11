In the bot's own ocapn repo (endojs/endo-but-for-bots), the two shared-suite ocapn test files carry identical test titles and therefore share identical `tmp/<title>#…` state dirs, so they race on `purge` when ava runs them concurrently (non-`--serial`). Key the tmp dir per file so the two files no longer collide; this is the real fix for the latent collision noted in the PR body.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  claimed_at: 2026-07-11T06:48:51Z
