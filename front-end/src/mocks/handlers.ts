import { rest } from "msw";

import { faker } from "@faker-js/faker";

import { AllMetricsReport, CreateMetric, CreateRecord, SingleMetricReport } from "../api";

const createMetric = rest.post<{}, {}, CreateMetric.Success>("/metrics", async (req, res, ctx) => {
  const body = await req.json<CreateMetric.Data>();

  return res(
    ctx.status(201),
    ctx.json({
      ...body,
      id: 1,
      created_at: "2020-01-01T05:00:00+01:00",
      updated_at: "2020-01-01T05:00:00+01:00",
    }),
  );
});

const createRecord = rest.post<{}, { metricId: string }, CreateRecord.Success>(
  "/metrics/:metricId/records",
  async (req, res, ctx) => {
    const body = await req.json<CreateRecord.Data>();

    return res(
      ctx.status(201),
      ctx.json({
        ...body,
        id: 1,
        metric_id: 1,
        created_at: "2020-01-01T05:00:00+01:00",
        updated_at: "2020-01-01T05:00:00+01:00",
      }),
    );
  },
);

const allMetricsReport = rest.get<{}, {}, AllMetricsReport.Success>(
  "/reports/metrics",
  (_, res, ctx) =>
    res(
      ctx.status(200),
      ctx.json([
        {
          id: 1,
          name: "Metric",
          created_at: "2020-01-01T05:00:00+01:00",
          updated_at: "2020-01-01T05:00:00+01:00",
          average: 592.5,
          series: [
            ["2020-01-10T20:00:00+01:00", 2000],
            ["2020-01-11T15:00:00+01:00", 1000],
            ["2020-01-12T06:00:00+01:00", 250],
            ["2020-01-13T10:00:00+01:00", 250],
            ["2020-01-14T12:00:00+01:00", 50],
            ["2020-01-15T15:00:00+01:00", 5],
          ],
        },
        {
          id: 2,
          name: "Metric 2",
          created_at: "2021-05-06T05:16:54+01:00",
          updated_at: "2020-08-04T05:13:22+01:00",
          average: 0,
          series: [],
        },
      ]),
    ),
);

const singleMetricReport = rest.get<{}, { id: string }, SingleMetricReport.Success>(
  "/reports/metrics/:metricId",
  (_, res, ctx) =>
    res(
      ctx.status(200),
      ctx.json({
        id: 1,
        name: "Metric",
        created_at: "2020-01-01T05:00:00+01:00",
        updated_at: "2020-01-01T05:00:00+01:00",
        average: 592.5,
        series: [
          ["2020-01-10T20:00:00+01:00", 2000],
          ["2020-01-11T15:00:00+01:00", 1000],
          ["2020-01-12T06:00:00+01:00", 250],
          ["2020-01-13T10:00:00+01:00", 250],
          ["2020-01-14T12:00:00+01:00", 50],
          ["2020-01-15T15:00:00+01:00", 5],
        ],
      }),
    ),
);

export const handlers = [createMetric, createRecord, allMetricsReport, singleMetricReport];
