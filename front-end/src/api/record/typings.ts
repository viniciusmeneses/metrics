import { ValidationErrors } from "../typings";

export declare namespace CreateRecord {
  interface Data {
    metricId: number;
    value: number;
    timestamp: string;
  }

  interface Success {
    id: number;
    timestamp: string;
    value: number;
    metric_id: number;
    created_at: string;
    updated_at: string;
  }

  type Error = ValidationErrors<Data>;
}
