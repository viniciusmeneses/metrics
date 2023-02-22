import { rest } from "msw";

import { faker } from "@faker-js/faker";

import { AllMetricsReport, CreateMetric, CreateRecord, SingleMetricReport } from "../api";

const recentISO = () => faker.date.recent().toISOString();

const createMetric = rest.post<{}, {}, CreateMetric.Success>("/metrics", async (req, res, ctx) => {
  const body = await req.json<CreateMetric.Data>();

  return res(
    ctx.status(201),
    ctx.json({
      ...body,
      id: faker.datatype.number(),
      created_at: recentISO(),
      updated_at: recentISO(),
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
        id: faker.datatype.number(),
        metric_id: Number(req.params.metricId),
        created_at: recentISO(),
        updated_at: recentISO(),
      }),
    );
  },
);

const allMetricsReport = rest.get<{}, {}, AllMetricsReport.Success>(
  "/reports/metrics",
  async (_, res, ctx) =>
    res(
      ctx.status(200),
      ctx.json([
        {
          id: faker.datatype.number(),
          name: faker.lorem.word(),
          created_at: recentISO(),
          updated_at: recentISO(),
          average: faker.datatype.number(),
          series: Array.from({ length: 10 }, () => [recentISO(), faker.datatype.number()]),
        },
      ]),
    ),
);

const singleMetricReport = rest.get<{}, { id: string }, SingleMetricReport.Success>(
  "/reports/metrics/:metricId",
  async (req, res, ctx) =>
    res(
      ctx.status(200),
      ctx.json({
        id: Number(req.params.id),
        name: faker.lorem.word(),
        created_at: recentISO(),
        updated_at: recentISO(),
        average: faker.datatype.number(),
        series: Array.from({ length: 10 }, () => [recentISO(), faker.datatype.number()]),
      }),
    ),
);

export const handlers = [createMetric, createRecord, allMetricsReport, singleMetricReport];
