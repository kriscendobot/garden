---
source_kind: agent-launch-config
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: evoke/config.sh
source_line_range: 1-19
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 390 chat-lane ingest paired to cycle 389 designs-
  lane exo-method-banks doc. 19-line evoke/config.sh, the
  shell-script configuration for invoking the agent.
  Companion to cycle 383's evoke/SOUL.md. Thirty-eighth
  AUTHORED conformant single-body section doc in post-
  refactor era. Eightieth consecutive non-garden source
  after the pivot (310-390). §eighty-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  three-layer-agent-config-launch-soul-conventions —
  cycle 383's evoke/SOUL.md was the agent's DISCIPLINE
  document (workflow, planning, constraints); cycle 387's
  AGENTS.md was the repo's CODE CONVENTIONS document
  (TypeScript, types-index, exo, commit rules); cycle 390's
  evoke/config.sh is the agent's LAUNCH CONFIGURATION
  (binary, args, paths, notification URL). THREE LAYERS of
  agent configuration coexist in the bot-fork's repo,
  each at a different level: how to launch the agent,
  how the agent behaves, how the agent codes. §the-named-
  three-files-for-three-layers-of-agent-config as tier-3
  meta-pattern.

  §The-named-evoke-as-agent-invocation-tool — the script
  is for "evoke," which the directory naming (evoke/)
  implies is a tool that LAUNCHES (evokes) the agent.
  Companion to cycle 383's evoke/SOUL.md which is loaded
  INTO the agent by evoke. §the-named-evoke-as-companion-
  to-soul as tier-3 meta-pattern.

  §The-named-AGENT_NAME-and-AGENT_ARGS-pair — line 16-17:
  `AGENT_NAME='claude'` and `AGENT_ARGS=('claude' '--
  dangerously-skip-permissions')`. The agent name is a
  separate variable from the launch command, so they can
  be referenced independently. §the-named-name-vs-args-
  as-separated-config as tier-3 meta-pattern.

  §The-named-claude-not-pi-comment — line 15: "Evoking
  Claude not Pi for now." A pithy comment that names BOTH
  options (Claude AND Pi) and the CURRENT CHOICE. §the-
  named-multi-agent-support-implied-via-not-X-for-now as
  tier-3 meta-pattern; the comment names the alternative
  even when not used, so future readers know the toolchain
  supports multiple agents.

  §The-named-dangerously-skip-permissions-flag — line 17
  passes `--dangerously-skip-permissions` to claude. The
  flag's name acknowledges the danger; the bot-fork
  deliberately opts in. §the-named-dangerous-flag-named-
  as-dangerous as tier-3 meta-pattern; the developer
  acknowledges they're skipping safety for development
  velocity.

  §The-named-AGENT_SESSIONS-path-via-PWD-substitution —
  line 18: `AGENT_SESSIONS="$HOME/.claude/projects/${PWD//
  \//-}"`. The current working directory is substituted
  into a sessions path with `/` → `-` substitution. §the-
  named-pwd-as-project-identifier-with-substitution as
  tier-3 meta-pattern; the path encoding survives the OS's
  directory-separator semantics.

  §The-named-NOTIFY-URL-as-webhook — line 8: `NOTIFY=http:
  //127.0.0.1:8077/chat`. The agent posts notifications to
  a local webhook (likely the @endo/chat app from cycle
  385 running locally on port 8077). §the-named-localhost-
  webhook-for-agent-notifications as tier-3 meta-pattern;
  the agent talks to the chat UI via HTTP POST.

  §The-named-TASK_FILE-commented-out-with-TODO — lines 2-
  3: `# TODO want to disable this, but not sure evoke
  supports empty string / # TASK_FILE=TODOs.md`. The
  developer named the desired state (disable) AND the
  obstacle (uncertainty about empty-string support).
  Sibling honest-acknowledgment shape from cycles 357/359/
  372/375/377/378/379. §the-named-want-but-not-sure-as-
  named-tension as tier-3 meta-pattern.

  §The-named-TASKS_IN-TASKS_OUT-task-section-markers —
  lines 5-6: `# TASKS_IN=TODO` and `# TASKS_OUT=TADA`.
  Commented-out names for the input task section and
  output task section. The default is presumably the
  same (TODO / TADA — a cute name choice). §the-named-
  TODO-TADA-as-task-section-pair as tier-3 meta-pattern.

  §The-named-NEXT_TASK_DELAY-1m-as-pacing-knob — line 10
  `# NEXT_TASK_DELAY=1m` (commented out). The autonomous
  loop's between-task delay can be set to 1 minute, but
  the default is presumably faster or different. §the-
  named-autonomous-loop-pacing-via-config as tier-3 meta-
  pattern.

  §The-named-AGENT_IDENTITY-as-whoami-repo-hostname — line
  13 (commented out): `AGENT_IDENTITY="$(whoami)+${REPO_
  NAME}@$(hostname)"`. The identity format is "user+repo
  @host". §the-named-three-part-identity-user-repo-host
  as tier-3 meta-pattern; the agent identity ties to the
  user, the repo, and the machine — a three-part naming
  for multi-host multi-repo agent operation.

  §The-named-AGENT_CURRENT_SESSION-empty-as-fresh-start —
  line 19: `AGENT_CURRENT_SESSION=` (empty). The current
  session is set to empty, meaning the next invocation
  starts a fresh session. The variable's existence implies
  the agent CAN resume a session if set. §the-named-
  empty-session-variable-as-resume-shape as tier-3 meta-
  pattern.

  Closes seven citation arcs: cycle 389 (1, adjacent
  forward; method-bank/exo two-layer pattern → three-
  layer agent config; both are about layered structure
  but at different domains) + cycle 387 (1, AGENTS.md is
  one of the three layers cycle 390 names) + cycle 383
  (1, SOUL.md is the second of the three layers) + cycle
  385 (1, chat README ingested earlier; the NOTIFY URL on
  port 8077 likely points to the @endo/chat app from
  cycle 385) + cycle 326 (64, pure-naming-as-discipline;
  the three-layer naming is pure naming applied to agent
  config) + cycle 357 (2, want-but-not-sure honest-
  acknowledgment sibling) + cycle 322 (64). Pushes
  citation-arc-closures-in-pivot to FOUR-HUNDRED-NINE
  (402 + 7 net new).
---

19-line evoke/config.sh, the shell-script configuration for invoking the agent. Companion to cycle 383 SOUL.md. §the-named-three-layer-agent-config-launch-soul-conventions (single most structurally interesting move; evoke/config.sh = launch + evoke/SOUL.md = behavior + AGENTS.md = code conventions; three layers of agent configuration). §the-named-evoke-as-agent-invocation-tool; §the-named-evoke-as-companion-to-soul. §the-named-AGENT_NAME-and-AGENT_ARGS-pair. §the-named-claude-not-pi-comment (multi-agent support implied by naming the alternative). §the-named-dangerously-skip-permissions-flag (dangerous flag named as dangerous). §the-named-AGENT_SESSIONS-path-via-PWD-substitution. §the-named-NOTIFY-URL-as-webhook (likely cycle 385 chat app on port 8077). §the-named-TASK_FILE-commented-out-with-TODO (want-but-not-sure honest-acknowledgment sibling shape). §the-named-TASKS_IN-TASKS_OUT-task-section-markers (TODO/TADA pair). §the-named-NEXT_TASK_DELAY-1m-as-pacing-knob. §the-named-AGENT_IDENTITY-as-whoami-repo-hostname (three-part identity user+repo@host). §the-named-AGENT_CURRENT_SESSION-empty-as-fresh-start. Seven citation arcs closed.
