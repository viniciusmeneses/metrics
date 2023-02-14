import { useQuery, useQueryClient } from "@tanstack/react-query";

import { api } from "../api";

import { AllMetricsReport, SingleMetricReport } from "./typings";

export const useAllMetricsReport = ({ groupBy }: AllMetricsReport.Params) =>
  useQuery<AllMetricsReport.Success, AllMetricsReport.Error>({
    queryKey: ["AllMetricsReport", groupBy],
    queryFn: () => api.get("/reports/metrics", { params: { group_by: groupBy } }),
  });

export const useSingleMetricReport = ({ id, groupBy }: SingleMetricReport.Params) => {
  const queryClient = useQueryClient();

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
