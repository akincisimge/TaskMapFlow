export function validateProjectInput(data: unknown): {name: string; requestId: string} {
  if (!data || typeof data !== 'object') throw new Error('VALIDATION_FAILED');
  const {name, requestId} = data as Record<string, unknown>;
  if (typeof name !== 'string' || name.trim().length < 1 || name.trim().length > 100 ||
      typeof requestId !== 'string' || !/^[A-Za-z0-9_-]{16,80}$/.test(requestId)) {
    throw new Error('VALIDATION_FAILED');
  }
  return {name: name.trim(), requestId};
}
