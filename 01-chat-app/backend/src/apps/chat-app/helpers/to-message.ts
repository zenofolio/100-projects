/**
 * Convert simple message to object with exra data
 *
 * @param username
 * @param message
 * @param options
 * @returns
 */
export const toMessage = (
  username: string,
  message: string,
  options?: any
) => ({
  username,
  message,
  createdAt: Date.now(),
  options,
});
