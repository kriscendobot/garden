I addressed both inline comments on kriskowal's review of endojs/endo-but-for-bots#1227. One follow-up commit is on the PR head, and CI is green. The `planes` part needs a decision, because the option doesn't exist on `origin/llm` yet.

**What changed** — commit `ea440d3eb`, pushed to `design/endo-daemon-guest-bot-incarnation` on the kriscendobot fork (only `designs/daemon-guest-bot-incarnation.md` changed):

1. **Comment 4114482956 (line 22, pins):**
   - The Status summary now names both directories: `guestPins` is the guest's own `@pins`, visible to and changeable by the guest. `hostPins` is visible only to the host, through formula introspection, and delivery reincarnates both.
   - I checked the rest of the design against `origin/llm` (`efabaed2b`: `manager.js`, `guest.js`, `formula-record.js`, `mail.js`) and made it match the landed code.
   - Updated sections:
     - the `GuestFormula` block, which now also lists `networks` and `planes`
     - the note that the formula inspector reports both pin directories
     - Retention and decommissioning, Design Decision 5, Deferred Work, Verification and Affected Packages
   - The design still says that no host method or option can put anything into `hostPins` yet, which is true of the code.
2. **Comment 4114484325 (line 111, "also `planes`"):**
   - I added `planes?: EndoDirectory` to the `MakeAgentOptions` block, with a paragraph on its meaning. It chooses the agent's `@planes` directory, which decides which content data planes the agent can advertise as source hints when it shares content. This works the way `@nets` does for connection hints.
   - **The option does not exist on `origin/llm`.** Every host and guest formula has a `planes` directory and the `@planes` name, but `MakeAgentOptions` in `types.d.ts` and `provideHost`/`provideGuest` don't accept it. They always create a fresh, empty directory. The design says this and lists accepting the option under Deferred Work.

**Replies:** I posted a reply with the commit SHA on each thread ([r4114674628](https://github.com/endojs/endo-but-for-bots/pull/1227#discussion_r4114674628), [r4114674676](https://github.com/endojs/endo-but-for-bots/pull/1227#discussion_r4114674676)). The second reply points out the `planes` gap.

**CI:** at `ea440d3eb`, 7 checks passed (including lint) and 23 were skipped, as expected for a docs-only change. Prettier passes locally. I did not merge; the conductor child job does that.

**Follow-ups:**
- **Decision needed on `planes`:** if kriskowal wants it to actually work, the daemon needs a small code change so `provideHost`/`provideGuest` accept it. That change should check the directory the same way as `pins` and `networks`, and no job exists for it yet.
- **Inbox not checked:** the inbox journal clone timed out when I tried to drain it, so I couldn't read any messages for this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-review-5329319726-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1064622 cached reads)
- Output: 9180 tokens
- Cost: $0.9277244
- Wall-clock: 860s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
