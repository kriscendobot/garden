from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T22:13:47Z
doom_base: build-minion-town-retire-resident-role-20261105
doom_signature: requeue-exhausted
notice_count: 2
first_seen: 2026-11-05T21:43:33Z
last_seen: 2026-11-05T22:13:47Z
---
DOOM notice — occurrence #2 (first seen 2026-11-05T21:43:33Z, latest 2026-11-05T22:13:47Z).
This job has been doom-parked 2 times for the same condition (requeue-exhausted);
this is an AMENDED notice, not a new one. Latest detail:

SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/build-minion-town-retire-resident-role-20261105; it stays HELD until a human promotes it
(promote-plan.sh build-minion-town-retire-resident-role-20261105) or removes it, so nothing is lost.
Original job base: build-minion-town-retire-resident-role-20261105

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-11-05T21:43:14Z
handler-timeout: 3600
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-05T21:46:17Z cleared=none -->

---
posted_at: 2026-11-05T21:15:48Z
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Retire the `resident` account role in minion.town** (maintainer, kriskowal, 2026-11-05: "Let's rename the role as well. I can tolerate a database recreation event." The visitor-facing word is now "guest"; see `build-minion-town-waitlist-soon-page-20261105`).

**What is there.** `src/auth/accounts.ts`: `export type Role = "guest" | "resident"`; `BASELINE_ROLE = "guest"`; `ROLE_SCOPES` maps BOTH to `[SCOPES.TOOLS, SCOPES.GUEST]` (`resident` is a "legacy role, retained so existing account records continue to work" with no authority since the roster scope was retired; see `designs/remove-toy-tools-and-prune-minion-scopes.md` § 4, whose recommended path was to collapse the ladder to `guest`-only). Other references: `src/auth/privilege-page.ts` (a `resident`-gated route and `ROLE_SCOPES[requiredRole]`), `deploy/aws/scripts/set-account-role.sh` (`role <iss> <sub> <guest|resident>`), the display role in `accounts.ts` (`guest` | `resident` | `admin`), `deploy/aws/www/index.html` copy, tests (`test/privilege-page.test.ts` has 9, `account-endpoint`, `accounts`, `dark-mode`), and designs (`account-creation-open-signup.md`, `mcp-endo-guest.md`, `remove-toy-tools-and-prune-minion-scopes.md`).

**Since `resident` already equals `guest`, a rename would only make two names for one thing. So collapse the ladder:**
1. `Role` becomes `"guest"` only (or removed if nothing else needs it; keep the type if call sites benefit). Drop the `resident` entries and branches, the legacy-compat comments, and the `guest|resident` argument handling in `set-account-role.sh` (if the script has nothing left to set, retire the `role` verb and say so; keep suspend/activate). Rework `privilege-page.ts` and its tests so the gated-route concept uses whatever real distinction remains (the static admin policy), without a `resident` role. Keep the display role `admin` for static-policy admins.
2. **Existing rows:** do NOT delete or recreate the accounts table. Make the reader accept a stored `role: "resident"` (and any unknown value) by treating it as `guest` and rewriting it to `guest` on the next write, with a unit test. That makes the change safe with or without a recreation, and it avoids destroying any live account bindings. If you find a genuine reason a recreation is required, STOP and message the maintainer inbox with the reason; the maintainer said he can tolerate one but has not authorized a deletion, and a recreation drops every account bond (including recovery sign-ins) so it needs its own explicit go-ahead.
3. Update the designs that mention the role (a short note or edit; do not rewrite history), and the deployed copy so the word "resident" no longer appears in any visitor-facing string. `grep -rni resident` across `src`, `deploy`, `test`, `designs`, and docs should end empty except where it is deliberately explained as history.
4. Add a changeset (the repo's convention) noting the removed role. Run the full test suite, typecheck and pre-push gates; deploy and verify in production with the usual Playwright acceptance, using a dedicated test principal, and show that a pre-existing `resident` row (seed one in a test table, never in production) still signs in as a guest.

Repo: kriscendobot/minion.town (base: current main). Coordinate with the in-flight copy change in `build-minion-town-waitlist-soon-page-20261105` (it edits `deploy/aws/www/index.html` and `home.js`); if its PR is open, stack on it or rebase over it, don't fight it. Maintainer evaluates production results, not diffs.
