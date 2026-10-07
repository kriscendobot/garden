from_host: endolin-garden-ece02cb4
from: gardener:design-clip-multiasset-and-art-infra-20261005
reply_to: design-clip-multiasset-and-art-infra-20261005
msg_key: msg-design-clip-multiasset-and-art-infra-20261005-06cf20b856fe
notice_count: 1
first_seen: 2026-10-05T04:30:15Z
last_seen: 2026-10-05T04:30:18Z
sent_at: 2026-10-05T04:30:18Z
---
from: liaison
sent_at: 2026-10-05T04:30:00Z
---
**Illustration quality / clip-capability / art-infrastructure follow-up**

Posted `design-clip-multiasset-and-art-infra-20261005` (role: designer) to
land a design PR on kriscendobot/garden covering two threads:

1. **Clip multi-asset/multi-page capability.** Checked live just now:
   `img-src 'self' data:` is already in the deployed CSP, and
   `minion-town-clip-publishing`'s own skill doc already documents
   `publish`'s `content` as an array of files (CSS is already shipped as a
   sibling file, not inlined). This strongly suggests there is **no real
   platform gap** forcing inline-only SVG — the one-big-page,
   everything-inlined approach was a self-imposed simplification in the book
   tooling, not a hard constraint. The design job will empirically verify
   this (publish a real test clip with a separate raster image and two
   linked HTML pages) before concluding either way, and will scope the
   book's eventual move to real per-chapter pages with navigation if
   confirmed.
2. **Image-generation / art-supervisor / art-recognition infrastructure.**
   Confirmed by checking the actual reputation-event receipt that the
   illustration production genuinely was claimed by Codex
   (`provider: openai`, `model: gpt-5.6-sol`) — the model pin did not fail.
   The real problem: this garden has **no actual text-to-image generation
   capability anywhere** — both the Claude and Codex art jobs were hand-
   authoring SVG markup, which is inherently limited regardless of which
   text/code model writes it.
3. **On the OpenAI-subscription question:** confirmed the garden's Codex
   workers already authenticate via a ChatGPT-plan OAuth login (not a
   metered API key) — this repo's own design docs already note Codex's
   dollar cost is unresolved under that auth. Whether that same login also
   grants bundled image-generation access, or whether generating images
   would hit OpenAI's separately-billed Platform Images API regardless, is
   **not something I could confirm from documentation** — I did not correct
   or confirm your belief either way, and told the design job to test it
   directly (try invoking image generation under the existing Codex
   credential, see what it actually does/bills) rather than guess.

This design job carries real open questions (new credential/cost
authorization if a separate API key turns out to be needed, raster-vs-vector
choice for book art, scope of restructuring garden-book into a multi-page
site) and will land as a PR per this repo's own open-questions carve-out, not
bare to `main2`.
