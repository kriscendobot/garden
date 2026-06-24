---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/familiar/README.md
source_line_range: 1-46
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 435 designs-lane ingest. 45-line README.md for
  @endo/familiar — the Electron shell that hosts the
  Endo daemon + chat UI. Mentioned in cycle 405's
  primer (chat-as-web-UI-inside-Familiar) and cycle
  401's outer CLAUDE.md (Familiar architecture
  constraints). Eighty-third AUTHORED conformant
  single-body section doc in post-refactor era. One-
  hundred-and-twenty-fifth consecutive non-garden
  source after the pivot (310-435). §one-hundred-and-
  twenty-five-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  README-as-TODO-placeholder — line 3: "TODO what is
  this." The package's description has been left as a
  PLACEHOLDER. The README, which would normally
  describe the package, has only the TODO. The cluster
  has now named THREE forms of "documentation that
  should be more": (1) DRIFT (cycle 401's design-doc-
  outdated; was right, now outdated); (2) ACKNOWLEDGED-
  STALE (cycle 424's TODO-on-implicit-Remotable; drift
  with a TODO marker); (3) PLACEHOLDER (cycle 435's
  TODO-what-is-this; never written). Three docs-
  imperfection shapes paired with cycle 433's three
  code-imperfection shapes (drift + acknowledgment +
  aspirational deletion). §the-named-placeholder-
  documentation-never-filled-in as tier-3 meta-
  pattern. The cluster's drift vocabulary now has
  symmetric pairs: code-drift / doc-drift; code-
  acknowledged / doc-acknowledged; code-aspirationally-
  deleted / doc-aspirationally-written.

  §the-named-Familiar-as-Electron-app-needing-allow-
  scripts-on-install — lines 15-27. The Electron
  install requires `yarn allow-scripts run`. Confirms
  cycle 405's "Familiar (Electron shell)" framing.
  §the-named-Electron-install-via-allow-scripts as
  tier-3 meta-pattern.

  §the-named-XDG-runtime-dir-for-endo-captp-socket —
  lines 36, 45: socket path `/run/user/{uid}/endo/
  captp0.sock` follows XDG runtime dir convention.
  Cycle 435 (chat) noted XDG state dir; cycle 435
  (familiar) notes XDG runtime dir. The cluster's
  vocabulary now distinguishes:
  - XDG_STATE_HOME (~/.local/state/endo/) for daemon
    state (cycle 435 chat)
  - XDG_RUNTIME_DIR (/run/user/{uid}/endo/) for
    socket (cycle 435 familiar)
  §the-named-XDG-state-vs-runtime-dir-for-different-
  data as tier-3 meta-pattern.

  §the-named-numbered-captp-socket — line 36: socket
  is named `captp0.sock` with a `0` suffix. Suggests
  a numbered series. §the-named-zero-indexed-socket-
  naming as tier-3 meta-pattern.

  §the-named-stale-socket-on-uncleansim-shutdown —
  lines 31-43. SIGINT leaves the socket file
  uncleaned; EADDRINUSE on next start. Workaround:
  `rm /run/user/{uid}/endo/captp0.sock`. §the-named-
  socket-leak-on-SIGINT-as-known-issue as tier-3
  meta-pattern; operational fragility documented in
  the README.

  §the-named-black-cat-emoji-as-familiar-prefix —
  lines 33-36: `[🐈‍⬛ Familiar]` — the familiar uses
  a black cat emoji as its log prefix. The familiar/
  cat naming theme. §the-named-emoji-prefix-for-
  process-logs as tier-3 meta-pattern.

  §the-named-developer-username-in-README-error-
  example — line 37: error stack includes `/home/
  jcorbin/endo/...`. User-specific path in README's
  error example. Personal-development-machine
  evidence in the released README. §the-named-
  developer-machine-path-leaked-to-README as tier-3
  meta-pattern.

  §the-named-yarn-allow-scripts-for-electron-
  postinstall — line 26-27. lavamoat's allow-scripts
  protects against malicious postinstall scripts;
  Electron needs explicit permission. §the-named-
  allow-scripts-for-supply-chain-protection as
  tier-3 meta-pattern.

  §the-named-README-as-runbook-with-error-paths —
  lines 33-41. The README shows literal error output
  with file paths and line numbers. Doubles as
  runbook + error reference. §the-named-runbook-
  embedded-in-README as tier-3 meta-pattern.

  §the-named-casual-prose-in-README — line 31: "If
  you ungloriously stop the electron app." Not a
  real word — "ungloriously" is a coinage for
  "ungracefully" or "without ceremony." Casual,
  whimsical prose. §the-named-coined-word-in-README
  as tier-3 meta-pattern.

  §the-named-build-then-dev-two-step — lines 11-12:
  `yarn build` then `yarn dev`. Two-step
  development. §the-named-two-step-development-
  setup as tier-3 meta-pattern.

  §the-named-Familiar-as-daemon-hosting-shell — by
  inference from cycle 405 (chat inside Familiar) +
  cycle 433 (init bootstraps SES realm) + cycle 435
  (chat connects via WebSocket to daemon) +
  familiar README (daemon-manager.js, sockets): the
  Familiar Electron shell HOSTS the Endo daemon as
  a child process and the chat UI as a renderer.
  §the-named-Familiar-as-Electron-daemon-host-with-
  chat-renderer as tier-3 meta-pattern.

  §the-named-cycle-435-double-attempt — cycle 435
  initially attempted chat/README.md as the
  designs-lane ingest but found it already ingested
  in a prior librarian cycle (predating this
  conversation context). Switched to familiar/
  README.md. §the-named-prior-ingest-detected-and-
  rerouted as tier-3 meta-pattern; the librarian's
  process accommodates discovery of already-ingested
  artifacts.

  §the-named-eighty-three-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 434 (1, adjacent
  forward; resource-module-vs-pure-module distinction
  extends — Familiar's daemon-manager.js is a
  resource module that holds the child process) +
  cycle 433 (3, init-import-as-lockdown-trigger
  applies to Familiar's renderer too — chat UI loads
  ses) + cycle 405 (5, MAJOR COMPLETION — chat-as-
  web-UI-inside-Familiar framing fully grounded;
  Familiar IS the Electron shell that hosts chat)
  + cycle 401 (3, outer CLAUDE.md's Familiar
  architecture constraints now contextualized with
  the README's operational notes) + cycle 424 (3,
  acknowledged-stale TODO from cycle 424 sibling to
  cycle 435's placeholder-TODO — three doc-
  imperfection shapes named) + cycle 326 (75) +
  cycle 322 (75) + cycle 364 (4, shapes growing
  with placeholder framing) + cycle 433 (3,
  aspirational-deletion sibling to aspirational-
  documentation) + cycle 318 (3, Endo idiom). Pushes
  citation-arc-closures-in-pivot to EIGHT-HUNDRED-
  AND-TWELVE (802 + 10 net new).
