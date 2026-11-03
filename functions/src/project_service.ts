import {createHash} from 'node:crypto';
import {Firestore, FieldValue, Timestamp} from 'firebase-admin/firestore';
import {HttpsError} from 'firebase-functions/v2/https';

export async function createProjectForUser(db: Firestore, uid: string, input: {name: string; requestId: string}, displayName: string) {
  const receiptId = createHash('sha256').update(`${uid}:${input.requestId}`).digest('hex');
  const receipt = db.collection('commandReceipts').doc(receiptId);
  const project = db.collection('projects').doc();
  const inputHash = createHash('sha256').update(JSON.stringify({name: input.name})).digest('hex');
  return db.runTransaction(async (tx) => {
    const existing = await tx.get(receipt);
    if (existing.exists) {
      if (existing.get('inputHash') !== inputHash) throw new HttpsError('already-exists', 'REQUEST_ID_REUSED');
      return existing.get('result') as {projectId: string; version: number};
    }
    const now = FieldValue.serverTimestamp();
    const result = {projectId: project.id, version: 1};
    tx.create(project, {name: input.name, ownerId: uid, archivedAt: null, version: 1, createdAt: now, updatedAt: now});
    tx.create(project.collection('members').doc(uid), {role: 'owner', active: true, displayName: displayName, joinedAt: now});
    tx.create(db.doc(`users/${uid}/projectRefs/${project.id}`), {projectId: project.id, name: input.name, role: 'owner'});
    tx.create(project.collection('graphState').doc('current'), {revision: 0});
    tx.create(project.collection('activity').doc(), {actorId: uid, entityId: project.id, type: 'project.created', changes: {name: {before: null, after: input.name}}, occurredAt: now, requestId: input.requestId});
    tx.create(receipt, {uid, requestId: input.requestId, inputHash, result, expiresAt: Timestamp.fromMillis(Date.now() + 7 * 86400000)});
    return result;
  });
}
