---
title: §`endo http` subcommand tree replaces single verb
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

The CLI surface migrates from PR #144's `endo http-client --name <petname> --origins <urls>` (single one-shot verb at top level) to an `endo http <verb>` subcommand tree:

```text
endo http mk        <name>  <origins...>      [policy options]
endo http allow     <name>  <origin>
endo http deny      <name>  <origin>
endo http set-rate  <name>  <max-per-minute>
endo http set-bytes <name>  <max-bytes>
endo http set-time  <name>  <timeout-ms>
endo http revoke    <name>
endo http inspect   <name>
```

§Subcommand-tree-IS-the-room-to-grow-pattern + §single-verb-at-top-level-cannot-be-extended-without-collision. §Sibling to cycle 230 endor-npm-registry-proxy's named subcommands. §When-a-CLI-surface-needs-to-grow, §replace-the-flat-verb-with-a-subcommand-tree-and-make-the-creation-verb-one-among-siblings.

§Verb-names-as-placeholders-pending-namer-dispatch — §the-design-doc-uses-placeholders-and-calls-them-out-explicitly; §the-design-and-the-naming-are-two-different-decisions; §the-design-doesn't-block-on-the-namer.
