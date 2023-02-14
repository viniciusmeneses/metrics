import { useMemo } from "react";
import ReactApexChart from "react-apexcharts";

import { SingleMetricReport } from "../../../api";

import * as options from "./options";

interface Props {
  name: string;
  series: SingleMetricReport.Success["series"];
}

export const MetricChart = ({ name, series }: Props) => {
  const chartSeries = useMemo(() => {
    const data = series.map(([date, total]) => [Date.parse(date), total]);
    return [{ name, data }];
  }, [name, series]);

  return <ReactApexChart type="area" height={250} series={chartSeries} options={options} />;
};
