import { useQueryParam } from "use-query-params";

export type GroupByParam = "day" | "hour" | "minute";

export const useSearchMetrics = () => {
  const [name, setName] = useQueryParam<string>("metricName");
  const [groupBy, setGroupBy] = useQueryParam<GroupByParam>("groupBy");

  return {
    name: name ?? "",
    groupBy: groupBy ?? "day",
    setName,
    setGroupBy,
  };
};
