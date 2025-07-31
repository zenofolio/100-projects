export const $string = (str?: string | null) =>
  typeof str === "string" && str.length > 0;
