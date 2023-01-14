import { Divider } from "@chakra-ui/react";

import { Header, Layout, Search } from "../../components/common";
import { useSearchMetrics } from "../../models/metric";

export const Home = () => {
  const search = useSearchMetrics();

  const metricName = search.name.toLocaleLowerCase().trim();

  return (
    <Layout>
      <Header />
      <Search />

      <Divider my={6} />
    </Layout>
  );
};
