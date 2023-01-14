import { useForm } from "react-hook-form";
import * as yup from "yup";

import { yupResolver } from "@hookform/resolvers/yup";

import { CreateRecord, useCreateRecord } from "../../../api";

interface CreateRecordForm {
  timestamp: Date;
  value: number;
}

interface Options {
  metricId: number;
  onSuccess?: (data: CreateRecord.Success) => void;
}

export const useCreateRecordForm = ({ metricId, ...options }: Options) => {
  const createRecordFormSchema: yup.SchemaOf<CreateRecordForm> = yup.object({
    timestamp: yup
      .date()
      .typeError("Must be a valid date and time")
      .max(new Date(), "Must not be future")
      .required("Is required"),
    value: yup
      .number()
      .transform((_, value) => parseFloat(value.replaceAll(".", "").replaceAll(",", ".")))
      .required("Is required")
      .min(0.01, "Must be greater than or equal to 0.01"),
  });

  const { handleSubmit, ...form } = useForm<CreateRecordForm>({
    resolver: yupResolver(createRecordFormSchema),
  });

  const { mutateAsync, isLoading } = useCreateRecord(options);

  const onSubmit = handleSubmit(({ timestamp, ...values }) =>
    mutateAsync({ metricId, timestamp: timestamp.toISOString(), ...values }),
  );

  return { ...form, isSubmitting: isLoading, onSubmit };
};
