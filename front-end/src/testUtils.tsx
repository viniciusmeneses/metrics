import { PropsWithChildren, ReactElement } from "react";
import { QueryParamProvider } from "use-query-params";
import { WindowHistoryAdapter } from "use-query-params/adapters/window";

import { ChakraProvider } from "@chakra-ui/react";
import { render as rtlRender, RenderOptions } from "@testing-library/react";

import { ApiProvider } from "./api";

const AllProviders = ({ children }: PropsWithChildren) => (
  <ChakraProvider>
    <ApiProvider>
      <QueryParamProvider adapter={WindowHistoryAdapter}>{children}</QueryParamProvider>
    </ApiProvider>
  </ChakraProvider>
);

export const render = (ui: ReactElement, options?: RenderOptions) =>
  rtlRender(ui, { wrapper: AllProviders, ...options });
