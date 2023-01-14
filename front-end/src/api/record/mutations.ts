import { useMutation, UseMutationOptions, useQueryClient } from "@tanstack/react-query";

import { api } from "../api";

import { CreateRecord } from "./typings";

export const useCreateRecord = ({
  onSuccess,
  ...options
}: UseMutationOptions<CreateRecord.Success, CreateRecord.Error, CreateRecord.Data>) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ metricId, ...data }) => api.post(`/metrics/${metricId}/records`, data),
    onSuccess: (data, variables, context) => {
      queryClient.invalidateQueries({ queryKey: ["SingleMetricReport", variables.metricId] });
      onSuccess?.(data, variables, context);
    },
    ...options,
  });
};
