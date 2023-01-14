import { useMemo } from "react";
import ReactApexChart from "react-apexcharts";

import { SingleMetricReport } from "../../../api";

import * as options from "./options";

interface Props {
  name: string;
  series: SingleMetricReport.Success["series"];
}

export const MetricChart = ({ name, series }: Props) => {
  const timestampSeries = useMemo(
    () => series.map(([date, total]) => [Date.parse(date), total]),
    [series],
  );

  return (
    <ReactApexChart
      type="area"
      height={250}
      series={[{ name, data: timestampSeries }]}
      options={options}
    />
  );
};
