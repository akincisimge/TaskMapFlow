import {initializeApp} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
import {onCall, HttpsError} from 'firebase-functions/v2/https';
import {validateProjectInput} from './domain.js';
import {createProjectForUser} from './project_service.js';

initializeApp();
const db = getFirestore();

// The authenticated identity is authoritative; never accept actorId from input.
export const createProject = onCall({region: 'europe-west1', maxInstances: 3}, async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'UNAUTHENTICATED');
  let input: ReturnType<typeof validateProjectInput>;
  try { input = validateProjectInput(request.data); }
  catch { throw new HttpsError('invalid-argument', 'VALIDATION_FAILED'); }
  return createProjectForUser(db, request.auth.uid, input, request.auth.token.name ?? 'Proje sahibi');
});
