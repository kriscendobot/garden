---
role: accountant
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: accountant.** Open a **budgeting conversation with the maintainer** and hold it through your inbox.

Maintainer ask (kriskowal, liaison session 2026-09-30): "I would like to have a conversation with our new accountant about budgeting. A number of efforts are clamoring for a budget slice. I feel we need to find a way to nudge roles to dispatch messages to an accountant inbox so the accountant can roll up what needs tokens and present a proposed budget, informed by the current priorities the foreman currently holds."

**Context:** your design is `designs/accountant-arc-apportionment.md` (status Proposed). Its build (`build-accountant-arc-apportionment`) is parked behind go-ahead, so `set-apportionment.sh` and `accountant-statement.sh` **do not exist yet**. This is a conversation, not an apply. Do not write `config/apportionment`, `config/arc-budgets/*` or `config/foreman-mandate`.

Standing policies to honor:
- Spend a subscription to 90%, never 100% (see your inbox history on `design-accountant-role-budget-apportionment` and `journal2:projects/garden/reset-credits.md`).
- Reset credits are used mid-week before they expire (the weekly `reset-credit-watch` schedule).

**Do:**
1. **Survey who is clamoring for tokens.** Gather this from the board, not from guesses:
   - `jobs/plan/` (parked work, with its gates and priorities), `jobs/todo/`, `jobs/doin/`;
   - active orchestrations (`jobs/orch/`);
   - live press schedules (`schedules/`);
   - per-arc and campaign spend where recorded (`arc-spend.sh`, `campaign-spend.sh`, `usage/`).
   - Group it into candidate **arcs** (efforts), each with its recent spend and its outstanding demand.
2. **Read the foreman's current priorities** in `config/foreman-mandate` (kriskowal 2026-09-26):
   1. minion.town capabilities: remote Claude, and the capability git remote;
   2. endor metering (explorative);
   3. ironhorse.
3. **Build the capacity picture:** this week's remaining quota per subscription, with natural resets on Fri 20:00 PT, the 90% ceiling, and the reset credits (see `reset-credits.md` and the latest checkpoints).
4. **Send the maintainer an opening message** with `message-user.sh <your-base>`, one screen:
   - the capacity picture;
   - the clamoring efforts with their demand;
   - a **proposed slate**, ranked slices of this week's foreman budget, informed by the mandate, with one-line reasons;
   - **2–3 specific questions** for the maintainer: what to cut, what to rank up, whether the mandate still holds.
5. **Converse:** wait on your own inbox for replies; the liaison relays them. Answer, refine the proposal, and repeat until the maintainer is satisfied or says stop.
6. **Record the agreed outcome** as a note at `journal2:projects/garden/budget-slate-<YYYYMMDD>.md`, via `land-journal-edit.sh`: the agreed slate, the reasons, and any mandate change the maintainer wants. That note becomes the input the build will apply once it lands. Also carry the maintainer's views on the **budget-request intake** mechanism (a separate design job, `design-accountant-budget-request-intake`) to that job's inbox.

Handler budget: this is a conversation, so use `post-plan.sh --budget-hold` / `--go-ahead` handoffs rather than running out the clock if the maintainer is slow to reply.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T21:14:09Z
