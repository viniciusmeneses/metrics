import { useForm } from "react-hook-form";
import * as yup from "yup";

import { yupResolver } from "@hookform/resolvers/yup";

import { CreateMetric, useCreateMetric } from "../../../api";

interface CreateMetricForm {
  name: string;
}

interface Options {
  onSuccess?: (data: CreateMetric.Success) => void;
}

export const useCreateMetricForm = (options: Options) => {
  const createMetricFormSchema: yup.SchemaOf<CreateMetricForm> = yup.object({
    name: yup.string().required("Is a required").max(30, "Must be at most 30 characters"),
  });

  const { mutateAsync, isLoading } = useCreateMetric(options);

  const { handleSubmit, ...form } = useForm<CreateMetricForm>({
    resolver: yupResolver(createMetricFormSchema),
    defaultValues: {
      name: "",
    },
  });

  const onSubmit = handleSubmit((values) => mutateAsync(values));

  return { ...form, isSubmitting: isLoading, onSubmit };
};
