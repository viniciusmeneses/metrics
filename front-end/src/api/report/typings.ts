import { CreateMetric } from "../metric/typings";
import { ValidationErrors } from "../typings";

type MetricReport = CreateMetric.Success & {
  average: number;
  series: [string, number][];
};

export declare namespace AllMetricsReport {
  interface Params {
    groupBy?: "day" | "minute" | "hour";
  }

  type Success = MetricReport[];

  type Error = ValidationErrors<{ group_by: string }>;
}

export declare namespace SingleMetricReport {
  type Params = AllMetricsReport.Params & { id: number };

  type Success = MetricReport;

  type Error = ValidationErrors<Params>;
}
