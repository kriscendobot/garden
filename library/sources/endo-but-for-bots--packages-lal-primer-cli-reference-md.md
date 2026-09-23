---
source_kind: primer
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/cli-reference.md
source_line_range: 1-85
source_commit: 81f1d64b8c28470e44014cf23e7f24805fbda7f3
source_date: 2026-04-09
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 447 designs-lane ingest. 85-line
  packages/lal/primer/cli-reference.md — the Endo CLI
  reference for operators. One-hundred-and-thirty-seventh
  consecutive non-garden source after the pivot (310-447).
  Ninety-fifth AUTHORED conformant single-body section doc
  in post-refactor era.

  Single most structurally interesting move: §the-named-
  cli-as-execution-plus-daemon-surface-no-chat-equivalent
  — the CLI exposes two categories wholly absent from the
  Chat UI: (1) daemon lifecycle management (start, stop,
  restart, status, ping, log, where, clean, purge — nine
  verbs) and (2) code execution (eval, run, make, spawn,
  bundle — five verbs). Chat adds interaction-first
  extensions (/view, /edit, /dm, /network*, /share,
  /adopt-locator, /enter, /exit); CLI retains the full
  administration+execution surface. The shared vocabulary
  is inventory+messaging; the asymmetry is
  audience-shaped: Chat is for end-users and operators
  navigating the system interactively; CLI is for
  developers and daemon administrators. §the-named-
  surface-asymmetry-by-audience-needs as tier-3 meta-
  pattern. Closes the Chat/CLI asymmetry arc opened in
  cycle 445.

  §the-named-per-command-as-flag-identity-switch — the
  `-a`/`--as` flag on ANY CLI command performs per-command
  identity switching (operate as another persona for one
  command). Chat's `/enter`/`/exit` is stateful navigation
  (persistent profile switch until exit). The same
  capability (identity switching) appears as two
  UX models: flag (transient, per-command) vs
  navigation (persistent, stateful). §the-named-stateful-
  vs-per-command-identity-switch confirmed in source.

  §the-named-define-endow-as-cli-attenuation-commands —
  `endo define <source> --slots <name=label>...` proposes
  code with named capability slots; `endo endow <msgnum>
  <slot=name>...` binds capabilities to a definition and
  evaluates. The howto-code.md (cycle 423) named this
  pair as the operator-side attenuation flow; cli-
  reference.md grounds it at the CLI surface. Two
  commands, one attenuated code injection pattern.
  §the-named-define-endow-as-attenuated-code-injection
  confirmed in source.

  §the-named-invite-accept-as-guest-onboarding-pair —
  `endo invite <guest>` creates an invitation; `endo
  accept <guest-name>` accepts an invitation. The
  Agents/Profiles/Personas section names this as the
  operator bootstrapping flow for new guests. §the-named-
  invitation-bootstrap-for-guest-onboarding.

  §the-named-locate-as-cli-equivalent-of-chat-share —
  `endo locate <name>` retrieves the locator URL for a
  named value; Chat's `/share <name>` generates a locator
  with connection hints. The CLI provides raw locator
  access; Chat wraps it with network-hint context for
  sharing across peers. Same underlying operation, surface-
  specific presentation. §the-named-locate-vs-share-as-
  surface-specific-locator-access.

  §the-named-checkin-checkout-with-ci-co-shorthands —
  `endo checkin <dir>` / `endo ci` and `endo checkout
  <name> <dir>` / `endo co` ship with explicit ci/co
  aliases; conventional shorthand imported from
  version-control vocabulary. §the-named-ci-co-as-
  version-control-vocabulary-transplant.

  §the-named-cancel-formula-as-inventory-operation —
  `endo cancel <name>` cancels a formula (not a process
  signal; a formula cancellation). Distinguished from
  remove (which removes the name); cancel terminates the
  formula's lifecycle. §the-named-cancel-vs-remove-as-
  formula-vs-name-operation.

  §the-named-ninety-five-conformant-cycles-and-counting.

  Closes six citation arcs: cycle 446 (1, adjacent
  forward; TCP rung grounded at source; CLI completes the
  operator-facing reference pair) + cycle 445 (2, chat-
  reference named CLI/Chat parity with exceptions; cli-
  reference.md is the symmetry partner — arc CLOSES) +
  cycle 423 (3, howto-code.md's define/endow attenuation
  pattern confirmed at CLI surface level) + cycle 441 (3,
  howto-messaging.md's four-command lifecycle confirmed:
  send/reply/dismiss/clear all present in CLI) + cycle
  326 (75) + cycle 322 (75). Pushes citation-arc-
  closures-in-pivot to NINE-HUNDRED-AND-FOURTEEN (908 +
  6 net new).
---

85-line `packages/lal/primer/cli-reference.md` — the Endo CLI reference for operators. The CLI is invoked as `endo <command>` from the terminal; the `-a`/`--as` flag on any command performs per-command identity switching and `-n`/`--name` names a result. Designs-lane after cycle 446 chat-lane tcp-netstring.js. **Single most structurally interesting move**: §the-named-cli-as-execution-plus-daemon-surface-no-chat-equivalent — *the CLI exposes two categories wholly absent from the Chat UI: (1) daemon lifecycle management (nine verbs: start/stop/restart/status/ping/log/where/clean/purge) and (2) code execution (five verbs: eval/run/make/spawn/bundle). The shared vocabulary is inventory + messaging; the asymmetry is audience-shaped: Chat is interaction-first for end-users and operators; CLI is administration-first for developers and daemon administrators.* §the-named-surface-asymmetry-by-audience-needs as tier-3 meta-pattern. Closes the Chat/CLI asymmetry arc opened in cycle 445. §the-named-per-command-as-flag-identity-switch (`-a`/`--as` on any command = transient per-command persona; Chat's `/enter`/`/exit` = persistent stateful profile navigation); confirms §the-named-stateful-vs-per-command-identity-switch from cycle 445. §the-named-define-endow-as-cli-attenuation-commands (`endo define <source> --slots <name=label>...` proposes code with capability slots; `endo endow <msgnum> <slot=name>...` binds and evaluates; grounds howto-code.md's attenuated code injection pattern at CLI surface); §the-named-define-endow-as-attenuated-code-injection confirmed in source. §the-named-invite-accept-as-guest-onboarding-pair (`endo invite <guest>` creates invitation; `endo accept <guest-name>` accepts; operator bootstrapping flow); §the-named-invitation-bootstrap-for-guest-onboarding. §the-named-locate-as-cli-equivalent-of-chat-share (`endo locate <name>` = raw locator URL; Chat `/share <name>` = locator with network connection hints; same underlying operation, surface-specific presentation); §the-named-locate-vs-share-as-surface-specific-locator-access. §the-named-checkin-checkout-with-ci-co-shorthands (ci/co aliases transplant version-control vocabulary). §the-named-cancel-formula-as-inventory-operation (`endo cancel` terminates formula lifecycle; `endo rm` removes name; two distinct operations). §the-named-ninety-five-conformant-cycles-and-counting. Six citation arcs closed; pushes citation-arc-closures-in-pivot to NINE-HUNDRED-AND-FOURTEEN (908 + 6 net new).

## Section list

- [endo-but-for-bots--packages-lal-primer-cli-reference-md--cli-as-execution-plus-daemon-surface-and-per-command-identity-switch](../sections/endo-but-for-bots--packages-lal-primer-cli-reference-md--cli-as-execution-plus-daemon-surface-and-per-command-identity-switch.md)
