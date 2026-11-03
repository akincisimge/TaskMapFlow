import {test} from 'node:test';
import assert from 'node:assert/strict';
import {validateProjectInput} from './domain.js';

test('rejects malformed input and document-path injection in request ids', () => {
  for (const input of [null, {}, {name: '', requestId: 'a'.repeat(16)}, {name: 'a'.repeat(101), requestId: 'a'.repeat(16)}, {name: 'Project', requestId: '../another/path'}]) {
    assert.throws(() => validateProjectInput(input), /VALIDATION_FAILED/);
  }
});
test('normalizes project names without trusting additional actor fields', () => {
  assert.deepEqual(validateProjectInput({name: '  Endura  ', requestId: 'a'.repeat(16), actorId: 'attacker'}), {name: 'Endura', requestId: 'a'.repeat(16)});
});
