---
title: §Five-step-CLI-installation composing existing verbs
source-slug: endo-but-for-bots--llm-designs-endoclaw-skill-registry
section-id: no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-skill-registry.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-skill-registry.md
total-lines: 252
status: Not Started
ingest-cycle: 222
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-skill-registry--no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
---

```bash
endo list skills                                 # Browse
endo list skills gmail-bridge requires           # Inspect
endo adopt skills gmail-bridge code gmail-bridge-code  # Adopt
endo install gmail-bridge-code --name gmail-bridge     # Install
endo grant gmail-bridge oauth my-gmail-oauth     # Grant
endo grant gmail-bridge network-fetch gmail-http
```

§No-new-verbs — every step uses an existing CLI verb (list / adopt / install / grant). §Borrowable-pattern: §the-design-of-a-new-feature-is-a-composition-of-existing-verbs, §not-an-introduction-of-new-ones.

§Plus-an-optional-convenience-wrapper: `endo hub install gmail-bridge --from skills` — §single-command-encapsulating-the-five-steps + §interactive-confirmation-prompt with the description + requires + `Install and grant? [y/N]`.

§Two-shapes-for-the-same-operation: §explicit-five-step-flow + §single-convenience-command. §Borrowable-pattern: §provide-the-explicit-flow-and-the-convenience-wrapper; §the-explicit-flow-teaches-the-shape + §the-convenience-wrapper-makes-it-easy.

§Sibling to cycle 218 familiar-chat-weblet-hosting's §every-UI-action-also-has-a-command — same §three-surfaces-for-the-same-action discipline.
