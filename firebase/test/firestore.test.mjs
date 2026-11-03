import {readFile} from 'node:fs/promises';
import {before, after, test} from 'node:test';
import {initializeTestEnvironment, assertFails, assertSucceeds} from '@firebase/rules-unit-testing';
import {doc, getDoc, setDoc} from 'firebase/firestore';
let env;
before(async () => {
  env = await initializeTestEnvironment({projectId:'demo-taskmapflow',firestore:{rules:await readFile(new URL('../firestore.rules', import.meta.url),'utf8')}});
  await env.withSecurityRulesDisabled(async ctx => {
    const db=ctx.firestore();
    await setDoc(doc(db,'projects/p1'),{name:'Private project'});
    await setDoc(doc(db,'projects/p1/members/alice'),{active:true,role:'owner'});
    await setDoc(doc(db,'projects/p1/members/removed'),{active:false,role:'member'});
  });
});
after(async () => { await env?.cleanup(); });
test('active member reads project',async()=>assertSucceeds(getDoc(doc(env.authenticatedContext('alice').firestore(),'projects/p1'))));
test('outsider, anonymous and removed member cannot read',async()=>{
  for(const db of [env.authenticatedContext('bob').firestore(),env.unauthenticatedContext().firestore(),env.authenticatedContext('removed').firestore()]) await assertFails(getDoc(doc(db,'projects/p1')));
});
test('even owner cannot forge membership, task, sender or activity writes',async()=>{
 const db=env.authenticatedContext('alice').firestore();
 for(const path of ['members/bob','tasks/t1','messages/m1','activity/e1']) await assertFails(setDoc(doc(db,`projects/p1/${path}`),{role:'owner',senderId:'bob'}));
});
