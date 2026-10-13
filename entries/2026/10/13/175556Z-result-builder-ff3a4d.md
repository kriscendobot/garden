---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-10-13T17:56:03Z
job: garden-book-publish-ocap-site-after-hyperlinks-20261013
claim: 04ae3ea46d436c17
---
Published the post-hyperlink edition of *Better Code and Gardens* at https://5kwirevgc77outc6vptymbj6tfwpwuldnb74qumkrs55qlxzxutq.ocap.site/ from exact source commit `eaf634ae5d4d839e8979dc3f359037dca1594c96`.

Preflight: https://github.com/kriscendobot/garden-book/pull/13 is merged at the source commit, and the reviewed hyperlink head is present on `main`. https://github.com/kriscendobot/garden-book/pull/8 is merged as `c75caaed974e6691ab914c874cb80b909d23fcce` and is an ancestor of the published source.

Verification: `npm ci`, all 62 `npm test` tests, and `node build/build.mjs chapters out` completed successfully. Live `index.html` and `styles.css` compare byte-for-byte with the build output (sha256 `384dbd3ce3224354dfc2652b44773fe632a77363b75049d7bfdc7bb3e7087155` and `859ffed2b91ea2db5f0a963cbe22d5ffa48a8168423250fee4f251d4d27a49d0`). Chromium loaded the live clip at 390x844 and 1440x900 in light and dark: all four rendered-DOM checks had exact viewport width, 25 figures, no reported layout problems, caption contrast at least 5.68:1, and body contrast at least 12.9:1. Browser navigation reached new internal targets for chapter 5 and section 2.1, and external targets https://github.com/endojs/endo-but-for-bots and https://github.com/kriscendobot/garden/issues/15 returned HTTP 200.

Edition history: pushed commit `bfc4c3941c8e73a1cd128e27805b72a54f54214f` and opened draft https://github.com/kriscendobot/garden-book/pull/14 against frozen base `main-eaf634a`.

Notifications: sent the URL and source SHA to the maintainer and to `garden-book-review-supervisor-after-hyperlinks-20261013`.

Follow-up: review and merge https://github.com/kriscendobot/garden-book/pull/14 through the normal project process.

Self-improvement: routed to the liaison a correction for the stale `powers: "sites"` example in `skills/minion-town-clip-publishing/SKILL.md`; no out-of-scope garden-library edit was made.
