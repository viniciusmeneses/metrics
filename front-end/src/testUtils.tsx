import { PropsWithChildren, ReactElement } from "react";

import { ChakraProvider, theme } from "@chakra-ui/react";
import { render as rtlRender, RenderOptions } from "@testing-library/react";

const AllProviders = (props: PropsWithChildren) => <ChakraProvider theme={theme} {...props} />;

export const render = (ui: ReactElement, options?: RenderOptions) =>
  rtlRender(ui, { wrapper: AllProviders, ...options });
