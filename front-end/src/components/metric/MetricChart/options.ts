import ReactApexCharts from "react-apexcharts";

import { formatNumber } from "../../../models/number";
import { theme } from "../../../models/theme";

type Options = NonNullable<ReactApexCharts["props"]["options"]>;

export const chart: Options["chart"] = {
  zoom: { enabled: false },
  toolbar: { show: false },
};

export const colors: Options["colors"] = [theme.colors.primary[500]];

export const dataLabels: Options["dataLabels"] = { enabled: false };

export const fill: Options["fill"] = {
  type: "gradient",
  gradient: {
    shadeIntensity: 1,
    opacityFrom: 0.7,
    opacityTo: 0.9,
    stops: [0, 100],
  },
};

export const grid: Options["grid"] = {
  borderColor: theme.colors.gray[300],
  strokeDashArray: 3,
};

export const markers: Options["markers"] = { size: 0 };

export const stroke: Options["stroke"] = {
  width: 2,
  curve: "straight",
};

export const tooltip: Options["tooltip"] = {
  x: { format: "dd/MM/yyyy HH:mm" },
  y: { formatter: formatNumber },
  style: { fontSize: theme.fontSizes.xs, fontFamily: theme.fonts.body },
};

export const xaxis: Options["xaxis"] = {
  type: "datetime",
  labels: {
    datetimeFormatter: {
      year: "yyyy",
      month: "MM/yy",
      day: "dd/MM",
      hour: "HH:mm",
    },
    style: {
      fontSize: theme.fontSizes.xs,
      fontFamily: theme.fonts.body,
    },
  },
  tooltip: { enabled: false },
  axisBorder: { show: false },
};

export const yaxis: Options["yaxis"] = {
  labels: {
    formatter: formatNumber,
    style: {
      fontSize: theme.fontSizes.xs,
      fontFamily: theme.fonts.body,
    },
  },
};
