import { useQuery, useQueryClient } from "@tanstack/react-query";

import { api } from "../api";

import { AllMetricsReport, SingleMetricReport } from "./typings";

const DEFAULT_GROUP_BY = "day";

export const useAllMetricsReport = (params: AllMetricsReport.Params) => {
  const groupBy = params.groupBy ?? DEFAULT_GROUP_BY;

  return useQuery<AllMetricsReport.Success, AllMetricsReport.Error>({
    queryKey: ["AllMetricsReport", groupBy],
    queryFn: () => api.get("/reports/metrics", { params: { group_by: groupBy } }),
  });
};

export const useSingleMetricReport = ({ id, ...params }: SingleMetricReport.Params) => {
  const queryClient = useQueryClient();
  const groupBy = params.groupBy ?? DEFAULT_GROUP_BY;

  const initialData = () =>
    queryClient
      .getQueryData<AllMetricsReport.Success>(["AllMetricsReport", groupBy])
      ?.find((metric) => metric.id === id);

  return useQuery<SingleMetricReport.Success, SingleMetricReport.Error>({
    queryKey: ["SingleMetricReport", id, groupBy],
    queryFn: () => api.get(`/reports/metrics/${id}`, { params: { group_by: groupBy } }),
    initialData,
  });
};
