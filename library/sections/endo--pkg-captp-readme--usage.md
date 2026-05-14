---
title: Usage
source: packages/captp/README.md
source_repo: endojs/endo
source_commit: 1b767034b305
source_date: 2022-01-13
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [captp, eventual-send]
status: current
---

> Abstract: How to wire up CapTP: makeCapTP returns a {dispatch, getBootstrap, abort} triple. dispatch consumes incoming wire messages (e.g., from a WebSocket); getBootstrap returns a promise for the remote bootstrap capability; abort tears down the connection. The convertValToSlot/convertSlotToVal callbacks from marshal plug in here for slot identity.

## Usage

NOTE: `myconn` below is not part of the CapTP library, it represents a connection
object that you have created where `makeCapTP` is called on both sides of the
connection, passing in the function to send a JSON-able object on the connection, and returning
a `dispatch` function to receive a decoded JSON object from the connection.

```js
import { E, makeCapTP } from '@endo/captp';

// Create a message dispatcher and bootstrap.
// Messages on myconn are exchanged with JSON-able objects.
const { dispatch, getBootstrap, abort } = makeCapTP('myid', myconn.send, myBootstrap);
myconn.onReceive = obj => dispatch(obj);

// Get the remote's bootstrap object and call a remote method.
E(getBootstrap()).method(args).then(res => console.log('got res', res));

// Tear down the CapTP connection if it fails (e.g. connection is closed).
abort(Error('Connection aborted by user.'));
```


Source: [packages/captp/README.md](https://github.com/endojs/endo/blob/1b767034b305/packages/captp/README.md) at commit `1b767034`.
