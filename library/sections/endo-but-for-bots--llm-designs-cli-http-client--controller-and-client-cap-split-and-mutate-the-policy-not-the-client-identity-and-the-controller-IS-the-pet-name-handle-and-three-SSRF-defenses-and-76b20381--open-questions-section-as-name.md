---
title: §Open-questions-section as named uncertainty
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED
---

§Open-questions section enumerates §five-named-decisions-not-yet-made:

1. Single name or paired names for the kit?
2. Should `endo http inspect` show the live rate-limit window state or only the policy? (Default: show only policy; a `--window` flag reveals the state.)
3. What is the host's recourse if `endo http mk` is invoked against an existing name? (Default: error.)
4. Should `request`'s `cancellation` parameter be required or optional? (Document proposes: required.)
5. Should the response body carry a `sha256()` method?

§Each-open-question-has-a-default-or-a-proposal; §the-design-doesn't-leave-the-questions-purely-open + §it-makes-a-recommendation-and-marks-it-as-recommendation-not-decision. §When-uncertainty-remains, §make-a-recommendation-and-mark-it-as-recommendation-not-decision-so-the-next-reviewer-can-push-back-against-a-concrete-shape.
