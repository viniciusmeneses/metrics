import { AxiosResponse } from "axios";

export type ValidationErrors<Errors> = AxiosResponse<
  { errors?: { [key in keyof Errors]: string[] } } | undefined
>;