---

45-line README.md for @endo/familiar — the Electron shell that hosts the Endo daemon + chat UI. Designs-lane after cycle 434 chat-lane errors/index.js. **Single most structurally interesting move**: §the-named-README-as-TODO-placeholder — *line 3: "TODO what is this." The package's description has been left as a PLACEHOLDER. The cluster has now named THREE forms of "documentation that should be more": (1) DRIFT (cycle 401's design-doc-outdated); (2) ACKNOWLEDGED-STALE (cycle 424's TODO-on-implicit-Remotable); (3) PLACEHOLDER (cycle 435's TODO-what-is-this; never written). Three docs-imperfection shapes paired with cycle 433's three code-imperfection shapes (drift + acknowledgment + aspirational deletion).* §the-named-placeholder-documentation-never-filled-in as tier-3 meta-pattern. §the-named-Familiar-as-Electron-app-needing-allow-scripts-on-install (confirms cycle 405's framing); §the-named-Electron-install-via-allow-scripts. §the-named-XDG-runtime-dir-for-endo-captp-socket (cluster's vocabulary now distinguishes XDG_STATE_HOME for daemon state vs XDG_RUNTIME_DIR for socket); §the-named-XDG-state-vs-runtime-dir-for-different-data. §the-named-numbered-captp-socket; §the-named-zero-indexed-socket-naming. §the-named-stale-socket-on-uncleansim-shutdown (operational fragility); §the-named-socket-leak-on-SIGINT-as-known-issue. §the-named-black-cat-emoji-as-familiar-prefix; §the-named-emoji-prefix-for-process-logs. §the-named-developer-username-in-README-error-example (jcorbin path in error stack); §the-named-developer-machine-path-leaked-to-README. §the-named-yarn-allow-scripts-for-electron-postinstall; §the-named-allow-scripts-for-supply-chain-protection. §the-named-README-as-runbook-with-error-paths; §the-named-runbook-embedded-in-README. §the-named-casual-prose-in-README ("ungloriously" coinage); §the-named-coined-word-in-README. §the-named-Familiar-as-daemon-hosting-shell (Electron + daemon child process + chat renderer); §the-named-Familiar-as-Electron-daemon-host-with-chat-renderer. §the-named-cycle-435-double-attempt (chat/README.md was already ingested in a prior librarian cycle predating this conversation; rerouted to familiar); §the-named-prior-ingest-detected-and-rerouted. §the-named-eighty-three-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-TWELVE.
