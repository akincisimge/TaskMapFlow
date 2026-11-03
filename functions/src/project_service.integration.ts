import {test, after} from 'node:test';
import assert from 'node:assert/strict';
import {initializeApp, deleteApp} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
import {createProjectForUser} from './project_service.js';

if (!process.env.FIRESTORE_EMULATOR_HOST) throw new Error('Refusing to run outside Firestore Emulator');
const app = initializeApp({projectId: 'demo-taskmapflow'}, 'project-command-tests');
const db = getFirestore(app);
after(async () => { await db.terminate(); await deleteApp(app); });

test('concurrent retries create one project with membership, index and one activity', async () => {
  const input = {name: 'Idempotent project', requestId: 'integration-request-001'};
  const [a,b] = await Promise.all([createProjectForUser(db,'command-user',input,'Test'),createProjectForUser(db,'command-user',input,'Test')]);
  assert.equal(a.projectId,b.projectId);
  const project=db.doc(`projects/${a.projectId}`);
  assert.equal((await project.get()).get('ownerId'),'command-user');
  assert.equal((await project.collection('members').doc('command-user').get()).get('role'),'owner');
  assert.equal((await db.doc(`users/command-user/projectRefs/${a.projectId}`).get()).exists,true);
  assert.equal((await project.collection('activity').get()).size,1);
  await assert.rejects(createProjectForUser(db,'command-user',{...input,name:'Changed input'},'Test'),/REQUEST_ID_REUSED/);
});
