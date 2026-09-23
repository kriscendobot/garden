---
title: §Research-needed section
source-slug: endo-but-for-bots--llm-designs-familiar-localhttp-protocol
section-id: six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-localhttp-protocol.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-localhttp-protocol.md
total-lines: 636
status: Partially implemented (Familiar-side Ready; Chat-side Not Yet)
ingest-cycle: 220
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
---

§Four-named-open-verification-items:
1. Verify `app.configureHostResolver` with unreachable DoH prevents *all* DNS queries.
2. Confirm literal IP addresses bypass `--host-resolver-rules` MAP and DoH path.
3. Test whether `setProxy({ proxyRules: 'direct://' })` provides additional DNS isolation.
4. Determine whether `<a ping="...">` hyperlink auditing bypasses CSP `connect-src`.

§Borrowable-pattern: §Research-needed-section-as-honest-acknowledgment-of-incomplete-verification. §The-design-ships-but-the-author-names-what-isn't-verified-yet. §Honest-disclosure of §what-the-design-author-doesn't-know.

§The-Open-Questions-section at the end says explicitly: `(None remaining.)` — §the-design-knows-which-questions-have-been-resolved-and-which-haven't; §two-different-sections-for-two-different-classes-of-uncertainty (Research-needed = verification + Open-Questions = decision).
