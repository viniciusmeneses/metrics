import {
  Box,
  Button,
  Card,
  CardBody,
  CardHeader,
  CardProps,
  Heading,
  HStack,
  Text,
  useDisclosure,
} from "@chakra-ui/react";

import { useSingleMetricReport } from "../../../api";
import { useSearchMetrics } from "../../../models/metric";
import { formatNumber } from "../../../models/number";
import { MetricChart } from "../MetricChart";

interface Props {
  metricId: number;
}

export const MetricCard = ({ metricId, ...props }: CardProps & Props) => {
  const createRecordModal = useDisclosure();

  const { groupBy } = useSearchMetrics();

  const { data: metric } = useSingleMetricReport({ id: metricId, groupBy });

  if (!metric) return null;

  return (
    <Card bgColor="white" variant="outline" {...props}>
      <CardHeader pb={2}>
        <HStack>
          <Box flex="1">
            <Heading size="md">{metric.name}</Heading>
            <Text color="gray.500">
              {formatNumber(metric?.average)} per {groupBy ?? "day"}
            </Text>
          </Box>

          <Button variant="outline" onClick={createRecordModal.onOpen}>
            Add record
          </Button>
        </HStack>
      </CardHeader>

      <CardBody pt={0} pb={3} pl={1} pr={4}>
        <MetricChart name={metric.name} series={metric.series} />
      </CardBody>
    </Card>
  );
};
