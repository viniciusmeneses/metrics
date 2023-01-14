import { useMemo } from "react";

import { Divider, Spinner, VStack } from "@chakra-ui/react";

import { AllMetricsReport, useAllMetricsReport } from "../../api";
import { Header, Layout, Search } from "../../components/common";
import { MetricCard } from "../../components/metric";
import { useSearchMetrics } from "../../models/metric";

export const Home = () => {
  const search = useSearchMetrics();

  const { data, isLoading } = useAllMetricsReport({ groupBy: search.groupBy });

  const searchName = search.name.toLocaleLowerCase().trim();

  const metrics = useMemo(
    () => data?.filter(({ name }) => name.toLowerCase().includes(searchName)),
    [data, searchName],
  );

  return (
    <Layout>
      <Header />
      <Search />

      <Divider my={6} />

      <VStack spacing={6}>
        {isLoading ? (
          <Spinner color="red.500" size="xl" />
        ) : (
          metrics?.map(({ id }) => <MetricCard key={id} metricId={id} w="full" />)
        )}
      </VStack>
    </Layout>
  );
};
