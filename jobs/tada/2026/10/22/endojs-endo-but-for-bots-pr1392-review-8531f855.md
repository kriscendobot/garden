I didn't change any code on #1392. I posted a fixer job to do kriskowal's requested change, and a host-pinned relay job to post my reply. Both are now on the board in `jobs/todo/`.

**What the review asks for:** both inline comments are on `packages/pass-style/src/parcel.js`. At line 84, kriskowal says `makeBrandCheck` is a shape check that an object with the same shape can fool. They want a brand check instead: is it an object, and does it have an entry in a WeakMap from each parcel to its private slots (open hook and location)? At line 1, they say they expect WeakMap-backed private state there. The review body was "@kriscendobot rsvp", which I read as a request for an acknowledgement. The peer-resolution check found nothing already done, so I went ahead.

**What I found:** that WeakMap already exists. `packages/parcel/src/parcel-shim.js` keeps every Parcel in a private `details` WeakMap of `{ location, openHook }`, and `Parcel.isParcel` just asks that WeakMap whether it holds the value. `designs/parcel.md` § Pass style also says "The brand check is the only recognition path." So the fix is to drop the shape checks and have pass-style test that the value is an object, then call the realm's `Parcel.isParcel`.

**Fixer job `endojs-endo-but-for-bots-pr1392-parcel-weakmap-brand`** (role fixer). It tells the fixer to:
- replace the shape checks with the object test plus `Parcel.isParcel`;
- rework or delete the tests that only exercise the shape checks (`parcel.test.js`, `parcel-pre-shim*.js`);
- add a test that a frozen, empty object with the right prototype but no WeakMap entry is not a Parcel;
- fix the PR body text that describes the shape checks;
- run the pass-style, marshal and patterns tests and lint before pushing;
- reply to both inline comments with the commit SHA.

If the fixer decides pass-style must own or import the WeakMap itself, it has to ask kriskowal rather than change the design's layering (`@endo/parcel` never depends on pass-style).

**Reply job `endojs-endo-but-for-bots-pr1392-review-rsvp-relay`** (pinned to `endolin-garden-ece02cb4`). Posting the reply from this host failed with HTTP 403 ("Resource not accessible by personal access token"). This is the known limit of the bot's token on this host, so the job hands the posting to the endolin host. The reply:
- agrees to replace the shape check with a WeakMap brand check;
- points out that the WeakMap already lives in the shim, and outlines the fix and the impostor test;
- asks kriskowal whether they want the WeakMap inside pass-style itself, which would mean `@endo/parcel` and pass-style depending on each other differently than the design says;
- names the fixer job.

The relay job checks first that the comment isn't already there, so it won't post twice.

There were no bot-authored follow-ups in the review for the follow-up guard to catch, so I parked nothing.

**Follow-ups:**
- Both successor jobs may run into the same 403 when they reply on the PR. The relay job can only run on `endolin-garden-ece02cb4`, and per an earlier note that host has sometimes been over its token cap and left jobs waiting for over an hour.
- The fixer's inline replies may need the same relay to endolin if it runs on oros.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-review-8531f855.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1279605 cached reads)
- Output: 9387 tokens
- Cost: $1.0057329999999998
- Wall-clock: 556s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
