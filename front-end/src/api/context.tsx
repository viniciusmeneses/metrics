import { PropsWithChildren } from "react";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      refetchOnMount: false,
      cacheTime: Infinity,
      staleTime: Infinity,
    },
  },
});

export const ApiProvider = (props: PropsWithChildren) => (
  <QueryClientProvider client={queryClient} {...props} />
);
