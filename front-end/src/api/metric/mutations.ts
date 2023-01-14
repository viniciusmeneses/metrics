import { useMutation, UseMutationOptions, useQueryClient } from "@tanstack/react-query";

import { api } from "../api";

import { CreateMetric } from "./typings";

export const useCreateMetric = ({
  onSuccess,
  ...options
}: UseMutationOptions<CreateMetric.Success, CreateMetric.Error, CreateMetric.Data>) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data) => api.post("/metrics", data),
    onSuccess: (...args) => {
      queryClient.invalidateQueries({ queryKey: ["AllMetricsReport"] });
      onSuccess?.(...args);
    },
    ...options,
  });
};
