# Address kriskowal's CHANGES_REQUESTED review on endo-but-for-bots #513

Maintainer review (kriskowal, CHANGES_REQUESTED, 2026-06-24T22:56Z) on PR **#513**
("feat(pubsub): create @endo/pubsub …", branch `feat/endo-pubsub`):
https://github.com/endojs/endo-but-for-bots/pull/513#pullrequestreview-4566543393

Posted by the liaison (rsvp). Wear the **fixer** role (`roles/fixer/AGENT.md`). Repo:
`endojs/endo-but-for-bots`, PR **#513**. Address every inline ask; reply on each
thread citing the fixing commit SHA (standing endo-but-for-bots authorization permits
commenting).

## The four asks (all in packages/pubsub/)

1. **`cancel-kit.js`** — "This should be obviated by #345 which has purportedly
   already merged." Verify #345 (the `endo/cancel` work) is merged and provides the
   needed cancellation; if so, **remove `cancel-kit.js`** and use `@endo/cancel`
   instead. Confirm before deleting.
2. **`cancel-kit.js` (line 2 reference)** — "This reference should be superfluous since
   we import every reference we need. Please verify." Verify and **remove the
   superfluous reference** if confirmed.
3. **`index.js`** — "This is a barrel module and we strongly discourage them. Please
   remove this, obligating dependent modules to import the specific tool they need.
   Important for artifact/archive/bundle minimization (no automated tree shaking)."
   **Remove the barrel `index.js`** and update every dependent (in-repo) to import the
   specific module it needs directly. Update `package.json` `exports`/`main` as
   appropriate so consumers import specific tools, not a barrel.
4. **`README.md` (~line 127)** — "Update for endo/cancel." **Update the README** to
   reflect using `@endo/cancel` (consistent with removing `cancel-kit.js`).

## Task

Apply all four, keeping the change coherent (removing the barrel may require touching
the package's `exports` map and any in-repo importers). Update/extend tests. Push to
`feat/endo-pubsub` (bot identity; bot-fork PR — no identity switch). Reply on each of
the four inline threads with the fixing SHA, then **re-request review** from kriskowal.
If #345/`@endo/cancel` is NOT actually merged/available, report that rather than
deleting `cancel-kit.js` blindly. Post `shepherd-ebfb-pr513` after if CI impact is
non-trivial.

## Definition of done

All four review asks addressed (cancel-kit removed in favor of @endo/cancel if
confirmed; superfluous reference removed; barrel index.js removed with importers
updated; README updated for endo/cancel), tested, pushed under the bot identity, each
inline thread replied to with its SHA, review re-requested. Report the head SHA and
per-ask resolution. If any ask needs a judgment call, report rather than guessing.

Posted by the liaison on behalf of the maintainer.
