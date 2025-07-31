export type $TRY<T> = [null, T] | [Error, null];

export const $try = async <T>(promise: T): Promise<$TRY<T>> => {
  try {
    const result = await promise;

    return [result, null] as $TRY<T>;
  } catch (error) {
    if (error instanceof Error) {
      return [error, null];
    }

    return [new Error(`${(error as any)?.message || error}`), null];
  }
};
