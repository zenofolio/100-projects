import { useState } from "react";
import toast from "react-hot-toast";

export interface UseHandlerProps {
  texts?: {
    loading?: string;
    success?: string;
    error?: string;
  };
}
export default function useHandler(props?: UseHandlerProps) {
  const [isLoading, setLoading] = useState(false);

  const run = async <T,>(
    promise: Promise<T>,
  ): Promise<[null, T] | [Error, null]> => {
    const id = toast.loading(props?.texts?.loading ?? "Loading...");

    setLoading(true);

    try {
      const result = await promise;

      toast.success(props?.texts?.success || "Success!", { id });

      return [null, result] as any;
    } catch (error) {
      if (error instanceof Error) {
        toast.error(props?.texts?.error || error.message, { id });

        return [error, null];
      }

      const message =
        props?.texts?.error || `${(error as any)?.message || error}`;

      return [new Error(message), null];
    } finally {
      setLoading(false);
    }
  };

  return {
    run,
    isLoading,
  };
}
