/**
 * Standard to send error through socket
 *
 * @param error
 * @returns
 */
export const $error = (error: any) => ({ error });

/**
 * Standard to send success response through socket
 *
 * @param data
 * @param message
 * @returns
 */
export const $success = (data: any, message = "success") => ({ message, data });
