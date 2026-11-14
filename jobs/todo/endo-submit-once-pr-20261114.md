---
posted_at: 2026-11-14T13:40:31Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Open the submitOnce patch as a draft PR against endojs/endo-but-for-bots llm

Maintainer ask (kriskowal, liaison session 2026-11-14, relayed from the Tower). Repo: endojs/endo-but-for-bots, base `llm`. This is Endo work only.

## Task
Apply the patch below (a `git format-patch` email, authored "Kriskow Bot" — re-author it) to a branch off live `llm`, as a new draft PR. Keep the commit message; replace author and committer with the bot identity (kriscendobot). Suggested head: `submit-once`.

1. `git am` (or `git apply --index`) the patch on current `llm`. It applied cleanly at `204033b39`; if `llm` has moved and it conflicts, resolve conflicts, keeping `submit` unchanged.
2. Run the CI-equivalent checks locally before pushing (memory: CI failure = automation defect): `ava test/endo.test.js` for the mail/message/dismiss/form/submit/value/inbox selection (84 tests expected, seven new `submitOnce` tests), `help-text.test.js` (5), `mail-pins.test.js` (4), `tsc` including the repo-root `tsc -p tsconfig.json`, `eslint` on changed files, and root `yarn prettier --write` on changed files. The Tower's runs used the downstream app's Endo pin's installed dependencies, not a fresh install of `llm`, so do a fresh install for the PR (see the yarn EMLINK workaround note if install fails) and report honestly any failure.
3. Open the PR as a DRAFT against `llm` as kriscendobot. Body: summary of what it fixes (`submit` delivers then writes the sent copy; a crash between leaves a retrying caller unable to tell, so it sends a second answer), the `submitOnce(messageNumber, values, attempt)` contract, the Tower's evidence, and the one open window below. Mark it for maintainer review; do NOT merge.
4. The gauntlet follows the usual chain; do not un-draft by hand.

## Facts from the Tower (verbatim essentials)
- `submitOnce` returns `{ messageId, attempt, first }`. It binds the value message in the member's mailbox store as `attempt-<attempt>` before delivering, binds `answered-<attempt>` once the sender has received it, and only then writes the member's sent copy. A known attempt sends nothing new and returns the first message id with `first: false`.
- Attempt: 1 to 128 of `[A-Za-z0-9_-]`; kept until the member dismisses the form (removes them); at most 64 per form (a further new attempt is refused, a known one still answers). Calls serialized per mailbox. Delivery now ignores a message its mailbox already holds from the same sender with the same id.
- One window left open: a daemon stopped after the sender's delivery and before `answered-<attempt>` is written; the retry delivers again, and only the sender's own copy, if still held, prevents a second answer. Closing it would need the recipient to remember delivered ids after dismissal. State this in the PR; do not try to close it here.
- downstream web-app crash campaign: with `submit`, 21 of 64 cuts sent a second answer; with `submitOnce`, 0 of 96.
- Note for the PR: this touches `packages/daemon/src/mail.js`, the same area as a possible future mailbox-archive design (archive as a move to an archive store). Do not anticipate it.

