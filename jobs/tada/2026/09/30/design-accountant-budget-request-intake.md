The intake design is landed on `main2` as commit `05311a7f512`. It went in directly, with no review PR, because it leaves no open questions for you. The build job's text wasn't changed, but it will still pick up the new work (details below).

**How it works**

- **Where requests go.** Requests are files in a journal folder, `budget/requests/open/<effort>.md`. Once decided, they move to `budget/requests/closed/<week_start>/`. I didn't use the `role/accountant` bus topic: its read positions are kept per host and it can't mark a request open or decided. I didn't use a directed accountant inbox either: it only exists while an accountant job is live, and a message sent when none is live gets turned into a new job. The folder survives between accountant jobs, so no request is lost when no accountant is running.
- **What a request says.** Effort name, arc, estimated tokens, which week (this or next), which foreman-mandate item it serves, urgency (blocked, soon or whenever), what happens if it's unfunded, a link, and one to three lines of why. Filing one is a single command, `request-budget.sh`. A second request for the same effort updates the existing file and bumps a counter, so asking louder adds no tokens.
- **Who files a request.**
  - Automatically, by script: an orchestration recorded with `--budget-tokens`, and the foreman once per week for each arc whose plans are held on an exhausted slice.
  - By instruction in the role briefs: a designer landing a large build, an orchestrator without a token cap, a producer that wants a press or campaign cap (instead of running `set-arc-budget.sh` itself), and any job parking on `--budget-hold` that can estimate its size.
- **Weekly roll-up.** The accountant's statement gets a Demand section. It groups requests by arc, orders them by the slate's ranking, and flags any request whose stated mandate item doesn't match its arc's rank. It shows requested tokens against available tokens. Available is the week's total times a 90% planning ceiling (a setting in `config/apportionment`), plus any reset credit you've recorded. Requests without a size are estimated from past spend in that arc.
- **Closing requests.** After the slate is applied, `close-budget-request.sh` marks each request funded, partial, deferred, declined or expired. It messages the requester only if their job is still running, so a finished job isn't brought back to life; the closed file is the record. A request nobody renews over three weekly statements expires.
- **Mid-week.** An open "blocked" request whose arc has no budget left can trigger the existing re-slice reminder to you, at most once a day.
- **Guardrails.** Requests are advisory only: they never write config or grant tokens. Only a slate you approve does. No borrowing between arcs or weeks and no cancelling in-flight work, as before.

**Files changed**

- `designs/accountant-arc-apportionment.md`: the new § Budget requests section, two new rows in the ownership map, and an "Intake scope" list added to § Build plan.
- New `skills/budget-request/SKILL.md`.
- `roles/accountant/AGENT.md`: a new rule on handling requests, and the weekly definition of done now includes closing decided requests.
- A pointer to the skill in the designer and orchestrator briefs, and a short "Asking for budget" section in `roles/COMMON.md`.
- `CLAUDE.md`: the skill list now includes `budget-request`.
- The garden's cliché and British-spelling checks found nothing in the changes.

**Build job and follow-ups**

- **Build job text unchanged.** `build-accountant-arc-apportionment` had already left the plan queue and is waiting unclaimed in `todo/`, so the annotation step skipped it. Its body says to implement the design's § Build plan, which now contains the Intake scope, so the builder will see it. Intake doesn't depend on the rest of the build and could land first.
- **Nothing from the budgeting conversation yet.** My inbox was empty both times I checked. The conversation job (`accountant-budget-conversation-20260930`) is still waiting in `todo/`, so nothing from it is folded in.
- **One assumption to check.** "90% ceiling" and "reset credits" weren't defined anywhere in the repo. I defined them myself as a planning ceiling defaulting to 0.90 and credits you record in `budget/reset-events/`. Say if you meant something else.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-accountant-budget-request-intake.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1880435 cached reads)
- Output: 18683 tokens
- Cost: $1.4197710000000003
- Wall-clock: 204s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
