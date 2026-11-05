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

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-05T21:33:14Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-05T21:33:21Z