## Patch
```
From e1deea1458f89f85d57304e3edd44c8467a05409 Mon Sep 17 00:00:00 2001
From: Kriskow Bot <kriskowbot@tower.invalid>
Date: Sat, 14 Nov 2026 05:36:34 +0000
Subject: [PATCH] feat(daemon): submitOnce answers a form at most once per
 attempt

`submit` delivers the value message to the form's sender, then writes the
member's sent copy. A caller that retries after losing the answer (a
daemon killed between the two writes, a dropped connection) cannot tell
whether the first call reached the sender, so a retry sends a second
answer.

`submitOnce(messageNumber, values, attempt)` takes a caller's retry key.
The mailbox keeps the attempt in its store as `attempt-<attempt>`, bound
to the formula of the value message, durably, before anything is
delivered. Once the form's sender has received the message, the store
also binds `answered-<attempt>` to the same formula, and only then is the
sent copy written. A call with a known attempt sends no new answer and
returns the first call's message id with `first: false`:

- `answered-<attempt>` is held: nothing goes to the sender; a missing sent
  copy is written again.
- only `attempt-<attempt>` is held: the first call stopped before the
  sender's delivery was recorded, so the same message (same id, same
  values) is delivered again. Delivery now ignores a message its mailbox
  already holds from the same sender with the same id.

An attempt is 1 to 128 of `[A-Za-z0-9_-]`. Attempts are kept until the
member dismisses the form they answer, which removes them, and a form
holds at most 64: a further new attempt is refused, a known one still
answers. Calls are serialized per mailbox, so concurrent calls with one
attempt send once. Attempts are reloaded with the mailbox after a
restart. `submit` is unchanged.

Tested with `ava test/endo.test.js` (seven new submitOnce tests, and the
mail, message, dismissal, form and value tests), `help-text.test.js` and
`mail-pins.test.js`, `tsc` and `eslint` on the changed files (no new
errors or warnings). The test of a retry after both the sender dismissed
the answer and the member's sent copy was lost fails against a version
that re-posts whenever the sent copy is missing. Endo's harness cannot
stop the daemon between the two writes, so the crash state is made by
dismissing the sent copy. Not covered by a test: a daemon stopped after
the sender's delivery and before `answered-<attempt>` is written, where
the retry delivers again and relies on the sender still holding the
first copy.

These results are from the commit on 825c598bc649. On `llm` at
204033b39 the commit applies without conflict; there `tsc` is clean and
the same `endo.test.js` selection passes (84 tests, the seven new ones
among them), run on the pin's installed dependencies with `llm`'s
workspace packages linked in, not on a fresh install of `llm`.
---
 packages/daemon/src/guest.js          |   6 +
 packages/daemon/src/help-text-data.js |   4 +
 packages/daemon/src/help.md           |  28 +++
 packages/daemon/src/host.js           |   2 +
 packages/daemon/src/interfaces.js     |  12 +
 packages/daemon/src/mail.js           | 344 ++++++++++++++++++++++++--
 packages/daemon/src/manager.js        |   1 +
 packages/daemon/src/types.d.ts        |  45 ++++
 packages/daemon/test/endo.test.js     | 230 +++++++++++++++++
 9 files changed, 652 insertions(+), 20 deletions(-)

diff --git a/packages/daemon/src/guest.js b/packages/daemon/src/guest.js
index 6b5288195..dcc3c781f 100644
--- a/packages/daemon/src/guest.js
+++ b/packages/daemon/src/guest.js
@@ -209,6 +209,7 @@ export const makeGuestMaker = ({
       define: mailboxDefine,
       form: mailboxForm,
       submit: mailboxSubmit,
+      submitOnce: mailboxSubmitOnce,
       sendValue: mailboxSendValue,
     } = mailbox;
 
@@ -325,6 +326,10 @@ export const makeGuestMaker = ({
     const submit = (messageNumber, values) =>
       mailboxSubmit(messageNumber, values);
 
+    /** @type {EndoGuest['submitOnce']} */
+    const submitOnce = (messageNumber, values, attempt) =>
+      mailboxSubmitOnce(messageNumber, values, attempt);
+
     /** @type {EndoGuest['sendValue']} */
     const sendValue = (messageNumber, petNameOrPath) =>
       mailboxSendValue(messageNumber, petNameOrPath);
@@ -507,6 +512,7 @@ export const makeGuestMaker = ({
       storeBlob,
       storeValue,
       submit,
+      submitOnce,
       sendValue,
       invite,
       accept,
diff --git a/packages/daemon/src/help-text-data.js b/packages/daemon/src/help-text-data.js
index 7ae067d2b..24d5b4665 100644
--- a/packages/daemon/src/help-text-data.js
+++ b/packages/daemon/src/help-text-data.js
@@ -108,6 +108,8 @@ export const helpTextEntries = harden([
         'storeValue(value, petNameOrPath) -> Promise<void>\nStore a passable value (number, string, array, record, etc.) in your directory.\n- storeValue(42, "answer") stores the number 42 as "answer"\n- storeValue({x: 1, y: 2}, "point") stores a record as "point"\n- storeValue(["a", "b"], ["subdir", "items"]) stores in a subdirectory\nValues must be passable (no functions or non-transferable objects).',
       submit:
         'submit(messageNumber, values) -> Promise<void>\nSubmit values for a form message. Each call creates a new value message\nin reply to the form, allowing multiple submissions.\n\n- messageNumber: The inbox message number of the form\n- values: A record with keys matching the form\'s field definitions\n\nExample: submit(0, { name: "Alice", age: 30 })',
+      submitOnce:
+        'submitOnce(messageNumber, values, attempt) -> Promise<{ messageId, attempt, first }>\nSubmit values for a form message at most once per attempt. Retrying with\nthe same attempt sends no second answer; it returns the first call\'s\nmessageId with first: false.\n\n- messageNumber: The inbox message number of the form\n- values: A record with keys matching the form\'s field definitions\n- attempt: A retry key, 1 to 128 letters, digits, "-" or "_"\n\nAttempts are kept until the form is dismissed, at most 64 per form.\n\nExample: submitOnce(0, { name: "Alice" }, "a1b2c3")',
       sendValue:
         'sendValue(messageNumber, petNameOrPath) -> Promise<void>\nReply to any message with a retained value from your pet store.\n\n- messageNumber: The inbox message number to reply to\n- petNameOrPath: Pet name (or path) of the value to send\n\nExample: sendValue(0, "my-counter")',
       readText:
@@ -166,6 +168,8 @@ export const helpTextEntries = harden([
       form: 'form(recipientName, description, fields) -> Promise<void>\nSend a structured form to another agent.\nThe form appears in the recipient\'s inbox. They can submit values using submit().\n\n- recipientName: Pet name or path of the recipient\n- description: Human-readable description of what the form is for\n- fields: Array of field definitions, e.g. [{ name: "email", label: "Your email" }]\n\nExample: form("@host", "Configure settings", [{ name: "name", label: "Name" }, { name: "email", label: "Email" }])',
       submit:
         'submit(messageNumber, values) -> Promise<void>\nSubmit values for a form message. Each call creates a new value message\nin reply to the form, allowing multiple submissions.\n\n- messageNumber: The form message number\n- values: Record mapping field names to values, e.g. { name: "Alice" }\n\nEach value must match the pattern specified by the form field (if any).\nFields without explicit patterns default to M.string().\n\nExample: submit(0, { name: "Alice", age: 30 })',
+      submitOnce:
+        'submitOnce(messageNumber, values, attempt) -> Promise<{ messageId, attempt, first }>\nSubmit values for a form message at most once per attempt. Retrying with\nthe same attempt sends no second answer; it returns the first call\'s\nmessageId with first: false.\n\n- messageNumber: The inbox message number of the form\n- values: A record with keys matching the form\'s field definitions\n- attempt: A retry key, 1 to 128 letters, digits, "-" or "_"\n\nAttempts are kept until the form is dismissed, at most 64 per form.\n\nExample: submitOnce(0, { name: "Alice" }, "a1b2c3")',
       sendValue:
         'sendValue(messageNumber, petNameOrPath) -> Promise<void>\nReply to any message with a retained value from your pet store.\n\n- messageNumber: The inbox message number to reply to\n- petNameOrPath: Pet name (or path) of the value to send\n\nExample: sendValue(0, "my-counter")',
       getFormulaGraph:
diff --git a/packages/daemon/src/help.md b/packages/daemon/src/help.md
index c54a85e67..6f6e9934b 100644
--- a/packages/daemon/src/help.md
+++ b/packages/daemon/src/help.md
@@ -328,6 +328,20 @@ in reply to the form, allowing multiple submissions.
 
 Example: submit(0, { name: "Alice", age: 30 })
 
+## submitOnce(messageNumber, values, attempt) -> Promise<{ messageId, attempt, first }>
+
+Submit values for a form message at most once per attempt. Retrying with
+the same attempt sends no second answer; it returns the first call's
+messageId with first: false.
+
+- messageNumber: The inbox message number of the form
+- values: A record with keys matching the form's field definitions
+- attempt: A retry key, 1 to 128 letters, digits, "-" or "_"
+
+Attempts are kept until the form is dismissed, at most 64 per form.
+
+Example: submitOnce(0, { name: "Alice" }, "a1b2c3")
+
 ## sendValue(messageNumber, petNameOrPath) -> Promise<void>
 
 Reply to any message with a retained value from your pet store.
@@ -559,6 +573,20 @@ Fields without explicit patterns default to M.string().
 
 Example: submit(0, { name: "Alice", age: 30 })
 
+## submitOnce(messageNumber, values, attempt) -> Promise<{ messageId, attempt, first }>
+
+Submit values for a form message at most once per attempt. Retrying with
+the same attempt sends no second answer; it returns the first call's
+messageId with first: false.
+
+- messageNumber: The inbox message number of the form
+- values: A record with keys matching the form's field definitions
+- attempt: A retry key, 1 to 128 letters, digits, "-" or "_"
+
+Attempts are kept until the form is dismissed, at most 64 per form.
+
+Example: submitOnce(0, { name: "Alice" }, "a1b2c3")
+
 ## sendValue(messageNumber, petNameOrPath) -> Promise<void>
 
 Reply to any message with a retained value from your pet store.
diff --git a/packages/daemon/src/host.js b/packages/daemon/src/host.js
index 21bba4185..5bb712bcc 100644
--- a/packages/daemon/src/host.js
+++ b/packages/daemon/src/host.js
@@ -2449,6 +2449,7 @@ export const makeHostMaker = ({
       deliver,
       form,
       submit,
+      submitOnce,
       sendValue,
       deliverValueById,
       editMessage,
@@ -2741,6 +2742,7 @@ export const makeHostMaker = ({
       accept,
       endow,
       submit,
+      submitOnce,
       sendValue,
       // Diagnostics (formula records, dependency graph, error traces)
       diagnostics,
diff --git a/packages/daemon/src/interfaces.js b/packages/daemon/src/interfaces.js
index 28a079cc9..5f6cc28c5 100644
--- a/packages/daemon/src/interfaces.js
+++ b/packages/daemon/src/interfaces.js
@@ -332,6 +332,12 @@ export const GuestInterface = M.interface('EndoGuest', {
     MessageNumberShape, // messageNumber
     M.record(), // values
   ).returns(M.promise()),
+  // Submit values for a form at most once per attempt
+  submitOnce: M.call(
+    MessageNumberShape, // messageNumber
+    M.record(), // values
+    M.string(), // attempt
+  ).returns(M.promise()),
   // Send a retained value as a reply
   sendValue: M.call(
     MessageNumberShape, // messageNumber
@@ -596,6 +602,12 @@ export const HostInterface = M.interface('EndoHost', {
     MessageNumberShape, // messageNumber
     M.record(), // values
   ).returns(M.promise()),
+  // Submit values for a form at most once per attempt
+  submitOnce: M.call(
+    MessageNumberShape, // messageNumber
+    M.record(), // values
+    M.string(), // attempt
+  ).returns(M.promise()),
   // Send a retained value as a reply
   sendValue: M.call(
     MessageNumberShape, // messageNumber
diff --git a/packages/daemon/src/mail.js b/packages/daemon/src/mail.js
index 3ef4ef8a9..a6f1002a3 100644
--- a/packages/daemon/src/mail.js
+++ b/packages/daemon/src/mail.js
@@ -44,6 +44,38 @@ import {
 const NEXT_MESSAGE_NUMBER_NAME = /** @type {PetName} */ ('next-number');
 const messageNumberNamePattern = /^(0|[1-9][0-9]*)$/;
 
+/**
+ * `submitOnce` keeps each attempt in the mailbox store under
+ * `attempt-<attempt>`, bound to the formula of the value message it sends,
+ * and binds `answered-<attempt>` to the same formula once the form's sender
+ * has received it. An attempt is a caller's retry key: 1 to 128 letters,
+ * digits, `-` or `_`.
+ */
+const ATTEMPT_NAME_PREFIX = 'attempt-';
+const ANSWERED_NAME_PREFIX = 'answered-';
+const attemptPattern = /^[A-Za-z0-9_-]{1,128}$/;
+const attemptNamePattern = /^(attempt|answered)-([A-Za-z0-9_-]{1,128})$/;
+
+/**
+ * The most attempts a mailbox keeps for one form. Attempts are kept until the
+ * member dismisses the form they answer, so this bounds what one undismissed
+ * form can hold. A further new attempt for that form is refused; a known
+ * attempt still answers.
+ */
+export const MAX_ATTEMPTS_PER_FORM = 64;
+
+/**
+ * @param {unknown} attempt
+ * @returns {asserts attempt is string}
+ */
+const assertAttempt = attempt => {
+  if (typeof attempt !== 'string' || !attemptPattern.test(attempt)) {
+    throw new Error(
+      `Invalid attempt ${q(attempt)}: expected 1 to 128 letters, digits, "-" or "_"`,
+    );
+  }
+};
+
 /**
  * @param {string} name
  */
@@ -51,6 +83,9 @@ export const assertMailboxStoreName = name => {
   if (name === NEXT_MESSAGE_NUMBER_NAME) {
     return;
   }
+  if (attemptNamePattern.test(name)) {
+    return;
+  }
   if (!messageNumberNamePattern.test(name)) {
     throw new Error(`Invalid mailbox store name ${q(name)}`);
   }
@@ -307,6 +342,15 @@ export const makeMailboxMaker = ({
     /** @type {Topic<StampedMessage>} */
     const messagesTopic = makeChangeTopic();
     const mailboxStoreJobs = makeSerialJobs();
+    /** Serializes `submitOnce`, so two calls with one attempt send once. */
+    const attemptJobs = makeSerialJobs();
+    /**
+     * The attempts this mailbox keeps, by the message id of the form each
+     * answers. Loaded from the mailbox store's `attempt-*` and `answered-*`
+     * names.
+     * @type {Map<string, Set<string>>}
+     */
+    const attemptsByForm = new Map();
     let nextMessageNumber = 0n;
 
     /** @type {Mail['listMessages']} */
@@ -562,7 +606,26 @@ export const makeMailboxMaker = ({
               String(messageNumber)
             );
             await mailboxStore.remove(messageNumberName);
+            const dismissed = messages.get(messageNumber);
             messages.delete(messageNumber);
+            if (dismissed !== undefined && dismissed.type === 'form') {
+              // A dismissed form takes the attempts that answered it.
+              const attempts = attemptsByForm.get(dismissed.messageId);
+              if (attempts !== undefined) {
+                attemptsByForm.delete(dismissed.messageId);
+                for (const attempt of attempts) {
+                  for (const prefix of [
+                    ATTEMPT_NAME_PREFIX,
+                    ANSWERED_NAME_PREFIX,
+                  ]) {
+                    const name = /** @type {PetName} */ (`${prefix}${attempt}`);
+                    if (mailboxStore.identifyLocal(name) !== undefined) {
+                      await mailboxStore.remove(name);
+                    }
+                  }
+                }
+              }
+            }
             dismissal.resolve();
           });
           return undefined;
@@ -815,6 +878,39 @@ export const makeMailboxMaker = ({
         }
       });
 
+      const attemptNames = mailboxStore
+        .list()
+        .filter(name => attemptNamePattern.test(name));
+      const attemptRecords = await Promise.allSettled(
+        attemptNames.map(async name => {
+          const id = mailboxStore.identifyLocal(/** @type {PetName} */ (name));
+          if (id === undefined) {
+            return undefined;
+          }
+          const formula = await getFormulaForId(
+            /** @type {FormulaIdentifier} */ (id),
+          );
+          if (formula.type !== 'message' || formula.replyTo === undefined) {
+            return undefined;
+          }
+          const match = /** @type {RegExpExecArray} */ (
+            attemptNamePattern.exec(name)
+          );
+          return { attempt: match[2], replyTo: formula.replyTo };
+        }),
+      );
+      for (const entry of attemptRecords) {
+        if (entry.status === 'fulfilled' && entry.value !== undefined) {
+          const { attempt, replyTo } = entry.value;
+          let attempts = attemptsByForm.get(replyTo);
+          if (attempts === undefined) {
+            attempts = new Set();
+            attemptsByForm.set(replyTo, attempts);
+          }
+          attempts.add(attempt);
+        }
+      }
+
       if (
         storedNextNumber === undefined ||
         storedNextNumber !== computedNextNumber
@@ -843,6 +939,18 @@ export const makeMailboxMaker = ({
     const deliver = async envelope => {
       await mailboxStoreJobs.enqueue(async () => {
         assertMessageEnvelope(envelope);
+        // Delivery is idempotent by sender and message id: a sender that
+        // re-posts a message after a crash (`submitOnce`) must not leave a
+        // second copy. Message ids are random 256-bit numbers, so a match
+        // is a redelivery.
+        for (const held of messages.values()) {
+          if (
+            held.messageId === envelope.messageId &&
+            held.from === envelope.from
+          ) {
+            return;
+          }
+        }
         const messageNumber = nextMessageNumber;
         const date = new Date().toISOString();
         const done =
@@ -1404,13 +1512,14 @@ export const makeMailboxMaker = ({
       });
     };
 
-    /** @type {Mail['submit']} */
-    const submit = async (messageNumber, values) => {
-      const {
-        fields,
-        messageId: formMessageId,
-        guestHandleId,
-      } = getForm(messageNumber);
+    /**
+     * Check `values` against the form's fields, with the form's defaults
+     * applied, and marshal them. The caller must unpin the returned id.
+     *
+     * @param {FormField[]} fields
+     * @param {Record<string, unknown>} values
+     */
+    const marshalFormValues = async (fields, values) => {
       const defaults = Object.fromEntries(
         fields.map(({ name, default: defaultValue }) => [name, defaultValue]),
       );
@@ -1435,22 +1544,47 @@ export const makeMailboxMaker = ({
         marshalTasks,
         pinTransient,
       );
+      return marshalledId;
+    };
 
+    /**
+     * Build a value message envelope answering a form, addressed back to the
+     * form's sender.
+     *
+     * @param {FormulaNumber} formMessageId
+     * @param {string} guestHandleId
+     * @param {FormulaIdentifier} valueId
+     */
+    const makeFormAnswer = async (formMessageId, guestHandleId, valueId) => {
+      const valueMessageId = /** @type {FormulaNumber} */ (
+        await randomHex256()
+      );
+      /** @type {ValueMessage & { from: FormulaIdentifier, to: FormulaIdentifier }} */
+      const valueEnvelope = harden({
+        type: /** @type {const} */ ('value'),
+        from: /** @type {FormulaIdentifier} */ (selfId),
+        to: /** @type {FormulaIdentifier} */ (guestHandleId),
+        messageId: valueMessageId,
+        replyTo: formMessageId,
+        valueId,
+      });
+      return valueEnvelope;
+    };
+
+    /** @type {Mail['submit']} */
+    const submit = async (messageNumber, values) => {
+      const {
+        fields,
+        messageId: formMessageId,
+        guestHandleId,
+      } = getForm(messageNumber);
+      const marshalledId = await marshalFormValues(fields, values);
       try {
-        // Build a value message envelope addressed back to the form sender.
-        const valueMessageId = /** @type {FormulaNumber} */ (
-          await randomHex256()
+        const valueEnvelope = await makeFormAnswer(
+          formMessageId,
+          guestHandleId,
+          marshalledId,
         );
-        /** @type {ValueMessage & { from: FormulaIdentifier, to: FormulaIdentifier }} */
-        const valueEnvelope = harden({
-          type: /** @type {const} */ ('value'),
-          from: /** @type {FormulaIdentifier} */ (selfId),
-          to: /** @type {FormulaIdentifier} */ (guestHandleId),
-          messageId: valueMessageId,
-          replyTo: formMessageId,
-          valueId: marshalledId,
-        });
-
         const recipientHandle = await provideHandle(
           /** @type {FormulaIdentifier} */ (guestHandleId),
         );
@@ -1460,6 +1594,175 @@ export const makeMailboxMaker = ({
       }
     };
 
+    /**
+     * Deliver a kept form answer to the form's sender, record that it was
+     * delivered, then write this mailbox's sent copy.
+     *
+     * @param {ValueMessage & { from: FormulaIdentifier, to: FormulaIdentifier }} valueEnvelope
+     * @param {FormulaIdentifier} attemptId
+     * @param {PetName} answeredName
+     */
+    const deliverAnswer = async (valueEnvelope, attemptId, answeredName) => {
+      const recipientHandle = await provideHandle(valueEnvelope.to);
+      const envelope = makeEnvelope();
+      outbox.set(envelope, valueEnvelope);
+      await E(recipientHandle).receive(envelope, selfId);
+      await mailboxStoreJobs.enqueue(() =>
+        mailboxStore.storeIdentifier(answeredName, attemptId),
+      );
+      await deliver(valueEnvelope);
+    };
+
+    /**
+     * Answer a `submitOnce` call whose attempt this mailbox already keeps.
+     *
+     * @param {string | number | bigint} messageNumber
+     * @param {string} attempt
+     * @param {FormulaIdentifier} knownId
+     * @param {PetName} answeredName
+     */
+    const answerKnownAttempt = async (
+      messageNumber,
+      attempt,
+      knownId,
+      answeredName,
+    ) => {
+      const kept = /** @type {MessageFormula} */ (
+        await getFormulaForId(knownId)
+      );
+      const normalizedNumber = coerceMessageNumber(messageNumber);
+      const asked =
+        normalizedNumber === undefined
+          ? undefined
+          : messages.get(normalizedNumber);
+      if (
+        asked !== undefined &&
+        asked.type === 'form' &&
+        asked.messageId !== kept.replyTo
+      ) {
+        throw new Error(
+          `Attempt ${q(attempt)} already answered another form`,
+        );
+      }
+      /** @type {ValueMessage & { from: FormulaIdentifier, to: FormulaIdentifier }} */
+      const keptEnvelope = harden({
+        type: /** @type {const} */ ('value'),
+        from: /** @type {FormulaIdentifier} */ (kept.from),
+        to: /** @type {FormulaIdentifier} */ (kept.to),
+        messageId: /** @type {FormulaNumber} */ (kept.messageId),
+        replyTo: /** @type {FormulaNumber} */ (kept.replyTo),
+        valueId: /** @type {FormulaIdentifier} */ (kept.valueId),
+      });
+      if (mailboxStore.identifyLocal(answeredName) === undefined) {
+        await deliverAnswer(keptEnvelope, knownId, answeredName);
+      } else {
+        // The sender has it: at most restore this mailbox's sent copy.
+        await deliver(keptEnvelope);
+      }
+      return harden({
+        messageId: keptEnvelope.messageId,
+        attempt,
+        first: false,
+      });
+    };
+
+    /**
+     * Send a form answer at most once per attempt.
+     *
+     * The attempt is kept in this mailbox's store as `attempt-<attempt>`,
+     * bound to the formula of the value message, durably, before anything is
+     * delivered. Once the form's sender has received the message, the store
+     * also binds `answered-<attempt>` to it, before this mailbox writes its
+     * sent copy. A call with a known attempt sends no new message and answers
+     * with the first call's message id:
+     *
+     * - `answered-<attempt>` is held: the form's sender has the answer. Nothing
+     *   is sent to it; only a missing sent copy is written.
+     * - Only `attempt-<attempt>` is held: the first call was cut short before
+     *   the sender's delivery was recorded. The same message (same id, same
+     *   values) is delivered again. Delivery is idempotent by sender and
+     *   message id while the recipient holds the message.
+     *
+     * Attempts are kept until the member dismisses the form they answer, at
+     * most `MAX_ATTEMPTS_PER_FORM` for one form.
+     *
+     * @type {Mail['submitOnce']}
+     */
+    const submitOnce = (messageNumber, values, attempt) => {
+      assertAttempt(attempt);
+      const attemptName = /** @type {PetName} */ (
+        `${ATTEMPT_NAME_PREFIX}${attempt}`
+      );
+      const answeredName = /** @type {PetName} */ (
+        `${ANSWERED_NAME_PREFIX}${attempt}`
+      );
+      return attemptJobs.enqueue(async () => {
+        const knownId = /** @type {FormulaIdentifier | undefined} */ (
+          mailboxStore.identifyLocal(attemptName)
+        );
+        if (knownId !== undefined) {
+          return answerKnownAttempt(
+            messageNumber,
+            attempt,
+            knownId,
+            answeredName,
+          );
+        }
+
+        const {
+          fields,
+          messageId: formMessageId,
+          guestHandleId,
+        } = getForm(messageNumber);
+        const formAttempts = attemptsByForm.get(formMessageId);
+        if (
+          formAttempts !== undefined &&
+          formAttempts.size >= MAX_ATTEMPTS_PER_FORM
+        ) {
+          throw new Error(
+            `Form ${q(messageNumber)} already holds ${MAX_ATTEMPTS_PER_FORM} attempts; dismiss it or retry a known attempt`,
+          );
+        }
+        const marshalledId = await marshalFormValues(fields, values);
+        try {
+          const valueEnvelope = await makeFormAnswer(
+            formMessageId,
+            guestHandleId,
+            marshalledId,
+          );
+          // Keep the attempt, durably, before anything is delivered.
+          const attemptFormula = makeMessageFormula(
+            valueEnvelope,
+            new Date().toISOString(),
+            true,
+          );
+          const attemptId = await mailboxStoreJobs.enqueue(async () => {
+            const { id } = await formulateMessage(attemptFormula, pinTransient);
+            try {
+              await mailboxStore.storeIdentifier(attemptName, id);
+            } finally {
+              unpinTransient(id);
+            }
+            let attempts = attemptsByForm.get(formMessageId);
+            if (attempts === undefined) {
+              attempts = new Set();
+              attemptsByForm.set(formMessageId, attempts);
+            }
+            attempts.add(attempt);
+            return id;
+          });
+          await deliverAnswer(valueEnvelope, attemptId, answeredName);
+          return harden({
+            messageId: valueEnvelope.messageId,
+            attempt,
+            first: true,
+          });
+        } finally {
+          unpinTransient(marshalledId);
+        }
+      });
+    };
+
     /** @type {Mail['sendValue']} */
     const sendValue = async (messageNumber, petNameOrPath) => {
       const normalizedMessageNumber = mustParseBigint(messageNumber, 'message');
@@ -1786,6 +2089,7 @@ export const makeMailboxMaker = ({
       getDefineRequest,
       getForm,
       submit,
+      submitOnce,
       sendValue,
       deliverValueById,
       editMessage,
diff --git a/packages/daemon/src/manager.js b/packages/daemon/src/manager.js
index 3d6e82b54..4da8b6f94 100644
--- a/packages/daemon/src/manager.js
+++ b/packages/daemon/src/manager.js
@@ -4482,6 +4482,7 @@ const makeDaemonCore = async (
             storeBlob: disallowedFn,
             storeValue: disallowedFn,
             submit: disallowedFn,
+            submitOnce: disallowedFn,
             sendValue: disallowedFn,
             invite: disallowedFn,
             accept: disallowedFn,
diff --git a/packages/daemon/src/types.d.ts b/packages/daemon/src/types.d.ts
index b60ead1e0..82c5c4c16 100644
--- a/packages/daemon/src/types.d.ts
+++ b/packages/daemon/src/types.d.ts
@@ -1224,6 +1224,15 @@ export type MakeDirectoryNode = (
   ) => Promise<ContentSourceHint[]>,
 ) => EndoDirectory & ContentLocatable;
 
+/** The answer of `submitOnce`. */
+export type SubmitOnceResult = {
+  /** The message id of the value message that answers the form. */
+  messageId: FormulaNumber;
+  attempt: string;
+  /** Whether this call is the one that sent it. */
+  first: boolean;
+};
+
 export interface Mail {
   handle: () => Handle;
   // Partial inheritance from StoreController:
@@ -1281,6 +1290,18 @@ export interface Mail {
     guestHandleId: string;
   };
   submit(messageNumber: bigint, values: Record<string, unknown>): Promise<void>;
+  /**
+   * Submit values for a form at most once per `attempt`. The attempt is
+   * kept in this mailbox, durably, before the answer is delivered, and marked
+   * answered once the form's sender has received it. A call with a known
+   * attempt sends no new answer and returns the first call's message id.
+   * Attempts are kept until the form is dismissed, at most 64 per form.
+   */
+  submitOnce(
+    messageNumber: bigint,
+    values: Record<string, unknown>,
+    attempt: string,
+  ): Promise<SubmitOnceResult>;
   sendValue(
     messageNumber: bigint,
     petNameOrPath: string | string[],
@@ -1738,6 +1759,18 @@ export interface EndoGuest extends EndoAgent {
     petName: string | string[],
   ): Promise<void>;
   submit(messageNumber: bigint, values: Record<string, unknown>): Promise<void>;
+  /**
+   * Submit values for a form at most once per `attempt`. The attempt is
+   * kept in this mailbox, durably, before the answer is delivered, and marked
+   * answered once the form's sender has received it. A call with a known
+   * attempt sends no new answer and returns the first call's message id.
+   * Attempts are kept until the form is dismissed, at most 64 per form.
+   */
+  submitOnce(
+    messageNumber: bigint,
+    values: Record<string, unknown>,
+    attempt: string,
+  ): Promise<SubmitOnceResult>;
   sendValue: Mail['sendValue'];
   /**
    * Mint a single-use invitation whose locator's `from` names this guest's
@@ -2148,6 +2181,18 @@ export interface EndoHost extends EndoAgent {
     resultName?: string | string[],
   ): Promise<void>;
   submit(messageNumber: bigint, values: Record<string, unknown>): Promise<void>;
+  /**
+   * Submit values for a form at most once per `attempt`. The attempt is
+   * kept in this mailbox, durably, before the answer is delivered, and marked
+   * answered once the form's sender has received it. A call with a known
+   * attempt sends no new answer and returns the first call's message id.
+   * Attempts are kept until the form is dismissed, at most 64 per form.
+   */
+  submitOnce(
+    messageNumber: bigint,
+    values: Record<string, unknown>,
+    attempt: string,
+  ): Promise<SubmitOnceResult>;
   sendValue: Mail['sendValue'];
   /**
    * Returns the privileged read-only diagnostics facet: formula
diff --git a/packages/daemon/test/endo.test.js b/packages/daemon/test/endo.test.js
index d9e0327cd..19520dde2 100644
--- a/packages/daemon/test/endo.test.js
+++ b/packages/daemon/test/endo.test.js
@@ -5140,6 +5140,236 @@ test('form multi-submission: same form submitted twice produces two value messag
   t.is(value2.replyTo, formMsg.messageId);
 });
 
+/**
+ * @param {any} agent
+ */
+const listValueMessages = async agent => {
+  const messages = await E(agent).listMessages();
+  return messages.filter(message => message.type === 'value');
+};
+
+/**
+ * Guest sends the host a one-field form; returns the host's form message.
+ *
+ * @param {any} host
+ * @param {any} guest
+ */
+const sendAnswerForm = async (host, guest) => {
+  const hostIterator = iterateReader(E(host).followMessages());
+  await E(guest).form(
+    '@host',
+    'Once',
+    harden([{ name: 'answer', label: 'Answer' }]),
+  );
+  const { value: formMsg } = await hostIterator.next();
+  return formMsg;
+};
+
+test('submitOnce sends one answer per attempt', async t => {
+  const { host } = await prepareHost(t);
+  const guest = await E(host).provideGuest('guest');
+  const formMsg = await sendAnswerForm(host, guest);
+
+  const first = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'first' }),
+    'attempt-1',
+  );
+  t.true(first.first);
+  t.is(typeof first.messageId, 'string');
+
+  // Same attempt, even with other values: the first answer, nothing sent.
+  const again = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'changed' }),
+    'attempt-1',
+  );
+  t.false(again.first);
+  t.is(again.messageId, first.messageId);
+
+  const guestValues = await listValueMessages(guest);
+  t.is(guestValues.length, 1);
+  t.is(guestValues[0].messageId, first.messageId);
+  t.is(guestValues[0].replyTo, formMsg.messageId);
+  t.is((await listValueMessages(host)).length, 1);
+
+  // Another attempt is another answer.
+  const other = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'second' }),
+    'attempt-2',
+  );
+  t.true(other.first);
+  t.not(other.messageId, first.messageId);
+  t.is((await listValueMessages(guest)).length, 2);
+});
+
+test('submitOnce with concurrent calls of one attempt sends once', async t => {
+  const { host } = await prepareHost(t);
+  const guest = await E(host).provideGuest('guest');
+  const formMsg = await sendAnswerForm(host, guest);
+
+  const results = await Promise.all(
+    [1, 2, 3].map(() =>
+      E(host).submitOnce(formMsg.number, harden({ answer: 'x' }), 'same'),
+    ),
+  );
+  t.is(results.filter(result => result.first).length, 1);
+  t.is(new Set(results.map(result => result.messageId)).size, 1);
+  t.is((await listValueMessages(guest)).length, 1);
+});
+
+test('submitOnce retry after the sent copy is lost delivers no second answer', async t => {
+  const { host } = await prepareHost(t);
+  const guest = await E(host).provideGuest('guest');
+  const formMsg = await sendAnswerForm(host, guest);
+
+  const first = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'only' }),
+    'cut',
+  );
+
+  // The state a crash between delivery and the sent copy leaves: the attempt
+  // is kept and the form's sender holds the answer, but the member's mailbox
+  // has no sent copy.
+  const [sentCopy] = await listValueMessages(host);
+  await E(host).dismiss(sentCopy.number);
+  t.is((await listValueMessages(host)).length, 0);
+
+  const retry = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'only' }),
+    'cut',
+  );
+  t.false(retry.first);
+  t.is(retry.messageId, first.messageId);
+
+  const guestValues = await listValueMessages(guest);
+  t.is(guestValues.length, 1, 'the sender holds one answer');
+  const hostValues = await listValueMessages(host);
+  t.is(hostValues.length, 1, 'the member holds its sent copy again');
+  t.is(hostValues[0].messageId, first.messageId);
+});
+
+test('submitOnce retry after the sender dismissed the answer sends nothing', async t => {
+  const { host } = await prepareHost(t);
+  const guest = await E(host).provideGuest('guest');
+  const formMsg = await sendAnswerForm(host, guest);
+
+  const first = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'only' }),
+    'read',
+  );
+  const [received] = await listValueMessages(guest);
+  await E(guest).dismiss(received.number);
+  // And the member's sent copy is missing, as after a crash between
+  // delivery and the sent copy.
+  const [sentCopy] = await listValueMessages(host);
+  await E(host).dismiss(sentCopy.number);
+
+  const retry = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'only' }),
+    'read',
+  );
+  t.false(retry.first);
+  t.is(retry.messageId, first.messageId);
+  t.is(
+    (await listValueMessages(guest)).length,
+    0,
+    'the dismissed answer is not delivered again',
+  );
+  t.is((await listValueMessages(host)).length, 1);
+});
+
+test('submitOnce attempts survive a daemon restart', async t => {
+  const { cancelled, config } = await prepareConfig(t);
+
+  /** @type {bigint} */
+  let formNumber;
+  /** @type {string} */
+  let messageId;
+  {
+    const { host } = await makeHost(config, cancelled);
+    const guest = await E(host).provideGuest('guest', {
+      agentName: 'guest-agent',
+    });
+    const formMsg = await sendAnswerForm(host, guest);
+    formNumber = formMsg.number;
+    ({ messageId } = await E(host).submitOnce(
+      formNumber,
+      harden({ answer: 'before' }),
+      'durable',
+    ));
+  }
+
+  await restart(config);
+
+  {
+    const { host } = await makeHost(config, cancelled);
+    const retry = await E(host).submitOnce(
+      formNumber,
+      harden({ answer: 'after' }),
+      'durable',
+    );
+    t.false(retry.first);
+    t.is(retry.messageId, messageId);
+    const guest = await E(host).lookup('guest-agent');
+    const guestValues = await listValueMessages(guest);
+    t.is(guestValues.length, 1);
+    t.is(guestValues[0].messageId, messageId);
+  }
+});
+
+test('submitOnce refuses a malformed attempt', async t => {
+  const { host } = await prepareHost(t);
+  const guest = await E(host).provideGuest('guest');
+  const formMsg = await sendAnswerForm(host, guest);
+
+  for (const attempt of ['', 'a/b', 'x'.repeat(129), 'sp ace']) {
+    // eslint-disable-next-line no-await-in-loop
+    await t.throwsAsync(
+      () =>
+        E(host).submitOnce(formMsg.number, harden({ answer: 'a' }), attempt),
+      { message: /Invalid attempt/ },
+    );
+  }
+  t.is((await listValueMessages(guest)).length, 0);
+});
+
+test('submitOnce attempts go with their dismissed form, and are bounded per form', async t => {
+  const { host } = await prepareHost(t);
+  const guest = await E(host).provideGuest('guest');
+  const formMsg = await sendAnswerForm(host, guest);
+
+  for (let i = 0; i < 64; i += 1) {
+    // eslint-disable-next-line no-await-in-loop
+    await E(host).submitOnce(formMsg.number, harden({ answer: 'a' }), `a${i}`);
+  }
+  await t.throwsAsync(
+    () => E(host).submitOnce(formMsg.number, harden({ answer: 'a' }), 'a64'),
+    { message: /already holds 64 attempts/ },
+  );
+  // A known attempt still answers at the bound.
+  const known = await E(host).submitOnce(
+    formMsg.number,
+    harden({ answer: 'a' }),
+    'a0',
+  );
+  t.false(known.first);
+  t.is((await listValueMessages(guest)).length, 64);
+
+  await E(host).dismiss(formMsg.number);
+  // The attempt went with the form: a retry finds neither.
+  await t.throwsAsync(
+    () => E(host).submitOnce(formMsg.number, harden({ answer: 'a' }), 'a0'),
+    { message: /No such message/ },
+  );
+  t.is((await listValueMessages(guest)).length, 64);
+});
+
 test('form field patterns survive a daemon restart', async t => {
   const { cancelled, config } = await prepareConfig(t);
 
-- 
2.43.0

```
