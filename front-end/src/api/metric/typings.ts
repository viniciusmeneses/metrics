import { ValidationErrors } from "../typings";

export declare namespace CreateMetric {
  interface Data {
    name: string;
  }

  interface Success {
    id: number;
    name: string;
    created_at: string;
    updated_at: string;
  }

  type Error = ValidationErrors<Data>;
}
