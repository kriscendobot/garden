---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §six-step-implementation in the JS manager
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

```js
const debugWorker = async petNameOrPath => {
  const namePath = namePathFrom(petNameOrPath);
  assertNamePath(namePath);

  // 1. Identify the worker formula
  const workerId = await E(directory).identify(...namePath);
  if (workerId === undefined) throw new TypeError(...);

  // 2. Get the worker's bus handle
  const workerHandle = await getWorkerHandle(workerId);

  // 3. Suspend (snapshot to CAS)
  await requestSuspend(workerHandle);

  // 4. Set the debug flag
  sendControlVerb('debug-flag', { handle: workerHandle });

  // 5. Create a session that will receive <login>
  const session = createDebugSession(workerHandle);

  // 6. Trigger resume via no-op message
  sendControlVerb('debug-ping', { handle: workerHandle });

  // 7. Wait for <login>
  await session.waitForLogin();

  // 8. Return the Debugger exo
  return makeDebuggerExo(session, workerHandle);
};
```

The §sequence-matters-but-each-step-is-existing observation.
Steps 1-2 are pet-name resolution; steps 3-4 are existing
verbs; steps 5-7 are existing debugger machinery; step 8
wraps existing infrastructure in an exo.

The §inbox-as-resume-trigger observation:

> *Alternatively, if the worker's inbox already has pending
> messages, no ping is needed — the next `route_message`
> call for that handle will trigger resume.*

The §opportunistic-shortcut discipline: the `debug-ping` step
is only needed *if no other message would arrive*. A worker
with pending mail resumes naturally.
