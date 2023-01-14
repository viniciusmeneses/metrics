import { HStack, Input, Select, StackProps } from "@chakra-ui/react";

import { GroupByParam, useSearchMetrics } from "../../../models/metric";

export const Search = (props: StackProps) => {
  const search = useSearchMetrics();

  return (
    <HStack mt={4} spacing={3} {...props}>
      <Input
        placeholder="Metric name"
        bgColor="white"
        aria-label="Metric name"
        value={search.name}
        onChange={(e) => search.setName(e.target.value)}
      />
      <Select
        w="140px"
        sx={{ width: "140px" }}
        bgColor="white"
        aria-label="Grouping"
        value={search.groupBy}
        onChange={(e) => search.setGroupBy(e.target.value as GroupByParam)}
      >
        <option value="day">By day</option>
        <option value="hour">By hour</option>
        <option value="minute">By minute</option>
      </Select>
    </HStack>
  );
};
