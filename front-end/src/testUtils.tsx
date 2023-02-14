import { PropsWithChildren, ReactElement } from "react";

import { ChakraProvider } from "@chakra-ui/react";
import { render as rtlRender, RenderOptions } from "@testing-library/react";

import { ApiProvider } from "./api";

const AllProviders = (props: PropsWithChildren) => (
  <ChakraProvider>
    <ApiProvider {...props} />
  </ChakraProvider>
);

export const render = (ui: ReactElement, options?: RenderOptions) =>
  rtlRender(ui, { wrapper: AllProviders, ...options });
