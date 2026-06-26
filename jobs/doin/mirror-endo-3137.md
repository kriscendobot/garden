# Mirror endojs/endo#3137 onto endo-but-for-bots

Mirror upstream **endojs/endo#3137** (`feat: support .ts runtime modules via erasable type
syntax`) onto the bot fork **endojs/endo-but-for-bots** (bot has direct push there), per the
garden mirror workflow. Wear the **boatman/mirror** role (mirror direction — bringing an upstream
PR onto the bot fork; bot identity, NOT an upstream identity-switch). Bot repo.

## Task

1. Fetch upstream #3137's branch/commits (`endojs/endo`, head `<#3137 head>`, base
   `<#3137 base>`). Create a mirror branch on `endojs/endo-but-for-bots` carrying #3137's commits,
   based on the matching bot-fork base (sync the bot base to current `endojs/endo` upstream first
   if drifted, per the mirror discipline; use a frozen-base snapshot if the bot convention calls
   for it).
2. **Open a mirror PR** on `endojs/endo-but-for-bots` (a real PR object — a compare URL alone is
   insufficient) whose body links to upstream #3137 and notes it is a mirror for autonomous work.
   Preserve #3137's title/description (note the mirror provenance).
3. Resolve any conflicts that arise from the bot base differing from upstream; if the mirror needs
   porting beyond a clean apply, escalate to a fixer and resume per the standing rule.

## Definition of done

A mirror PR open on `endojs/endo-but-for-bots` carrying endojs/endo#3137's content, linked to the
upstream PR, on the correct bot base. Report the mirror PR number and its base/head. If #3137 is
already mirrored, report the existing mirror PR instead of opening a duplicate.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 100
  claimed_at: 2026-06-26T06:52:32Z
